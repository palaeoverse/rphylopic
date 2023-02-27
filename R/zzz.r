#' Fixed phylogeny blank theme for ggphylo
#' @export
#' @importFrom ggplot2 theme element_blank element_text
theme_phylo_blank2 <- function() {
  element_blank <- element_blank
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.title.x = element_text(colour = NA),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )
}

pc <- function(l) Filter(Negate(is.null), l)

as_null <- function(x) if (length(x) == 0) NULL else x

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

ibase <- function() "https://images.phylopic.org/images"
pbase <- function() "https://api.phylopic.org"
