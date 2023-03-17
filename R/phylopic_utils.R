#' @export
flip_phylopic <- function(img, horizontal = TRUE, vertical = FALSE) {
  UseMethod("flip_phylopic")
}

#' @export
flip_phylopic.Picture <- function(img, horizontal = TRUE, vertical = FALSE) {
  # modified from
  # https://github.com/thomasp85/ggforce/blob/main/R/trans_linear.R
  if (horizontal) {
    mat <- matrix(c(-1, 0, 0,
                    0, 1, 0,
                    0, 0, 1), ncol = 3, byrow = TRUE)
    img <- transform_picture(img, mat)
  }
  if (vertical) {
    mat <- matrix(c(1, 0, 0,
                    0, -1, 0,
                    0, 0, 1), ncol = 3, byrow = TRUE)
    img <- transform_picture(img, mat)
  }
  img
}

#' @export
flip_phylopic.array <- function(img, horizontal = TRUE, vertical = FALSE) {
  if (horizontal) {
    img <- img[, ncol(img):1, , drop=FALSE]
  }
  if (vertical) {
    img <- img[nrow(img):1, , , drop=FALSE]
  }
  x
}

#' @export
rotate_phylopic <- function(img, angle = 90) {
  UseMethod("rotate_phylopic")
}

#' @export
rotate_phylopic.Picture <- function(img, angle = 90) {
  # change to radians
  angle <- angle / 360 * (2 * pi)
  # change to clockwise
  angle <- (2 * pi) - angle
  # create rotation matrix (modified from
  # https://github.com/thomasp85/ggforce/blob/main/R/trans_linear.R)
  mat <- matrix(c(cos(angle), sin(angle), 0,
                  -sin(angle), cos(angle), 0,
                  0, 0, 1), ncol = 3, byrow = TRUE)
  transform_picture(img, mat)
}

#' @export
rotate_phylopic.array <- function(img, angle = 90) {
  stop("`rotate_phylopic` is not yet implemented for rasterized phylopics.")
}

#' @importFrom grImport2 applyTransform
transform_picture <- function(img, mat) {
  # transform the img content given the specified transformation matrix
  img@content <- lapply(img@content, function(cont) applyTransform(cont, mat))
  # transform the xscale and yscale with the same matrix
  img@summary <- transform_summary(img@summary, mat)
  img
}

transform_summary <- function(summary, mat) {
  # transform the corners given the specified transformation matrix
  corners <- expand.grid(x = summary@xscale, y = summary@yscale)
  corners_trans <- mat %*% rbind(corners$x, corners$y, z = 1)
  # maintain the directionality of the scales
  rev_x <- summary@xscale[1] > summary@xscale[2]
  rev_y <- summary@yscale[1] > summary@yscale[2]
  # set the new scales
  summary@xscale <- range(corners_trans[1, ])
  if (rev_x) summary@xscale <- rev(summary@xscale)
  summary@yscale <- range(corners_trans[2, ])
  if (rev_y) summary@yscale <- rev(summary@yscale)
  summary
}


#' Recolor a phylopic image
#'
#' Function to recolour and change alpha levels of a phylopic image.
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param alpha A value between 0 and 1, specifying the opacity of the
#'   silhouette.
#' @param color Color to plot the silhouette in. If NULL, the color is not
#'   changed.
#' 
#' @return A [Picture][grImport2::Picture-class] or png array object (matching
#'   the type of `img`)
#' @importFrom grDevices rgb col2rgb
#' @export
recolor_phylopic <- function(img, alpha = 1, color = NULL) {
  UseMethod("recolor_phylopic")
}

#' @export
recolor_phylopic.array <- function(img, alpha = 1, color = NULL) {
  if (is.null(color)) {
    mat <- matrix(rgb(img[, , 1], img[, , 2], img[, , 3], img[, , 4] * alpha),
                  nrow = dim(img)[1])
  } else {
    cols <- col2rgb(color)
    imglen <- length(img[, , 1])
    mat <- matrix(ifelse(img[, , 4] > 0, rgb(rep(cols[1, 1], imglen),
                                             rep(cols[2, 1], imglen),
                                             rep(cols[3, 1], imglen),
                                             img[, , 4] * 255 * alpha,
                                             maxColorValue = 255),
                         ## make background white for devices
                         ## that do not support alpha channel
                         rgb(rep(1, imglen),
                             rep(1, imglen),
                             rep(1, imglen),
                             img[, , 4] * alpha)),
                  nrow = dim(img)[1])
  }
  return(mat)
}

#' @export
recolor_phylopic.Picture <- function(img, alpha = 1, color = NULL) {
  img@content <- lapply(img@content, function(cont) {
    for (i in seq_along(cont@content)) {
      cont@content[[i]]@gp$alpha <- alpha
      if (!is.null(color)) {
        cont@content[[i]]@gp$fill <- color
      }
    }
    cont
  })
  return(img)
}
