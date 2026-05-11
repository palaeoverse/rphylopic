#' @importFrom utils packageDescription
.onAttach <- function(libname, pkgname) {
  pkgVersion <- packageDescription(pkgname, fields = "Version")
  packageStartupMessage(paste0('You are using rphylopic v.', pkgVersion, '. ',
                              'Please remember to credit PhyloPic contributors',
                              ' (hint: `get_attribution()`) and cite rphylopic',
                              ' in your work (hint: `citation("rphylopic")`).'))
}

pc <- function(l) Filter(Negate(is.null), l)

as_null <- function(x) if (length(x) == 0) NULL else x

phost <- function() "api.phylopic.org"
pbase <- function() paste0("https://", phost())

.phy_cache <- new.env(parent = emptyenv())

#' @importFrom httpcache GET
#' @importFrom curl nslookup
phy_GET <- function(path, query = list(), ...) {
  query <- as_null(pc(query))
  url <- file.path(pbase(), path)
  tt <- tryCatch({
    # Cached responses should work even if user is offline
    httpcache::GET(url = url, query = query)
  }, error = function(e) {
    # Check PhyloPic (or user) is online
    tryCatch({
      nslookup(phost())
    }, error = function(e2) {
      stop("PhyloPic is not available or you have no internet connection.")
    })
    stop(e)  # network is fine; rethrow the original GET error
  })
  jsn <- response_to_JSON(tt)
  if (tt$status == 400) { # need to supply the build argument
    query[["build"]] <- jsn$build
    tt <- httpcache::GET(url = file.path(pbase(), path), query = query)
    jsn <- response_to_JSON(tt)
  }
  jsn
}

#' @importFrom httr POST
#' @importFrom httr add_headers
#' @importFrom jsonlite toJSON
#' @importFrom curl nslookup
phy_POST <- function(path, body = list(), ...) {
  # Convert to JSON
  body <- toJSON(body)
  tryCatch({
    resp <- POST(url = pbase(), path = path, body = body,
               add_headers("Content-type" = "application/vnd.phylopic.v2+json"),
               encode = "raw")
  }, error = function(e) {
    # Check PhyloPic (or user) is online
    tryCatch({
      nslookup(phost())
    },
    error = function(e) {
      stop("PhyloPic is not available or you have no internet connection.")
    })
    stop(e)  # network is fine; rethrow the original POST error
  })
  resp <- response_to_JSON(resp)
  resp
}

#' @importFrom httr content
#' @importFrom jsonlite fromJSON
response_to_JSON <- function(response) {
  tmp <- content(response, as = "text", encoding = "UTF-8")
  return(fromJSON(tmp))
}
