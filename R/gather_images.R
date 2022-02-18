#' Gather 1 image per species
#' 
#' There are multiple images per species, and not all pciture UIDs are valid.
#' This function makes searching for a valid image for each species much easier.
#' Searches for the best name match per \code{species} and 
#' iteratively tries image UIDs until a viable PNG is found.
#' 
#' @param species Species list.
#' @inheritParams name
#' 
#' @export 
#' @examples  
#' species <- c("Mus_musculus","Pan_troglodytes","Homo_sapiens")
#' res <- gather_images(species=species)
gather_images <- function(species,
                          options=c("namebankID","names","string"),
                          include_image_data=FALSE,
                          ...){ 
  orig_names <- unique(species)
  species <- gsub("-|_|[(]|[)]"," ", orig_names)
  res <- lapply(species, function(s){
    message(s)
    tryCatch({
      uids <- name_search(text = s,
                          options = options)[[1]]
      uids <- subset(do.call("rbind", uids), string==s)[1,]
      #### Get image info ####
      x <- ubio_get(namebankID = uids$namebankID)
      z <- name_images(x$uid)
      d <- data.frame(uid=unlist(z),
                      name=names(unlist(z)))
      d <- d[nrow(d):1,]
      img <- NA
      picid <- NA
      i <- 1 
      #### Iterate until viable image found ####
      while(is.na(img) & i<=nrow(d)){
        message("try: ",i)
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
  })  
  res <- cbind(species=orig_names, 
               do.call("rbind",res))
  return(res)
}
