// =============================================================================
//  LECTURE-NOTES PREAMBLE  (importable module)
// =============================================================================
//
//  HOW TO USE (in every lecture file in the same directory)
//  ---------------------------------------------------------------------------
//      #import "preamble.typ": *
//      #show: setup
//
//  `#import` brings in the definitions (environments, boxes, shorthands).
//  `#show: setup` applies the document-wide rules (page, RTL text, headings,
//  frame styling, reference chips). Typst does NOT carry #set/#show rules
//  across imports, so forgetting `#show: setup` gives an unstyled LTR document.
//  Compile the lecture file, not this one.
//
//  FILE MAP  (search for the tag in [brackets] to jump to a section)
//  ---------------------------------------------------------------------------
//   [PKG]      Package imports
//   [CFG]      Shared colours
//   [UTIL]     Generic helpers (no output of their own)
//   [ENV]      Numbered environments (frame-it): definition, corollary, ...
//   [REF]      Cross-reference helpers (chip, number display)
//   [BOX]      Unnumbered boxes: exercise, example, todo, informal, proof
//   [LIST]     env-list: grouped list of same-type environments
//   [BRACE]    braced: body | "}" | note layout
//   [SHORT]    Shorthands: Hebrew words, math symbols, row ops, highlight
//   [SETUP]    setup(): all #set / #show rules, applied with `#show: setup`
//   [PSET]     Problem-set layer: hw-setup, problem, solution, claim, remark, case
//
//  PUBLIC API (names the lecture documents use; do NOT rename)
//  ---------------------------------------------------------------------------
//   Setup        : setup
//   Problem sets : hw-setup(course:, number:, name:)  problem(title:, body)
//                  solution(body)  claim(body)  remark(body)  case(label, body)
//   Environments : definition corollary notation property axiom proposition fact
//                  theorem lemma
//   Boxes        : exercise(title:, body)  example(title:, body)
//                  todo(title:, body)  informal(body)  proof(body)
//   Layout       : env-list(title:, accent-color:, unit:, numbered:, gap:, ..items)
//                  braced(note, body, gap:, brace-width:, brace-width-factor:)
//                  rtl-indent(..children)
//   Shorthands   : nv nvs nvof  dov doh Rn ammnr vz  whe so  ero(x)  hl(x)
//                  bcs(ref-body, size:)
//                  def prop cor ex thm lem (aliases)  Span
//                  cv(x, n)  coord(v, B)  Mat(F)  ip(u, v)  cdh
//   Re-exported  : everything from suiji, frame-it, lovelace (via `*`), plus
//                  hydra, cetz, showybox, pavemat
//
//  INVARIANTS (changing these silently alters output)
//  ---------------------------------------------------------------------------
//   1. Order of `show` rules inside setup() matters in Typst. Keep:
//      heading-reset -> frame-style -> ref. Do not reorder them.
//   2. In [ENV], the order of `environment-data` MUST match the destructuring
//      of `generated-envs`. To add an environment: append to `environment-data`
//      AND append the same id (same position) to the destructuring list.
//   3. Everything is RTL (Hebrew). Code that needs LTR (the brace glyph, the
//      braced() row) switches locally with `set text(dir: ltr)`.
//   4. Definitions must appear before their first use (Typst has no hoisting).
//   5. Any new #set / #show rule that should affect the whole document goes
//      INSIDE setup(), not at the top level of this file (top-level rules do
//      not apply to files that import this one).
// =============================================================================


// =============================================================================
//  [PKG] Packages
// =============================================================================
// NOTE: `cetz` was previously imported twice (0.4.2 and 0.5.2); the second
// import silently shadowed the first, so only 0.5.2 is kept here.
#import "@preview/hydra:0.6.3": hydra
#import "@preview/suiji:0.5.1": *
#import "@preview/cetz:0.5.2"
#import "@preview/frame-it:2.0.0": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/pavemat:0.2.0": pavemat
#import "@preview/lovelace:0.3.1": *


