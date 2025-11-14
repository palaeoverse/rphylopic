# Use PhyloPics as legend key glyphs

Specify existing images, taxonomic names, or PhyloPic uuids to use
PhyloPic silhouettes as legend key glyphs in a ggplot plot.

## Usage

``` r
phylopic_key_glyph(img = NULL, name = NULL, uuid = NULL)
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

## Details

One (and only one) of `img`, `name`, or `uuid` must be specified.

This argument may also be a vector/list of valid values if multiple
silhouettes should be used as key glyphs. In this case, the specified
silhouettes will be used as ordered as key glyphs one by one, with
recycling as necessary.

Note that the sizes of the silhouettes in the legend are currently
maximized based on the size of the key. This size can be modified using
the `legend.key.size` argument in
[`ggplot2::theme()`](https://ggplot2.tidyverse.org/reference/theme.html).
Therefore, the silhouettes will not reflect the size aesthetic, and this
function should not be used for size legends.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
df <- data.frame(x = c(2, 4), y = c(10, 20),
                 name = c("Felis silvestris catus", "Odobenus rosmarus"))
ggplot(df) +
  geom_phylopic(aes(x = x, y = y, name = name, color = name), size = 10,
                show.legend = TRUE,
                key_glyph = phylopic_key_glyph(name =
                                               c("Felis silvestris catus",
                                                 "Odobenus rosmarus"))) +
  coord_cartesian(xlim = c(1,6), ylim = c(5, 30))
} # }
```
