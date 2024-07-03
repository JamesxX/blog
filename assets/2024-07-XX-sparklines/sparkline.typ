#import "@preview/cetz:0.2.2"

#let line(data, (x-min, x-max), (y-min, y-max)) = cetz.draw.line(
  ..data
)

#let vline(x, ..style) = (data, (x-min, x-max), (y-min, y-max)) => {
  cetz.draw.line(
    (x, y-min),
    (x, y-max),
    ..style
  )
}

#let make(
  data, 
  height: 1em,
  width: 1em, 
  style: (stroke: 0.4pt),
  draw: (
    line,
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