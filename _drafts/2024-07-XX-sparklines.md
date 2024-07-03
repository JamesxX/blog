---
layout: post
title: "Sparklines - A neat alternative to figures"
---
Sometimes, you'll want to convey (or remind) the reader about some fact or data that is more intuitively understood when represented graphically.
For this reason, we have figures: pictures that are signposted by a label. Generally, they will take up enough space (or are difficult enough to typeset) that consideration must be put into whether the information is significant enough to warrant the costs.
For this reason, some journals even place a limit on the number of tables or figures.

This is where sparklines make their entrance. For quickly graphically representing a subset or feature of previously presented data, a text-sized plot without axes is included in the text.

![Expression]({{ "/assets/2024-07-XX-sparklines/header.png" | relative_url }})  

For the purposes of illustration, I'm using `ETH` to `GBP` exchange rates to simulate actual data. The only matter of note was that when important the data from the CSV to Typst, and owing to the lack of named capture groups, the code that casts YYYY-MM-DD to date is atrocious.

```
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
)
```

= Text sized plots
One of the distinguishing features of sparklines is that when they are in the body of a text, they do not catch the eye more than is absolutely necessary. They don't have a luminance that is darker than the text, they are sized in proportion to the glyphs that surround them, and do not affect the line spacing. Now that we've set our goals, let's get started.

The lowest hanging fruit is that, no matter how they are encoded in the source file, they have a space width on either side. This can be achieved by nesting space symbols within weak 0em horizontal spacing, like so

```
h(0em, weak: true) + sym.space + box({
  
}) + sym.space + h(0em, weak: true)

```

To get our plots text-sized, I'm going to scale the x and y according to the spread of the data and the given `width` and `height` lengths
```
#let sparkline(
  data, 
  height: 1em,
  width: 1em, 
) = h(0em, weak: true) + sym.space + box({
  
  // Calculate the spread of data
  let x-min = calc.min(..data.map(it=>it.first()))
  let x-max = calc.max(..data.map(it=>it.first()))

  let y-min = calc.min(..data.map(it=>it.last()))
  let y-max = calc.max(..data.map(it=>it.last()))

  // Setup a canvas that scales with text size
  cetz.canvas(
    length: 1em,
    {
      cetz.draw.scale(
        x: width / ((x-max - x-min ) * 1em),  // Normalize data to between 0 and 1
        y: height / (2*(y-max - y-min) * 1em)
      )
      cetz.draw.line(..data)
    }
  )
}) + sym.space + h(0em, weak: true)
```