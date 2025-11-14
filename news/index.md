# Changelog

## rphylopic (development version)

- Added add_phylopic_tree() to add silhouettes to plotted trees
  ([\#110](https://github.com/palaeoverse/rphylopic/issues/110))
- Fixed a bug in add_phylopic_base() where all names were reported as
  not returning PhyloPic results when only a single name actually
  returned no PhyloPic results
- resolve_phylopic() now will retry API calls if they fail
- Fixed geom_phylopic() and add_phylopic() under ggplot2 4.0.0 and up
  ([\#125](https://github.com/palaeoverse/rphylopic/issues/125))

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

- Added add_phylopic_legend
  ([\#83](https://github.com/palaeoverse/rphylopic/issues/83))
- Added permalink generation option to get_attribution
  ([\#81](https://github.com/palaeoverse/rphylopic/issues/81))

## rphylopic 1.3.0

CRAN release: 2023-12-20

- updated citation
- added warning when specified size is more than 1000 times smaller than
  the y-axis range (mostly useful for when making maps with coord_sf)
  ([\#86](https://github.com/palaeoverse/rphylopic/issues/86))
- changed the defaults and behavior of the color and fill
  argument/aesthetics to better maintain backwards compatibility but
  also prevent unnecessary outlines
  ([\#87](https://github.com/palaeoverse/rphylopic/issues/87))
- added resolve_phylopic
  ([\#66](https://github.com/palaeoverse/rphylopic/issues/66))
- pick_phylopic now accepts a list of uuids via the uuid argument
  ([\#95](https://github.com/palaeoverse/rphylopic/issues/95))
- fixed check behavior on CRAN (all tests and examples are now skipped)
- caught a rare error when nothing matched `filter`

## rphylopic 1.2.2

CRAN release: 2023-10-28

- vignettes are now precompiled

## rphylopic 1.2.1

CRAN release: 2023-10-10

- updated rphylopic to work with grImport2 version 0.3.0 and rsvg
  version 2.6.0
- rphylopic now requires grImport2 \>= 0.3.0 and rsvg \>= 2.6.0

## rphylopic 1.2.0

CRAN release: 2023-08-29

- added text argument to get_attribution
  ([\#56](https://github.com/palaeoverse/rphylopic/issues/56))
- get_attribution now handles multiple uuids
- added browse_phylopic function
  ([\#60](https://github.com/palaeoverse/rphylopic/issues/60))
- added preview argument to get_phylopic
  ([\#59](https://github.com/palaeoverse/rphylopic/issues/59))
- switched to {maps} package in base R advanced vignette
- geom_phylopic now properly handles a single unlisted image object
  passed to the “img” parameter
  ([\#75](https://github.com/palaeoverse/rphylopic/issues/75))
- added filter (license) argument to get_uuid, pick_phylo,
  add_phylopic_base, add_phylopic, and geom_phylopic
  ([\#72](https://github.com/palaeoverse/rphylopic/issues/72))
- added img argument to get_uuid and get_attribution
- added verbose argument (calls get_attribution) to geom_phylopic,
  add_phylopic, and add_phylopic_base
  ([\#71](https://github.com/palaeoverse/rphylopic/issues/71))
- split out the functionality of the color argument/aesthetic to color
  (silhouette outline) and fill (silhouette) arguments/aesthetics in
  add_phylopic, geom_phylopic, and add_phylopic_base
  ([\#58](https://github.com/palaeoverse/rphylopic/issues/58))
  - when only the color argument/aesthetic is specified, it is copied to
    the fill argument/aesthetic (maintaining mostly backwards
    compatibility with old code)
- added plot and print methods for silhouette objects
  ([\#73](https://github.com/palaeoverse/rphylopic/issues/73))
- fixed the behavior of geom_phylopic when used with coord_sf
- added phylopic_key_glyph for using silhouettes inside ggplot legends
  ([\#57](https://github.com/palaeoverse/rphylopic/issues/57))

## rphylopic 1.1.1

CRAN release: 2023-07-08

- Minor fixes for Fedora
- Better handling of malformed Picture objects

## rphylopic 1.1.0

CRAN release: 2023-06-30

- added functions for transforming PhyloPic silhouettes (flipping and
  rotating)
- save_phylopic bg argument updated to be “transparent” by default
- added geom_phylopic
  ([\#25](https://github.com/palaeoverse/rphylopic/issues/25))
- vectorized add_phylopic and add_phylopic_base
  ([\#42](https://github.com/palaeoverse/rphylopic/issues/42))
- recolor_phylopic now removes white backgrounds by default
- fixed the handling of alpha values
- get_phylopic can now return any size raster image
  ([\#50](https://github.com/palaeoverse/rphylopic/issues/50))
- removed the “thumbnail” and “twitter” format options for get_phylopic
- fixed how silhouettes are gathered from PhyloPic
  ([\#51](https://github.com/palaeoverse/rphylopic/issues/51))
- pick_phylopic updated to allow visualization of multiple silhouettes
  at once ([\#43](https://github.com/palaeoverse/rphylopic/issues/43))
- fixed add_phylopic_base for multi-panel figures
- added three vignettes
  ([\#49](https://github.com/palaeoverse/rphylopic/issues/49),
  [\#55](https://github.com/palaeoverse/rphylopic/issues/55))

## rphylopic 1.0.0

CRAN release: 2023-03-20

- rphylopic has now been transferred to the Palaeoverse community (new
  maintainer: William Gearty and author: Lewis Jones)
- The package has been updated to work with PhyloPic API ver. \>=2.1.1
- The package has been reworked to its core functionality of fetching
  silhouettes and plotting them in base R and ggplot2:
  - get_uuid: this function enables users to get uuid(s) associated with
    a taxonomic name (new function)
  - get_phylopic: this function enables users to get the PhyloPic
    silhouette associated with a specific uuid (replaces image_get)
  - pick_phylopic: this function enables users to pick specific PhyloPic
    silhouettes when multiple are available for a given taxonomic name
    (new function)
  - add_phylopic_base: this function retains it’s core functionality and
    is used to add a silhouette to a base R plot (updated from
    add_phylopic_base)
  - add_phylopic: this function retains it’s core functionality and is
    used to add a silhouette to a ggplot2 (updated from add_phylopic)
  - get_attribution: this function enables users to get the attribution
    data associated with a specific uuid (new function)
  - save_phylopic: this function enables users to save PhyloPic
    silhouettes using various formats (replaces save_png)

## rphylopic 0.3.4

#### NEW FEATURES

- New exported function: `gather_images`
- New internal functions in *zzz.R*:
  - `check_for_a_pkg`
  - `messager`
  - `message_parallel`

## rphylopic 0.3.0

CRAN release: 2020-06-04

#### NEW FEATURES

- PDF cheatsheet and hex sticker added, from
  [@GabsPalomo](https://github.com/GabsPalomo)
  ([\#24](https://github.com/palaeoverse/rphylopic/issues/24))

#### MINOR IMPROVEMENTS

- fix to
  [`add_phylopic_base()`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md):
  remove use of [`par()`](https://rdrr.io/r/graphics/par.html)
  internally, better behavior
  ([\#26](https://github.com/palaeoverse/rphylopic/issues/26))
  ([\#28](https://github.com/palaeoverse/rphylopic/issues/28))

#### DEFUNCT

- `plot_phylopic_base()` was removed, see
  [`?add_phylopic_base`](https://rphylopic.palaeoverse.org/reference/add_phylopic_base.md)
  ([\#27](https://github.com/palaeoverse/rphylopic/issues/27))
  ([\#28](https://github.com/palaeoverse/rphylopic/issues/28))

## rphylopic 0.2.0

CRAN release: 2018-11-19

#### NEW FEATURES

- released to CRAN
