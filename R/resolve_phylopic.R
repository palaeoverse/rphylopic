#' Resolve a name from another database to an image in the PhyloPic database
#'
#' @param name \code{character}. A full or partial taxonomic name to be matched
#'   to the specified `api`.
#' @param api \code{character}. One of
#' @param hierarchy \code{logical}.
#' @param max_ranks \code{numeric}. The maximum number of taxonomic ranks that
#'   should be included if `hierarchy` is `TRUE`.
#' @inheritParams get_uuid
#'
#' @return If `hierarchy` is `FALSE`, a list of length 1 containing `n` valid
#'   PhyloPic image uuids for the taxonomic node that most closely matches the
#'   supplied `name` as it relates to the specified `api`. If `hierarchy` is
#'   `TRUE`, a list where the names are the the taxonomic hierarchy for `name`
#'   as reported by the specified `api` and the values are `n` resolved PhyloPic
#'   uuids for each taxonomic entity (if they exist).
#'
#' @details
#'
#' @importFrom httr GET POST
#' @importFrom utils URLencode
#' @importFrom stats setNames
#' @export
#' @examples
resolve_phylopic <- function(name, api = "paleobiodb.org", hierarchy = FALSE,
                             max_ranks = 5, n = 1, filter = NULL) {
  # Normalise name -------------------------------------------------------
  name <- tolower(name)
  name <- gsub("_", " ", name)
  name <- URLencode(name)
  # Query specified API for the name
  # TODO: get taxonomic hierarchy if requested
  if (api == "eol.org") {
    # check api is online
    headers <- curlGetHeaders("https://eol.org/api/search/1.0.json")
    if (attr(headers, "status") != 200) {
      stop("Encyclopedia of Life is not available or you have no internet
           connection.")
    }
    namespace <- "pages"
    url <- paste0("https://eol.org/api/search/1.0.json?page=1&q=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$results$id[1]
    if (hierarchy) {
      warning("`hierarchy = TRUE` is not currently available for eol.org.")
      hierarchy <- FALSE
    }
  } else if (api == "gbif.org") {
    # check api is online
    headers <- curlGetHeaders("https://api.gbif.org/v1/")
    if (attr(headers, "status") != 200) {
      stop("Global Biodiversity Information Facility is not available or you
           have no internet connection.")
    }
    namespace <- "species"
    url <- paste0("https://api.gbif.org/v1/species/suggest?",
                  "limit=1&q=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$key
    if (hierarchy) {
      url <- paste0("https://api.gbif.org/v1/species/match?verbose=true&",
                    "name=", URLencode(jsn$canonicalName[1]))
      res <- GET(url = url)
      jsn <- response_to_JSON(res)
      ids <- c(jsn$speciesKey[1], jsn$genusKey[1], jsn$familyKey[1],
               jsn$orderKey[1], jsn$classKey[1], jsn$phylumKey[1],
               jsn$kingdomKey[1])
    }
  } else if (api == "marinespecies.org") {
    # check api is online
    headers <- curlGetHeaders("https://www.marinespecies.org/rest/")
    if (attr(headers, "status") != 200) {
      stop("World Register of Marine Species is not available or you have no
           internet connection.")
    }
    namespace <- "taxname"
    url <- paste0("https://www.marinespecies.org/rest/",
                  "AphiaRecordsByMatchNames?marine_only=false&",
                  "scientificnames%5B%5D=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn[[1]]$AphiaID[1]
    if (hierarchy) {
      url <- paste0("https://www.marinespecies.org/rest/",
                    "AphiaClassificationByAphiaID/", ids)
      res <- GET(url = url)
      jsn <- response_to_JSON(res)
      lst_sub <- jsn
      ids <- character()
      while ("child" %in% names(lst_sub)) {
        ids <- c(ids, lst_sub$AphiaID)
        lst_sub <- lst_sub$child
      }
      ids <- rev(ids)
    }
  } else if (api == "paleobiodb.org") {
    # check api is online
    headers <- curlGetHeaders("https://paleobiodb.org/data1.2/")
    if (attr(headers, "status") != 200) {
      stop("Paleobiology Database is not available or you have no internet
           connection.")
    }
    namespace <- "txn"
    url <- paste0("https://paleobiodb.org/data1.2/taxa/auto.json?",
                  "limit=1&name=", name)
    res <- GET(url = url)
    jsn <- response_to_JSON(res)
    ids <- jsn$records$oid[1]
    if (hierarchy) {
      url <- paste0("https://paleobiodb.org/data1.2/taxa/list.json?",
                    "rel=all_parents&", "id=txn:", ids)
      res <- GET(url = url)
      jsn <- response_to_JSON(res)
      ids <- rev(gsub("txn:", "", jsn$records$oid))
    }
  } else if (api == "opentreeoflife.org") {
    # check api is online
    headers <- curlGetHeaders("https://api.opentreeoflife.org/")
    if (attr(headers, "status") != 200) {
      stop("Open Tree of Life is not available or you have no internet
           connection.")
    }
    namespace <- "taxonomy"
    url <- "https://api.opentreeoflife.org/v3/tnrs/autocomplete_name"
    res <- POST(url = url, encode = "json", body = list("name" = name))
    jsn <- response_to_JSON(res)
    ids <- jsn$ott_id[1]
    if (hierarchy) {
      url <- "https://api.opentreeoflife.org/v3/taxonomy/taxon_info"
      res <- POST(url = url, encode = "json",
                  body = list("include_lineage" = TRUE, "ott_id" = ids))
      jsn <- response_to_JSON(res)
      ids <- c(ids, jsn$lineage$ott_id)
    }
  } else {
    stop("Invalid value for `api`. See the documentation for valid options.")
  }
  # iterate over taxonomic hierarchy, if requested
  ids <- ids[seq_len(min(length(ids), max_ranks))]
  lst <- list()
  for (i in seq_along(ids)) {
    # Resolve to taxonomic name in PhyloPic database
    api_return <- phy_GET(path = paste0("resolve/", api, "/", namespace,
                                        "/", ids[i]))
    # catch any errors here
    if ("errors" %in% names(api_return)) {
      lst[[i]] <- NULL
    } else {
      tax <- api_return$names[[1]]$text[1]
      lst[[tax]] <- get_uuid(tax, n = n, filter = filter)
    }
  }
  if (!hierarchy) return(lst[1]) else return(lst)
}
