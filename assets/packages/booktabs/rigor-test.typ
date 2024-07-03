#import "lib.typ" as booktabs

#import "@preview/typpuccino:0.1.0"
#let bg-fill-1 = typpuccino.latte.base
#let bg-fill-2 = typpuccino.latte.mantle

#set text(size: 11pt)

#show link: box.with(stroke:red)

#let data = (
  (
    date: [00/11/1234],
    particulars: lorem(05),
    ledger: [JRS123] + booktabs.footnotes.make[Hello World],
    amount: (unit: $100$, decimal: $00$),
    total: (unit: $99$, decimal: $00$),
  ),
)*7 +(
  (
    date: [01/09/1994],
    particulars: [Just buying something extra this week before I run out of stuff],
    ledger: [JRS123] + booktabs.footnotes.make[Special reference because it has a label],
    amount: (unit: $12,222$, decimal: $99$),
    total: (unit: $99$, decimal: $00$),
  ), 
)


#let example = (
  (
    key: "date",
    display: [Date],
    // fill: bg-fill-1,
    // align: left,
    width: 5em,
    gutter: 0.5em,
  ),
  (
    key: "particulars",
    display: text(tracking: 5pt)[Particulars],
    width: 1fr,
    gutter: 0.5em,
  ),
  (
    key: "ledger",
    display: [Ledger],
    // fill: bg-fill-2,
    width: 2cm,
    // align: center,
    gutter: 0.5em,
  ),
  (
    key: "amount", 
    display: align(center)[Amount],
    // fill: bg-fill-1,
    gutter: 0.5em,
    hline: arguments(stroke: booktabs.lightrule),
    children: (
      (
        key: "unit", 
        display: align(left)[£], 
        width: 5em, 
        align: right,
        vline: arguments(stroke: booktabs.lightrule),
        gutter: 0em,
      ),
      (
        key: "decimal",
        display: align(right, text(number-type: "old-style")[.00]), 
        width: 2em,
        // align: left
      ),
    )
  ),
  (
    key: "total", 
    display: align(center)[Total],
    gutter: 0.5em,
    hline: arguments(stroke: booktabs.lightrule),
    children: (
      (
        key: "unit", 
        display: align(left)[£], 
        width: 5em, 
        align: right,
        vline: arguments(stroke: booktabs.lightrule),
        gutter: 0em,
      ),
      (
        key: "decimal",
        display: align(right, text(number-type: "old-style")[.00]), 
        width: 2em,
        align: left
      ),
    )
  ),
)

#set page(height: auto, margin: 1em)
#booktabs.rigor.make(columns: example, 
  data: data, 
  // notes: booktabs.footnotes.display-list
)