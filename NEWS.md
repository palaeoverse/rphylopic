# rphylopic (development version)

* updated citation
* added warning when specified size is more than 1000 times smaller than the y-axis range (mostly useful for when making maps with coord_sf) (#86)
* changed the defaults and behavior of the color and fill argument/aesthetics to better maintain backwards compatibility but also prevent unnecessary outlines (#87)
* added resolve_phylopic (#66)
* pick_phylopic now accepts a list of uuids via the uuid argument (#95)

# rphylopic 1.2.2

* vignettes are now precompiled

# rphylopic 1.2.1

* updated rphylopic to work with grImport2 version 0.3.0 and rsvg version 2.6.0
* rphylopic now requires grImport2 >= 0.3.0 and rsvg >= 2.6.0

# rphylopic 1.2.0

* added text argument to get_attribution (#56)
* get_attribution now handles multiple uuids
* added browse_phylopic function (#60)
* added preview argument to get_phylopic (#59)
* switched to {maps} package in base R advanced vignette
* geom_phylopic now properly handles a single unlisted image object passed to the "img" parameter (#75)
* added filter (license) argument to get_uuid, pick_phylo, add_phylopic_base, add_phylopic, and geom_phylopic (#72)
* added img argument to get_uuid and get_attribution
* added verbose argument (calls get_attribution) to geom_phylopic, add_phylopic, and add_phylopic_base (#71)
* split out the functionality of the color argument/aesthetic to color (silhouette outline) and fill (silhouette) arguments/aesthetics in add_phylopic, geom_phylopic, and add_phylopic_base (#58)
  * when only the color argument/aesthetic is specified, it is copied to the fill argument/aesthetic (maintaining mostly backwards compatibility with old code)
* added plot and print methods for silhouette objects (#73)
* fixed the behavior of geom_phylopic when used with coord_sf
* added phylopic_key_glyph for using silhouettes inside ggplot legends (#57)

# rphylopic 1.1.1

* Minor fixes for Fedora
* Better handling of malformed Picture objects

# rphylopic 1.1.0

* added functions for transforming PhyloPic silhouettes (flipping and rotating)
* save_phylopic bg argument updated to be "transparent" by default
* added geom_phylopic (#25)
* vectorized add_phylopic and add_phylopic_base (#42)
* recolor_phylopic now removes white backgrounds by default
* fixed the handling of alpha values
* get_phylopic can now return any size raster image (#50)
* removed the "thumbnail" and "twitter" format options for get_phylopic
* fixed how silhouettes are gathered from PhyloPic (#51)
* pick_phylopic updated to allow visualization of multiple silhouettes at once (#43)
* fixed add_phylopic_base for multi-panel figures
* added three vignettes (#49, #55)

# rphylopic 1.0.0

* rphylopic has now been transferred to the Palaeoverse community (new maintainer: William Gearty and author: Lewis Jones)
* The package has been updated to work with PhyloPic API ver. >=2.1.1
* The package has been reworked to its core functionality of fetching silhouettes and plotting them in base R and ggplot2:
  * get_uuid: this function enables users to get uuid(s) associated with a taxonomic name (new function)
  * get_phylopic: this function enables users to get the PhyloPic silhouette associated with a specific uuid (replaces image_get)
  * pick_phylopic: this function enables users to pick specific PhyloPic silhouettes when multiple are available for a given taxonomic name (new function)
  * add_phylopic_base: this function retains it's core functionality and is used to add a silhouette to a base R plot (updated from add_phylopic_base)
  * add_phylopic: this function retains it's core functionality and is used to add a silhouette to a ggplot2 (updated from add_phylopic)
  * get_attribution: this function enables users to get the attribution data associated with a specific uuid (new function)
  * save_phylopic: this function enables users to save PhyloPic silhouettes using various formats (replaces save_png)
  

# rphylopic 0.3.4

### NEW FEATURES

* New exported function: `gather_images` 
* New internal functions in *zzz.R*: 
  + `check_for_a_pkg`
  + `messager`
  + `message_parallel` 

# rphylopic 0.3.0

### NEW FEATURES

* PDF cheatsheet and hex sticker added, from @GabsPalomo (#24)

### MINOR IMPROVEMENTS

* fix to `add_phylopic_base()`: remove use of `par()` internally, better behavior (#26) (#28)

### DEFUNCT

* `plot_phylopic_base()` was removed, see `?add_phylopic_base` (#27) (#28)


# rphylopic 0.2.0

### NEW FEATURES

* released to CRAN
