// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find
// documentation on creating typst templates and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 2cm, y: 2cm, top: 1.5cm, bottom: 2cm),
  paper: "a4",
  lang: "en",
  region: "AU",
  font: "libertinus serif",
  fontsize: 11pt,
  linestretch: 1.3,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "Fira Sans",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  heading-size: 0.85em,
  branding: false,
  sectionnumbering: none,
  pagenumbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  // Define authornames string from authors list
  let authornames = if authors != none {
    authors.map(author => author.name).join(", ")
  } else {
    ""
  }

  // Set PDF metadata
  set document(
    title: title,
    author: authornames,
    date: if date != none { auto } else { none },
  )
  set page(
    paper: paper,
    margin: margin,
    numbering: pagenumbering,
    header: context {
      if counter(page).get().first() > 1 and title != none {
        grid(
          columns: (1fr, auto),
          align: (left, right),
          [#text(font: heading-family, size: 10pt)[#title]],
          [#text(font: heading-family, size: 10pt)[#counter(page).display()]],
        )
        v(-6pt)
        line(length: 100%, stroke: 0.5pt)
        v(6pt) // Add some space below the line
      }
    },
    footer: context {
      if counter(page).get().first() == 1 {
        align(center)[#counter(page).display()]
      }
    },
  )
  set par(justify: true, leading: linestretch * 0.7em)
  set text(lang: lang, region: region, font: font, size: fontsize)
  set heading(numbering: sectionnumbering)
  show heading: set text(
    font: heading-family,
    size: heading-size,
    weight: heading-weight,
    style: heading-style,
    fill: heading-color,
  )
  show heading.where(level: 1): set block(above: 20pt, below: 12pt)
  show outline: set text(font: heading-family, size: 0.85em)

  // Indented lists
  show list: set block(above: 1.2em, below: 1.2em)
  show enum: set block(above: 1.2em, below: 1.2em)
  show list: set list(indent: 1em)
  show enum: set enum(indent: 1em)

  // Make all links blue
  show link: set text(fill: rgb(0, 0, 255))
  // Math font
  show math.equation: set text(font: "Libertinus math")
  // Optional branding logo at top
  if branding {
    // Bottom right logos on first page only
    place(
      bottom + right,
      dx: 0cm,
      dy: 1cm,
      grid(
        columns: 3,
        column-gutter: 9pt,
        image("AACSB.png", height: 0.7cm), image("EQUIS.png", height: 0.7cm), image("AMBA.png", height: 0.7cm),
      ),
    )
    v(-1.7cm)
    grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [
        #image("monash2.png", height: 1.5cm)
      ],
      [
        #image("MBSportrait.jpg", height: 1.5cm)
      ],
    )
    v(10pt)
  } else {
    v(-1cm)
  }
  // Gray box title header
  if title != none {
    rect(
      fill: gray.lighten(50%),
      //stroke: gray,
      width: 100%,
      inset: 6pt,
      radius: 2pt,
    )[
      #align(left)[
        #text(font: heading-family, size: title-size, weight: heading-weight)[#title]
        #if subtitle != none {
          v(4pt)
          text(font: heading-family, size: subtitle-size, weight: "normal")[#subtitle]
        }
      ]

      #v(4pt)

      // Author on left, date on right using grid
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [
          #if authornames != "" {
            text(font: heading-family, size: 12pt)[#authornames]
          }
        ],
        [
          #if date != none {
            text(font: heading-family, size: 10pt)[#date]
          }
        ],
      )
    ]

    v(20pt)
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
      #outline(
        title: toc_title,
        depth: toc_depth,
        indent: toc_indent,
      );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}
