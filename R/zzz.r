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
phy_GET <- function(path, query = list(), ...) {
  tmp <- phy_GET2(path, query, ...)
  fromJSON(tmp, FALSE)
}

#' @importFrom httr GET content
phy_GET2 <- function(path, query, ...) {
  tt <- GET(url = pbase(), path = path, query = as_null(pc(query)))
  #tt$raise_for_status()
  content(tt, as = "text", encoding = "UTF-8")
}

ibase <- function() "https://images.phylopic.org/images"
pbase <- function() "https://api.phylopic.org"
