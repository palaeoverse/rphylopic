.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste("Thank you for using rphylopic! Don't forget to",
                              "attribute the silhouettes that you use to their",
                              "contributors using the `get_attribution()`",
                              "function and/or the `verbose` argument in the",
                              "`geom_phylopic()`, `add_phylopic()`, and",
                              "`add_phylopic_base()` functions. We would also",
                              "appreciate it if you cite this package in your",
                              'work (use `citation("rphylopic")`).'))
}

pc <- function(l) Filter(Negate(is.null), l)

as_null <- function(x) if (length(x) == 0) NULL else x

pbase <- function() "https://api.phylopic.org"

#' @importFrom jsonlite fromJSON
#' @importFrom httr GET content
#' @importFrom curl nslookup
phy_GET <- function(path, query = list(), ...) {
  # Check PhyloPic (or user) is online
  tryCatch(
    {
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
