# Changelog

## rphylopic (development version)

## rphylopic 1.7.0

CRAN release: 2026-07-08

- PhyloPic API responses and parsed images are now cached in a temporary
  in-memory R environment to speed up repeated calls
  ([\#123](https://github.com/palaeoverse/rphylopic/issues/123))
  - The cache is cleared when the R session ends
  - The cache can also be manually cleared using
    [`clear_phylopic_cache()`](https://rphylopic.palaeoverse.org/dev/reference/clear_phylopic_cache.md)
- Added support for using PhyloPic silhouettes as vertices when plotting
  [igraph](https://r.igraph.org/) networks via a new `"phylopic"` vertex
  shape, registered automatically when both packages are loaded
  ([\#115](https://github.com/palaeoverse/rphylopic/issues/115),
  [\#118](https://github.com/palaeoverse/rphylopic/issues/118))
- Added new “Network plots” sections to both advanced vignettes,
  demonstrating the new [igraph](https://r.igraph.org/) integration in
  base R and the use of
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  inside [ggraph](https://ggraph.data-imaginist.com) plots

Deprecation:

- The “ysize” and “size” arguments/aesthetics are now fully deprecated
  in favor of “height” and “width” arguments/aesthetics. These
  arguments/aesthetics will be removed in a future version of rphylopic.

## rphylopic 1.6.0

CRAN release: 2025-11-18

- Added
  [`add_phylopic_tree()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_tree.md)
  to add silhouettes to base R trees
  ([\#110](https://github.com/palaeoverse/rphylopic/issues/110))
- Fixed a bug in
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  where all names were reported as not returning PhyloPic results when
  only a single name actually returned no PhyloPic results
- [`resolve_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/resolve_phylopic.md)
  now will retry API calls if they fail
- Fixed
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  and
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md)
  under [ggplot2](https://ggplot2.tidyverse.org) 4.0.0 and up
  ([\#125](https://github.com/palaeoverse/rphylopic/issues/125))
- [`get_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/get_phylopic.md)
  now has a “source” argument that can be used to retrieve the original
  source file from the PhyloPic database
  ([\#116](https://github.com/palaeoverse/rphylopic/issues/116))

## rphylopic 1.5.0

CRAN release: 2024-09-04

- Added ability to specify horizontal and vertical justification of
  silhouettes
  ([\#101](https://github.com/palaeoverse/rphylopic/issues/101))
- Added ability to specify width or height for silhouettes
  ([\#103](https://github.com/palaeoverse/rphylopic/issues/103))
  - Note that all “ysize” and “size” arguments/aesthetics are now
    deprecated in favor of “height” and “width” arguments/aesthetics

## rphylopic 1.4.0

CRAN release: 2024-04-23

- Added
  [`add_phylopic_legend()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_legend.md)
  ([\#83](https://github.com/palaeoverse/rphylopic/issues/83))
- Added permalink generation option to
  [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md)
  ([\#81](https://github.com/palaeoverse/rphylopic/issues/81))

## rphylopic 1.3.0

CRAN release: 2023-12-20

- updated citation
- added warning when specified size is more than 1000 times smaller than
  the y-axis range (mostly useful for when making maps with
  [`ggplot2::coord_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html))
  ([\#86](https://github.com/palaeoverse/rphylopic/issues/86))
- changed the defaults and behavior of the color and fill
  argument/aesthetics to better maintain backwards compatibility but
  also prevent unnecessary outlines
  ([\#87](https://github.com/palaeoverse/rphylopic/issues/87))
- added
  [`resolve_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/resolve_phylopic.md)
  ([\#66](https://github.com/palaeoverse/rphylopic/issues/66))
- [`pick_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/pick_phylopic.md)
  now accepts a list of uuids via the uuid argument
  ([\#95](https://github.com/palaeoverse/rphylopic/issues/95))
- fixed check behavior on CRAN (all tests and examples are now skipped)
- caught a rare error when nothing matched `filter`

## rphylopic 1.2.2

CRAN release: 2023-10-28

- vignettes are now precompiled

## rphylopic 1.2.1

CRAN release: 2023-10-10

- updated [rphylopic](https://rphylopic.palaeoverse.org) to work with
  [grImport2](https://r-forge.r-project.org/projects/grimport/) version
  0.3.0 and [rsvg](https://docs.ropensci.org/rsvg/) version 2.6.0
- [rphylopic](https://rphylopic.palaeoverse.org) now requires
  [grImport2](https://r-forge.r-project.org/projects/grimport/) \>=
  0.3.0 and [rsvg](https://docs.ropensci.org/rsvg/) \>= 2.6.0

## rphylopic 1.2.0

CRAN release: 2023-08-29

- added text argument to
  [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md)
  ([\#56](https://github.com/palaeoverse/rphylopic/issues/56))
- [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md)
  now handles multiple uuids
- added
  [`browse_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/browse_phylopic.md)
  function ([\#60](https://github.com/palaeoverse/rphylopic/issues/60))
- added preview argument to
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/get_phylopic.md)
  ([\#59](https://github.com/palaeoverse/rphylopic/issues/59))
- switched to [maps](https://github.com/adeckmyn/maps) package in base R
  advanced vignette
- [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  now properly handles a single unlisted image object passed to the
  “img” parameter
  ([\#75](https://github.com/palaeoverse/rphylopic/issues/75))
- added filter (license) argument to
  [`get_uuid()`](https://rphylopic.palaeoverse.org/dev/reference/get_uuid.md),
  [`pick_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/pick_phylopic.md),
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md),
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md),
  and
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  ([\#72](https://github.com/palaeoverse/rphylopic/issues/72))
- added img argument to
  [`get_uuid()`](https://rphylopic.palaeoverse.org/dev/reference/get_uuid.md)
  and
  [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md)
- added verbose argument (calls
  [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md))
  to
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md),
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md),
  and
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  ([\#71](https://github.com/palaeoverse/rphylopic/issues/71))
- split out the functionality of the color argument/aesthetic to color
  (silhouette outline) and fill (silhouette) arguments/aesthetics in
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md),
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md),
  and
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  ([\#58](https://github.com/palaeoverse/rphylopic/issues/58))
  - when only the color argument/aesthetic is specified, it is copied to
    the fill argument/aesthetic (maintaining mostly backwards
    compatibility with old code)
- added plot and print methods for silhouette objects
  ([\#73](https://github.com/palaeoverse/rphylopic/issues/73))
- fixed the behavior of
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  when used with
  [`ggplot2::coord_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html)
- added
  [`phylopic_key_glyph()`](https://rphylopic.palaeoverse.org/dev/reference/phylopic_key_glyph.md)
  for using silhouettes inside ggplot legends
  ([\#57](https://github.com/palaeoverse/rphylopic/issues/57))

## rphylopic 1.1.1

CRAN release: 2023-07-08

- Minor fixes for Fedora
- Better handling of malformed Picture objects

## rphylopic 1.1.0

CRAN release: 2023-06-30

- added functions for transforming PhyloPic silhouettes (flipping and
  rotating)
- [`save_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/save_phylopic.md)
  bg argument updated to be “transparent” by default
- added
  [`geom_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/geom_phylopic.md)
  ([\#25](https://github.com/palaeoverse/rphylopic/issues/25))
- vectorized
  [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md)
  and
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  ([\#42](https://github.com/palaeoverse/rphylopic/issues/42))
- [`recolor_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/recolor_phylopic.md)
  now removes white backgrounds by default
- fixed the handling of alpha values
- [`get_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/get_phylopic.md)
  can now return any size raster image
  ([\#50](https://github.com/palaeoverse/rphylopic/issues/50))
- removed the “thumbnail” and “twitter” format options for
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/get_phylopic.md)
- fixed how silhouettes are gathered from PhyloPic
  ([\#51](https://github.com/palaeoverse/rphylopic/issues/51))
- [`pick_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/pick_phylopic.md)
  updated to allow visualization of multiple silhouettes at once
  ([\#43](https://github.com/palaeoverse/rphylopic/issues/43))
- fixed
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  for multi-panel figures
- added three vignettes
  ([\#49](https://github.com/palaeoverse/rphylopic/issues/49),
  [\#55](https://github.com/palaeoverse/rphylopic/issues/55))

## rphylopic 1.0.0

CRAN release: 2023-03-20

- [rphylopic](https://rphylopic.palaeoverse.org) has now been
  transferred to the Palaeoverse community (new maintainer: William
  Gearty and author: Lewis Jones)
- The package has been updated to work with PhyloPic API ver. \>=2.1.1
- The package has been reworked to its core functionality of fetching
  silhouettes and plotting them in base R and
  [ggplot2](https://ggplot2.tidyverse.org):
  - [`get_uuid()`](https://rphylopic.palaeoverse.org/dev/reference/get_uuid.md):
    this function enables users to get uuid(s) associated with a
    taxonomic name (new function)
  - [`get_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/get_phylopic.md):
    this function enables users to get the PhyloPic silhouette
    associated with a specific uuid (replaces `image_get()`)
  - [`pick_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/pick_phylopic.md):
    this function enables users to pick specific PhyloPic silhouettes
    when multiple are available for a given taxonomic name (new
    function)
  - [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md):
    this function retains it’s core functionality and is used to add a
    silhouette to a base R plot (updated from
    [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md))
  - [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md):
    this function retains it’s core functionality and is used to add a
    silhouette to a [ggplot2](https://ggplot2.tidyverse.org) (updated
    from
    [`add_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic.md))
  - [`get_attribution()`](https://rphylopic.palaeoverse.org/dev/reference/get_attribution.md):
    this function enables users to get the attribution data associated
    with a specific uuid (new function)
  - [`save_phylopic()`](https://rphylopic.palaeoverse.org/dev/reference/save_phylopic.md):
    this function enables users to save PhyloPic silhouettes using
    various formats (replaces `save_png()`)

## rphylopic 0.3.4

#### NEW FEATURES

- New exported function: `gather_images()`
- New internal functions in *zzz.R*:
  - `check_for_a_pkg()`
  - `messager()`
  - `message_parallel()`

## rphylopic 0.3.0

CRAN release: 2020-06-04

#### NEW FEATURES

- PDF cheatsheet and hex sticker added, from
  [@GabsPalomo](https://github.com/GabsPalomo)
  ([\#24](https://github.com/palaeoverse/rphylopic/issues/24))

#### MINOR IMPROVEMENTS

- fix to
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md):
  remove use of [`par()`](https://rdrr.io/r/graphics/par.html)
  internally, better behavior
  ([\#26](https://github.com/palaeoverse/rphylopic/issues/26))
  ([\#28](https://github.com/palaeoverse/rphylopic/issues/28))

#### DEFUNCT

- `plot_phylopic_base()` was removed, see
  [`?add_phylopic_base`](https://rphylopic.palaeoverse.org/dev/reference/add_phylopic_base.md)
  ([\#27](https://github.com/palaeoverse/rphylopic/issues/27))
  ([\#28](https://github.com/palaeoverse/rphylopic/issues/28))

## rphylopic 0.2.0

CRAN release: 2018-11-19

#### NEW FEATURES

- released to CRAN
