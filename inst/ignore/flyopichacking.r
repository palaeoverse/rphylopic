# library(EBImage)
# library(RGraphics)
# x <- readImage("~/Dropbox/CANPOLIN_phenology/data_analyses/bee_phylopic.png")
# g1 <- ebimageGrob(x)
# dev.new(width=g1$width/72, height=g1$height/72)
# grid.draw(g1)
#
# searchres <- search_text(text = "Homo sapiens", options = "names")
# output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
# myobjs <- get_image(uuids = output, size = "128")
# make_phylo(pngobj=myobjs)
#
# img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#
# qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
#
#
# add_phylopic <- function(img, x_min, y_min, x_max, y_max){
#   mat <- matrix(rgb(img[,,1],img[,,2],img[,,3],img[,,4] * 0.2),nrow=dim(img)[1])
# #   annotation_custom(xmin=x_min, ymin=y_min, xmax=x_max, ymax=y_max, rasterGrob(mat))
# }
#
# add_phylopic <- function(img, x_min, y_min, x_max, y_max){
#  5
# }
#
# add_phylopic <- function(img){
#   print(5)
# }
#
# foo = function(x){
#   print(x)
# }
#
#
# isocodes
# isocodes[isocodes$gbif_name %in% 'CÔTE_DIVOIRE',"gbif_name"] <- "COTE_DIVOIRE"
# isocodes[isocodes$gbif_name %in% 'SAINT_BARTHÉLEMY',"gbif_name"] <- "SAINT_BARTHELEMY"
# isocodes[isocodes$gbif_name %in% 'CURAÇAO',"gbif_name"] <- "CURACAO"
# isocodes[isocodes$gbif_name %in% 'RÉUNION',"gbif_name"] <- "REUNION"
# save(isocodes, file="~/github/ropensci/rgbif/data/isocodes.rda")
#
# page_breaks <-
#   list(1:1000, 1001:2000, 2001:3000, 3001:4000, 4001:5000, 5001:6000, 6001:7000, 7001:8000, 8001:8400)
# split(1:8400, 1000)
#
# d <- 1:8400
# split(d, ceiling(seq_along(d)/1000))
#
#
# list1 <- list2 <- list3 <- list4 <- list(1,2)
# var_names <- c("list1","list2","list3","list4")
# sapply(var_names, function(x) eval(parse(text=x)))
#
#
