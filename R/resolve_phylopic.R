#' Resolve a name from another database to an image in the PhyloPic database
#'
#' @param name \code{character}. A full or partial taxonomic name to be matched
#'   to the specified `api`.
#' @param api \code{character}. One of 
#' @param hierarchy \code{logical}.
#' @inheritParams get_uuid
#'
#' @return If `hierarchy` is `FALSE`, `n` valid PhyloPic image uuids for the
#'   taxonomic node that most closely matches the supplied `name` as it relates
#'   to the specified `api`. If `hierarchy` is `TRUE`, a list where the names
#'   are the the taxonomic hierarchy for `name` as reported by the specified
#'   `api` and the values are `n` resolved PhyloPic uuids for each taxonomic
#'   entity (if they exist).
#'
#' @details
#'
#' @importFrom httr GET POST
#' @importFrom utils URLencode
#' @importFrom stats setNames
#' @export
#' @examples
resolve_phylopic <- function(name, api = "paleobiodb.org", hierarchy = FALSE,
                             n = 1, filter = NULL) {
  # Normalise name -------------------------------------------------------
  name <- tolower(name)
  name <- gsub("_", " ", name)
  name <- URLencode(name)
  # Query specified API for the name
  # TODO: get taxonomic hierarchy if requested
  if (api == "eol.org") {
    namespace <- "pages"
    url <- paste0("https://eol.org/api/search/1.0.json?page=1&",
                  "q=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$results$id[1]
  } else if (api == "gbif.org") {
    namespace <- "species"
    url <- paste0("https://api.gbif.org/v1/species/suggest?",
                  "limit=1&q=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$key
  } else if (api == "marinespecies.org") {
    namespace <- "taxname"
    url <- paste0("https://www.marinespecies.org/rest/",
                  "AphiaRecordsByMatchNames?marine_only=false&",
                  "scientificnames%5B%5D=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn[[1]]$AphiaID[1]
  } else if (api == "paleobiodb.org") {
    namespace <- "txn"
    url <- paste0("https://paleobiodb.org/data1.2/taxa/auto.json?",
                  "limit=1&name=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$records$oid[1]
  } else if (api == "opentreeoflife.org") {
    namespace <- "taxonomy"
    url <- paste0("https://api.opentreeoflife.org/v3/tnrs/autocomplete_name")
    res <- POST(url = url, encode = "json", body = list("name" = name))
    jsn <- response_to_JSON(res)
    ids <- jsn$ott_id[1]
  } else {
    stop("Invalid value for `api`. See the documentation for valid options.")
  }
  # lapply over taxonomic hierarchy, if requested
  # Resolve to taxonomic name in PhyloPic database
  api_return <- phy_GET(path = paste0("resolve/", api, "/", namespace),
                        query = list("objectIDs" = ids,
                                     "embed_primaryImage" = "true"))
  # catch any errors here
  tax <- api_return$names[[1]]$text[1]
  setNames(get_uuid(tax, n = n, filter = filter),
           tax)
}
