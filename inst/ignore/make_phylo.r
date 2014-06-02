#' Make phylogeny with Phylopic images
#'
#' @import ggplot2 ggphylo ape adephylo grid
#' @param pngobj Object from get_image function
#' @param phytheme The ggplot2 style layout. You can write your own theme and pass
#'    it in to the function. See example below.
#' @examples \dontrun{
#' toget <- c("27356f15-3cf8-47e8-ab41-71c6260b2724", "bd88f674-6976-4cb2-a46e-e6a12a8ba463", "e547cd01-7dd1-495b-8239-52cf9971a609", "9c6af553-390c-4bdd-baeb-6992cbc540b1", "e547cd01-7dd1-495b-8239-52cf9971a609", "bd88f674-6976-4cb2-a46e-e6a12a8ba463")
#' myobjs <- get_image(uuids = toget, size = "thumb")
#' make_phylo(pngobj=myobjs)
#'
#' # Settingn phytheme to NULL uses ggphylo's default theme
#' make_phylo(pngobj=myobjs, phytheme=NULL)
#'
#' # Make your own theme
#' mytheme <- theme_phylo_blank2() + ggplot2::theme(panel.background=element_rect(fill="lightblue"))
#' make_phylo(pngobj=myobjs, phytheme=mytheme)
#'
#' # The use case starting from a text search
#' searchres <- search_text(text = "Homo sapiens", options = "names")
#' output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
#' myobjs <- get_image(uuids = output, size = "128")
#' make_phylo(pngobj=myobjs)
#' }
#' @export
make_phylo <- function(pngobj, phytheme = theme_phylo_blank2())
{
  imgtoplot <- lapply(pngobj, function(y) matrix(rgb(y[,,1], y[,,2], y[,,3], y[,,4] * 0.2), nrow = dim(y)[1]))
  tree <- rcoal(n=length(pngobj))
  roottotip <- distRoot(x=tree, tips=1)[[1]]
  ggannlist <- list()
  for(i in seq_along(imgtoplot)){
    ggannlist[[i]] <- annotation_custom(xmin=roottotip+(roottotip * 0.1), xmax=roottotip+(roottotip * 0.18), ymin=i-0.3, ymax=i+0.3, rasterGrob(imgtoplot[[i]]))
  }

  return(
    ggphylo(tree, label.size = 0, node.size = 0) +
    ggannlist +
    phytheme
  )
}
