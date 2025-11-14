# Geom for adding PhyloPic silhouettes to a plot

This geom acts like
[`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html),
except that the specified silhouettes are used as points. Silhouettes
can be specified by their `name`, `uuid`, or image objects (`img`).

## Usage

``` r
geom_phylopic(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE,
  remove_background = TRUE,
  verbose = FALSE,
  filter = NULL
)
```

## Arguments

- mapping:

  Set of aesthetic mappings created by
  [`aes()`](https://ggplot2.tidyverse.org/reference/aes.html). If
  specified and `inherit.aes = TRUE` (the default), it is combined with
  the default mapping at the top level of the plot. You must supply
  `mapping` if there is no plot mapping.

- data:

  The data to be displayed in this layer. There are three options:

  If `NULL`, the default, the data is inherited from the plot data as
  specified in the call to
  [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

  A `data.frame`, or other object, will override the plot data. All
  objects will be fortified to produce a data frame. See
  [`fortify()`](https://ggplot2.tidyverse.org/reference/fortify.html)
  for which variables will be created.

  A `function` will be called with a single argument, the plot data. The
  return value must be a `data.frame`, and will be used as the layer
  data. A `function` can be created from a `formula` (e.g.
  `~ head(.x, 10)`).

- stat:

  The statistical transformation to use on the data for this layer. When
  using a `geom_*()` function to construct a layer, the `stat` argument
  can be used the override the default coupling between geoms and stats.
  The `stat` argument accepts the following:

  - A `Stat` ggproto subclass, for example `StatCount`.

  - A string naming the stat. To give the stat as a string, strip the
    function name of the `stat_` prefix. For example, to use
    [`stat_count()`](https://ggplot2.tidyverse.org/reference/geom_bar.html),
    give the stat as `"count"`.

  - For more information and other ways to specify the stat, see the
    [layer
    stat](https://ggplot2.tidyverse.org/reference/layer_stats.html)
    documentation.

- position:

  A position adjustment to use on the data for this layer. This can be
  used in various ways, including to prevent overplotting and improving
  the display. The `position` argument accepts the following:

  - The result of calling a position function, such as
    [`position_jitter()`](https://ggplot2.tidyverse.org/reference/position_jitter.html).
    This method allows for passing extra arguments to the position.

  - A string naming the position adjustment. To give the position as a
    string, strip the function name of the `position_` prefix. For
    example, to use
    [`position_jitter()`](https://ggplot2.tidyverse.org/reference/position_jitter.html),
    give the position as `"jitter"`.

  - For more information and other ways to specify the position, see the
    [layer
    position](https://ggplot2.tidyverse.org/reference/layer_positions.html)
    documentation.

- ...:

  Other arguments passed on to
  [`layer()`](https://ggplot2.tidyverse.org/reference/layer.html)'s
  `params` argument. These arguments broadly fall into one of 4
  categories below. Notably, further arguments to the `position`
  argument, or aesthetics that are required can *not* be passed through
  `...`. Unknown arguments that are not part of the 4 categories below
  are ignored.

  - Static aesthetics that are not mapped to a scale, but are at a fixed
    value and apply to the layer as a whole. For example,
    `colour = "red"` or `linewidth = 3`. The geom's documentation has an
    **Aesthetics** section that lists the available options. The
    'required' aesthetics cannot be passed on to the `params`. Please
    note that while passing unmapped aesthetics as vectors is
    technically possible, the order and required length is not
    guaranteed to be parallel to the input data.

  - When constructing a layer using a `stat_*()` function, the `...`
    argument can be used to pass on parameters to the `geom` part of the
    layer. An example of this is
    `stat_density(geom = "area", outline.type = "both")`. The geom's
    documentation lists which parameters it can accept.

  - Inversely, when constructing a layer using a `geom_*()` function,
    the `...` argument can be used to pass on parameters to the `stat`
    part of the layer. An example of this is
    `geom_area(stat = "density", adjust = 0.5)`. The stat's
    documentation lists which parameters it can accept.

  - The `key_glyph` argument of
    [`layer()`](https://ggplot2.tidyverse.org/reference/layer.html) may
    also be passed on through `...`. This can be one of the functions
    described as [key
    glyphs](https://ggplot2.tidyverse.org/reference/draw_key.html), to
    change the display of the layer in the legend.

- na.rm:

  If `FALSE`, the default, missing values are removed with a warning. If
  `TRUE`, missing values are silently removed.

- show.legend:

  logical. Should this layer be included in the legends? `FALSE`, the
  default, never includes, `NA` includes if any aesthetics are mapped,
  and `TRUE` always includes. It can also be a named logical vector to
  finely select the aesthetics to display.

- inherit.aes:

  If `FALSE`, overrides the default aesthetics, rather than combining
  with them. This is most useful for helper functions that define both
  data and aesthetics and shouldn't inherit behaviour from the default
  plot specification, e.g.
  [`borders()`](https://ggplot2.tidyverse.org/reference/annotation_borders.html).

- remove_background:

  `logical`. Should any white background be removed from the
  silhouette(s)? See
  [`recolor_phylopic()`](https://rphylopic.palaeoverse.org/reference/recolor_phylopic.md)
  for details.

- verbose:

  `logical`. Should the attribution information for the used
  silhouette(s) be printed to the console (see
  [`get_attribution()`](https://rphylopic.palaeoverse.org/reference/get_attribution.md))?

- filter:

  `character`. Filter by usage license if using the `name` aesthetic.
  Use "by" to limit results to images which do not require attribution,
  "nc" for images which allows commercial usage, and "sa" for images
  without a ShareAlike clause. The user can also combine these filters
  as a vector.

## Details

One (and only one) of the `img`, `name`, or `uuid` aesthetics must be
specified. The `img` aesthetic can be
[Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) objects
or png array objects, e.g., from using
[`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).
Use the `x` and `y` aesthetics to place the silhouettes at specified
positions on the plot. The `height` or `width` aesthetic specifies the
height or width, respectively, of the silhouettes in the units of the y
axis (only one is allowed). The aspect ratio of the silhouettes will
always be maintained. The `hjust` and `vjust` aesthetics can be used to
manage the justification of the silhouettes with respect to the `x` and
`y` coordinates.