// =============================================================================
//  [CFG] Shared colours
//  (page / text / heading settings live in setup(), see [SETUP])
// =============================================================================

// Colours of the clickable reference chip (see [REF]).
#let link-fill = rgb("#eef3fc")
#let link-stroke = rgb("#4a7bd1")
#let link-text = rgb("#2554b0")


// =============================================================================
//  [UTIL] Generic helpers
// =============================================================================

// Build a dictionary from an array of (key, value) pairs.
#let dict-from-pairs(pairs) = {
  let d = (:)
  for (key, value) in pairs { d.insert(key, value) }
  d
}

// Dictionaries below are keyed by the repr of the (content) supplement,
// because that is the only thing a figure/ref element exposes.
#let supplement-key(supplement) = repr[#supplement]


// =============================================================================
//  [ENV] Numbered environments (frame-it)
//  Numbering is "<section>.<n>", where n restarts at every level-2 heading
//  (the reset rule is in setup()).
//  Pipeline: data -> counters -> style -> frames -> destructure
// =============================================================================

// (id, Hebrew supplement)  -- ORDER MATTERS: must match the destructuring of
// `generated-envs` further below (see INVARIANT 2).
#let environment-data = (
  ("definition", "הגדרה"),
  ("corollary", "מסקנה"),
  ("notation", "סימון"),
  ("property", "תכונה"),
  ("axiom", "אקסיומה"),
  ("proposition", "טענה"),
  ("fact", "עובדה"),
  ("theorem", "משפט"),
  ("lemma", "למה"),
)

// One counter per environment, reachable by id or by supplement key.
#let env-counters-by-id = dict-from-pairs(
  environment-data.map(((id, _)) => (
    id,
    counter("frame-it-env-counter-" + id),
  )),
)
#let env-counters-by-supplement = dict-from-pairs(
  environment-data.map(((id, heb)) => (
    supplement-key(heb),
    env-counters-by-id.at(id),
  )),
)

// Visual style of a numbered environment.
#let showy-frame-style(title, tags, body, supplement, number, accent-color) = {
  let cnt = env-counters-by-supplement.at(supplement-key(supplement))
  (
    cnt.step()
      + context {
        let section-number = counter(heading).get().at(1, default: 0)
        let type-number = cnt.get().first()
        let label = [#supplement #section-number.#type-number]
        let has-title = title != none and title != []

        showybox(
          frame: (
            border-color: accent-color.darken(30%),
            title-color: accent-color.lighten(40%),
            body-color: accent-color.lighten(90%),
          ),
          title-style: (color: black, weight: "bold", align: right),
          title: if has-title { [#label: #title] } else { label },
          body,
        )
      }
  )
}

#let generated-envs = frames(
  ..dict-from-pairs(environment-data.map(((id, heb)) => (id, (heb,)))),
)
// Same order as `environment-data` (INVARIANT 2).
#let (
  definition,
  corollary,
  notation,
  property,
  axiom,
  proposition,
  fact,
  theorem,
  lemma,
) = generated-envs


// =============================================================================
//  [REF] Cross-reference helpers
//  (the `show ref` rule that uses them is in setup())
// =============================================================================

// The number shown when referencing a frame-it environment ("<section>.<n>").
#let frame-display-number(el) = context {
  let cnt = env-counters-by-supplement.at(repr(el.supplement))
  let section-number = counter(heading).at(el.location()).at(1, default: 0)
  // +1 is required: el.location() is the figure's own start, which is just
  // *before* the cnt.step() inside its own caption, so .at() reports the
  // value from the moment right before this frame.
  let type-number = cnt.at(el.location()).first() + 1
  str(section-number) + "." + str(type-number)
}

// A highlighted, clickable "chip".
#let ref-chip(target, body) = link(target)[
  #box(
    fill: link-fill,
    stroke: link-stroke + 0.05em,
    radius: 0.25em,
    outset: (x: 0.15em, y: 0.10em),
  )[
    #text(fill: link-text, weight: "medium", body)
  ]
]


