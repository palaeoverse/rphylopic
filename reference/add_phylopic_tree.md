# Add PhyloPics to a phylogenetic tree plotted with base R

Specify existing images, taxonomic names, or PhyloPic uuids to add
PhyloPic silhouettes alongside the associated leaves of a phylogenetic
tree that has been plotted in the active graphics device using the base
R graphics functions.

## Usage

``` r
add_phylopic_tree(
  tree,
  tip = names(img) %||% names(uuid) %||% names(name) %||% name,
  img = NULL,
  name = if (is.null(img) && is.null(uuid)) tip else NULL,
  uuid = NULL,
  width,
  padding = NULL,
  relWidth = 0.06,
  relPadding = 1/200,
  hjust = 0,
  ...
)
```

## Arguments

- tree:

  The phylogenetic tree object of class `phylo` on which to add the
  silhouette.

- tip:

  The tip labels against which to add the silhouettes. If not specified,
  the names of the `img`, `uuid` or `name` vector are used.

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object, e.g., from using
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

- name:

  `character`. A taxonomic name to be passed to
  [`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md).

- uuid:

  `character`. A valid uuid for a PhyloPic silhouette (such as that
  returned by
  [`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md)
  or
  [`pick_phylopic()`](https://rphylopic.palaeoverse.org/reference/pick_phylopic.md)).

- width:

  `numeric`. Width of the silhouette in coordinate space. If "NULL", the
  default, and `height` is also "NULL", the silhouette will be as large
  as fits in the plot area. If "NULL" and `height` is specified, the
  width is determined by the aspect ratio of the original image. One or
  both of `height` and `width` must be "NULL".

- padding, relPadding:

  Distance to inset each silhouette from the right edge of the plotting
  area, in the plot coordinate system (`padding`) or relative to the
  size of the plotting area (`relPadding`). Negative values offset to
  the right.

- relWidth:

  The width of each silhouette relative to the plotting area.

- hjust:

  `numeric`. A numeric vector between 0 and 1 specifying horizontal
  justification (left = 0, center = 0.5, right = 1).

- ...:

  Further arguments to pass to
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md).

## See also

For trees plotted using ggtree, see
[`geom_phylopic()`](https://rphylopic.palaeoverse.org/reference/geom_phylopic.md).

## Author

[Martin R. Smith](https://orcid.org/0000-0001-5660-1727)
(<martin.smith@durham.ac.uk>)

## Examples

``` r
if (FALSE) { # \dontrun{
 # Load the ape library to work with phylogenetic trees
library("ape")

# Read a phylogenetic tree
tree <- ape::read.tree(text = "(cat, (dog, mouse));")

# Set a large right margin to accommodate the silhouettes
par(mar = c(1, 1, 1, 10))

# Plot the tree
plot(tree)

# Add a PhyloPic silhouette of a cat to the tree
add_phylopic_tree(
  tree, # Must be the tree that was plotted
  "cat", # Which leaf should the silhouette be plotted against?
  uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9", # Silhouette to plot
  relWidth = 0.2,
  fill = "brown"
)
} # }
```
