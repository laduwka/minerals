// Mineral Collection Catalog — Typst template for Pandoc
// Exports a `conf()` function consumed by Pandoc's default.typst wrapper.

#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let conf(
  title: none,
  subtitle: none,
  authors: (),
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  margin: (x: 2.5cm, y: 2.5cm),
  paper: "a4",
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  pagenumbering: "1",
  doc,
) = {
  // ── Document metadata ──────────────────────────────────────
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(a => content-to-string(a.name)).join(", "),
  ) if authors != none and authors != ()

  // ── Base page settings (body pages) ────────────────────────
  set page(paper: paper, margin: margin, numbering: pagenumbering, columns: cols)
  set par(justify: true, leading: linestretch * 0.65em)
  set text(lang: lang, region: region, size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none
  set heading(numbering: sectionnumbering)

  // Link colors
  show link: set text(fill: rgb("#" + content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb("#" + content-to-string(citecolor))) if citecolor != none

  // ── Scale images to page width ─────────────────────────────
  show image: it => block(width: 100%)[#it]

  // ── Title page ─────────────────────────────────────────────
  if title != none {
    page(
      margin: 0pt,
      numbering: none,
      header: none,
      footer: none,
    )[
      #block(
        width: 100%,
        height: 100%,
        fill: rgb("#2563eb"),
      )[
        #align(center + horizon)[
          #text(fill: white, weight: "bold", size: 28pt)[#title]
          #if subtitle != none {
            v(0.5em)
            text(fill: white, weight: "regular", size: 18pt)[#subtitle]
          }
          #v(2em)
          #if authors != none and authors != () {
            text(fill: white, size: 14pt)[
              #authors.map(a => content-to-string(a.name)).join(", ")
            ]
            v(0.5em)
          }
          #if date != none {
            text(fill: white, size: 14pt)[#date]
          }
        ]
      ]
    ]
  }

  // ── Headers and footers for body pages ─────────────────────
  set page(
    header: context {
      if counter(page).get().first() > 0 {
        text(size: 9pt, fill: luma(100))[Mineral Collection Catalog]
        h(1fr)
      }
    },
    footer: context {
      align(center, text(size: 9pt, fill: luma(100))[
        #counter(page).display("1")
      ])
    },
  )

  doc
}