// =============================================================================
//  [BOX] Extra (unnumbered) boxes: exercise, example, todo, informal, proof
// =============================================================================

// Shared builder for titled, coloured boxes.
#let titled-box(accent, title, body) = showybox(
  frame: (
    border-color: accent.darken(20%),
    title-color: accent.lighten(60%),
    body-color: accent.lighten(90%),
    thickness: 1pt,
  ),
  title-style: (color: black, weight: "bold", align: right),
  title: title,
  body,
)

#let exercise(title: "תרגיל", body) = titled-box(blue, title, body)
#let example(title: "דוגמה", body) = titled-box(green, title, body)
#let todo(title: "TODO", body) = titled-box(orange, title, body)

#let informal(body) = showybox(
  frame: (
    border-color: gray.darken(10%),
    body-color: gray.lighten(80%),
    dash: "dashed",
  ),
  body,
)

#let proof(body) = showybox(
  frame: (
    border-color: black,
    title-color: white,
    body-color: white,
    thickness: 1pt,
  ),
  title-style: (color: black, weight: "bold", align: right),
  title: "הוכחה",
  [#body #h(1fr) $square$],
)


// =============================================================================
//  [LIST] env-list: gathers same-type environments (e.g. all exercises of a
//  chapter) into one breakable group with a margin accent bar.
//
//    #env-list(title: "תרגילי חזרה - פרק 3", numbered: true,
//      exercise[...], exercise[...],
//    )
//
//  - title:        header label for the group (none = no header)
//  - accent-color: colour of header, count and margin bar
//  - unit:         word used in the item-count label
//  - numbered:     add a running-index badge beside each item
//  - gap:          vertical spacing between items
// =============================================================================
#let env-list(
  title: none,
  accent-color: rgb("#4a7bd1"),
  unit: "פריטים",
  numbered: false,
  gap: 0.9em,
  ..args,
) = {
  let entries = args.pos()

  let badge(n) = box(
    circle(
      radius: 0.68em,
      fill: accent-color.lighten(65%),
      stroke: 1pt + accent-color.darken(15%),
      align(center + horizon)[
        #text(size: 0.72em, weight: "bold", fill: accent-color.darken(45%))[#n]
      ],
    ),
  )

  let render-item(i, item) = if numbered {
    grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
      align: (horizon, top),
      badge(i + 1), item,
    )
  } else {
    item
  }

  let header = block(
    width: 100%,
    breakable: false,
    below: 0.5em,
    box(
      width: 100%,
      fill: accent-color.lighten(88%),
      stroke: (bottom: 1.5pt + accent-color.darken(10%)),
      inset: (x: 0.7em, y: 0.45em),
      radius: (top: 0.3em),
      [
        #set text(dir: rtl)
        #set align(right)
        #text(fill: accent-color.darken(35%), weight: "bold")[#title]
        #h(1fr)
        #text(
          fill: accent-color.darken(15%),
          size: 0.85em,
        )[#entries.len() #unit]
      ],
    ),
  )

  block(
    width: 100%,
    breakable: true,
    above: 1.2em,
    below: 1.2em,
    {
      if title != none { header }
      block(
        width: 100%,
        breakable: true,
        stroke: (right: 2.5pt + accent-color.darken(5%)),
        inset: (right: 1em, y: 0pt),
        stack(
          dir: ttb,
          spacing: gap,
          ..entries.enumerate().map(((i, item)) => render-item(i, item)),
        ),
      )
    },
  )
}


// =============================================================================
//  [BRACE] braced: content on the visual right, a stretched "}" brace, then a
//  note.   Usage:  #braced[note][body]
// =============================================================================

