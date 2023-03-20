rphylopic 1.0.0
==============

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
  

rphylopic 0.3.4
==============

### NEW FEATURES

* New exported function: `gather_images` 
* New internal functions in *zzz.R*: 
  + `check_for_a_pkg`
  + `messager`
  + `message_parallel` 

rphylopic 0.3.0
===============

### NEW FEATURES

* PDF cheatsheet and hex sticker added, from @GabsPalomo (#24)

### MINOR IMPROVEMENTS

* fix to `add_phylopic_base()`: remove use of `par()` internally, better behavior (#26) (#28)

### DEFUNCT

* `plot_phylopic_base()` was removed, see `?add_phylopic_base` (#27) (#28)


rphylopic 0.2.0
===============

### NEW FEATURES

* released to CRAN
