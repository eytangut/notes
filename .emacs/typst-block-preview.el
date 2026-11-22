;;; typst-block-preview.el --- Preview the [..] block at point as a one-page PDF  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; No live preview (it would need screen space).  Instead, one command:
;;
;;   M-x typst-block-preview        the innermost [..] around point
;;   C-u 2 M-x typst-block-preview  two levels up (3 = three levels, ...)
;;   M-x typst-block-preview-with-head   same, but keeps the #call( .. ) in
;;                                  front of the [ (e.g. #theorem[..] with its box)
;;
;; What it does:
;;   1. Finds the preamble: everything from the top of the file up to the
;;      line that is a `//' comment containing "END preamble".
;;   2. Finds the [..] block around point (brackets in math $..$, comments,
;;      raw `..` and escapes like \[ are ignored when counting).
;;   3. Writes preamble + block to a hidden temp file next to your document
;;      (so relative #import / #image paths keep working), compiles it with
;;      `typst compile', and deletes the temp file.
;;   4. Shows the resulting PDF through `typst-block-preview-viewer'.  My
;;      init.el sets that to `my/open-pdf': Android's full-screen viewer on the
;;      phone (Termux), a window on the right inside Emacs on the desktop.
;;      With no viewer set, it auto-detects one (termux-open, wslview, xdg-open).
;;
;; The page is forced to `height: auto' so you get ONE tight page, with
;; small margins and no header/footer/page number (see
;; `typst-block-preview-page-override').
;;
;; The temp file keeps the SAME LINE NUMBERS as your document, so an error
;; "line 87" means line 87 of your buffer; on failure point jumps there.

;;; Code:

(require 'cl-lib)

(defgroup typst-block-preview nil
  "Preview the Typst [..] block at point."
  :group 'tools)

(defcustom typst-block-preview-marker "END preamble"
  "Text marking the end of the preamble.
It must be on a line that starts with `//' (a comment)."
  :type 'string)

(defcustom typst-block-preview-page-override
  "#set page(height: auto, margin: (x: 8mm, y: 5mm), numbering: none, header: none, footer: none)"
  "Typst code that replaces the marker line, making the output one tight page."
  :type 'string)

(defcustom typst-block-preview-typst "typst"
  "The typst executable."
  :type 'string)

(defcustom typst-block-preview-root nil
  "Directory passed as `--root' to typst, or nil for the document's directory.
Set this if your template lives outside the document's directory."
  :type '(choice (const nil) directory))

(defcustom typst-block-preview-font-dirs '("~/fonts" "~/.fonts")
  "Directories (if they exist) passed to typst as `--font-path'.
Typst only sees the fonts of the machine it runs on: copy the fonts your
template uses (e.g. your Hebrew font) into one of these on that machine."
  :type '(repeat directory))

(defcustom typst-block-preview-output-dir "~/.cache/typst-block-preview/"
  "Where preview PDFs are written (emptied before each run)."
  :type 'directory)

(defcustom typst-block-preview-viewer nil
  "Function called with the PDF path, or nil to auto-detect a viewer."
  :type '(choice (const nil) function))

(defvar typst-block-preview--last-pdf nil)
(defvar typst-block-preview--preamble-lines 0
  "Number of preamble lines used by the last `typst-block-preview--build'.")
(defconst typst-block-preview--log-buffer "*typst-preview*")

;;;; Scanning

(defun typst-block-preview--walk (from limit fn)
  "Scan markup from FROM, calling (FN CHAR POS) for each [ or ] before LIMIT.
Comments, raw text, $math$ and backslash escapes are skipped.  Stops and
returns FN's value as soon as it is non-nil.  Point is moved."
  (goto-char from)
  (let ((case-fold-search nil)
        (limit (or limit (point-max)))
        result)
    (while (and (not result) (< (point) limit)
                (re-search-forward "\\\\.\\|//\\|/\\*\\|`+\\|\\$\\|\\[\\|\\]" limit t))
      (let ((tok (match-string 0)) (beg (match-beginning 0)))
        (cond
         ((eq (aref tok 0) ?\\) nil)
         ((string= tok "//")
          ;; "https://..." is a link, not a comment.
          (unless (eq (char-before beg) ?:) (end-of-line)))
         ((string= tok "/*")
          (unless (search-forward "*/" nil t) (goto-char (point-max))))
         ((eq (aref tok 0) ?`)
          (unless (= (length tok) 2)
            (unless (search-forward (make-string (length tok) ?`) nil t)
              (goto-char (point-max)))))
         ((string= tok "$")
          (while (and (re-search-forward "\\\\.\\|\\$" nil 'move)
                      (not (string= (match-string 0) "$")))))
         (t (setq result (funcall fn (aref tok 0) beg))))))
    result))

(defun typst-block-preview--enclosing (pos start)
  "Positions of the `[' still open at POS, innermost first (scan from START)."
  (let (stack)
    (save-excursion
      (typst-block-preview--walk
       start pos
       (lambda (c p) (if (eq c ?\[) (push p stack) (pop stack)) nil)))
    stack))

(defun typst-block-preview--close (open)
  "Position of the `]' matching the `[' at OPEN, or nil."
  (let ((depth 1))
    (save-excursion
      (typst-block-preview--walk
       (1+ open) nil
       (lambda (c p)
         (if (eq c ?\[) (cl-incf depth) (cl-decf depth))
         (and (= depth 0) p))))))

;;;; The "#call(..)" in front of a [

(defun typst-block-preview--skip-group (pos limit)
  "If a ( or [ group starts at POS, return the position after its closer.
Never looks at or beyond LIMIT; returns nil if the group is not closed."
  (let ((stack nil) (i pos) result)
    (while (and (not result) (< i limit))
      (let ((c (char-after i)))
        (if (eq (car stack) ?\])
            ;; markup inside [..]: only brackets, $math$ and escapes matter
            (cond ((eq c ?\[) (push ?\] stack))
                  ((eq c ?\]) (pop stack) (unless stack (setq result (1+ i))))
                  ((eq c ?\\) (cl-incf i))
                  ((eq c ?$)
                   (cl-incf i)
                   (while (and (< i limit) (not (eq (char-after i) ?$)))
                     (when (eq (char-after i) ?\\) (cl-incf i))
                     (cl-incf i))))
          ;; code inside (..)
          (cond ((eq c ?\() (push ?\) stack))
                ((eq c ?\[) (push ?\] stack))
                ((memq c '(?\) ?\]))
                 (if (eq c (car stack))
                     (progn (pop stack) (unless stack (setq result (1+ i))))
                   (setq i limit result 'fail)))
                ((eq c ?\\) (cl-incf i))
                ((eq c ?\")
                 (cl-incf i)
                 (while (and (< i limit) (not (eq (char-after i) ?\")))
                   (when (eq (char-after i) ?\\) (cl-incf i))
                   (cl-incf i)))))
        (cl-incf i)))
    (and (integerp result) result)))

(defun typst-block-preview--chain-p (from open)
  "Non-nil if FROM..OPEN is only adjacent (..) / [..] argument groups."
  (let ((i from))
    (while (and i (< i open) (memq (char-after i) '(?\( ?\[)))
      (setq i (typst-block-preview--skip-group i open)))
    (and i (= i open))))

(defun typst-block-preview--head-start (open lower)
  "Start of the #call whose argument is the `[' at OPEN, or nil.
Only looks back to LOWER."
  (save-excursion
    (goto-char open)
    (let ((lo (max lower (- open 3000))) found)
      (while (and (not found)
                  (re-search-backward "#[[:alpha:]_][[:alnum:]_.-]*" lo t))
        (let ((p (point)))
          (when (typst-block-preview--chain-p (match-end 0) open)
            (setq found p))))
      found)))

;;;; Building the temp document

(defun typst-block-preview--marker-bounds ()
  "(BEG . END) of the line holding the preamble marker, or nil."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((case-fold-search t))
        (when (re-search-forward
               (concat "^[ \t]*//.*" (regexp-quote typst-block-preview-marker)) nil t)
          (cons (line-beginning-position) (line-end-position)))))))

(defun typst-block-preview--build (levels with-head)
  "Return the temp document text for the block LEVELS up from point."
  (let* ((mark (or (typst-block-preview--marker-bounds)
                   (user-error "No \"// %s\" line found" typst-block-preview-marker)))
         (pos (point)))
    (when (<= pos (cdr mark))
      (user-error "Point is inside the preamble"))
    (save-restriction
     (widen)                            ; narrowing must not hide the preamble
     (let* ((stack (typst-block-preview--enclosing pos (1+ (cdr mark))))
           (open (or (nth (1- levels) stack)
                     (user-error "Point is not inside %s [..] block"
                                 (if (> levels 1) (format "%d nested" levels) "a"))))
           (close (or (typst-block-preview--close open)
                      (user-error "The [ on line %d has no closing ]"
                                  (line-number-at-pos open t))))
           (head (and with-head
                      (typst-block-preview--head-start open (1+ (cdr mark)))))
           (start (or head (1+ open)))
           (end (if head (1+ close) close))
           (p-line (line-number-at-pos (car mark) t))
           (s-line (line-number-at-pos start t)))
      (setq typst-block-preview--preamble-lines (1- p-line))
      (concat (buffer-substring-no-properties (point-min) (car mark))
              typst-block-preview-page-override
              ;; blank lines so the block keeps its original line numbers
              (make-string (max 1 (- s-line p-line)) ?\n)
              (buffer-substring-no-properties start end)
              "\n")))))

;;;; Running typst, viewing, errors

(defun typst-block-preview--view (file)
  "Open FILE in an external full-screen viewer."
  (cond
   (typst-block-preview-viewer (funcall typst-block-preview-viewer file))
   ((executable-find "termux-open") (start-process "typst-view" nil "termux-open" file))
   ((executable-find "wslview") (start-process "typst-view" nil "wslview" file))
   ((executable-find "xdg-open") (start-process "typst-view" nil "xdg-open" file))
   (t (message "Preview ready, but no viewer found: %s" file))))

(defun typst-block-preview--report-error (srcbuf logbuf tmpname)
  "Show the first Typst error; jump to it in SRCBUF if it is in the block."
  (let (file line col msg)
    (with-current-buffer logbuf
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward
               "^\\(.*\\):\\([0-9]+\\):\\([0-9]+\\): error: \\(.*\\)$" nil t)
          (setq file (match-string 1) line (string-to-number (match-string 2))
                col (string-to-number (match-string 3)) msg (match-string 4)))))
    (cond
     ((not msg)
      (message "Typst failed -- see the log (SPC p l)"))
     ((and (string-match-p (regexp-quote tmpname) file) (buffer-live-p srcbuf))
      (switch-to-buffer srcbuf)
      (goto-char (point-min))
      (forward-line (1- line))
      (forward-char (min (max 0 (1- col)) (- (line-end-position) (point))))
      (message "Typst error, line %d: %s  (full log: SPC p l)" line msg))
     (t (message "Typst error in %s:%d: %s" (file-name-nondirectory file) line msg)))))

;;;###autoload
(defun typst-block-preview (&optional levels with-head)
  "Compile the [..] block LEVELS up from point (default 1) with the preamble.
With WITH-HEAD, keep the #call(..) in front of the `['.  Shows the PDF in an
external viewer."
  (interactive "p")
  (unless (executable-find typst-block-preview-typst)
    (user-error "`%s' not found (install typst: see the top of init.el)" typst-block-preview-typst))
  (let* ((text (typst-block-preview--build (max 1 (or levels 1)) with-head))
         (srcbuf (current-buffer))
         (dir (file-name-directory (or buffer-file-name
                                       (expand-file-name "x.typ" default-directory))))
         (tmp (expand-file-name ".typst-block-preview.typ" dir))
         (outdir (file-name-as-directory (expand-file-name typst-block-preview-output-dir)))
         (pdf (expand-file-name (format-time-string "block-%H%M%S.pdf") outdir))
         (logbuf (get-buffer-create typst-block-preview--log-buffer)))
    (make-directory outdir t)
    (dolist (old (directory-files outdir t "\\.pdf\\'")) (delete-file old))
    (let ((coding-system-for-write 'utf-8-unix))
      (write-region text nil tmp nil 'silent))
    (with-current-buffer logbuf
      (let ((inhibit-read-only t)) (erase-buffer))
      (special-mode))
    (message "Typst: compiling block (preamble = %d lines)..."
             typst-block-preview--preamble-lines)
    (make-process
     :name "typst-block-preview"
     :buffer logbuf
     :noquery t
     :command (append
               (list typst-block-preview-typst "compile" "--diagnostic-format" "short")
               (when typst-block-preview-root
                 (list "--root" (expand-file-name typst-block-preview-root)))
               (cl-mapcan (lambda (d)
                            (let ((d (expand-file-name d)))
                              (when (file-directory-p d) (list "--font-path" d))))
                          typst-block-preview-font-dirs)
               (list tmp pdf))
     :sentinel
     (lambda (proc _event)
       (when (memq (process-status proc) '(exit signal))
         (ignore-errors (delete-file tmp))
         (if (and (eq (process-status proc) 'exit)
                  (zerop (process-exit-status proc))
                  (file-exists-p pdf))
             (progn (setq typst-block-preview--last-pdf pdf)
                    (let ((n (with-current-buffer (process-buffer proc)
                               (count-matches ": warning: " (point-min) (point-max)))))
                      (message "%s" (if (> n 0)
                                        (format "Typst: opening preview (%d warning(s), see SPC p l)" n)
                                      "Typst: opening preview")))
                    (typst-block-preview--view pdf))
           (typst-block-preview--report-error srcbuf (process-buffer proc) tmp)))))))

;;;###autoload
(defun typst-block-preview-with-head (&optional levels)
  "Like `typst-block-preview' but keeps the #call(..) before the block."
  (interactive "p")
  (typst-block-preview levels t))

;;;###autoload
(defun typst-block-preview-show-source (&optional levels with-head)
  "Show, without compiling, the exact document the preview would compile."
  (interactive "p")
  (let ((text (typst-block-preview--build (max 1 (or levels 1)) with-head))
        (buf (get-buffer-create "*typst-preview-source*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t)) (erase-buffer) (insert text))
      (goto-char (point-min))
      (special-mode))
    (pop-to-buffer buf)))

;;;###autoload
(defun typst-block-preview-reopen ()
  "Open the last preview PDF again without recompiling."
  (interactive)
  (if (and typst-block-preview--last-pdf (file-exists-p typst-block-preview--last-pdf))
      (typst-block-preview--view typst-block-preview--last-pdf)
    (user-error "No preview yet")))

;;;###autoload
(defun typst-block-preview-show-log ()
  "Show the output of the last typst run."
  (interactive)
  (pop-to-buffer typst-block-preview--log-buffer))

(provide 'typst-block-preview)
;;; typst-block-preview.el ends here