// A genuine typographic brace scaled to `height`.
// `}` must be rendered in a local LTR context; under RTL the delimiter would
// otherwise be mirrored and produce the opposite brace.
#let true-brace(height, width-factor: 50%) = context {
  let natural = measure($\}$).height
  let candidate = {
    set text(dir: ltr)
    math.stretch($\}$, size: height / natural * 100%)
  }
  let vertical-factor = height / measure(candidate).height * 100%

  // Normalise the rendered glyph instead of clipping it; the horizontal
  // factor is `width-factor` times the vertical one, making the brace wider.
  scale(
    x: vertical-factor * width-factor,
    y: vertical-factor,
    origin: horizon + center,
    candidate,
  )
}

#let rtl-indent(..children) = indent(
  ..children.pos().map(child => [
    #set align(right)
    #child
  ])
)

#let braced(
  note,
  body,
  gap: 8pt,
  brace-width: 2pt,
  brace-width-factor: 150%,
) = layout(size => {
  // The outer row is laid out LTR, so restore RTL inside the content.
  let as-rtl(content) = {
    set text(dir: rtl)
    content
  }
  let rtl-note = as-rtl(note)
  let rtl-body = as-rtl(body)

  let note-width = measure(rtl-note).width
  let body-width = size.width - note-width - brace-width - 2 * gap
  let body-height = measure(width: body-width, rtl-body).height

  // Visual order (left to right): body | brace | note.
  set text(dir: ltr)
  grid(
    columns: (body-width, brace-width, note-width),
    gutter: gap,
    align: top,

    block(width: body-width, rtl-body),

    box(
      width: brace-width,
      height: body-height,
      place(horizon + center, true-brace(
        body-height,
        width-factor: brace-width-factor,
      )),
    ),

    box(
      width: note-width,
      height: body-height,
      place(horizon + center, rtl-note),
    ),
  )
})


// =============================================================================
//  [SHORT] Shorthands
// =============================================================================

// --- Hebrew words built around $n$ ------------------------------------------
#let nv = $n$ + "-יה"
#let nvs = $n$ + "-יות"
#let nvof = $n$ + "-ית"

// --- Math symbols / sets ----------------------------------------------------
#let dov = $dots.v$
#let doh = $dots.h$
#let Rn = $RR^n$
#let ammnr = $A in M_(m times n) (RR)$
#let vz = $vec(0, dov, 0)$

// --- Short aliases for environments ------------------------------------------
// (`ex` = example; change to `exercise` if that is what your lectures expect.)
#let def = definition
#let prop = proposition
#let cor = corollary
#let ex = example
#let thm = theorem
#let lem = lemma

// --- Linear-algebra macros ---------------------------------------------------
// `dim` and `deg` are built-in math operators, so they are intentionally not
// redefined here.
#let Span = math.op("span")

// Column vector with n entries:  cv(x, n)  ->  vec(x_1, dots.v, x_n)
#let cv(x, n) = {
  let first = math.attach(x, b: [1])
  let last = math.attach(x, b: n)
  $vec(#first, dots.v, #last)$
}

// Coordinate vector of v with respect to the basis B:  [v]_B
#let coord(v, B) = $lr([#v])_(#B)$

// The space of m x n matrices over F:  M_(m x n)(F)
#let Mat(F, m: $m$, n: $n$) = $M_(#m times #n)(#F)$

// Inner product:  <u, v>
// (literal ⟨ ⟩: the symbol name angle.l / chevron.l differs by Typst version)
#let ip(u, v) = $lr(⟨ #u, #v ⟩)$

// Horizontal dots at mid-height:  ... centred (dots.h.c)
#let cdh = $dots.h.c$

// --- Vertical bar for "such that" / "where" (`whe` and `so` are identical) --
#let whe = $mid(|)$
#let so = $mid(|)$

// --- Elementary row operations: ero(x) draws an arrow labelled x ------------
#let ero(x) = $stretch(arrow.r)^(#x)$

// --- Highlighter ------------------------------------------------------------
#let hl(x) = box(fill: yellow, inset: 1pt, radius: 2pt)[#x]

