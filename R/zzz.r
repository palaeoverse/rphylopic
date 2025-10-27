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

#' @importFrom digest digest
.cache_key <- function(method, path, payload = NULL) {
  paste0(method, ":", path, ":", digest(payload))
}

#' @importFrom httr GET
#' @importFrom curl nslookup
phy_GET <- function(path, query = list(), ...) {
  query <- as_null(pc(query))
  key <- .cache_key("GET", path, query)
  
  if (exists(key, envir = .phy_cache, inherits = FALSE)) {
    return(get(key, envir = .phy_cache))
  }
  
  # Check PhyloPic (or user) is online
  tryCatch({
    nslookup(phost())
  },
  error = function(e) {
    stop("PhyloPic is not available or you have no internet connection.")
  })
  tt <- GET(url = pbase(), path = path, query = query)
  jsn <- response_to_JSON(tt)
  if (tt$status == 400) { # need to supply the build argument
    query[["build"]] <- jsn$build
    tt <- GET(url = pbase(), path = path, query = query)
    jsn <- response_to_JSON(tt)
  }
  
  assign(key, jsn, envir = .phy_cache)
  jsn
}

#' @importFrom httr POST add_headers
#' @importFrom jsonlite toJSON
#' @importFrom curl nslookup
phy_POST <- function(path, body = list(), ...) {
  # Check PhyloPic (or user) is online
  tryCatch({
    nslookup(phost())
  },
  error = function(e) {
    stop("PhyloPic is not available or you have no internet connection.")
  })
  # Convert to JSON
  body <- toJSON(body)
  resp <- POST(url = pbase(), path = path, body = body,
               add_headers("Content-type" = "application/vnd.phylopic.v2+json"),
               encode = "raw")
  resp <- response_to_JSON(resp)
  resp
}

#' @importFrom httr content
#' @importFrom jsonlite fromJSON
response_to_JSON <- function(response) {
  tmp <- content(response, as = "text", encoding = "UTF-8")
  return(fromJSON(tmp))
}
