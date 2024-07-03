
#import "sparkline.typ"
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
    data.converted.filter(it=>it.first()>300), 
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
    data.converted.filter(it=>(it.first()>290 and it.first() < 320 )), 
    width: 1.7em,  
    height: 1.2em,
    draw: (
      sparkline.line,
      sparkline.vline(313, stroke: (thickness: 0.4pt, paint: red))
    )
  ) the exchange rate 
]