#import "footnotes.typ"
#import "style.typ": *

#let make(
  header: none,
  footer: none,
  notes: footnotes.display,
  data: none,
  keys: none,
  columnwise-transform: (none,),
  ..args
) = {
  set text(size: 9pt)
  set math.equation(numbering: none)
  show table.cell.where(y:0): set text(weight: "bold") if header != none

  footnotes.clear() + table(
    stroke: none,
    ..args.named(),
    table.hline(stroke: toprule),
    ..(if (header != none){
      (
        table.header(..header),
        table.hline(stroke: midrule)
      )
    }),
    ..(if (data != none and keys != none){
      for entry in data {
        for key in keys{
          (entry.at(key, default: none),)
        }
      }
    } else {
      args.pos()
    }),
    ..(if footer != none {(
        table.hline(stroke: midrule),
        table.footer(..footer),
      )
    }),
    table.hline(stroke: bottomrule)
  ) + if (notes != none) {footnotes.display-style(notes)}
}

// #let lr-measure(..cell-contents-varg, separator: ".") = {
//   let measures = cell-contents-varg.pos().fold( (), (acc, input)=>{
//     let split = input.text.split(separator)
//     return acc + ((
//       l: measure(text(split.at(0, default: ""))).width,
//       r: measure(text(split.at(1, default: ""))).width,
//     ),)
//   })
//   let bounds = measures.fold((l: 0pt, r: 0pt), (acc, it)=>{
//     (
//       l: calc.max(acc.l, it.l),
//       r: calc.max(acc.r, it.r)
//     )
//   })
//   cell-contents-varg.pos().enumerate().map( ((key, value)) => {
//     pad(
//       left: bounds.l - measures.at(key, default: (l: 0pt)).l,
//       right: bounds.r - measures.at(key, default: (r: 0pt)).r,
//       value
//     )
//   })
// }