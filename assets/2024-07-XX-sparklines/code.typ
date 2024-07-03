
#import "@preview/cetz:0.2.2"

#let c = csv("ETH-GBP.csv", row-type: dictionary)

#let sparkline(
  data, 
  height: auto,
  width: 1, 
  style: (stroke: (thickness: 0.45pt))
) = h(0em, weak: true) + sym.space + box(context {

  let height = if (height == auto) {text.size} else {height}
  
  let min-x = calc.min(..data.map(it=>it.first()))
  let max-x = data.fold(min-x, (acc, it)=>{calc.max(acc, it.first())})
  
  let min-y = calc.min(..data.map(it=>it.last()))
  let max-y = data.fold(min-y, (acc, it)=>{calc.max(acc, it.last())})

  let data = data.map(it=>{
    it.first() = width * ( height / 2) * (it.first() - min-x) / (max-x - min-x)
    return it
  })
  
  cetz.canvas(
    length: height / (2* (max-y - min-y )),
    {
      cetz.draw.set-style(..style)
      cetz.draw.line(..data)
    }
  )
}) + sym.space + h(0em, weak: true)

#set par(justify: true)
#set text(size: 10pt)
#lorem(100)
#let x = c.map(
  (it)=>(
    datetime(..("year", "month", "day").zip(it.Date.matches(regex("(\d{4})-(\d{2})-(\d{2})")).first().captures).fold((:), (acc, it) => (..acc, (it.first()): int(it.last())))).ordinal(),
    float(it.at("Adj Close"))
  )
).filter(it=>it.first()>300)
Owing to the good $#`ETH`->#`GBP`$ 
#sparkline(x, width: 5) 
exchange rate. 
#lorem(100)
