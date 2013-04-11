#' Fixed phylogeny blank theme for ggphylo
#' @import ggplot2
#' @export 
theme_phylo_blank2 <- function()
{
  element_blank <- ggplot2::element_blank
  ggplot2::theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.title.x = element_text(colour=NA),
    axis.title.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )
}

#' Unnest a nested list
#' 
#' @param x A nested list
#' @keywords internal
unnest <- function(x) 
{
  if(is.null(names(x))) {
    list(unname(unlist(x)))
  }
  else {
    c(list(all=unname(unlist(x))), do.call(c, lapply(x, unnest)))
  }
}

#' Replaces null with "none"
#' 
#' @param x A list
#' @keywords internal
replacenull <- function(x){
  x$canonicalName[sapply(x$canonicalName, function(x) is.null(x))] <- "none"
  x
}

#' Convert citation null to number 1
#' 
#' @keywords internal
citationtonumber <- function(x){
  make1 <- function(x){
    if(x$canonicalName$citationStart == "none")
      x$canonicalName$citationStart <- 1
    x
  }
  make1(x)
}

#' Strip authority
#' 
#' @param x A string
#' @param y Another string
#' @keywords internal
stripauth <- function(x, y){ if(!y == 1){ str_sub(x, 1, y-1) } else { x } }