#' Make phylogeny with Phylopic images
#'
#' @import ggplot2 ape adephylo
#' @param input Object from get_image function
#' @param phytheme The ggplot2 style layout. You can write your own theme and pass
#'    it in to the function. See example below.
#' @examples \dontrun{
#' # Attach taxon names to the figure
#' make_phylo_names(query="Homo sapiens", size="128", usenames=TRUE)
#' }
#' @export
make_phylo_names <- function(query, size = size, phytheme = theme_phylo_blank2(), usenames = FALSE)
{
  message("not quite working yet, will make a phylogeny, and attach names")
#   message("Searching for your query...")
#   searchres <- search_text(text = query, options = "names")
#
#   message("Searching for images that match your query...")
#   output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
#
#   message("Retrieving images...")
#   myobjs <- get_image(uuids = output, size = size)
#
#   message("Creating plot...")
#   imgtoplot <- lapply(myobjs, function(y) matrix(rgb(y[,,1], y[,,2], y[,,3], y[,,4] * 0.2), nrow = dim(y)[1]))
#   tree <- rcoal(n=length(myobjs))
#
#   if(usenames)
#     taxonnames <- ldply(unnest(output)$all, get_names, options = "string")$name
#     tree$tip.label <- as.character(taxonnames)
#
#   roottotip <- distRoot(x=tree, tips=1)[[1]]
#   ggannlist <- list()
#   for(i in seq_along(imgtoplot)){
#     ggannlist[[i]] <- annotation_custom(xmin=roottotip+(roottotip * 0.1), xmax=roottotip+(roottotip * 0.18), ymin=i-0.3, ymax=i+0.3, rasterGrob(imgtoplot[[i]]))
#   }
#
#   message("...done")
#   return(
#     ggphylo(tree, label.size = 0, node.size = 0) +
#       ggannlist +
#       phytheme
#   )
}