The `color` (default: NA), `fill` (default: "black"), and `alpha` (
default: 1) aesthetics can be used to change the outline color, fill
color, and transparency (outline and fill) of the silhouettes,
respectively. If `color` is specified and `fill` is NA `color` will be
used as the fill color (for backwards compatibility). If "original" is
specified for the `color` aesthetic, the original color of the
silhouette outline will be used (usually the same as "transparent"). If
"original" is specified for the `fill` aesthetic, the original color of
the silhouette body will be used (usually the same as "black"). To
remove the fill or outline, you can set `fill` or `color` to
"transparent", respectively.

The `horizontal` and `vertical` aesthetics can be used to flip the
silhouettes. The `angle` aesthetic can be used to rotate the
silhouettes. When specifying a horizontal and/or vertical flip **and** a
rotation, the flip(s) will always occur first. If you would like to
customize this behavior, you can flip and/or rotate the image within
your own workflow using
[`flip_phylopic()`](https://rphylopic.palaeoverse.org/reference/flip_phylopic.md)
and
[`rotate_phylopic()`](https://rphylopic.palaeoverse.org/reference/rotate_phylopic.md).

Note that png array objects can only be rotated by multiples of 90
degrees. Also, outline colors do not currently work for png array
objects.

## Aesthetics

geom_phylopic understands the following aesthetics:

- **x** (required)

- **y** (required)

- **img** *or* **uuid** *or* **name** (one, and only one, required)

- height *or* width (optional, maximum of only one allowed)

- ysize **\[deprecated\]** Deprecated in favor of height or width

- color *or* colour

- fill

- alpha

- horizontal

- vertical

- angle

- hjust

- vjust

  Learn more about setting these aesthetics in
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/reference/add_phylopic.md).

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
df <- data.frame(x = c(2, 4), y = c(10, 20),
                 name = c("Felis silvestris catus", "Odobenus rosmarus"))
ggplot(df) +
  geom_phylopic(aes(x = x, y = y, name = name),
                fill = "purple", height = 10) +
  facet_wrap(~name) +
  coord_cartesian(xlim = c(1,6), ylim = c(5, 30))
} # }
```
