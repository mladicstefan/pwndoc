#let code-block(
  code,
  lang: "bash",
  title: none,
) = {
  block(
    width: 100%,
    fill: rgb("#1a1a1a"),
    radius: 4pt,
    stroke: 1pt + rgb("#404040"),
    inset: 0pt,
    breakable: false,
  )[
    #if title != none [
      #block(
        width: 100%,
        fill: rgb("#2a2a2a"),
        inset: (x: 12pt, y: 8pt),
        radius: (top: 4pt),
      )[
        #text(
          fill: rgb("#b0b0b0"),
          size: 9pt,
          weight: "medium",
          font: "IBM Plex Mono",
        )[#title]
      ]
    ]
    
    #block(
      width: 100%,
      inset: 12pt,
    )[
      #text(
        fill: rgb("#e8e8e8"),
        font: "IBM Plex Mono",
        size: 9pt,
      )[
        #raw(code, lang: lang, block: true)
      ]
    ]
  ]
}

#let highlight(
  content,
  color: yellow,
) = {
  box(
    fill: color.lighten(75%),
    outset: (x: 2pt, y: 1pt),
    radius: 2pt,
  )[
    #text(weight: "medium")[#content]
  ]
}

#let htb-card(
  title: "",
  severity: "medium",
  ip: "",
  port: "",
  service: "",
  finding: "",
  exploit: "",
  remediation: "",
) = {
  let colors = (
    critical: (
      bg: rgb("#fef2f2"),
      border: rgb("#b91c1c"),
      text: rgb("#7f1d1d"),
    ),
    high: (
      bg: rgb("#fff7ed"),
      border: rgb("#c2410c"),
      text: rgb("#7c2d12"),
    ),
    medium: (
      bg: rgb("#fefce8"),
      border: rgb("#a16207"),
      text: rgb("#713f12"),
    ),
    low: (
      bg: rgb("#f0fdf4"),
      border: rgb("#15803d"),
      text: rgb("#14532d"),
    ),
    info: (
      bg: rgb("#eff6ff"),
      border: rgb("#1d4ed8"),
      text: rgb("#1e3a8a"),
    ),
  )
  
  let c = colors.at(severity)
  
  block(
    width: 100%,
    fill: c.bg,
    stroke: (
      left: 4pt + c.border,
      rest: 1pt + c.border.lighten(40%),
    ),
    radius: 4pt,
    inset: 14pt,
    breakable: true,
  )[
    #grid(
      columns: (1fr, auto),
      align: (left, right),
      gutter: 10pt,
      [
        #text(size: 14pt, weight: "semibold", fill: c.text)[
          #title
        ]
      ],
      [
        #box(
          fill: c.border,
          inset: (x: 10pt, y: 5pt),
          radius: 3pt,
        )[
          #text(fill: white, size: 8pt, weight: "bold")[
            #upper(severity)
          ]
        ]
      ]
    )
    
    #v(10pt)
    
    #block(
      width: 100%,
      fill: white,
      stroke: 1pt + c.border.lighten(60%),
      radius: 3pt,
      inset: 10pt,
    )[
      #grid(
        columns: (auto, 1fr),
        gutter: 8pt,
        align: (right, left),
        row-gutter: 6pt,
        
        [#text(weight: "semibold", size: 9pt)[TARGET:]], 
        [#text(font: "IBM Plex Mono", size: 9pt)[#ip]],
        
        [#text(weight: "semibold", size: 9pt)[PORT:]], 
        [#text(font: "IBM Plex Mono", size: 9pt)[#port]],
        
        [#text(weight: "semibold", size: 9pt)[SERVICE:]], 
        [#text(font: "IBM Plex Mono", size: 9pt)[#service]],
      )
    ]
    
    #v(10pt)
    
    #text(weight: "semibold", size: 10pt)[
      FINDING
    ]
    #v(5pt)
    #text(size: 9.5pt)[#finding]
    
    #v(10pt)
    
    #text(weight: "semibold", size: 10pt)[
      EXPLOITATION
    ]
    #v(5pt)
    #block(
      width: 100%,
      fill: rgb("#1a1a1a"),
      stroke: 1pt + rgb("#404040"),
      inset: 10pt,
      radius: 3pt,
    )[
      #text(
        fill: rgb("#a3e635"),
        font: "IBM Plex Mono",
        size: 8.5pt,
      )[
        #raw(exploit, lang: "bash", block: true)
      ]
    ]
    
    #if remediation != "" [
      #v(10pt)
      #text(weight: "semibold", size: 10pt)[
        REMEDIATION
      ]
      #v(5pt)
      #text(size: 9.5pt)[#remediation]
    ]
  ]
}

