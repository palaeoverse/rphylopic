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

pbase <- function() "https://api.phylopic.org"

#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @importFrom curl nslookup
phy_GET <- function(path, query = list(), ...) {
  # Check PhyloPic (or user) is online
  tryCatch({
    nslookup("api.phylopic.org")
  },
  error = function(e) {
    stop("PhyloPic is not available or you have no internet connection.")
  })
  query <- as_null(pc(query))
  tt <- GET(url = pbase(), path = path, query = query)
  tmp <- content(tt, as = "text", encoding = "UTF-8")
  jsn <- fromJSON(tmp)
  if (tt$status == 400) { # need to supply the build argument
    query[["build"]] <- jsn$build
    tt <- GET(url = pbase(), path = path, query = query)
    tmp <- content(tt, as = "text", encoding = "UTF-8")
    jsn <- fromJSON(tmp)
  }
  jsn
}
