;;; init.el --- ONE config for phone (Termux) and desktop (WSL, GUI): evil + Typst + Hebrew  -*- lexical-binding: t; -*-

;; ======================================================================
;; ONE FILE FOR BOTH MACHINES.  At startup it asks "where am I?" (see
;; `my/termux-p' just below) and switches what differs:
;;
;;   PHONE   (Termux, terminal): tiny screen, ONE window, Android PDF viewer,
;;           saves itself often (Android may kill Termux), phone clipboard,
;;           a calmer language-server timing to save battery.
;;   DESKTOP (WSL, GUI window):  font + maximized window, many windows, the PDF
;;           shown in a window on the RIGHT, line numbers, current-line
;;           highlight, window-layout undo, smooth scrolling, snappier
;;           language server, errors in a bottom panel.
;;
;; Everything not marked PHONE or DESKTOP behaves the same on both.
;;
;; WHERE THE FILES LIVE: the two config files sit in the synced repo, in
;; ~/notes/.emacs/ (init.el, typst-block-preview.el).  Emacs itself only reads
;; ~/.emacs.d/init.el, so that file is a tiny stub on each machine:
;;     (load (expand-file-name "~/notes/.emacs/init.el") nil 'nomessage)
;; Machine-local stuff (installed packages, custom.el, backups, undo history,
;; the saved session) stays in ~/.emacs.d/ and is NOT synced -- on purpose.
;;
;; SETUP -- phone (Termux), once:
;;   pkg update && pkg upgrade
;;   pkg install emacs git typst clang make
;;   put init.el and typst-block-preview.el in ~/notes/.emacs/ (the git repo)
;;   and make the 2-line stub ~/.emacs.d/init.el  (see "WHERE THE FILES LIVE")
;;   emacs                       first start downloads packages (needs
;;                               internet, 1-2 min; ignore the warnings)
;;
;; SETUP -- desktop (Fedora in WSL), once:
;;   sudo dnf install emacs git gcc gcc-c++ make ghostscript dejavu-sans-mono-fonts
;;       (gcc/make = compile the Typst grammar; ghostscript = the PDF side
;;        window.  Check `dnf info typst' -- if Fedora has it, install it;
;;        else use a GitHub release binary or `cargo install --locked
;;        typst-cli'.  tinymist and typstyle (optional) the same way.)
;;   same two files in ~/notes/.emacs/, same stub in ~/.emacs.d/init.el
;;   emacs &                     a window opens through WSLg
;;   Keep your notes inside WSL (e.g. ~/notes), NOT under /mnt/c: git, typst
;;   and file watching are much faster and more reliable there.
;;
;; Then, inside Emacs, once on EACH machine:  M-x typst-ts-mc-install-grammar RET
;; (compiles the Typst syntax grammar; this is why a C compiler is installed).
;; If Emacs was built without tree-sitter, nothing breaks: a small built-in
;; fallback mode (section 7) is used instead.
;;
;; Extra packages used (installed automatically on first start): evil,
;; evil-collection, evil-surround, evil-commentary, undo-fu-session.
;; Project settings that are NOT in this file live in a .dir-locals.el next
;; to your notes (see section 6, "Direction per file").
;;
;; Read this file top to bottom once: every section says what it does and why.
;; Press  SPC ?  (in normal mode) for a one-screen key cheat sheet.
;; ======================================================================


;;;; Which machine is this? --------------------------------------------------
;; Used everywhere below as  (if my/termux-p PHONE-thing DESKTOP-thing).
(defconst my/termux-p
  (and (or (getenv "TERMUX_VERSION")
           (string-match-p "android" system-configuration))
       t)
  "Non-nil when Emacs runs inside Termux on the phone.")
(defconst my/wsl-p
  (and (not my/termux-p)
       (or (getenv "WSL_DISTRO_NAME")
           (string-match-p "microsoft" (downcase operating-system-release)))
       t)
  "Non-nil when Emacs runs inside Windows Subsystem for Linux.")


;;;; 0. Packages ---------------------------------------------------------
;; Emacs's "Customize" system and package.el like to append their own
;; (custom-set-variables ...) blocks to your init file.  Send them to a
;; separate file instead, so this file stays yours.  This MUST come before
;; the package code below.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; Emacs downloads extra packages from "archives".  Emacs 29+ already knows
;; GNU ELPA and NonGNU ELPA; MELPA is added because evil-collection is there.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents (ignore-errors (package-refresh-contents)))
;; `use-package' (built in since Emacs 29) = "install this package if
;; missing, then configure it".  :ensure t means "install if missing".
(require 'use-package)

;; typst-block-preview.el lives next to THIS file (wherever the stub loaded it
;; from, e.g. ~/notes/.emacs/); ~/.emacs.d/lisp/ also works.
(when load-file-name
  (add-to-list 'load-path (file-name-directory (file-truename load-file-name))))
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path user-emacs-directory)

;; DESKTOP: programs installed with cargo / pip --user (typst, tinymist,
;; typstyle) live in these folders, which Emacs does not see when it was not
;; started from a shell that has them on PATH.
(unless my/termux-p
  (dolist (dir '("~/.cargo/bin" "~/.local/bin"))
    (let ((d (expand-file-name dir)))
      (when (and (file-directory-p d) (not (member d exec-path)))
        (add-to-list 'exec-path d)
        (setenv "PATH" (concat d ":" (getenv "PATH")))))))


;;;; 1. Basics ---------------------------------------------------------------
;; Always UTF-8: Hebrew and Typst symbols need it.
(set-language-environment "UTF-8")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq inhibit-startup-screen t        ; no welcome screen
      initial-scratch-message nil
      use-short-answers t             ; "y"/"n" instead of typing "yes"
      ring-bell-function #'ignore
      confirm-kill-processes nil
      ;; Emacs normally drops a symlink named .#file next to every file you
      ;; edit (an "I am editing this" flag).  With git sync those links get
      ;; committed, so switch the feature off.
      create-lockfiles nil
      ;; keep backup files out of your notes folder
      backup-directory-alist `(("." . ,(locate-user-emacs-file "backups/")))
      auto-save-list-file-prefix (locate-user-emacs-file "auto-save-list/.saves-"))
(setq-default indent-tabs-mode nil)

;; Save the real file automatically after a few idle seconds (no "unsaved"
;; panic).  Phone: Android can kill Termux while you look at the PDF.
(setq auto-save-visited-interval 4)
(auto-save-visited-mode 1)

(global-auto-revert-mode 1)           ; reload files changed on disk (git pull, sync)
(save-place-mode 1)                   ; reopen a file at the line you left
(setq recentf-max-saved-items 500)    ; default is only 20
(recentf-mode 1)                      ; remember recent files (SPC f r)
(unless (display-graphic-p) (xterm-mouse-mode 1))  ; terminal only: tap = move cursor, drag = scroll
(show-paren-mode 1)                   ; highlight the matching bracket

;; --- Survive a crash or kill (phone: Android killing Termux) ------------------
;; Android can kill Termux at any moment, and then Emacs never gets to run its
;; "save everything on exit" code.  So each of these things is saved while you
;; work (on a timer), not only at exit.
;;   1. savehist: remembers what you typed in M-x / find-file / search prompts.
(setq savehist-autosave-interval 60)  ; seconds (the default is 300)
(savehist-mode 1)
;;   2. desktop: remembers which files were open, so a restart brings them back.
(setq desktop-dirname user-emacs-directory
      desktop-path (list user-emacs-directory)
      desktop-save t                  ; save without asking
      desktop-auto-save-timeout 30    ; also save every 30 idle seconds
      desktop-load-locked-desktop t   ; after a kill the old "lock" is stale: ignore it
      desktop-restore-eager 5         ; open 5 files at once, the rest while idle
      desktop-restore-frames nil)     ; restore buffers only, not window layout
(desktop-save-mode 1)
;; PDFs shown in the side window (section 13) are temporary: never restore them.
(with-eval-after-load 'desktop
  (add-to-list 'desktop-modes-not-to-save 'doc-view-mode))
;;   3. recentf (above): its list is normally written only on exit, so write
;;      it quietly once a minute while Emacs is idle.
(run-with-idle-timer 60 t (lambda ()
                            (let ((inhibit-message t)) (recentf-save-list))))
;;   4. undo-fu-session: keeps the UNDO history on disk, so u / C-r still work
;;      after a restart.  (A package: installed in section 4, next to evil.)

;; PHONE, OPTIONAL: copy from Emacs to the Android clipboard (vim y, d, Emacs M-w).
;; (Desktop: GUI Emacs under WSLg shares the Windows clipboard by itself.)
;; Needs:  pkg install termux-api  AND the "Termux:API" app (F-Droid).
;; Pasting INTO Emacs needs nothing: use Termux's own paste (long-press, or
;; Ctrl+Alt+V on a keyboard); Emacs receives it as one paste, not as typing.
(when (and my/termux-p (executable-find "termux-clipboard-set"))
  (setq interprogram-cut-function
        (lambda (text)
          (when (and (> (length text) 0) (< (length text) 200000))
            (let ((p (make-process :name "clip" :command '("termux-clipboard-set")
                                   :connection-type 'pipe :noquery t)))
              (process-send-string p text)
              (process-send-eof p))))))

;; Brackets pair themselves: type ( and get ().  Quotes are NOT paired on
;; purpose: Hebrew abbreviations like ד"ר would fight with it.
(setq electric-pair-pairs nil electric-pair-text-pairs nil)
(electric-pair-mode 1)

;; DESKTOP: this machine has the power.  Fewer garbage-collection pauses and a
;; bigger pipe to the language server make eglot feel snappier.
(unless my/termux-p
  (setq gc-cons-threshold (* 64 1024 1024)
        read-process-output-max (* 1024 1024)))


;;;; 2. Screen: small phone terminal vs. big desktop window ------------------
;; PHONE: the font SIZE is a Termux setting, not an Emacs one (pinch-zoom, or
;; Ctrl+Alt+ + / -).  The menu bar is off (it costs a whole line) and Emacs
;; stays in ONE window.
;; DESKTOP: a real GUI window.  Font below; change its size live with
;; C-x C-+ / C-x C-- (or Ctrl + mouse wheel).  `my/font-size' is the startup
;; size in 1/10 pt (120 = 12 pt).  DejaVu Sans Mono has Hebrew letters.
(defvar my/font-size 120 "Desktop startup font size in 1/10 point.")
(defvar my/font-candidates '("DejaVu Sans Mono" "Noto Sans Mono" "Liberation Mono")
  "Monospace fonts to try, in order (the first installed one is used).")
(defun my/setup-gui (&optional frame)
  "Set the font of a graphical FRAME (does nothing in a terminal)."
  (when (display-graphic-p frame)
    (let ((family (seq-find (lambda (f) (find-font (font-spec :family f) frame))
                            my/font-candidates)))
      (when family
        (set-face-attribute 'default frame :family family :height my/font-size)))))
(my/setup-gui)
(add-hook 'after-make-frame-functions #'my/setup-gui)   ; also frames made later

(menu-bar-mode -1)                    ; (desktop: delete this line to get the menu bar back)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))
(blink-cursor-mode -1)
(setq-default truncate-lines nil)     ; wrap long lines instead of scrolling sideways
(setq scroll-conservatively 101       ; scroll one line at a time, not by half pages
      scroll-margin 2)

(if my/termux-p
    (progn
      ;; PHONE: never auto-split the screen in two: there is no room.
      (setq split-width-threshold nil
            split-height-threshold nil)
      ;; Help, cheat sheet, logs open in the SAME window (q returns to your text).
      (add-to-list 'display-buffer-alist
                   '("\\*\\(Help\\|Cheatsheet\\|typst-preview\\|Messages\\|Warnings\\|Packages\\)\\*"
                     (display-buffer-same-window)))
      ;; Same for the list of TODOs, the grep results and the git-sync log.
      (add-to-list 'display-buffer-alist
                   '("\\*\\(Occur\\|grep\\|git-sync\\)\\*"
                     (display-buffer-same-window))))
  ;; DESKTOP: several windows are fine.
  (global-hl-line-mode 1)             ; highlight the current line
  (winner-mode 1)                     ; undo / redo window layouts (SPC w u / r)
  (when (and (display-graphic-p) (fboundp 'pixel-scroll-precision-mode))
    (pixel-scroll-precision-mode 1))  ; smooth mouse-wheel / touchpad scrolling
  ;; Lists (compile errors, TODOs, references, error list, git-sync log) open
  ;; in a panel at the BOTTOM, 30% high; q closes it.  Your text stays visible.
  (add-to-list 'display-buffer-alist
               '("\\*\\(Occur\\|grep\\|compilation\\|git-sync\\|xref\\|eldoc\\|Flymake diagnostics.*\\|Flymake log\\)\\*"
                 (display-buffer-at-bottom)
                 (window-height . 0.3))))

;; One compact mode line:  " N  notes.typ*  12:5 [HE] RTL  Typst LSP"
;;   N/I/V = vim state, * = unsaved, 12:5 = line:column,
;;   [HE] = Hebrew typing on, LTR/RTL = forced paragraph direction,
;;   Narrow = only one problem is visible (SPC e w / SPC e W),
;;   LSP = the language server (tinymist) is attached.
(defun my/evil-tag ()
  (let ((s (and (bound-and-true-p evil-local-mode) (bound-and-true-p evil-state))))
    (propertize (pcase s
                  ('normal " N ") ('insert " I ") ('visual " V ") ('replace " R ")
                  ('emacs " E ") ('motion " M ") (_ ""))
                'face 'mode-line-emphasis)))
(defun my/mode-line-extra ()
  (concat (when current-input-method " [HE]")
          (pcase bidi-paragraph-direction
            ('left-to-right " LTR") ('right-to-left " RTL") (_ ""))
          (when (buffer-narrowed-p) " Narrow")))
(defun my/lsp-tag ()
  (if (and (fboundp 'eglot-current-server) (eglot-current-server)) " LSP" ""))
;; ONE definition of the whole mode line (it used to be two, the second one
;; appended the LSP tag).
(setq-default mode-line-format
              '("%e" (:eval (my/evil-tag)) " %b%* " "%l:%c"
                (:eval (my/mode-line-extra)) "  %m" (:eval (my/lsp-tag))))

;; Theme: Modus Vivendi = pure black background, white text, very high
;; contrast (designed for accessibility; good at arm's length and on OLED).
(setq modus-themes-bold-constructs t)
(load-theme 'modus-vivendi t)
(defun my/toggle-theme ()
  "Switch between the dark and the light high-contrast theme."
  (interactive)
  (let ((dark (memq 'modus-vivendi custom-enabled-themes)))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme (if dark 'modus-operandi 'modus-vivendi) t)))

(defun my/toggle-line-numbers ()
  "Relative line numbers on/off (useful for 5j / 12dd, costs 4 columns)."
  (interactive)
  (setq display-line-numbers-type 'relative)
  (display-line-numbers-mode 'toggle))


;;;; 3. Learning aids ------------------------------------------------------
;; which-key: press a prefix (SPC, C-x, C-c ...), wait half a second, and
;; a small panel lists what you can press next.  The best Emacs teacher.
(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 0.5
        which-key-side-window-max-height 0.3)   ; at most 30% of the screen
  (which-key-mode 1))

;; Completion for M-x, find-file, switch-buffer: a vertical list that
;; narrows as you type.  C-n/C-p (or arrows) move, RET picks, and
;; C-j accepts EXACTLY what you typed (to create a new file name).
(setq icomplete-compute-delay 0)
(fido-vertical-mode 1)

(defvar my/cheatsheet-text
  (concat
  "SPC = leader key (vim normal mode). Pause after it: a menu appears.
 SPC SPC  run command (M-x)     SPC ?    this sheet
 SPC f f  open file             SPC f s  save     SPC f r  recent files
 SPC b b  switch buffer         SPC b k  close buffer
 SPC s i  jump to a heading     SPC w m  maximize window
 SPC h k  what does this key do SPC h f/v  describe function/variable
 SPC t d  paragraph direction (auto/LTR/RTL)
 SPC t i  Hebrew typing on/off  (C-\\ also, in insert mode)
 SPC t n  line numbers          SPC t t  dark/light theme
 SPC p p  PREVIEW the [..] around the cursor
 SPC p 2  ...one level further up   SPC p 3  two levels up
 SPC p h  preview including the #call(..) in front of the [
 SPC p l  typst log  SPC p o  reopen last preview
 SPC p s  show the exact text the preview compiles (debugging)
 SPC c f/r/a  format / rename / fixes
 SPC c d/R/b  definition / uses / back
 SPC c n/p    next / previous error
 SPC c e/E    errors: this file / project
 SPC c h  docs   SPC c s  find symbol
 SPC c i  inline hints   SPC c x  restart LSP
 SPC t c  suggestions on/off (TAB = accept,
          M-n / M-p = next / previous one)
 SPC i    snippet menu ($, math, #proof[] ...)
 SPC e n  next problem heading  SPC e f  new pset file
 SPC e w / W  narrow / widen to this problem
 ]] / [[  next / previous problem
 SPC e t / T  list TODOs (file / project)
 za zM zR  fold problem / fold all / open all
 SPC p c  compile + open PDF   SPC p w  typst watch
 SPC p v  open the PDF
 SPC g s  git sync (add, commit, pull, push)
 i$ a$    text object: inside / around $..$
 gcc      comment line (gc + motion: gcap)
 ys cs ds surround: ysiw$ = $word$, ysiwP = #proof[word]
 C-\\     Hebrew on/off by hand (insert mode)
 SPC q q  quit Emacs

Vim: Esc = normal, i/a/o insert, v/V visual, u undo, C-r redo,
 dd yy p, ciw, ci[ (change inside [ ]), dap, / search, n next,
 gg G, % jump to matching bracket, :w save, :q quit, C-u/C-d half page.
Emacs: C-g cancels ANYTHING.  M-x = Alt+x.  C-x C-f / C-x C-s still work.
Hebrew line: l / w move in READING direction (left on screen);
 the arrow keys always move visually.
"
  (if my/termux-p
      "In Termux avoid Ctrl+Alt+<key>: Termux itself grabs those.
"
    "DESKTOP: SPC p c shows the PDF in a window on the RIGHT (it refreshes
 itself on every compile; SPC p w = typst watch, SPC p W = its log).
 SPC w h/j/k/l  go to window   SPC w u / r  undo / redo window layout
 SPC t n  line numbers (already on in Typst files)
 Font size: C-x C-+ / C-x C--  (or Ctrl + mouse wheel).
")
  "	q closes this sheet.")
  "Text of the cheat sheet buffer.")

(defun my/cheatsheet ()
  "Show the key cheat sheet."
  (interactive)
  (let ((buf (get-buffer-create "*Cheatsheet*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert my/cheatsheet-text))
      (goto-char (point-min))
      (special-mode))
    (pop-to-buffer buf)))


;;;; 4. Vim emulation: evil ---------------------------------------------------
;; evil = vim inside Emacs: modes, hjkl, dd, ciw, /search, :w, macros, text
;; objects.  These variables must be set BEFORE evil loads (hence :init).
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t       ; let evil cooperate with other packages
        evil-want-keybinding nil      ; evil-collection (below) does that instead
        evil-want-C-u-scroll t        ; C-u scrolls up like vim (C-d scrolls down)
        evil-want-C-i-jump nil        ; in a terminal TAB and C-i are the same key
        evil-want-Y-yank-to-eol t     ; Y = y$
        evil-undo-system 'undo-redo   ; u / C-r behave like vim
        evil-respect-visual-line-mode t ; j/k/0/$ follow WRAPPED lines (essential for long Hebrew paragraphs)
        evil-mode-line-format nil     ; our own mode line shows the state
        evil-shift-width 2)
  :config
  (evil-mode 1))

;; Vim-style keys in the places where plain evil leaves you in Emacs-land.
;; ONE call lists every place:
;;   dired = file browser, help, info = the manual,
;;   xref = references list, flymake = error list (section 8),
;;   compile = the typst error buffer (section 13), occur / grep = TODO lists.
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init '(dired help info xref flymake compile occur grep doc-view)))

;; evil-surround: wrap / change / remove brackets around text.
;;   ysiw)   wrap the word in ( )       cs"'   change " to '
;;   ds)     remove the ( )             S)     (in visual mode) wrap selection
;; Typst-specific pairs ($, P, D) are added in section 7.
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

;; evil-commentary: gcc comments / uncomments the line; gc + a motion does
;; more (gcap = a whole paragraph); in visual mode just press gc.  Handy for
;; hiding a failed attempt without deleting it.
(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode 1))

;; undo-fu-session: saves the undo history of each file on disk (see the
;; "Survive a crash or kill" part of section 1).
(use-package undo-fu-session
  :ensure t
  :config
  (setq undo-fu-session-compression nil)   ; plain files: simpler
  (undo-fu-session-global-mode 1))


;;;; 5. The SPC menu (leader key) ---------------------------------------------
;; In normal/visual mode SPC opens a menu of everything below, labelled by
;; which-key.  Add your own with (my/leader "x y" #'some-command).
(defvar my/leader-map (make-sparse-keymap) "Keymap behind the SPC key.")
(defun my/leader (key command)
  (define-key my/leader-map (kbd key) command))

(with-eval-after-load 'evil
  (dolist (map (list evil-normal-state-map evil-visual-state-map evil-motion-state-map))
    (define-key map (kbd "SPC") my/leader-map))
  ;; In INSERT mode, C-\ switches Hebrew typing on/off by hand.  In Typst
  ;; buffers this is a manual OVERRIDE of the automatic switching (section 9).
  (define-key evil-insert-state-map (kbd "C-\\") #'my/toggle-hebrew))

(my/leader "SPC" #'execute-extended-command)
(my/leader "?"   #'my/cheatsheet)
(my/leader "f f" #'find-file)
(my/leader "f s" #'save-buffer)
(my/leader "f r" #'recentf-open)
(my/leader "f d" #'dired)
(my/leader "b b" #'switch-to-buffer)
(my/leader "b k" #'kill-current-buffer)
(my/leader "b n" #'next-buffer)
(my/leader "b p" #'previous-buffer)
(my/leader "w w" #'other-window)
(my/leader "w m" #'delete-other-windows)
(my/leader "w d" #'delete-window)
(my/leader "w s" #'split-window-below)
(my/leader "w v" #'split-window-right)
(unless my/termux-p                   ; DESKTOP: several windows are normal
  (my/leader "w h" #'evil-window-left)
  (my/leader "w j" #'evil-window-down)
  (my/leader "w k" #'evil-window-up)
  (my/leader "w l" #'evil-window-right)
  (my/leader "w u" #'winner-undo)     ; undo a window-layout change
  (my/leader "w r" #'winner-redo))
(my/leader "s i" #'imenu)             ; headings / definitions of this file
(my/leader "t n" #'my/toggle-line-numbers)
(my/leader "t t" #'my/toggle-theme)
(my/leader "t d" #'my/cycle-bidi-direction)
(my/leader "t i" #'toggle-input-method)
(my/leader "h"   help-map)            ; SPC h k, SPC h f, SPC h v, SPC h t (tutorial)
(my/leader "q q" #'save-buffers-kill-terminal)

;; The keys for the features of sections 9-14 are defined next to those
;; features:  SPC i (snippets)  SPC e (problems)  SPC p c/w/v (compile)
;;            SPC g s (git sync)

(autoload 'typst-block-preview "typst-block-preview" nil t)
(autoload 'typst-block-preview-with-head "typst-block-preview" nil t)
(autoload 'typst-block-preview-reopen "typst-block-preview" nil t)
(autoload 'typst-block-preview-show-log "typst-block-preview" nil t)
(my/leader "p p" #'typst-block-preview)
(defun my/preview-2-levels () "Preview the block 2 levels up." (interactive) (typst-block-preview 2))
(defun my/preview-3-levels () "Preview the block 3 levels up." (interactive) (typst-block-preview 3))
(my/leader "p 2" #'my/preview-2-levels)
(my/leader "p 3" #'my/preview-3-levels)
(my/leader "p h" #'typst-block-preview-with-head)
(my/leader "p o" #'typst-block-preview-reopen)
(my/leader "p l" #'typst-block-preview-show-log)
(autoload 'typst-block-preview-show-source "typst-block-preview" nil t)
(my/leader "p s" #'typst-block-preview-show-source)
;; The block preview shows its PDF through `my/open-pdf' (section 13), so the
;; phone viewer, the desktop side window and the Windows viewer all follow one rule.
(with-eval-after-load 'typst-block-preview
  (setq typst-block-preview-viewer #'my/open-pdf))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "SPC f" "file" "SPC b" "buffer" "SPC w" "window" "SPC s" "jump"
    "SPC t" "toggle" "SPC p" "typst preview/compile" "SPC h" "help" "SPC q" "quit"
    "SPC i" "snippets" "SPC e" "problems" "SPC g" "git"))


;;;; 6. Hebrew and mixed right-to-left / left-to-right text -------------------
;; Emacs implements the Unicode bidi algorithm itself (a terminal such as
;; Termux does not reorder text on its own), so what you see is Emacs's
;; correct visual order.
;;
;; bidi-paragraph-direction nil = decide per paragraph from the first strong
;; letter: a line starting with Hebrew is displayed right-to-left, one
;; starting with Latin/#/$ left-to-right.  The two regexps below make EVERY
;; LINE its own paragraph, so a Typst code line next to Hebrew prose never
;; flips its direction (by default a "paragraph" runs until a blank line).
(setq-default bidi-display-reordering t
              bidi-paragraph-direction nil
              bidi-paragraph-start-re "^"
              bidi-paragraph-separate-re "^")

(defun my/cycle-bidi-direction ()
  "Cycle this buffer's text direction: auto -> LTR -> RTL -> auto."
  (interactive)
  (setq bidi-paragraph-direction
        (pcase bidi-paragraph-direction
          ('nil 'left-to-right) ('left-to-right 'right-to-left) (_ nil)))
  (force-mode-line-update)
  (message "Text direction: %s" (or bidi-paragraph-direction "auto")))

;; Typing Hebrew.  PROBLEM: if the keyboard layout (Android / Windows) is Hebrew, vim
;; commands (dd, ciw, :w ...) stop working in normal mode, because they
;; arrive as Hebrew letters.  SOLUTION: keep the keyboard on ENGLISH and
;; let Emacs type Hebrew: C-\ (or SPC t i) toggles Emacs's "hebrew" input
;; method = the standard Israeli layout (a->ש  s->ד  d->ג  f->כ  ...  period
;; is "/", as on a Hebrew keyboard).  Evil switches it off automatically in
;; normal mode and back on when you press i, so commands always work.
;; The input method would also remap ( ) and punctuation, which breaks Typst
;; code and math.  In Typst buffers section 9 therefore switches it on and off
;; BY ITSELF while you type: on in plain text, off inside $math$ and #code.
;; The mode line shows [HE] while it is on.
(setq default-input-method "hebrew")

;; --- Direction per file ---------------------------------------------------
;; With "auto" direction (above) a line that STARTS with $, # or a Latin
;; letter is laid out left-to-right, even when the rest of the sentence is
;; Hebrew.  For lecture / problem-set files that looks wrong, so those files
;; are forced to right-to-left by a .dir-locals.el next to them:
;;
;;   ((typst-ts-mode   . ((bidi-paragraph-direction . right-to-left)))
;;    (typst-lite-mode . ((bidi-paragraph-direction . right-to-left))))
;;
;; (Emacs applies it to every file in that folder and below.)  SPC t d still
;; cycles auto -> LTR -> RTL for the current file.
;;
;; 1. Tell Emacs this value is harmless, so it does not ask "is it safe?"
;;    every time.
(put 'bidi-paragraph-direction 'safe-local-variable
     (lambda (v) (memq v '(nil left-to-right right-to-left))))
;; 2. The files listed here stay on "auto" even when the folder says RTL.
(defvar my/bidi-auto-files '("preamble.typ")
  "File names (no directory) that keep automatic text direction.")
(defun my/bidi-auto-for-some-files ()
  "Undo the folder's forced direction for the files in `my/bidi-auto-files'."
  (when (and buffer-file-name
             (derived-mode-p 'typst-ts-mode 'typst-lite-mode)
             (member (file-name-nondirectory buffer-file-name) my/bidi-auto-files))
    (setq-local bidi-paragraph-direction nil)))
;; This hook runs AFTER .dir-locals.el has been applied to the buffer.
(add-hook 'hack-local-variables-hook #'my/bidi-auto-for-some-files)


;;;; 7. Typst ---------------------------------------------------------------------
;; typst-ts-mode = good highlighting/indent/headings, based on tree-sitter.
;; It needs (1) Emacs built with tree-sitter and (2) the grammar, which you
;; install once with  M-x typst-ts-mc-install-grammar.
(use-package typst-ts-mode
  :ensure t
  :defer t
  :if (and (fboundp 'treesit-available-p) (treesit-available-p))
  :init
  (with-eval-after-load 'treesit
    (add-to-list 'treesit-language-source-alist
                 '(typst "https://github.com/uben0/tree-sitter-typst"))))

;; Fallback: colours for headings, #commands, $math$, comments, list markers.
(defvar typst-lite-font-lock-keywords
  '(("^[ \t]*\\(=+\\)[ \t].*$" 0 font-lock-function-name-face)
    ("\\$[^$]*\\$" 0 font-lock-string-face)
    ("#[[:alpha:]_][[:alnum:]_.-]*" 0 font-lock-keyword-face)
    ("^[ \t]*\\([-+]\\)[ \t]" 1 font-lock-builtin-face)
    ("//.*$" 0 font-lock-comment-face t)))
(define-derived-mode typst-lite-mode text-mode "Typst-lite"
  "Minimal Typst mode (colours only), used when tree-sitter is unavailable."
  (setq-local comment-start "// " comment-end "")
  (setq-local font-lock-defaults '(typst-lite-font-lock-keywords)))

(defun my/typst-mode ()
  "Use typst-ts-mode when its grammar is installed, else the lite mode.
When it falls back, the reason is written to *Messages*."
  ;; `treesit-ready-p' is NOT autoloaded: until treesit.el is loaded,
  ;; (fboundp 'treesit-ready-p) is nil.  The old check ran before anything
  ;; loaded it, so it failed every time and silently chose the lite mode.
  (when (and (fboundp 'treesit-available-p) (treesit-available-p))
    (require 'treesit))
  (let ((why (cond
              ((not (fboundp 'treesit-ready-p))
               "this Emacs has no tree-sitter support")
              ((not (fboundp 'typst-ts-mode))
               "package typst-ts-mode is not installed")
              ((not (treesit-ready-p 'typst t))
               (format "typst grammar not usable: %S"
                       (treesit-language-available-p 'typst t))))))
    (if why
        (progn (message "typst-lite-mode: %s" why) (typst-lite-mode))
      (typst-ts-mode))))
(add-to-list 'auto-mode-alist '("\\.typ\\'" . my/typst-mode))

(defun my/typst-setup ()
  "Per-buffer setup for Typst files (runs in both Typst modes)."
  (visual-line-mode 1)                ; wrap at the screen edge (not mid-word)
  (setq-local tab-width 2)
  ;; DESKTOP: relative line numbers (for 5j, 12dd).  Phone: off, they cost columns.
  (unless my/termux-p
    (setq-local display-line-numbers-type 'relative)
    (display-line-numbers-mode 1))
  ;; $ pairs like brackets: typing $ gives $|$ and typing $ again steps over it
  (setq-local electric-pair-pairs '((?$ . ?$)))
  ;; Comment syntax, needed by gcc / gc (evil-commentary): // like Typst.
  (setq-local comment-start "// " comment-end "" comment-start-skip "//+[ \t]*")
  ;; Hebrew typing switches itself on/off (section 9).
  (add-hook 'post-command-hook #'my/typst-auto-input-method nil t)
  (add-hook 'evil-insert-state-exit-hook #'my/hebrew-forget-override nil t)
  ;; Extra surround pairs (evil-surround): ysiw$  -> $word$
  ;;   ysiwP -> #proof[word]      ysiwD -> #definition[word]
  ;; (Capital P / D: a small p would clash with the paragraph text object.)
  (setq-local evil-surround-pairs-alist
              (append '((?$ . ("$" . "$"))
                        (?P . ("#proof[" . "]"))
                        (?D . ("#definition[" . "]")))
                      (default-value 'evil-surround-pairs-alist)))
  ;; Folding: lines starting with "=" are outline headings, so za / zc / zo /
  ;; zM / zR (evil) fold and unfold problems.  We set the heading pattern by
  ;; hand, because it must work in the fallback mode too.
  (setq-local outline-regexp "=+[ \t]")
  (setq-local outline-level (lambda () (1- (- (match-end 0) (match-beginning 0)))))
  (when (boundp 'outline-search-function)    ; Emacs 30: force the pattern above
    (setq-local outline-search-function nil))
  (outline-minor-mode 1))
(add-hook 'typst-ts-mode-hook #'my/typst-setup)
(add-hook 'typst-lite-mode-hook #'my/typst-setup)
(add-hook 'text-mode-hook #'visual-line-mode)

;; ]] and [[ jump to the next / previous problem (section 12).  They replace
;; evil's "next section" keys, but only in Typst buffers.
(defun my/typst-problem-keys (map)
  (evil-define-key* 'motion map
    (kbd "]]") #'my/problem-forward
    (kbd "[[") #'my/problem-backward))
(my/typst-problem-keys typst-lite-mode-map)
(with-eval-after-load 'typst-ts-mode
  (my/typst-problem-keys typst-ts-mode-map))

;; The block preview (SPC p p ...) lives in typst-block-preview.el, loaded on
;; first use via the autoloads in section 5.  It expects a comment line
;;     // END preamble
;; at the end of your template/preamble.

;;;; 8. Typst language server (tinymist) via eglot -----------------------------
;; The server (tinymist) is a separate program; eglot is Emacs's built-in
;; client for it.  Install the server first (Termux: pkg install tinymist; desktop: a release binary or cargo).
;; Nothing here needs an extra package.  Completion uses Emacs 30's built-in
;; completion-preview-mode (check with M-x emacs-version).

(with-eval-after-load 'eglot
  ;; WHICH program to start for Typst files (our entry goes first).
  (add-to-list 'eglot-server-programs '(typst-ts-mode . ("tinymist")))
  ;; Stop the server when the last Typst buffer closes: saves battery/RAM.
  (setq eglot-autoshutdown t)
  ;; Settings sent to the server (built by `my/tinymist-config' below, so
  ;; they can depend on the project you are in).
  (setq-default eglot-workspace-configuration #'my/tinymist-config)
  ;; Tuning (phone-friendly, harmless on the desktop):
  ;;  - eglot keeps a log of every message to/from the server.  Size 0 = keep
  ;;    no log: saves memory and CPU.  (Newer Emacs renamed the setting, so
  ;;    both names are set.)
  (setq eglot-events-buffer-size 0)
  (when (boundp 'eglot-events-buffer-config)
    (setq eglot-events-buffer-config '(:size 0 :format full)))
  ;;  - how long Emacs waits after your LAST keystroke before telling the
  ;;    server about the change (default 0.5 s).  Larger = fewer updates
  ;;    while typing, less battery; errors and hints appear a bit later.
  ;;    Phone 1.5 s (battery); desktop 0.5 s (snappier).
  (setq eglot-send-changes-idle-time (if my/termux-p 1.5 0.5))
  ;; Newer eglot versions add commands; bind them only if they exist.
  (when (fboundp 'eglot-semantic-tokens-mode)    ; server-based coloring
    (my/leader "c t" #'eglot-semantic-tokens-mode))
  (when (fboundp 'eglot-describe-connection)     ; which server, project, version
    (my/leader "c ?" #'eglot-describe-connection)))

;; The settings for tinymist.  A function (not a fixed list) so that the font
;; folder is found per project.
;;   formatterMode "typstyle" = use typstyle for formatting (SPC c f).
;;   exportPdf "never"        = the server must NOT write PDFs by itself; PDFs
;;                              come from SPC p c (section 13) only.
;;   fontPaths                = extra folder(s) with fonts: the project's
;;                              fonts/ folder, if it has one.
(defun my/tinymist-config (&optional _server)
  (let ((fonts (expand-file-name "fonts" (my/project-root))))
    `(:tinymist (:formatterMode "typstyle"
                 :exportPdf "never"
                 :fontPaths ,(if (file-directory-p fonts) (vector fonts) [])))))

;; Start eglot automatically in Typst files, only if tinymist exists.
;; The check runs at Emacs startup, so restart Emacs after installing it.
(when (executable-find "tinymist")
  (add-hook 'typst-ts-mode-hook #'eglot-ensure))

;; Small screen: keep hover/signature text in the bottom line to ONE row.
(setq eldoc-echo-area-use-multiline-p nil)

;; --- Completion: built-in completion-preview-mode ---------------------------
;; While you type, the best suggestion appears as faint text after the
;; cursor.  Eglot feeds it the server's suggestions automatically.
;;   TAB = accept it.   M-n / M-p = show the next / previous suggestion.
;; Typing on ignores it; nothing is inserted unless you press TAB.
(when (fboundp 'completion-preview-mode)
  (add-hook 'typst-ts-mode-hook #'completion-preview-mode)
  (setq completion-preview-minimum-symbol-length 2) ; start after 2 characters
  (with-eval-after-load 'completion-preview
    ;; "TAB" is what a terminal sends, <tab> what a GUI sends: bind both.
    (define-key completion-preview-active-mode-map (kbd "TAB") #'completion-preview-insert)
    (define-key completion-preview-active-mode-map (kbd "<tab>") #'completion-preview-insert)
    (define-key completion-preview-active-mode-map (kbd "M-n") #'completion-preview-next-candidate)
    (define-key completion-preview-active-mode-map (kbd "M-p") #'completion-preview-prev-candidate))
  (my/leader "t c" #'completion-preview-mode))  ; off/on, handy for Hebrew prose

;; --- Lists open in the one window (PHONE; the desktop uses the bottom panel, section 2) ---
;; References, the error list, the doc buffer and eglot's info buffers replace
;; the current window (like Help in section 2).  q returns to your text.
(when my/termux-p
  (add-to-list 'display-buffer-alist
               '("\\*\\(xref\\|eldoc\\|Flymake diagnostics.*\\|Flymake log\\|EGLOT.*\\)\\*"
                 (display-buffer-same-window))))

;; (Vim-style keys in those lists come from the evil-collection call in
;; section 4.)

;; --- Keys, under SPC c ("code") -----------------------------------------------
;; An autoload = "load that file the first time this command is called",
;; so the keys work even before eglot has started.
(dolist (fn '(eglot eglot-format eglot-rename eglot-code-actions
                    eglot-reconnect eglot-inlay-hints-mode))
  (autoload fn "eglot" nil t))
(dolist (fn '(flymake-goto-next-error flymake-goto-prev-error
                                      flymake-show-buffer-diagnostics
                                      flymake-show-project-diagnostics))
  (autoload fn "flymake" nil t))
(autoload 'eldoc-doc-buffer "eldoc" nil t)

;; Formatting is a KEY, not format-on-save: section 1 saves every 4 idle
;; seconds, so format-on-save would rearrange text while you still think.
;; With a visual selection active, it formats only the selection.
(my/leader "c f" #'eglot-format)
(my/leader "c r" #'eglot-rename)           ; rename everywhere
(my/leader "c a" #'eglot-code-actions)     ; fixes offered at the cursor
(my/leader "c c" #'eglot)                  ; start eglot by hand
(my/leader "c x" #'eglot-reconnect)        ; restart the server if it misbehaves
(my/leader "c h" #'eldoc-doc-buffer)       ; full documentation of the thing at point
(my/leader "c d" #'xref-find-definitions)  ; go to definition (also: gd)
(my/leader "c R" #'xref-find-references)   ; list every use
(my/leader "c b" #'xref-go-back)           ; jump back after d / R
(my/leader "c s" #'xref-find-apropos)      ; search symbols in the project
(my/leader "c n" #'flymake-goto-next-error)
(my/leader "c p" #'flymake-goto-prev-error)
(my/leader "c e" #'flymake-show-buffer-diagnostics)  ; errors in this file
(my/leader "c E" #'flymake-show-project-diagnostics) ; errors in the whole project
(my/leader "c i" #'eglot-inlay-hints-mode) ; show/hide inline hints (parameter names)

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements "SPC c" "code"))


;;;; 9. Hebrew typing that switches itself (Typst buffers) ------------------------
;; While you type in INSERT mode, the Hebrew input method is
;;   ON   in plain text (markup), inside "strings" and inside // comments,
;;   OFF  inside $math$ and inside #code (#proof, #set ..., (...) arguments).
;; So you never press C-\ while writing a lecture.  The mode line [HE] shows
;; the current state.  C-\ still works as a MANUAL OVERRIDE: it flips Hebrew
;; and the automatic switching pauses until you move into a different kind of
;; place (for example from text into math) or leave insert mode.
;;
;; How it decides:
;;   typst-ts-mode   asks tree-sitter: it looks at the syntax tree around the
;;                   cursor.  The node names are listed in the two variables
;;                   below.  If switching ever misbehaves, M-x
;;                   treesit-inspect-mode shows the node name under the cursor
;;                   in the mode line; add that name to the right list.
;;   typst-lite-mode has no syntax tree, so it just counts $ signs from the
;;                   top of the file: an odd number before the cursor = in math.
;; In both modes, right after "#name" (while you type a command) Hebrew is off.

(defvar my/typst-on-nodes '("content" "source_file" "string" "comment")
  "Tree-sitter node types in which Hebrew typing should be ON.
\"content\" is the [ ... ] block, so #proof[ ... ] is text again inside.")

(defvar my/typst-off-nodes
  '("math" "code" "call" "group" "block" "let" "set" "show" "if" "else"
    "for" "while" "import" "include" "lambda" "branch" "field"
    "raw_blck" "raw_span" "label" "ref" "url")
  "Tree-sitter node types in which Hebrew typing should be OFF.")

(defun my/typst-ts-active-p ()
  "Non-nil when this buffer is a typst-ts-mode buffer with a working parser."
  (and (derived-mode-p 'typst-ts-mode)
       (fboundp 'treesit-parser-list)
       (treesit-parser-list)))

(defun my/typst-ts-hebrew-p ()
  "Tree-sitter test: non-nil when point is in plain text (Hebrew wanted).
Walk from the node under the cursor up to the root.  Only nodes that the
cursor is STRICTLY inside count (a cursor right after the closing $ is
outside the math node).  The first node found in one of the two lists wins."
  (let ((pos (point))
        (node (treesit-node-at (point) 'typst))
        (answer 'unknown))
    (while (and node (eq answer 'unknown))
      (when (and (< (treesit-node-start node) pos)
                 (< pos (treesit-node-end node)))
        (let ((type (treesit-node-type node)))
          (cond ((member type my/typst-off-nodes) (setq answer nil))
                ((member type my/typst-on-nodes) (setq answer t)))))
      (setq node (treesit-node-parent node)))
    (if (eq answer 'unknown) t answer)))

;; --- helpers that count dollar signs (fallback mode, and the i$ object) ---------
(defun my/typst-dollar-positions (&optional limit)
  "Positions of every unescaped $ in the whole buffer, up to LIMIT (or the end)."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let (found)
        (while (search-forward "$" limit t)
          (unless (eq (char-before (1- (point))) ?\\)   ; \$ is a literal dollar
            (push (1- (point)) found)))
        (nreverse found)))))

(defun my/typst-in-dollars-p ()
  "Non-nil when an odd number of $ lie before point, i.e. we are inside $...$."
  (= (% (length (my/typst-dollar-positions (point))) 2) 1))

(defun my/typst-dollar-bounds ()
  "Fallback: (OPEN . END) of the $...$ around point, or nil.
OPEN is the position of the first $, END the position after the second $."
  (let ((pos (point))
        (dollars (my/typst-dollar-positions))
        found)
    (while (and dollars (not found))
      (let ((open (car dollars)) (close (cadr dollars)))
        (when (and close (<= open pos) (<= pos close))
          (setq found (cons open (1+ close))))
        (setq dollars (cddr dollars))))
    found))

(defun my/typst-math-bounds ()
  "(OPEN . END) of the $...$ around point (works over several lines), or nil."
  (if (my/typst-ts-active-p)
      (let ((node (treesit-node-at (point) 'typst)))
        (while (and node (not (equal (treesit-node-type node) "math")))
          (setq node (treesit-node-parent node)))
        (when node (cons (treesit-node-start node) (treesit-node-end node))))
    (my/typst-dollar-bounds)))

(defun my/after-hash-command-p ()
  "Non-nil right after #name, i.e. while a Typst command is being typed."
  (save-excursion
    (skip-chars-backward "[:alnum:]_.-" (line-beginning-position))
    (eq (char-before) ?#)))

(defun my/typst-hebrew-wanted-p ()
  "Should Hebrew typing be on at point?"
  (cond ((my/after-hash-command-p) nil)
        ((my/typst-ts-active-p) (my/typst-ts-hebrew-p))
        (t (not (my/typst-in-dollars-p)))))

;; --- the switch itself -----------------------------------------------------------
(defvar-local my/hebrew-last-wanted 'none
  "What the automatic switching decided last time (t, nil, or none).")
(defvar-local my/hebrew-override nil
  "Non-nil after C-\\ : automatic switching is paused until the place changes.")

(defun my/set-hebrew (on)
  "Turn the Hebrew input method ON (t) or off (nil), only if it differs."
  (let ((inhibit-message t))
    (cond ((and on (not current-input-method))
           (activate-input-method default-input-method))
          ((and (not on) current-input-method)
           (deactivate-input-method)))))

(defun my/typst-auto-input-method ()
  "Runs after every command in Typst buffers; acts only in insert state."
  (when (and (bound-and-true-p evil-local-mode)
             (eq evil-state 'insert)
             (not (minibufferp))
             default-input-method)
    ;; condition-case: an error in post-command-hook would make Emacs remove
    ;; the hook silently, so never let one escape.
    (condition-case nil
        (let ((wanted (and (my/typst-hebrew-wanted-p) t)))
          (unless (eq wanted my/hebrew-last-wanted)   ; moved to another kind of place
            (setq my/hebrew-last-wanted wanted
                  my/hebrew-override nil))
          (unless my/hebrew-override
            (my/set-hebrew wanted)))
      (error nil))))

(defun my/toggle-hebrew ()
  "C-\\ in insert mode: flip Hebrew by hand.
In Typst buffers this pauses the automatic switching until the cursor moves
into a different kind of place (text / math / code) or you leave insert mode."
  (interactive)
  (toggle-input-method)
  (when (derived-mode-p 'typst-ts-mode 'typst-lite-mode)
    (setq my/hebrew-last-wanted
          (condition-case nil (and (my/typst-hebrew-wanted-p) t) (error 'none))
          my/hebrew-override t)))

(defun my/hebrew-forget-override ()
  "Leaving insert mode: the next insert session starts automatic again."
  (setq my/hebrew-override nil
        my/hebrew-last-wanted 'none))


;;;; 10. Snippets on SPC i (work from NORMAL mode) ---------------------------------
;; Why normal mode: there the Hebrew input method is off, so a key like "d"
;; really is "d".  Press SPC i, wait for the menu (which-key), press one key.
;; The text appears AFTER the cursor, the cursor lands where | is in the
;; description, and you are in insert mode, ready to type.
;;
;; These use `skeleton-insert', which is built into Emacs (no package, no
;; abbreviations).  A skeleton is a list: strings are inserted as they are, and
;; the symbol _ marks where the cursor stays.  \n inside a string is a newline.
;; To add a snippet: copy one of the my/define-snippet lines below, then add a
;; key line like (my/leader "i x" #'my/snip-new).

(defun my/snippet (skeleton)
  "Insert SKELETON after the cursor (normal mode), then enter insert state."
  ;; In normal mode the cursor is ON a character; go after it, like `a'.
  (when (and (not (eq evil-state 'insert)) (not (eolp)))
    (forward-char))
  (skeleton-insert skeleton)
  (evil-insert-state))

(defmacro my/define-snippet (name doc &rest skeleton)
  "Define command NAME that inserts SKELETON with `my/snippet'."
  `(defun ,name () ,doc (interactive) (my/snippet '(nil ,@skeleton))))

(my/define-snippet my/snip-inline
  "Inline math:  $|$"
  "$" _ "$")
(my/define-snippet my/snip-display
  "Display math:  $ | $   (the spaces make it a centered equation)"
  "$ " _ " $")
(my/define-snippet my/snip-aligned
  "Aligned equations: lines end with \\ and line up at &="
  "$\n  " _ " &= \\\n  &= \\\n  &= \n$")
(my/define-snippet my/snip-mat
  "Matrix with an augment line after column 2 (use it inside math)."
  "mat(" _ ", , ; , , ; augment: #2)")
(my/define-snippet my/snip-cases
  "Piecewise definition (use it inside math)."
  "cases(\n  " _ " \"if\" ,\n  0 \"otherwise\"\n)")
(my/define-snippet my/snip-vec
  "Column vector (use it inside math)."
  "vec(x_1, dots.v, x_n)" _)
(my/define-snippet my/snip-definition
  "#definition[|]"
  "#definition[" _ "]")
(my/define-snippet my/snip-proof
  "#proof[|]"
  "#proof[" _ "]")
(my/define-snippet my/snip-example
  "#example[|]"
  "#example[" _ "]")
(my/define-snippet my/snip-parts
  "Sub-part list lettered in Hebrew: א. ב. ג.  (the #[ ] keeps the lettering local)"
  "#[\n  #set enum(numbering: \"א.\")\n  + " _ "\n  +\n  +\n]")
;; "A new problem heading" is `my/next-problem' from section 12 (it numbers
;; the heading for you), so it is bound below without a snippet of its own.

(my/leader "i i" #'my/snip-inline)
(my/leader "i d" #'my/snip-display)
(my/leader "i a" #'my/snip-aligned)
(my/leader "i m" #'my/snip-mat)
(my/leader "i c" #'my/snip-cases)
(my/leader "i v" #'my/snip-vec)
(my/leader "i D" #'my/snip-definition)
(my/leader "i p" #'my/snip-proof)
(my/leader "i e" #'my/snip-example)
(my/leader "i h" #'my/next-problem)
(my/leader "i l" #'my/snip-parts)

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "SPC i i" "inline $|$"
    "SPC i d" "display math"
    "SPC i a" "aligned &="
    "SPC i m" "matrix + augment"
    "SPC i c" "cases"
    "SPC i v" "vec(x_1, dots.v, x_n)"
    "SPC i D" "#definition[]"
    "SPC i p" "#proof[]"
    "SPC i e" "#example[]"
    "SPC i h" "new problem heading"
    "SPC i l" "Hebrew-lettered parts"))


;;;; 11. The i$ / a$ text object ---------------------------------------------------
;; In normal mode:  di$  deletes what is inside $...$,  ci$ changes it,
;; da$ deletes it with the dollars,  vi$ selects it.  It works over SEVERAL
;; LINES, so display math is handled too.  typst-ts-mode uses the syntax
;; tree; the fallback mode pairs up the $ signs.  For i$ the blanks right
;; after the opening $ and before the closing $ are not included, so
;; "$ a + b $" stays a display equation after ci$.
;; (evil-surround also uses these objects, so ds$ removes the dollars.)

(defun my/typst-math-range (outer)
  "Range of the $...$ at point: with the dollars if OUTER, else the inside."
  (let ((bounds (my/typst-math-bounds)))
    (unless bounds (user-error "Not inside $...$"))
    (let* ((open (car bounds))
           (end (cdr bounds))                          ; just after the closing $
           (closed (and (> (- end open) 1) (eq (char-before end) ?$)))
           (inner-beg (1+ open))
           (inner-end (if closed (1- end) end)))
      (if outer
          (evil-range open end 'exclusive)
        (let ((beg (save-excursion
                     (goto-char inner-beg)
                     (skip-chars-forward " \t\n" inner-end)
                     (point)))
              (fin (save-excursion
                     (goto-char inner-end)
                     (skip-chars-backward " \t\n" inner-beg)
                     (point))))
          (if (< beg fin)
              (evil-range beg fin 'exclusive)
            ;; only blanks (or nothing) inside: take all of it
            (evil-range inner-beg inner-end 'exclusive)))))))

(evil-define-text-object my/evil-inner-dollar (count &optional beg end type)
  "Inside $...$ (several lines are fine)."
  (my/typst-math-range nil))
(evil-define-text-object my/evil-outer-dollar (count &optional beg end type)
  "Around $...$, including the dollar signs."
  (my/typst-math-range t))
(define-key evil-inner-text-objects-map "$" #'my/evil-inner-dollar)
(define-key evil-outer-text-objects-map "$" #'my/evil-outer-dollar)


;;;; 12. Problem sets (SPC e) -----------------------------------------------------
;; A problem is a heading like   == שאלה 3   and everything under it, up to the
;; next heading with one or two "=".  Level-3 headings (===) belong to the
;; problem.
;;   SPC e n   insert the NEXT problem heading (highest number + 1) below the
;;             current line and start typing under it.  (Also SPC i h.)
;;   SPC e f   new problem-set file from a template (asks for the number)
;;   SPC e w   narrow: show only this problem;   SPC e W  show everything
;;   ]] / [[   jump to the next / previous problem (keeps the narrowing)
;;   SPC e t   list the TODOs of this file;  SPC e T  of the whole project
;;   za zc zo  fold / unfold this problem, zM fold all, zR unfold all
;;             (outline-minor-mode, switched on in `my/typst-setup')

(defvar my/problem-heading-re "^==[ \t]+שאלה[ \t]+\\([0-9]+\\)"
  "Matches a problem heading.  Group 1 is the number.")

(defun my/highest-problem-number ()
  "Highest N among the `== שאלה N' headings in the buffer (0 if there are none)."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((highest 0))
        (while (re-search-forward my/problem-heading-re nil t)
          (setq highest (max highest (string-to-number (match-string 1)))))
        highest))))

(defun my/next-problem ()
  "Insert `== שאלה N' (N = highest so far + 1) under this line; then type."
  (interactive)
  (let ((n (1+ (my/highest-problem-number))))
    (end-of-line)
    ;; a blank line before the heading, unless this line is blank already
    (insert (if (save-excursion (beginning-of-line) (looking-at-p "[ \t]*$"))
                "\n"
              "\n\n")
            (format "== שאלה %d\n" n))
    (evil-insert-state)
    (message "Problem %d" n)))

(defun my/problem-bounds ()
  "(BEG . END) of the problem around point, or nil if point is before the first."
  (save-excursion
    (save-restriction
      (widen)
      (end-of-line)                       ; so being ON the heading line counts
      (when (re-search-backward my/problem-heading-re nil t)
        (let ((beg (match-beginning 0)))
          (end-of-line)
          (cons beg (if (re-search-forward "^=\\{1,2\\}[ \t]" nil t)
                        (match-beginning 0)
                      (point-max))))))))

(defun my/narrow-to-problem ()
  "Show only the problem around point."
  (interactive)
  (let ((bounds (my/problem-bounds)))
    (unless bounds (user-error "Not inside a problem (== שאלה N)"))
    (widen)
    (narrow-to-region (car bounds) (cdr bounds))
    (message "Narrowed to this problem (SPC e W shows everything)")))

(defun my/widen ()
  "Show the whole file again."
  (interactive)
  (widen)
  (message "Showing everything"))

(defun my/problem-step (direction)
  "Move to the next (DIRECTION 1) or previous (-1) problem heading.
Return non-nil if there was one."
  (let ((start (point)) (found nil))
    (if (> direction 0)
        (progn (end-of-line)
               (setq found (re-search-forward my/problem-heading-re nil t)))
      (beginning-of-line)
      (setq found (re-search-backward my/problem-heading-re nil t)))
    (if found
        (goto-char (match-beginning 0))
      (goto-char start))
    found))

(defun my/problem-jump (direction count)
  "Jump COUNT problems in DIRECTION; if the buffer is narrowed, narrow to the new one."
  (let ((was-narrowed (buffer-narrowed-p))
        (n (or count 1))
        (moved nil))
    (when was-narrowed (widen))
    (while (and (> n 0) (my/problem-step direction))
      (setq moved t n (1- n)))
    (unless moved (message "No more problems that way"))
    (when was-narrowed (ignore-errors (my/narrow-to-problem)))))

;; Defined as evil MOTIONS, so d]] (delete up to the next problem) also works.
(evil-define-motion my/problem-forward (count)
  "Jump to the next problem heading."
  :jump t :type exclusive
  (my/problem-jump 1 count))
(evil-define-motion my/problem-backward (count)
  "Jump to the previous problem heading."
  :jump t :type exclusive
  (my/problem-jump -1 count))

;; New problem-set file from a template.
(defvar my/problem-set-file-format "pset%d.typ"
  "File name of a new problem set; %d becomes the number you type.")
(defvar my/problem-set-template
  "#import \"preamble.typ\": *
#show: setup

= תרגיל %d

"
  "Text of a new problem-set file; %d becomes the number.  Edit it to match
your lecture files (a literal percent sign must be written %%).")

(defun my/new-problem-set (number)
  "Create (or open) the problem-set file for NUMBER, next to the current file."
  (interactive "nProblem set number: ")
  (let* ((dir (if buffer-file-name
                  (file-name-directory buffer-file-name)
                default-directory))
         (file (expand-file-name (format my/problem-set-file-format number) dir)))
    (if (file-exists-p file)
        (progn (find-file file)
               (message "%s already exists: opened it" (file-name-nondirectory file)))
      (find-file file)
      (insert (format my/problem-set-template number))
      (save-buffer)
      (message "Created %s" (file-name-nondirectory file)))))

;; TODO lists.
(defvar my/todo-regexp "\\<\\(TODO\\|FIXME\\|XXX\\)\\>"
  "What counts as a to-do marker.")

(defun my/list-todos ()
  "List every TODO in this file (RET on a line jumps there, q goes back)."
  (interactive)
  (let ((case-fold-search nil))
    (occur my/todo-regexp)))

(defun my/list-todos-project ()
  "List every TODO in all .typ files of the project."
  (interactive)
  (let ((case-fold-search nil))
    (rgrep my/todo-regexp "*.typ" (my/project-root))))

(my/leader "e n" #'my/next-problem)
(my/leader "e f" #'my/new-problem-set)
(my/leader "e w" #'my/narrow-to-problem)
(my/leader "e W" #'my/widen)
(my/leader "e t" #'my/list-todos)
(my/leader "e T" #'my/list-todos-project)
(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "SPC e n" "next problem heading"
    "SPC e f" "new problem-set file"
    "SPC e w" "narrow to problem"
    "SPC e W" "widen"
    "SPC e t" "TODOs in this file"
    "SPC e T" "TODOs in project"))


;;;; 13. Compile and open (SPC p c) ------------------------------------------------
;; The project folder = the folder with .git in it (else the one with
;; preamble.typ).  It is used as typst's --root, as the place to look for the
;; fonts/ folder (--font-path), and by the TODO list and the language server.
(defun my/project-root ()
  "Root folder of the notes project, with a trailing slash."
  (let ((start (or buffer-file-name default-directory)))
    (file-name-as-directory
     (expand-file-name
      (or (locate-dominating-file start ".git")
          (locate-dominating-file start "preamble.typ")
          (file-name-directory (expand-file-name start)))))))

(defun my/typst-command (subcommand file &optional prefix)
  "Shell command: typst SUBCOMMAND FILE with this project's --root/--font-path.
--diagnostic-format short prints errors as  file:line:col: error: ...  which
Emacs's compilation buffer understands (RET on an error jumps to it)."
  (let* ((root (directory-file-name (my/project-root)))
         (fonts (expand-file-name "fonts" root)))
    (mapconcat #'identity
               (delq nil
                     (list prefix "typst" subcommand
                           "--root" (shell-quote-argument root)
                           (when (file-directory-p fonts)
                             (concat "--font-path " (shell-quote-argument fonts)))
                           "--diagnostic-format short"
                           (shell-quote-argument file)))
               " ")))

(defun my/typst-pdf-name (file)
  "The PDF that `typst compile FILE' writes: same name, next to FILE."
  (concat (file-name-sans-extension file) ".pdf"))

(defvar my/pdf-in-emacs t
  "DESKTOP: non-nil = show PDFs in a window of Emacs itself (needs ghostscript
or mupdf).  nil = always use the system viewer (Windows).")
(defvar my/pdf-side-window nil "The window that shows the PDF, once it exists.")

(defun my/side-viewer-ok-p ()
  "Can PDFs be shown inside Emacs on this machine?  (desktop + GUI + gs/mutool)"
  (and my/pdf-in-emacs (not my/termux-p) (display-graphic-p)
       (or (executable-find "gs") (executable-find "mutool"))
       t))

(defun my/pdf-show-side (pdf)
  "Show PDF in a window on the right (DocView); reuse that window next time.
DocView re-reads the file when it changes (auto-revert), so a new compile
shows up by itself.  The cursor stays in your text."
  (let* ((old (find-buffer-visiting pdf))
         (buf (or old (find-file-noselect pdf)))
         (win (and (window-live-p my/pdf-side-window) my/pdf-side-window)))
    (when old (with-current-buffer old (revert-buffer :ignore-auto :noconfirm)))
    (if win
        (set-window-buffer win buf)
      (setq my/pdf-side-window
            (display-buffer buf '((display-buffer-in-direction)
                                  (direction . right)
                                  (window-width . 0.45)))))
    ;; forget stale previews (their PDF files were deleted by the next run)
    (dolist (b (buffer-list))
      (when (and (not (eq b buf))
                 (eq (buffer-local-value 'major-mode b) 'doc-view-mode)
                 (buffer-file-name b)
                 (not (file-exists-p (buffer-file-name b))))
        (kill-buffer b)))
    (message "Showing %s" (file-name-nondirectory pdf))))

(defun my/run-viewer (&rest command)
  "Start COMMAND (a viewer program plus arguments) in the background."
  (make-process :name "pdf-viewer" :command command :noquery t :sentinel #'ignore))

(defun my/open-pdf (pdf)
  "Show PDF the way this machine does it.
Phone: Android's viewer (termux-open).  Desktop: a window on the right inside
Emacs; if that is not possible, the Windows default viewer (WSL) or xdg-open."
  (let ((name (file-name-nondirectory pdf)))
    (cond
     ((not (file-exists-p pdf))
      (message "No PDF yet: %s (SPC p c makes it)" name))
     (my/termux-p
      (if (executable-find "termux-open")
          (progn (my/run-viewer "termux-open" pdf)
                 (message "Opening %s" name))
        (message "termux-open not found (it is part of Termux itself)")))
     ((my/side-viewer-ok-p)
      (my/pdf-show-side pdf))
     ((executable-find "wslview")
      (my/run-viewer "wslview" pdf)
      (message "Opening %s" name))
     ((and (executable-find "explorer.exe") (executable-find "wslpath"))
      ;; explorer.exe always exits with code 1, even on success: ignored.
      (my/run-viewer "explorer.exe"
                     (string-trim
                      (shell-command-to-string
                       (concat "wslpath -w " (shell-quote-argument pdf)))))
      (message "Opening %s" name))
     ((executable-find "xdg-open")
      (my/run-viewer "xdg-open" pdf)
      (message "Opening %s" name))
     (t (message "No PDF viewer found (desktop: sudo dnf install ghostscript)")))))

(defvar my/compile-buffer nil "The compilation buffer of the last SPC p c.")
(defvar my/compile-pdf nil "The PDF to open when that compilation succeeds.")

(defun my/typst-compile ()
  "Compile this file with typst in the background, then open the PDF.
While it runs you can keep typing.  On an error the compilation buffer
replaces your text (RET on an error line jumps to it, q goes back)."
  (interactive)
  (unless buffer-file-name (user-error "This buffer has no file"))
  (unless (executable-find "typst") (user-error "typst not found (install it: see the top of init.el)"))
  (when (buffer-modified-p) (save-buffer))
  (let* ((file buffer-file-name)
         ;; run in the project root: typst names files relative to --root
         (default-directory (my/project-root))
         (compilation-ask-about-save nil)
         (compilation-always-kill t)
         ;; keep the compilation buffer out of sight while it works
         (display-buffer-overriding-action
          '(display-buffer-no-window (allow-no-window . t))))
    (setq my/compile-pdf (my/typst-pdf-name file))
    (setq my/compile-buffer (compile (my/typst-command "compile" file)))
    (message "typst: compiling...")))

(defun my/typst-compile-finished (buffer message)
  "Runs when ANY compilation ends; acts only for the one SPC p c started."
  (when (eq buffer my/compile-buffer)
    (if (string-match-p "\\`finished" message)
        (progn (message "typst: compiled OK")
               (my/open-pdf my/compile-pdf))
      (unless (window-minibuffer-p)
        (if my/termux-p (switch-to-buffer buffer) (pop-to-buffer buffer)))
      (message "typst: compilation FAILED (q goes back to your text)"))))
(add-hook 'compilation-finish-functions #'my/typst-compile-finished)

;; OPTIONAL: `typst watch' recompiles every time the file is saved (this
;; config saves every 4 idle seconds).  SPC p w starts it, SPC p w again
;; stops it.  Its messages go to the buffer *typst-watch*.  Open the PDF
;; with SPC p v whenever you want to look.
(defun my/typst-watch-toggle ()
  "Start or stop `typst watch' for this file."
  (interactive)
  (let ((process (get-buffer-process "*typst-watch*")))
    (if (process-live-p process)
        (progn (kill-process process) (message "typst watch: stopped"))
      (unless buffer-file-name (user-error "This buffer has no file"))
      (unless (executable-find "typst") (user-error "typst not found (install it: see the top of init.el)"))
      (when (buffer-modified-p) (save-buffer))
      (let ((default-directory (my/project-root))
            (display-buffer-overriding-action
             '(display-buffer-no-window (allow-no-window . t))))
        ;; "exec" makes the shell BECOME typst, so stopping it really stops typst
        (compilation-start (my/typst-command "watch" buffer-file-name "exec")
                           nil (lambda (_mode) "*typst-watch*"))
        (message "typst watch: running (SPC p w stops it, SPC p v opens the PDF)")))))

(defun my/typst-open-pdf ()
  "Open this file's PDF (side window on the desktop, Android viewer on the phone)."
  (interactive)
  (unless buffer-file-name (user-error "This buffer has no file"))
  (my/open-pdf (my/typst-pdf-name buffer-file-name)))

(my/leader "p c" #'my/typst-compile)
(my/leader "p w" #'my/typst-watch-toggle)
(defun my/typst-watch-log ()
  "Show the output (errors) of `typst watch'."
  (interactive)
  (if (get-buffer "*typst-watch*")
      (pop-to-buffer "*typst-watch*")
    (user-error "typst watch is not running (SPC p w starts it)")))

(my/leader "p v" #'my/typst-open-pdf)
(my/leader "p W" #'my/typst-watch-log)
(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "SPC p c" "compile + open PDF"
    "SPC p w" "typst watch on/off"
    "SPC p v" "open PDF"
    "SPC p W" "typst watch log"))


;;;; 14. One-key git sync (SPC g s) -----------------------------------------------
;; Runs, in the background:  git add -A  ->  git commit (message = timestamp)
;; ->  git pull --rebase  ->  git push.  You keep typing; the result appears
;; in the bottom line.  The full output is in the buffer *git-sync*.
;; If the pull finds a CONFLICT the sync stops right there and changes
;; nothing more: it never picks a side and never aborts for you.  Fix it in
;; a terminal (git status) and run SPC g s again.  While a rebase/merge is
;; unfinished, SPC g s refuses to start, so it cannot commit conflict markers.
;; Needs: git set up with your name/email and push access (ssh key or a saved
;; token); it never asks for a password, it fails instead.

(defvar my/git-sync-process nil "The running sync process, if any.")

(defvar my/git-sync-script
  (concat "git add -A || exit 10\n"
          "if git diff --cached --quiet; then echo NOTHING-NEW;\n"
          "else git commit -q -m \"$1\" || exit 11; fi\n"
          "git pull --rebase || exit 12\n"
          "git push || exit 13\n")
  "The shell script behind SPC g s.  Each failing step exits with its own
number, which `my/git-sync-sentinel' turns into a message.")

(defun my/git-sync-sentinel (process _event)
  "Report in the echo area when the sync process ends."
  (when (memq (process-status process) '(exit signal))
    (let* ((code (process-exit-status process))
           (nothing-new (with-current-buffer (process-buffer process)
                          (save-excursion
                            (goto-char (point-min))
                            (search-forward "NOTHING-NEW" nil t)))))
      (message "%s"
               (pcase code
                 (0 (if nothing-new
                        "git sync: nothing new to commit; pulled and pushed"
                      "git sync: done (committed, pulled, pushed)"))
                 (10 "git sync FAILED at git add. Details: *git-sync*")
                 (11 "git sync FAILED at commit (are git user.name / user.email set?). Details: *git-sync*")
                 (12 "git sync STOPPED at pull --rebase: probably a CONFLICT. Nothing was resolved for you; run git status in a terminal. Details: *git-sync*")
                 (13 "git sync FAILED at push (offline? no upstream?). Your commit is safe locally. Details: *git-sync*")
                 (_ (format "git sync FAILED (exit %s). Details: *git-sync*" code)))))))

(defun my/git-sync ()
  "git add -A, commit, pull --rebase, push: in the background."
  (interactive)
  (unless (executable-find "git") (user-error "git not found (install git)"))
  (let ((root (locate-dominating-file (or buffer-file-name default-directory) ".git")))
    (unless root (user-error "Not inside a git repository"))
    (when (process-live-p my/git-sync-process)
      (user-error "A git sync is already running"))
    (when (or (file-exists-p (expand-file-name ".git/rebase-merge" root))
              (file-exists-p (expand-file-name ".git/rebase-apply" root))
              (file-exists-p (expand-file-name ".git/MERGE_HEAD" root)))
      (user-error "An earlier merge/rebase is unfinished: resolve it in a terminal first"))
    (save-some-buffers t)                 ; write every modified file first
    (let* ((default-directory root)
           (log (get-buffer-create "*git-sync*"))
           ;; never wait for a password / editor / ssh question: fail instead
           (process-environment (append '("GIT_TERMINAL_PROMPT=0"
                                          "GIT_EDITOR=true"
                                          "GIT_SSH_COMMAND=ssh -o BatchMode=yes")
                                        process-environment)))
      (with-current-buffer log (let ((inhibit-read-only t)) (erase-buffer)))
      (setq my/git-sync-process
            (make-process :name "git-sync" :buffer log :noquery t
                          :command (list "sh" "-c" my/git-sync-script "git-sync"
                                         (format-time-string "sync %Y-%m-%d %H:%M"))
                          :sentinel #'my/git-sync-sentinel))
      (message "git sync: running..."))))

(my/leader "g s" #'my/git-sync)
(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements "SPC g s" "sync (add, commit, pull, push)"))

;;; init.el ends here
