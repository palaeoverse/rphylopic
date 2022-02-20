#' Gather 1 valid image per species
#' 
#' There are multiple images per species, and not all image UIDs are valid.
#' This function makes searching for a valid image for each species much easier.
#' Searches for the best name match per \code{species} and 
#' iteratively tries image UIDs until a viable image is found.
#' 
#' Contributed by \href{https://github.com/bschilder}{Brian M. Schilder}.
#' 
#' @param species Species list.
#' @param include_image_data Include the image data itself 
#' (not just the image UID) in the results.
#' @param mc.cores Accelerate multiple species queries by parallelising 
#' across multiple cores.
#' @param verbose Print messages.
#' @inheritParams name
#' @returns data.frame with:
#' \itemize{
#' \item{species : }{Species name.}
#' \item{uid : }{Species UID.}
#' \item{namebankID : }{\href{http://ubio.org/}{uBio} species ID.}
#' \item{string : }{Standardised species name.}
#' \item{picid : }{Image UID.}
#' }
#' @source \href{https://github.com/GuangchuangYu/ggimage/blob/master/R/geom_phylopic.R}{
#' Related function: \code{ggimage::geom_phylopic}}
#' 
#' @export 
#' @examples  
#' species <- c("Mus_musculus","Pan_troglodytes","Homo_sapiens")
#' res <- rphylopic::gather_images(species=species)
gather_images <- function(species,
                          options=c("namebankID","names","string"),
                          include_image_data=FALSE,
                          mc.cores = 1,
                          verbose = TRUE,
                          ...){  
  
  requireNamespace("parallel")
  requireNamespace("data.table")
  string <- NULL;
  
  messager("Gathering phylopic silhouettes.",v=verbose)
  orig_names <- unique(species)
  species <- gsub("-|_|[(]|[)]"," ", orig_names)
  res <- parallel::mclapply(species, function(s){
    if(verbose) message_parallel(s) 
    tryCatch({
      uids <- name_search(text = s,
                          options = options)[[1]]
      uids <- subset(do.call("rbind", uids), string==s)[1,]
      #### Get image info ####
      x <- ubio_get(namebankID = uids$namebankID)
      z <- name_images(x$uid)
      d <- data.frame(uid=unlist(z),
                      name=names(unlist(z)))
      d <- d[seq(nrow(d),1),]
      img <- NA
      picid <- NA
      i <- 1 
      #### Iterate until viable image found ####
      while(is.na(img) & i<=nrow(d)){
        messager("try: ",i,v=verbose)
        picid <- d$uid[[i]]
        img <- tryCatch({
          image_data(d$uid[[i]], size = "512")
        }, error = function(e) NA)
        i <- i + 1
      }  
      if(include_image_data){
        uids$img <- img 
      }
      uids$picid <- picid
      uids
    }, error=function(e) NULL)
  }, mc.cores = mc.cores)  
  #### rbindlist handles this more robustly than rbind #####
  names(res) <- orig_names
  res <- data.table::rbindlist(res, use.names = TRUE,
                               idcol = "input_species",
                               fill = TRUE)
  data.table::setnames(res,"string","species") 
  return(res)
}
