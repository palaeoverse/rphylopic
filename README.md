rphylopic
=======

![](http://phylopic.org/assets/images/submissions/bedd622a-4de2-4067-8c70-4aa44326d229.128.png)

## Get silhouettes of organisms from Phylopic.

The idea here is to create modular bits and pieces to allow you to add silhouettes to not only ggplot2 plots, but base plots as well. Some people prefer base plots while others prefer ggplot2 plots (me!), so it wouuld be nice to have both options.

## Important!

I plan to be able to get a phylogeny for taxa associatd with Phylopic silhouettes  using the NCBI taxonomy, but it's not easily available yet (though see [Ben Morris' phylofile](https://github.com/bendmorris/python-phylopic)). The first example below creates a phylogeny using `ape::rcoal`.

## Info
+ Phylopic website: [http://phylopic.org/](http://phylopic.org/)
+ Phylopic dev documentation: [http://phylopic.org/api/](http://phylopic.org/api/)

## Check out the wrapper for Python by Ben Morris [here](https://github.com/bendmorris/python-phylopic)

## Quick start

#### Install
```r
install_github("devtools")
library(devtools)
install_github("sckott/rphylopic")
library(rphylopic)
```

#### A few quick examples

##### Plot a phylogeny with silhouettes at the tips

```r
searchres <- search_text(text = "Homo sapiens", options = "names")
output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
myobjs <- get_image(uuids = output, size = "128")
make_phylo(pngobj=myobjs)
```

![phylo](/inst/assets/img/readme_image.png)


##### Plot a silhouette behind a plot

```r
library(ggplot2)
img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
```

![phylo](/inst/assets/img/img_behind_plot.png)


## Built on the shoulders of

This wouldn't have been possible without the great work of [Hadley Wickham](http://had.co.nz/) building [ggplot2](https://github.com/hadley/ggplot2), and [Greg Jordan](https://github.com/gjuggler) building [ggphylo](https://github.com/gjuggler/ggphylo) on top of `ggplot2`.
