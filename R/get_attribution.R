#' Get PhyloPic attribution data
#'
#' This function provides a convenient way to obtain attribution data
#' for PhyloPic images via an image uuid returned by [get_uuid()].
#' 
#' @param uuid \code{character}. A valid uuid for a PhyloPic silhouette such
#'   as that returned by [get_uuid()] or [pick_phylo()].
#'
#' @return A \code{list} of PhyloPic attribution data for an image `uuid`.
#'
#' @details This function returns image `uuid` specific attribution data,
#'   including: contributor name, contributor uuid, contributor contact,
#'   image uuid and license. 
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' # Get valid uuid
#' uuid <- get_uuid(name = "Acropora cervicornis")
#' # Get attribution data for uuid
#' get_attribution(uuid = uuid)
get_attribution <- function(uuid = NULL) {
  # Error handling -------------------------------------------------------
  if (is.null(uuid)) {
    stop("A `uuid` is required.")
  }
  if (!is.character(uuid)) {
    stop("`uuid` should be of class character.")
  }
  # API call -------------------------------------------------------------
  base <- "https://api.phylopic.org/images/"
  # Get build
  build <- GET(url = "https://api.phylopic.org/")
  build <- content(build, as = "text", encoding = "UTF-8")
  build <- fromJSON(build)$build
  build <- paste0("?build=", build)
  embed <- paste0("&embed_contributor=true")
  # Request
  request <- paste0(base, uuid, build, embed)
  api_return <- GET(url = request)
  api_return <- content(api_return, as = "text", encoding = "UTF-8")
  api_return <- fromJSON(api_return)
  # Process output -------------------------------------------------------
  att <- list(contributor = api_return$`_embedded`$contributor$name, 
              contributor_uuid = api_return$`_embedded`$contributor$uuid, 
              created = substr(x = api_return$`_embedded`$contributor$created,
                               start = 1,
                               stop = 10),
              contact = gsub(
                "mailto:", "",
                api_return$`_embedded`$contributor$`_links`$contact), 
              image_uuid = uuid,
              license = api_return$`_links`$license$href)
  # Return data ----------------------------------------------------------
  return(att)
}
