# Use PhyloPic silhouettes with igraph

When both `rphylopic` and `igraph` are loaded, rphylopic registers a
custom vertex shape called `"phylopic"`. Setting
`vertex.shape = "phylopic"` in
[`igraph::plot.igraph()`](https://r.igraph.org/reference/plot.igraph.html)
renders each vertex as a PhyloPic silhouette.

## Details

The shape accepts the following vertex parameters, mirroring the
arguments of
[`add_phylopic_base()`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md):

- `vertex.img`, `vertex.name`, `vertex.uuid` — silhouette source

- `vertex.size` — silhouette height (in plot units)

- `vertex.color`, `vertex.frame.color`, `vertex.alpha` — fill, outline,
  opacity

- `vertex.horizontal`, `vertex.vertical`, `vertex.angle` — orientation

- `vertex.hjust`, `vertex.vjust` — anchoring

- `vertex.remove_background`, `vertex.verbose`, `vertex.filter` — passed
  to
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md)

- `vertex.clip_scale` — numeric scale factor controlling the clipping of
  the edges (default: `0.7`)

## Note on interactive resizing

PhyloPic silhouettes are drawn as vector graphics on top of igraph's
base-graphics plot. Rendering as vectors preserves silhouette
resolution; however, when the graphics device is resized interactively
the silhouettes will not reposition along with the underlying graph
layout. The graph nodes, edges, and labels will redraw at their new
coordinates while the silhouettes remain anchored to their original
device positions. To restore alignment, re-run the
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) call after
resizing.

## See also

[`add_phylopic_base()`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md),
[`igraph::add_shape()`](https://r.igraph.org/reference/shapes.html)

## Examples

``` r
if (FALSE) { # \dontrun{
library(igraph)
g <- make_ring(10)
plot(g, vertex.shape = "phylopic", vertex.name = "Gorilla",
     vertex.color = rainbow(vcount(g)))
} # }
```
