fylopic
=======

## Get silhouettes of organisms from Phylopic.

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

```r
toget <- c("27356f15-3cf8-47e8-ab41-71c6260b2724", "bd88f674-6976-4cb2-a46e-e6a12a8ba463", "e547cd01-7dd1-495b-8239-52cf9971a609", "9c6af553-390c-4bdd-baeb-6992cbc540b1", "e547cd01-7dd1-495b-8239-52cf9971a609", "bd88f674-6976-4cb2-a46e-e6a12a8ba463")
myobjs <- get_image(uuids = toget, size = "thumb") 
make_phylo(pngobj=myobjs)
```

![phylo](/inst/assets/img/readme_image.png)