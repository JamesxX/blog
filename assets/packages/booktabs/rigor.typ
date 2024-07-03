#import "style.typ": *
#import "footnotes.typ" as footnotes

#let recurse-columns(columns, key, default: auto, inherit: true) = {
  // For every column
  for child in columns {

    // If it has children, recurse. If we should inherit, update the default.
    if "children" in child {
      recurse-columns(
        child.children, 
        key, 
        inherit: inherit, 
        default: {
        if inherit {child.at(key, default: default)} else {default}
        }
      )
      
    } else {

      // Bottom of rabbit hole: fetch the value (or default) and array join 
      // everything together
      (child.at(key, default: default),)
      
    }
  }
}

#let build-header(columns, max-depth: 1, start: 0) = {
  // For every column
  for entry in columns {

    if (entry.length == 0) {continue}
    // Make a cell that spans its recusive length (and limit rowspan if it has children)
    (table.cell(
      x: start,
      y: entry.depth,
      rowspan: if entry.length == 1 {max-depth - entry.depth} else {1},
      colspan: entry.length,

      // Header cells should be horizon aligned. Ideally it should default to `start`
      // but I've shadowed that variable.
      align: horizon + entry.at("align", default: left),
      entry.display
    ),)

    // If it has nested columns, build those too.
    // NOTE: Return values are collated using automatic array joining!
    if "children" in entry and entry.children.len() > 0 {
      build-header(
        entry.children, 
        max-depth: max-depth,
        start: start // Pass along 
      )
    }

    // If it has a hline, add it under the cell
    if ("hline" in entry){
      (
        table.hline(
          y: entry.depth + 1, 
          start: start, 
          end: start + entry.length, 
          ..entry.hline
        ),
      )
    }

    if ("vline" in entry){ (table.vline(x: start + 1, ..entry.vline),) }

    // Keep track of which column we are in. This could be precalculated.
    start += entry.length
  }
}


#let recurse-data(columns, data) = {
  // For every column
  for column in columns {
    // Handle nested columns
    if ("children" in column){
      recurse-data(
        column.children, 
        // If the parent column has a key, lets assume that its not a mistake, and
        // lets use this to slice the data before we pass it onto the child columns.
        // If the key is missing, from the data, lets assume it has been removed from
        // the data set
        if ("key" in column){
          data.at(column.key, default: (:))
        } else {
          data
        }
      )
    } else { // Bottom of the rabbit hole
      // Return the data, but if it doesn't exist, return empty content instead so
      // we don't mess up our alignments
      if "key" in column {
        (data.at(column.key, default:  []),)
      } else {
        ([],)
      }
    }
  }
}

#let sanitize-input(columns, depth: 0, max-depth: 1, length: 0) = {

  // For every column
  for (key, entry) in columns.enumerate() {

    // if it has children
    if "children" in entry {

      // Recurse
      let (children, child-depth, child-length) = sanitize-input(
        entry.children, 
        depth: depth + 1, 
        max-depth: max-depth + 1
      )

      // record the recursive length
      columns.at(key).insert("length", child-length)      
      columns.at(key).children = children
      length += child-length

      // Keep track of the deepest yet seen rabit hole
      max-depth = calc.max(max-depth, child-depth)

    // Bottom of the rabit hole, must have a length of 1
    } else {
      length += 1
      columns.at(key).insert("length", 1)
    }

    // In all cases, keep track of depth
    columns.at(key).insert("depth", depth)
  }

  // Pass the results on
  return (columns, max-depth, length)
}

#let make(
  columns: (), 
  data: (), 
  hline: none,
  toprule: toprule,
  midrule: midrule,
  bottomrule: bottomrule,
  notes: footnotes.display-list, // ADDED
  ..args
) = {

  let (columns, max-depth, length) = sanitize-input(columns, depth: 0)

  set text(size: 9pt)
  set math.equation(numbering: none)
  
  footnotes.clear() + table(  // ADDED
    stroke: none,
    fill: recurse-columns(columns, "fill", default: none),
    align: recurse-columns(columns, "align", default: start),
    column-gutter: recurse-columns(columns, "gutter", default: 0em),
    columns: recurse-columns(columns, "width"),
    table.header(
      table.hline(stroke: toprule),
      ..build-header(columns, max-depth: max-depth),
      table.hline(stroke: midrule, y: max-depth),
    ),
    ..args,
    ..(
      for entry in data{ 
        recurse-data(columns, entry)
        if hline != none {(hline,)}
      }
    ),
    table.hline(stroke: bottomrule)
  ) + if (notes != none) {footnotes.display-style(notes)} // ADDED
  
}

