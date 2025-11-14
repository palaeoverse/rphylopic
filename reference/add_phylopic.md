# Annotate a ggplot plot with PhyloPics

Specify existing images, taxonomic names, or PhyloPic uuids to add
PhyloPic silhouettes as a separate layer to an existing ggplot plot.

## Usage

``` r
add_phylopic(
  img = NULL,
  name = NULL,
  uuid = NULL,
  filter = NULL,
  x,
  y,
  ysize = deprecated(),
  height = NA,
  width = NA,
  alpha = 1,
  color = NA,
  fill = "black",
  horizontal = FALSE,
  vertical = FALSE,
  angle = 0,
  hjust = 0.5,
  vjust = 0.5,
  remove_background = TRUE,
  verbose = FALSE
)
```

## Arguments

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

- filter:

  `character`. Filter by usage license if `name` is defined. Use "by" to
  limit results to images which do not require attribution, "nc" for
  images which allows commercial usage, and "sa" for images without a
  ShareAlike clause. The user can also combine these filters as a
  vector.

- x:

  `numeric`. x value of the silhouette center.

- y:

  `numeric`. y value of the silhouette center.

- ysize:

  **\[deprecated\]** use the `height` or `width` argument instead.

- height:

  `numeric`. Height of the silhouette in coordinate space. If "NA", the
  default, and `width` is "NA", the silhouette will be as large as fits
  in the plot area. If "NA" and `width` is specified, the height is
  determined by the aspect ratio of the original image. One or both of
  `height` and `width` must be "NA".

- width:

  `numeric`. Width of the silhouette in coordinate space. If "NA", the
  default, and `height` is "NA", the silhouette will be as large as fits
  in the plot area. If "NA", the default, and `height` is specified, the
  width is determined by the aspect ratio of the original image. One or
  both of `height` and `width` must be "NA".

- alpha:

  `numeric`. A value between 0 and 1, specifying the opacity of the
  silhouette (0 is fully transparent, 1 is fully opaque).

- color:

  `character`. Color of silhouette outline. If "original" or NA is
  specified, the original color of the silhouette outline will be used
  (usually the same as "transparent"). To remove the outline, you can
  set this to "transparent".

- fill:

  `character`. Color of silhouette. If "original" is specified, the
  original color of the silhouette will be used (usually the same as
  "black"). If `color` is specified and `fill` is NA, `color` will be
  used as the fill color (for backwards compatibility). To remove the
  fill, you can set this to "transparent".

- horizontal:

  `logical`. Should the silhouette be flipped horizontally?

- vertical:

  `logical`. Should the silhouette be flipped vertically?

- angle:

  `numeric`. The number of degrees to rotate the silhouette clockwise.
  The default is no rotation.

- hjust:

  `numeric`. A numeric vector between 0 and 1 specifying horizontal
  justification (left = 0, center = 0.5, right = 1). Note that, due to
  the enforcement of the silhouette's aspect ratio, there may be
  unexpected behavior due to interactions between the aspect ratio of
  the plot and the aspect ratio of the silhouette.

- vjust:

  `numeric`. A numeric vector between 0 and 1 specifying vertical
  justification (top = 1, middle = 0.5, bottom = 0). Note that, due to
  the enforcement of the silhouette's aspect ratio, there may be
  unexpected behavior due to interactions between the aspect ratio of
  the plot and the aspect ratio of the silhouette.

- remove_background:

  `logical`. Should any white background be removed from the
  silhouette(s)? See
  [`recolor_phylopic()`](https://rphylopic.palaeoverse.org/reference/recolor_phylopic.md)
  for details.

- verbose:

  `logical`. Should the attribution information for the used
  silhouette(s) be printed to the console (see
  [`get_attribution()`](https://rphylopic.palaeoverse.org/reference/get_attribution.md))?

## Details

One (and only one) of `img`, `name`, or `uuid` must be specified. Use
parameters `x`, `y`, and `ysize` to place the silhouette at a specified
position on the plot. The aspect ratio of the silhouette will always be
maintained.

`x` and/or `y` may be vectors of numeric values if multiple silhouettes
should be plotted at once. In this case, any other arguments (except for
`remove_background`) may also be vectors of values, which will be
recycled as necessary.

When specifying a horizontal and/or vertical flip **and** a rotation,
the flip(s) will always occur first. If you would like to customize this
behavior, you can flip and/or rotate the image within your own workflow
using
[`flip_phylopic()`](https://rphylopic.palaeoverse.org/reference/flip_phylopic.md)
and
[`rotate_phylopic()`](https://rphylopic.palaeoverse.org/reference/rotate_phylopic.md).

Note that png array objects can only be rotated by multiples of 90
degrees. Also, outline colors do not currently work for png array
objects.

## Examples

``` r
if (FALSE) { # \dontrun{
# Put a silhouette behind a plot based on a taxonomic name
library(ggplot2)
ggplot(iris) +
  add_phylopic(x = 6.1, y = 3.2, name = "Iris", alpha = 0.2) +
  geom_point(aes(x = Sepal.Length, y = Sepal.Width))

# Put a silhouette in several places based on UUID
posx <- runif(10, 0, 10)
posy <- runif(10, 0, 10)
heights <- runif(10, 0.4, 2)
angle <- runif(10, 0, 360)
hor <- sample(c(TRUE, FALSE), 10, TRUE)
ver <- sample(c(TRUE, FALSE), 10, TRUE)
fills <- sample(c("black", "darkorange", "grey42", "white"), 10,
  replace = TRUE)
alpha <- runif(10, 0.3, 1)

p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
  geom_blank() +
  add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
               x = posx, y = posy, height = heights,
               fill = fills, alpha = alpha, angle = angle,
               horizontal = hor, vertical = ver)
p + ggtitle("R Cat Herd!!")
} # }
```
