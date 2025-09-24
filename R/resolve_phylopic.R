#' Use a taxonomic name from another database to get a PhyloPic image UUID
#'
#' This function takes a supplied taxonomic name, queries it via the specified
#' external API, resolves the API's returned taxonomic ID to the PhyloPic
#' taxonomic node database, then retrieves PhyloPic image uuids (or urls) for
#' that node.
#'
#' @param name \code{character}. A full or partial taxonomic name to be queried
#'   via the specified `api`.
#' @param api \code{character}. The API in which to query `name`. See Details
#'   for the available options.
#' @param hierarchy \code{logical}. Whether the taxonomic hierarchy of `name`
#'   should be retrieved from the API and used to get several sets of PhyloPic
#'   image uuids (or urls).
#' @param max_ranks \code{numeric}. The maximum number of taxonomic ranks that
#'   should be included if `hierarchy` is `TRUE`.
#' @inheritParams get_uuid
#'
#' @return A `list` where each value is `n` (or fewer) PhyloPic image uuids (or
#'   urls if `url = TRUE`) and each name is the taxonomic name as matched and
#'   reported by the specified `api`. If `hierarchy` is `FALSE`, the list has
#'   length 1. If `hierarchy` is `TRUE`, the list has maximum length
#'   `max_ranks`.
#'
#' @details If `hierarchy` is `FALSE`, the specified `name` is queried via the
#'   specified `api`. The matched id is then resolved to the matching taxonomic
#'   node in the PhyloPic database. If `hierarchy` is `TRUE`, the full taxonomic
#'   hierarchy for `name` is retrieved from the specified `api`, those taxonomic
#'   names are subset to `max_ranks` ranks (starting from the specified `name`
#'   and ascending the hierarchy). Then each of those names is resolved to the
#'   matching taxonomic node in the PhyloPic database (where possible). In
#'   either case, [get_uuid()] is then used to retrieve `n` image UUID(s) for
#'   each taxonomic name.
#'
#'   Note that while the names of the returned list are the taxonomic names as
#'   reported by the specified `api`, the PhyloPic images that are returned are
#'   associated with whatever taxonomic node that taxonomic name resolves to in
#'   the PhyloPic database. This means that, if `hierarchy` is `TRUE`, the same
#'   images may be returned for multiple taxonomic names. Also, if a particular
#'   taxonomic name does not resolve to any node in the PhyloPic database, no
#'   images will be returned for that name.
#'
#'   The following APIs are available for querying (`api`):
#'   \itemize{
#'     \item{"eol.org": the \href{https://eol.org/}{Encyclopedia of Life}}
#'     (note: `hierarchy = TRUE` is not currently available for this API) ("eol"
#'     is also allowed)
#'     \item{"gbif.org": the \href{https://www.gbif.org/}{Global Biodiversity
#'     Information Facility}} ("gbif" is also allowed)
#'     \item{"marinespecies.org": the \href{https://marinespecies.org/}{World
#'     Registor of Marine Species}} ("worms" is also allowed)
#'     \item{"opentreeoflife.org": the \href{https://tree.opentreeoflife.org/}{
#'     Open Tree of Life}} ("otol" is also allowed)
#'     \item{"paleobiodb.org": the \href{https://paleobiodb.org/#/}{Paleobiology
#'     Database}} ("pbdb" is also allowed)
#'   }
#'
#' @importFrom httpcache POST
#' @importFrom utils URLencode URLdecode
#' @importFrom stats setNames
#' @export
#' @examples \dontrun{
#' # get a uuid for a single name
#' resolve_phylopic(name = "Canis lupus")
#' # get uuids for the taxonomic hierarchy
#' resolve_phylopic(name = "Velociraptor mongoliensis", api = "paleobiodb.org",
#'                  hierarchy = TRUE, max_ranks = 3)
#' }
resolve_phylopic <- function(name, api = "gbif.org", hierarchy = FALSE,
                             max_ranks = 5, n = 1, filter = NULL, url = FALSE) {
  url_arg <- url
  # replace api abbreviations
  abbrvs <- setNames(c("eol.org", "gbif.org", "marinespecies.org",
                       "opentreeoflife.org", "paleobiodb.org"),
                     c("eol", "gbif", "worms", "otol", "pbdb"))
  if (api %in% names(abbrvs)) api <- abbrvs[[api]]
  # Check arguments ------------------------------------------------------
  api <- match.arg(api, unname(abbrvs))
  if (!is.character(name)) {
    stop("`name` should be of class character.")
  }
  if (!is.character(api)) {
    stop("`api` should be of class character.")
  }
  if (!is.logical(hierarchy)) {
    stop("`hierarchy` should be of class logical.")
  }
  if (!is.numeric(max_ranks)) {
    stop("`max_ranks` should be of class numeric.")
  }
  # Normalize name -------------------------------------------------------
  name <- tolower(name)
  name <- gsub("_", " ", name)
  name_encode <- URLencode(name)
  # Query specified API for the name -------------------------------------
  if (api == "eol.org") {
    check_url("https://eol.org/api/search/1.0.json")
    namespace <- "pages"
    url <- paste0("https://eol.org/api/search/1.0.json?page=1&q=", name_encode)
    jsn <- json_GET(url)
    # EOL appears to return lots of subspecies, so check if any match `name`
    # first, otherwise, return the first result
    if (jsn$totalResults == 0) stop("No results returned from the API.")
    matches <- which(tolower(jsn$results$title) == name)
    ind <- ifelse(any(matches), matches[1], 1)
    ids <- jsn$results$id[ind]
    name_vec <- jsn$results$title[ind]
    if (hierarchy) {
      warning("`hierarchy = TRUE` is not currently available for eol.org.")
      hierarchy <- FALSE
    }
  } else if (api == "gbif.org") {
    check_url("https://api.gbif.org/v1/")
    namespace <- "species"
    url <- paste0("https://api.gbif.org/v1/species/suggest?",
                  "limit=1&q=", name_encode)
    jsn <- json_GET(url)
    if (length(jsn) == 0) stop("No results returned from the API.")
    ids <- jsn$key
    name_vec <- jsn$canonicalName
    if (hierarchy) {
      url <- paste0("https://api.gbif.org/v1/species/match?verbose=true&",
                    "name=", URLencode(jsn$canonicalName[1]))
      jsn <- json_GET(url)
      ids <- c(jsn$speciesKey[1], jsn$genusKey[1], jsn$familyKey[1],
               jsn$orderKey[1], jsn$classKey[1], jsn$phylumKey[1],
               jsn$kingdomKey[1])
      name_vec <- c(jsn$species[1], jsn$genus[1], jsn$family[1],
                    jsn$order[1], jsn$class[1], jsn$phylum[1],
                    jsn$kingdom[1])
    }
  } else if (api == "marinespecies.org") {
    check_url("https://www.marinespecies.org/rest/")
    namespace <- "taxname"
    url <- paste0("https://www.marinespecies.org/rest/",
                  "AphiaRecordsByMatchNames?marine_only=false&",
                  "scientificnames%5B%5D=", name_encode)
    jsn <- json_GET(url)
    ids <- jsn[[1]]$AphiaID[1]
    name_vec <- jsn[[1]]$scientificname[1]
    if (hierarchy) {
      url <- paste0("https://www.marinespecies.org/rest/",
                    "AphiaClassificationByAphiaID/", ids)
      jsn <- json_GET(url)
      lst_sub <- jsn
      ids <- character()
      name_vec <- character()
      while ("child" %in% names(lst_sub)) {
        ids <- c(ids, lst_sub$AphiaID)
        name_vec <- c(name_vec, lst_sub$scientificname)
        lst_sub <- lst_sub$child
      }
      ids <- rev(ids)
      name_vec <- rev(name_vec)
    }
  } else if (api == "paleobiodb.org") {
    check_url("https://paleobiodb.org/data1.2/")
    namespace <- "txn"
    url <- paste0("https://paleobiodb.org/data1.2/taxa/auto.json?",
                  "limit=10&name=", name_encode)
    jsn <- json_GET(url)
    if ("errors" %in% jsn || length(jsn$records) == 0)
      stop("No results returned from the API.")
    # sometimes returns higher taxonomic ranks first even when there is a
    # perfect match, so check if any match `name`, otherwise, return the first
    # result
    matches <- which(tolower(jsn$records$nam) == name)
    ind <- ifelse(any(matches), matches[1], 1)
    ids <- jsn$records$oid[ind]
    name_vec <- jsn$records$nam[ind]
    if (hierarchy) {
      url <- paste0("https://paleobiodb.org/data1.2/taxa/list.json?",
                    "rel=all_parents&", "id=txn:", ids)
      jsn <- json_GET(url)
      ids <- rev(gsub("txn:", "", jsn$records$oid))
      name_vec <- rev(jsn$records$nam)
    }
  } else if (api == "opentreeoflife.org") {
    check_url("https://api.opentreeoflife.org/")
    namespace <- "taxonomy"
    url <- "https://api.opentreeoflife.org/v3/tnrs/autocomplete_name"
    res <- httpcache::POST(url = url, encode = "json",
                           body = list("name" = name))
    jsn <- response_to_JSON(res)
    if (length(jsn) == 0) stop("No results returned from the API.")
    ids <- jsn$ott_id[1]
    name_vec <- jsn$unique_name[1]
    if (hierarchy) {
      url <- "https://api.opentreeoflife.org/v3/taxonomy/taxon_info"
      res <- httpcache::POST(url = url, encode = "json",
                             body = list("include_lineage" = TRUE,
                                         "ott_id" = ids))
      jsn <- response_to_JSON(res)
      ids <- c(ids, jsn$lineage$ott_id)
      name_vec <- c(name_vec, jsn$lineage$unique_name)
    }
  }
  # subset ids if more than max_ranks
  ids <- ids[seq_len(min(length(ids), max_ranks))]
  # Resolve to PhyloPic and get images -----------------------------------
  lst <- list()
  for (i in seq_along(ids)) {
    api_return <- phy_GET(path = paste0("resolve/", api, "/", namespace, "/",
                                        ids[i]))
    # catch any errors here
    if ("errors" %in% names(api_return)) {
      lst[[name_vec[i]]] <- character()
    } else {
      tax <- api_return$names[[1]]$text[1]
      lst[[name_vec[i]]] <- get_uuid(tax, n = n, filter = filter, url = url_arg)
    }
  }
  return(lst)
}

# check that a particular URL (e.g., for an API) is online
check_url <- function(url) {
  tryCatch(headers <- curlGetHeaders(url), error = function(e) e)
  if (attr(headers, "status") != 200) {
    stop("API is not available. Error status: ", attr(headers, "status"), ".")
  }
}

#' @importFrom httpcache GET
json_GET <- function(url) {
  res <- httpcache::GET(url = url)
  if (length(res$content) == 0) stop("No results returned from the API.")
  response_to_JSON(res)
}
