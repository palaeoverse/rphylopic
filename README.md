fylopic
=======

## Get silhouettes of organisms from Phylopic.

## Important!

I plan to be able to get a phylogeny using the NCBI taxonomy, but it's not easily available yet. The example below just creates a random phylogeny using `ape::rcoal`.

## Info
+ Phylopic website: [http://phylopic.org/](http://phylopic.org/)
+ Phylopic dev documentation: [http://phylopic.org/api/](http://phylopic.org/api/)

## Quick start

##### Install
```r
install_github("devtools")
library(devtools)
install_github("fylopic", "schamberlain")
library(fylopic)
```

##### A quick example 
```r
searchres <- search_text(text = "Homo sapiens", options = "names")
output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
myobjs <- get_image(uuids = output, size = "128") 
make_phylo(pngobj=myobjs)
```

![phylo](/inst/assets/img/readme_image.png)