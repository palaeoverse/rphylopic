#' Get PhyloPic attribution data
#'
#' This function provides a convenient way to obtain attribution data
#' for PhyloPic images via an image uuid returned by [get_uuid()].
#'
#' @param uuid \code{character}. A vector of valid uuid(s) for PhyloPic 
#'   silhouette(s) such as that returned by [get_uuid()] or [pick_phylopic()].
#' @param img A [Picture][grImport2::Picture-class] or png array object from 
#'   [get_phylopic()]. A list of these objects can also be supplied. If `img`
#'   is supplied, `uuid` is ignored. Defaults to NULL.
#' @param text \code{logical}. Should attribution information be returned as 
#' a text paragraph? Defaults to `FALSE`.
#'
#' @return A \code{list} of PhyloPic attribution data for an image `uuid` or
#' a text output of relevant attribution information.
#'
#' @details This function returns image `uuid` specific attribution data,
#'   including: contributor name, contributor uuid, contributor contact,
#'   image uuid, license, and license abbreviation. If `text` is set to
#'   `TRUE`, a text paragraph with the contributor name, year of contribution,
#'    and license type is returned.
#' @importFrom knitr combine_words
#' @export
#' @examples
#' # Get valid uuid
#' uuid <- get_uuid(name = "Acropora cervicornis")
#' # Get attribution data for uuid
#' attri <- get_attribution(uuid = uuid)
#' # Get list of valid uuids
#' uuids <- get_uuid(name = "Scleractinia", n = 5)
#' # Get attribution data for uuids
#' get_attribution(uuid = uuids, text = TRUE)
get_attribution <- function(uuid = NULL, img = NULL, text = FALSE) {
  # Handle img -----------------------------------------------------------
  if (!is.null(img)) {
    if (is.list(img)) {
      uuid <- sapply(img, function(x) attr(x, "uuid"))
    } else {
      uuid <- attr(img, "uuid")
    }
    if (any(is.null(uuid))) {
      stop("uuid not available. Check `img` is from get_phylopic.")
    }
  }
  # Error handling -------------------------------------------------------
  if (is.null(uuid)) {
    stop("A `uuid` or `img` is required.")
  }
  if (!is.character(uuid)) {
    stop("`uuid` should be of class character.")
  }
  if (!is.logical(text)) {
    stop("`text` should be of class logical.")
  }
  # Get licenses ---------------------------------------------------------
  links <- c("https://creativecommons.org/publicdomain/zero/1.0/",
             "https://creativecommons.org/publicdomain/mark/1.0/",
             "https://creativecommons.org/licenses/by/4.0/",
             "https://creativecommons.org/licenses/by-sa/3.0/",
             "https://creativecommons.org/licenses/by/3.0/",
             "https://creativecommons.org/licenses/by-nc-sa/3.0/",
             "https://creativecommons.org/licenses/by-nc/3.0/")
  abbr <- c("CC0 1.0",
            "Public Domain Mark 1.0",
            "CC BY 4.0",
            "CC BY-SA 3.0",
            "CC BY 3.0",
            "CC BY-NC-SA 3.0",
            "CC BY-NC 3.0")
  licenses <- data.frame(links, abbr)
  
  # API call -------------------------------------------------------------
  if (length(uuid) > 1) {
    att <- lapply(uuid, get_attribution)
    names(att) <- uuid
  } else {
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
    # Add license title
    att$license_abbr <- licenses$abbr[which(licenses$links == att$license)]
  }
  # Format data
  if (length(uuid) == 1 && text) {
    # Text output desired?
    if (text) {
      att <- paste0("Silhouette was contributed by ",
                    att$contributor, ", ",
                    substr(att$created, start = 1, stop = 4), " ",
                    "(", att$license_abbr, ").")
    }
  } else if (length(uuid) > 1 && text) {
    att <- lapply(att, function (x) {
      paste0(x$contributor, ", ",
             substr(x$created, start = 1, stop = 4), " ",
             "(", x$license_abbr, ")")
    })
    # Keep unique items
    att <- unique(unlist(att))
    # Convert to string
    if (length(att) > 1) {
      att <- combine_words(att, oxford_comma = TRUE)
      att <- paste0("Silhouettes were contributed by ", toString(att), ".")
    } else {
      att <- paste0("Silhouette was contributed by ", toString(att), ".")
    }
  }
  if (text) {
    att <- paste0("Organism silhouettes are from PhyloPic ",
                  "(https://www.phylopic.org/; T. Michael Keesey, 2023). ",
                  att)
    return(message(att))
  }
  # Return data ----------------------------------------------------------
  return(att)
}
