
#import "@preview/cetz:0.2.2"

#let c = csv("ETH-GBP.csv", row-type: dictionary)

#let sparkline(
  data, 
  height: 1em,
  width: 1em, 
  style: (stroke: (thickness: 0.45pt))
) = h(0em, weak: true) + sym.space + box({
  
  let x-min = calc.min(..data.map(it=>it.first()))
  let x-max = calc.max(..data.map(it=>it.first()))

  let y-min = calc.min(..data.map(it=>it.last()))
  let y-max = calc.max(..data.map(it=>it.last()))

  cetz.canvas(
    length: 1em,
    {
      cetz.draw.set-style(..style)
      cetz.draw.scale(
        x: width / ((x-max - x-min ) * 1em), 
        y: height / (2*(y-max - y-min) * 1em)
      )
      cetz.draw.line(..data)
    }
  )
}) + sym.space + h(0em, weak: true)

#set par(justify: true)
#set text(size: 12pt)
#lorem(100)
#let x = c.map(
  (it)=>(
    datetime(
      ..("year", "month", "day").zip(
        it.Date.matches(
          regex("(\d{4})-(\d{2})-(\d{2})")
        ).first().captures
      ).fold(
        (:), 
        (acc, it) => (
          ..acc, 
          (it.first()): int(it.last())
        )
      )
    ).ordinal(),
    float(it.at("Adj Close"))
  )
).filter(it=>it.first()>300)
Owing to the good $#`ETH`->#`GBP`$ 
#sparkline(x, width: 2.5em,  height: 1.2em) 
exchange rate. 
#lorem(100)
