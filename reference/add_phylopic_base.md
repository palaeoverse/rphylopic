# Add PhyloPics to a base R plot

Specify existing images, taxonomic names, or PhyloPic uuids to add
PhyloPic silhouettes on top of an existing base R plot (like
[`points()`](https://rdrr.io/r/graphics/points.html)).

## Usage

``` r
add_phylopic_base(
  img = NULL,
  name = NULL,
  uuid = NULL,
  filter = NULL,
  x = NULL,
  y = NULL,
  ysize = deprecated(),
  height = NULL,
  width = NULL,
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

  `numeric`. x value of the silhouette center. If "NULL", the default,
  the mean value of the x-axis is used.

- y:

  `numeric`. y value of the silhouette center. If "NULL", the default,
  the mean value of the y-axis is used.

- ysize:

  **\[deprecated\]** use the `height` or `width` argument instead.

- height:

  `numeric`. Height of the silhouette in coordinate space. If "NULL",
  the default, and `width` is also "NULL", the silhouette will be as
  large as fits in the plot area. If "NULL" and `width` is specified,
  the height is determined by the aspect ratio of the original image.
  One or both of `height` and `width` must be "NULL".

- width:

  `numeric`. Width of the silhouette in coordinate space. If "NULL", the
  default, and `height` is also "NULL", the silhouette will be as large
  as fits in the plot area. If "NULL" and `height` is specified, the
  width is determined by the aspect ratio of the original image. One or
  both of `height` and `width` must be "NULL".

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
  justification (left = 0, center = 0.5, right = 1).

- vjust:

  `numeric`. A numeric vector between 0 and 1 specifying vertical
  justification (top = 1, middle = 0.5, bottom = 0).

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
parameters `x`, `y`, `hjust`, and `vjust` to place the silhouette at a
specified position on the plot. If `height` and `width` are both
unspecified, then the silhouette will be plotted to the full height
and/or width of the plot. The aspect ratio of `Picture` objects will
always be maintained (even when a plot is resized). However, if the plot
is resized after plotting a silhouette, the absolute size and/or
position of the silhouette may change.

Any argument (except for `remove_background`) may be a vector of values
if multiple silhouettes should be plotted. In this case, all other
arguments may also be vectors of values, which will be recycled as
necessary to the length of the longest vector argument.

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
# single image
plot(1, 1, type = "n", main = "A cat")
add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                  x = 1, y = 1, height = 0.4)

# lots of images using a uuid
posx <- runif(10, 0, 1)
posy <- runif(10, 0, 1)
size <- runif(10, 0.1, 0.3)
angle <- runif(10, 0, 360)
hor <- sample(c(TRUE, FALSE), 10, TRUE)
ver <- sample(c(TRUE, FALSE), 10, TRUE)
fills <- sample(c("black", "darkorange", "grey42", "white"), 10,
               replace = TRUE)

plot(posx, posy, type = "n", main = "A cat herd")
add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                  x = posx, y = posy, height = size,
                  fill = fills, angle = angle,
                  horizontal = hor, vertical = ver)

# Example using a cat background
cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
# setup plot area
plot(posx, posy, type = "n", main = "A cat herd, on top of a cat",
     xlim = c(0, 1), ylim = c(0, 1))
# plot background cat
add_phylopic_base(img = cat, alpha = 0.2)
# overlay smaller cats
add_phylopic_base(img = cat, x = posx, y = posy, height = size, alpha = 0.8)
} # }
```
