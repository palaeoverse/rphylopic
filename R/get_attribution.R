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
#' @param permalink \code{logical}. Should a permalink be created for this 
#' collection of `uuid`(s)? Defaults to `FALSE`.
#'
#' @return A \code{list} of PhyloPic attribution data for an image `uuid` or
#' a text output of relevant attribution information.
#'
#' @details This function returns image `uuid` specific attribution data,
#'   including: contributor name, contributor uuid, contributor contact,
#'   image uuid, license, and license abbreviation. If `text` is set to
#'   `TRUE`, a text paragraph with the contributor name, year of contribution,
#'    and license type is printed and image attribution data is returned 
#'    invisibly (i.e. using [invisible()]. If `permalink` is set to `TRUE`, a 
#'    permanent link (hosted by [PhyloPic](https://www.phylopic.org)) will be
#'    generated. This link can be used to view and share details about the 
#'    image silhouettes, including contributors and licenses.
#' @importFrom knitr combine_words
#' @importFrom utils packageVersion
#' @importFrom httr GET
#' @export
#' @examples \dontrun{
#' # Get valid uuid
#' uuid <- get_uuid(name = "Acropora cervicornis")
#' # Get attribution data for uuid
#' attri <- get_attribution(uuid = uuid)
#' 
#' # Get list of valid uuids
#' uuids <- get_uuid(name = "Scleractinia", n = 5)
#' # Get attribution data for uuids
#' get_attribution(uuid = uuids, text = TRUE)
#' # Get attribution data for uuids and create permalink
#' get_attribution(uuid = uuids, text = TRUE, permalink = TRUE)
#' }
get_attribution <- function(uuid = NULL, img = NULL, text = FALSE, 
                            permalink = FALSE) {
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
  # Create permalink ------------------------------------------------------
  if (permalink) {
    coll <- phy_POST(path = "collections", body = uuid)$uuid
    url <- paste0("https://www.phylopic.org/api/permalinks/collections/", 
                  coll)
    coll <- GET(url = url) 
    hash <- response_to_JSON(coll)
    perm <- paste0("https://www.phylopic.org/permalinks/", hash)
  }
  # API call -------------------------------------------------------------
  if (length(uuid) > 1) {
    att <- lapply(uuid, get_attribution)
    att <- unlist(att, recursive = FALSE)
    att <- lapply(1:length(att), function(x) {
      att[[x]]
    })
    att <- unlist(att, recursive = FALSE)
  } else {
    api_return <- phy_GET(file.path("images", uuid),
                          list(embed_contributor = "true"))
    # Process output -------------------------------------------------------
    att <- list(
      attribution = api_return$attribution,
      contributor = api_return$`_embedded`$contributor$name,
      contributor_uuid = api_return$`_embedded`$contributor$uuid,
      created = substr(
        x = api_return$`_embedded`$contributor$created,
        start = 1,
        stop = 10
      ),
      contact = gsub(
        "mailto:",
        "",
        api_return$`_embedded`$contributor$`_links`$contact
      ),
      image_uuid = uuid,
      license = api_return$`_links`$license$href
    )
    # Add license title
    att$license_abbr <- licenses$abbr[which(licenses$links == att$license)]
    # Attributor unknown?
    if (is.null(att$attribution)) {
      att$attribution <- "Unknown"
    }
    # Make sublist 
    att <- list(images = att)
    names(att) <- uuid
  }
  # Text output?
  if (text) {
    # Attributors
    txt <- lapply(att, function(x) {
      paste0(x$attribution, ", ",
             substr(x$created, start = 1, stop = 4), " ",
             "(", x$license_abbr, ")")
    })
    # Keep unique items
    txt <- unique(unlist(txt))
    # Contributors
    cont <- lapply(att, function(x) {
      paste0(x$contributor)
    })
    # Keep unique items
    cont <- unique(unlist(cont))
    # Convert to string
    if (length(txt) > 1) {
      txt <- combine_words(txt, oxford_comma = TRUE)
      txt <- paste0("Silhouettes were made by ", toString(txt), ".")
    } else {
      txt <- paste0("Silhouette was made by ", toString(txt), ".")
    }
    if (length(cont) > 1) {
      cont <- combine_words(cont, oxford_comma = TRUE)
      cont <- paste0("Silhouettes were contributed by ", toString(cont), ".")
    } else {
      cont <- paste0("Silhouette was contributed by ", toString(cont), ".")
    }
    txt <- paste0("Organism silhouettes are from PhyloPic ",
                  "(https://www.phylopic.org/; T. Michael Keesey, 2023) ",
                  "and were added using the rphylopic R package ver. ",
                  packageVersion("rphylopic"), " (Gearty & Jones, 2023). ",
                  txt, " ", cont)
    # Add permalink?
    if (permalink) {
      txt <- paste0(txt, " Full attribution details are available at: ", 
                    perm, ".")
    }
  }
  # Assign to images
  att <- list(images = att)
  # Add permalink?
  if (permalink) {
    att$permalink <- perm
  }
  # Add text?
  if (text) {
    att$text <- txt
    message(txt)
    return(invisible(att))
  }
  # Return data
  return(att)
}
