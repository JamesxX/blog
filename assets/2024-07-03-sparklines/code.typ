
#import "../packages/sparklines/lib.typ" as sparkline
#import "data.typ"

#set par(justify: true)
#set text(size: 12pt)

#let par-wrap(body) = {
  lorem(20)
  body
  lorem(20)
}

#par-wrap[
  Owing to the good $#`ETH`->#`GBP`$ 
  #sparkline.make(
    data.series("Adj Close").filter(it=>it.first()>300), 
    width: 2.5em,  
    height: 1.2em
  )
  exchange rate. 
]

#par-wrap[
  #sparkline.make(
    (1,4,2,5).enumerate(), 
    width: 0.8em,  
    height: 1em, 
    style: (stroke: 0.92pt), 
  ) 
]

#par-wrap[
  After the event
  #sparkline.make(
    data.series("Adj Close").filter(it=>(it.first()>290 and it.first() < 320)), 
    width: 1.7em,  
    height: 1.2em,
    draw: (
      sparkline.line,
      sparkline.vline(313, stroke: (thickness: 0.4pt, paint: red))
    )
  ) the exchange rate 
]

#import "../packages/booktabs/lib.typ" as booktabs

#let column(key, display, width: 1em) = (:
  key: key,
  display: sparkline.make(
    width: width,
    data.series(key)
  ) + display,
  width: 1fr,
  align: right,
)

#booktabs.rigor.make(
  columns: (
    (
      key: "Date-Display",
      display: [Date],
      gutter: 1em
    ),
    column("Open", width: 2.3em)[Open],
    column("High", width: 2.3em)[High],
    column("Low", width: 2.6em)[Low],
    column("Close", width: 2.1em)[Close],
    column("Volume")[Volume]
  ),
  data: data.converted.filter((it)=>{it.Day < 210})
)