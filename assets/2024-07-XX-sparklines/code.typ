
#import "sparkline.typ" as sparkline: make
#import "data.typ"

#set par(justify: true)
#set text(size: 12pt)

#lorem(20)
Owing to the good $#`ETH`->#`GBP`$ 
#sparkline.make(
  data.converted.filter(it=>it.first()>300), 
  width: 2.5em,  
  height: 1.2em
)
exchange rate. 
#lorem(20)

#lorem(20)
#sparkline.make(
  (1,4,2,5).enumerate(), 
  width: 0.8em,  
  height: 1em, 
  style: (stroke: 0.92pt), 
) 
#lorem(20)