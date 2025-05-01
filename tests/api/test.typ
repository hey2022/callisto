#import "/src/callisto.typ": *
#import reading: pick-format

== Function `pick-format`
=== Preferred format among `xyz`, `text/plain`, `abc`
#pick-format(("xyz", "text/plain", "abc"))

=== Same with `precedence: ("abc", "text/plain")`
#pick-format(
  ("xyz", "text/plain", "abc"),
  precedence: ("abc", "text/plain"),
)

== Using `python.ipynb`

#let (cells, cell, source, Cell, streams, stream-item, stream-items) = config(
  nb: "/tests/render/python.ipynb",
)

// Check for cell deduplication
#assert.eq(cells((..range(2), 0)).len(), 2)

=== All markdown cells
#cells(cell-type: "markdown")

=== Index of cell with id `"19cdb152-021b-4811-83de-3610ec97fc5b"`
#cell("19cdb152-021b-4811-83de-3610ec97fc5b").index

=== Merged stream for each code cell, with cell index
#streams(result: "dict").map(x => (cell: x.cell.index, value: x.value))

=== Source of cell 4
#source(4)

#pagebreak()

=== Rendering of cell 4
#Cell(4)

=== Stream names of stream items of cell 4
#stream-items(4, result: "dict").map(x => x.name)

=== Last stderr item of cell 4
#stream-item(4, stream: "stderr", item: -1)

== Using `julia.ipynb`

#let (display, results, result, errors) = config(
  nb: json("julia.ipynb"),
)

=== Cell with label `"plot3"`
#display("plot3", item: 0)

=== Cell with `"scatter"` type (custom metadata)
#display("scatter", name-path: "metadata.type", item: 1)

// Must fail with nice error messages
// #display("plots", name-path: "metadata.name", format: "x")
// #display("plots", name-path: "metadata.name", format: "x", ignore-wrong-format: true)

#pagebreak()

=== All cell results
#results().join()

=== Result of cell matching `"plot3"`
#result("plot3")

=== Results of cells with execution count larger than 3
#results(c => c.execution_count > 3)

=== The only Markdown display, shown using a custom handler (`repr`)
#display(format: "text/markdown", ignore-wrong-format: true, handlers: (
  "text/markdown": repr,
))

=== First error in the notebook, in dict form
#errors(result: "dict").first()

=== Allow multiple items in singular functions, pick the first
#let (cell, cells, display, result) = config(nb: json("julia.ipynb"), item: 0)
#display("plot3")
#result("scatter", name-path: "metadata.type")
