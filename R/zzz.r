#' Fixed phylogeny blank theme for ggphylo
#' @export
theme_phylo_blank2 <- function() {
  element_blank <- ggplot2::element_blank
  ggplot2::theme(
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

# Unnest a nested list
unnest <- function(x) {
  if (is.null(names(x))) {
    list(unname(unlist(x)))
  }
  else {
    c(list(all = unname(unlist(x))), do.call(c, lapply(x, unnest)))
  }
}

# Replaces null with "none"
replacenull <- function(x) {
  x$canonicalName[sapply(x$canonicalName, function(x) is.null(x))] <- "none"
  x
}

# Convert citation null to number 1
citationtonumber <- function(x) {
  make1 <- function(x){
    if (x$canonicalName$citationStart == "none") {
      x$canonicalName$citationStart <- 1
    }
    x
  }
  make1(x)
}

pc <- function(l) Filter(Negate(is.null), l)

as_null <- function(x) if (length(x) == 0) NULL else x

phy_GET <- function(path, args = list(), ...) {
  tmp <- phy_GET2(path, args, ...)
  jsonlite::fromJSON(tmp, FALSE)
}

phy_GET2 <- function(path, args, ...) {
  tt <- httr::GET(url = pbase(), path = path, query = as_null(pc(args)))
  #tt$raise_for_status()
  httr::content(tt, as = "text", encoding = "UTF-8")
}

ibase <- function() "https://images.phylopic.org/images"
pbase <- function() "https://api.phylopic.org"

check_for_a_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

messager <- function(..., v = TRUE) {
  msg <- paste(...)
  if (v) {
    message(msg)
  }
}

#' Send messages to console even from within parallel processes
#' @return A message
#' @keywords internal
message_parallel <- function(...) {
  system(sprintf('echo "%s"', paste0(..., collapse = "")))
}

