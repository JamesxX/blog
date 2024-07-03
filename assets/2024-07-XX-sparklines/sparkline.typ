#import "@preview/cetz:0.2.2"

#let line(data, (x-min, x-max), (y-min, y-max)) = cetz.draw.line(
  ..data
)

#let highlight-start-end-comparative(scale:1) = (data, (x-min, x-max), (y-min, y-max)) => {
  let ((first-x, first-y), (last-x, last-y)) = (data.first(), data.last())
  let colors = (red, green)
  if (first-y > last-y){colors = colors.reverse()}
  cetz.draw.mark(data.at(1), data.at(0), symbol: "o", scale: scale, transform-shape: false)
  // cetz.draw.mark((last-x, last-y))
}

#let make(
  data, 
  height: 1em,
  width: 1em, 
  style: (stroke: 0.4pt),
  draw: (
    line,
    highlight-start-end-comparative()
  )
) = h(0em, weak: true) + sym.space + box({
  
  let xs = data.map(it=>it.first())
  let x-min = calc.min(..xs)
  let x-max = calc.max(..xs)

  let ys = data.map(it=>it.last())
  let y-min = calc.min(..ys)
  let y-max = calc.max(..ys)

  cetz.canvas(
    length: 1em,
    {
      cetz.draw.set-style(stroke: stroke, ..style)
      cetz.draw.scale(
        x: width / ((x-max - x-min ) * 1em), 
        y: height / (2*(y-max - y-min) * 1em)
      )
      for cmd in draw {
        cmd(data, (x-min, x-max), (y-min, y-max))
      }
    }
  )
}) + sym.space + h(0em, weak: true)