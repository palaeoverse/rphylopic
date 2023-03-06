#' Get PhyloPic attribution data
#'
#' This function provides a convenient way to obtain attribution data
#' for PhyloPic images via an image uuid returned by [get_uuid()].
#'
#' @param uuid \code{character}. A valid uuid for a PhyloPic silhouette such
#'   as that returned by [get_uuid()] or [pick_phylopic()].
#'
#' @return A \code{list} of PhyloPic attribution data for an image `uuid`.
#'
#' @details This function returns image `uuid` specific attribution data,
#'   including: contributor name, contributor uuid, contributor contact,
#'   image uuid and license.
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
  api_return <- phy_GET(file.path("images", uuid),
                        list(embed_contributor = "true"))
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