#let tool-explain(
  tool-name: "",
  description: "",
  flags: (),
  common-vulns: (),
  misconfigs: (),
) = {
  block(
    width: 100%,
    stroke: 2pt + rgb("#404040"),
    radius: 4pt,
    inset: 0pt,
  )[
    #block(
      width: 100%,
      fill: rgb("#2a2a2a"),
      inset: (x: 14pt, y: 12pt),
      radius: (top: 4pt),
    )[
      #text(fill: white, size: 16pt, weight: "bold")[
        #tool-name
      ]
      #v(4pt)
      #text(fill: rgb("#b0b0b0"), size: 9pt)[
        #description
      ]
    ]
    
    #block(
      width: 100%,
      fill: white,
      inset: 14pt,
    )[
      #text(size: 11pt, weight: "semibold")[
        Common Flags & Options
      ]
      #v(8pt)
      
      #table(
        columns: (auto, 1fr, 2fr),
        stroke: (x, y) => if y == 0 { 
          (bottom: 1.5pt + rgb("#404040"))
        } else { 
          (bottom: 0.5pt + rgb("#e0e0e0"))
        },
        fill: (x, y) => if y == 0 {
          rgb("#f5f5f5")
        } else if calc.odd(y) {
          rgb("#fafafa")
        } else {
          white
        },
        inset: 8pt,
        align: (left, left, left),
        
        [#text(weight: "semibold", size: 9pt)[Flag]], 
        [#text(weight: "semibold", size: 9pt)[Name]], 
        [#text(weight: "semibold", size: 9pt)[Description]],
        
        ..flags.map(f => (
          text(
            font: "IBM Plex Mono",
            size: 9pt,
            fill: rgb("#b91c1c"),
            weight: "semibold",
          )[#f.flag],
          text(size: 9pt, weight: "medium")[#f.name],
          text(size: 9pt)[#f.desc],
        )).flatten()
      )
      
      #if common-vulns.len() > 0 [
        #v(14pt)
        #text(size: 11pt, weight: "semibold")[
          Common Vulnerabilities
        ]
        #v(8pt)
        
        #for (idx, vuln) in common-vulns.enumerate() [
          #block(
            width: 100%,
            fill: rgb("#fef2f2"),
            stroke: (left: 3pt + rgb("#b91c1c")),
            inset: 10pt,
            radius: 3pt,
            breakable: false,
          )[
            #text(weight: "semibold", size: 9.5pt)[
              #(idx + 1). #vuln.title
            ]
            #v(4pt)
            #text(size: 9pt)[#vuln.description]
            #v(4pt)
            #text(size: 8pt, fill: rgb("#7f1d1d"), weight: "medium")[
              CVE: #vuln.cve | CVSS: #vuln.cvss
            ]
          ]
          #v(6pt)
        ]
      ]
      
      #if misconfigs.len() > 0 [
        #v(14pt)
        #text(size: 11pt, weight: "semibold")[
          Common Misconfigurations
        ]
        #v(8pt)
        
        #list(
          tight: false,
          ..misconfigs.map(m => [
            #text(weight: "medium", size: 9.5pt)[#m.title:] 
            #text(size: 9pt)[#m.description]
          ])
        )
      ]
    ]
  ]
}