// --- "=" with a small annotation beneath it (e.g. the reason for the step) --
#let bcs(ref-body, size: 0.7em) = {
  $limits(=)_(#text(size: size, ref-body))$
}


// =============================================================================
//  [SETUP] Document-wide rules.  Apply in each file with:  #show: setup
//
//  All #set / #show rules live here (INVARIANT 5). Show-rule order matters
//  (INVARIANT 1): heading-reset -> frame-style -> ref.
// =============================================================================
#let setup(doc, header: context hydra(2)) = {
  // --- Page, text, headings --------------------------------------------------
  set page(
    header: header,
    numbering: "1 / 1",
    number-align: center,
  )

  set text(
    lang: "he",
    dir: rtl,
    size: 12pt,
    // font: ("Noto Sans Hebrew", "Arial", "Linux Libertine"),
  )

  set heading(numbering: "1.")

  // --- Reset every environment counter at each level-2 heading ---------------
  show heading.where(level: 2): it => {
    for c in env-counters-by-id.values() { c.update(0) }
    it
  }

  // --- Style of the numbered environments ------------------------------------
  show: frame-style(showy-frame-style)

  // --- References ------------------------------------------------------------
  // Short labels (<= 3 chars, e.g. equation labels) are shown as the label
  // itself; frames show "<supplement> <number>"; everything else is default.
  show ref: it => {
    let el = it.element
    if el == none { return it }

    let display = if str(it.target).len() <= 3 {
      str(it.target)
    } else if inspect.is-frame(el) {
      [#el.supplement #frame-display-number(el)]
    } else {
      it
    }
    ref-chip(el.location(), display)
  }

  doc
}


// =============================================================================
//  [PSET] Problem-set layer
//
//    #import "preamble.typ": *
//    #show: hw-setup.with(course: "אלגברה לינארית 1", number: 3, name: "שם")
//
//    #problem[ ... #solution[ ... ] ]
//
//  hw-setup() calls setup() (so every lecture-level rule still applies) and
//  swaps hydra for a fixed course / number / name header. It also sets
//  Hebrew lettering for sub-parts: `+ ...` lists render as (א), (ב), ...
//  Defined AFTER setup() on purpose (INVARIANT 4).
// =============================================================================

#let hw-header(course, number, name) = {
  set text(size: 10pt)
  grid(
    columns: (1fr, auto, 1fr),
    align: (start, center, end),
    [#course],
    [שיעורי בית#if number != none [ #number]],
    [#name],
  )
  v(-0.4em)
  line(length: 100%, stroke: 0.5pt + gray)
}

#let hw-setup(doc, course: none, number: none, name: none) = {
  show: setup.with(header: hw-header(course, number, name))
  set enum(numbering: "(א)")
  doc
}

// Auto-numbered problem: "שאלה N" (optionally "שאלה N: title").
#let problem-counter = counter("problem")

#let problem(title: none, body) = {
  problem-counter.step()
  context {
    let label = [שאלה #problem-counter.get().first()]
    let has-title = title != none and title != []
    titled-box(purple, if has-title { [#label: #title] } else { label }, body)
  }
}

// Solution box, deliberately lighter than `proof`: thin grey frame, small
// grey title, no end-of-proof square.
#let solution(body) = showybox(
  frame: (
    border-color: gray,
    title-color: gray.lighten(85%),
    body-color: white,
    thickness: 0.5pt,
    radius: 2pt,
  ),
  title-style: (color: gray.darken(35%), weight: "regular", align: right),
  title: "פתרון",
  body,
)

// Unnumbered inline helpers, for use inside solutions and proofs.
#let claim(body) = block(above: 0.8em, below: 0.8em)[*טענה.* #body]
#let remark(body) = block(above: 0.8em, below: 0.8em)[*הערה.* #emph(body)]
// case[1][...]  ->  "מקרה 1:" followed by the body, indented.
#let case(label, body) = block(above: 0.8em, below: 0.8em)[
  *מקרה #label:*
  #pad(right: 1.2em, body)
]

// END preamble
