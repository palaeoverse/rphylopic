#Vignettes that depend on internet access have been precompiled:
old_wd <- getwd()

setwd("vignettes/")

library(knitr)
knit("a-getting-started.Rmd.orig",
     "a-getting-started.Rmd")
knit("b-advanced-ggplot.Rmd.orig",
     "b-advanced-ggplot.Rmd")
knit("c-advanced-base.Rmd.orig",
     "c-advanced-base.Rmd")

library(devtools)
build_vignettes()

setwd(old_wd)
