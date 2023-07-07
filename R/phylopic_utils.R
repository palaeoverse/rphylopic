#' Flip a PhyloPic silhouette along its horizontal and/or vertical axis
#'
#' The picture can be a [Picture][grImport2::Picture-class] or png array object,
#' e.g., from using [get_phylopic()].
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param horizontal \code{logical}. Should the silhouette be flipped
#'   horizontally?
#' @param vertical \code{logical}. Should the silhouette be flipped vertically?
#' @return A [Picture][grImport2::Picture-class] or png array object (matching
#'   the type of `img`)
#' @family transformations
#' @export
flip_phylopic <- function(img, horizontal = TRUE, vertical = FALSE) {
  if (!is.logical(horizontal)) stop("`horizontal` must be TRUE or FALSE.")
  if (!is.logical(vertical)) stop("`vertical` must be TRUE or FALSE.")
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
  if (length(dim(img)) != 3) {
    stop("`img` must be an array with three dimensions.")
  }

  # modified from https://github.com/richfitz/vectoR/blob/master/R/vector.R
  if (horizontal) {
    img <- img[, rev(seq_len(ncol(img))), , drop = FALSE]
  }
  if (vertical) {
    img <- img[rev(seq_len(nrow(img))), , , drop = FALSE]
  }
  img
}

#' Rotate a PhyloPic silhouette
#'
#' The picture can be a [Picture][grImport2::Picture-class] or png array object,
#' e.g., from using [get_phylopic()]. Note that png array objects can only be
#' rotated by multiples of 90 degrees.
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param angle \code{numeric}. The number of degrees to rotate the silhouette
#'   clockwise.
#' @return A [Picture][grImport2::Picture-class] or png array object (matching
#'   the type of `img`)
#' @family transformations
#' @export
rotate_phylopic <- function(img, angle = 90) {
  if (!is.numeric(angle)) stop("`angle` must be a number.")
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
  if (length(dim(img)) != 3) {
    stop("`img` must be an array with three dimensions.")
  }
  if (angle %% 90 != 0) {
    stop(paste("`angle` must be divisible by 90. Other angles are not yet",
               "implemented for rasterized PhyloPics."))
  }

  # modified from https://stackoverflow.com/a/16497058/4660582
  if (angle > 0) { # clockwise
    rotate <- function(mat) t(mat[rev(seq_len(nrow(mat))), , drop = FALSE])
  } else if (angle < 0) { # counter clockwise
    rotate <- function(mat) {
      mat_t <- t(mat)
      mat_t[rev(seq_len(nrow(mat_t))), , drop = FALSE]
    }
  }
  img_new <- img
  for (i in seq_len(abs(angle) / 90)) {
    img_new <- simplify2array(
      lapply(seq_len(dim(img_new)[3]),
             function(i) rotate(img_new[, , i]))
      )
  }
  img_new
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

#' Recolor a PhyloPic image
#'
#' Function to recolor and change alpha levels of a PhyloPic image.
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param alpha \code{numeric}. A value between 0 and 1, specifying the opacity
#'   of the silhouette.
#' @param color \code{character}. Color to plot the silhouette in. If NULL, the
#'   color is not changed.
#' @param remove_background \code{logical}. Should any white background be
#'   removed? Only useful if `img` is a [Picture][grImport2::Picture-class]
#'   object. See details.
#'
#' @details Some PhyloPic silhouettes do not have a transparent background.
#'   Consequently, when color is used with vectorized versions of these images,
#'   the entire image--including the background--is recolored. Setting
#'   `remove_background` to `TRUE` (the default) will remove any white parts of
#'   the image (which should only be the background).
#'
#' @return A [Picture][grImport2::Picture-class] or png array object (matching
#'   the type of `img`)
#' @family transformations
#' @importFrom grDevices rgb col2rgb
#' @export
recolor_phylopic <- function(img, alpha = 1, color = NULL,
                             remove_background = TRUE) {
  if (!is.numeric(alpha) || alpha < 0 || alpha > 1) {
    stop("`alpha` must be a number between 0 and 1.")
  }
  if (!is.character(color) && !is.null(color)) {
    stop("`color` must be a character value.")
  }
  UseMethod("recolor_phylopic")
}

#' @export
recolor_phylopic.array <- function(img, alpha = 1, color = NULL,
                                   remove_background = TRUE) {
  dims <- dim(img)
  if (length(dim(img)) != 3) {
    stop("`img` must be an array with three dimensions.")
  }

  # convert to RGBA if needed
  if (dims[3] == 1) { # grayscale
    img <- g_to_rgba(img)
  } else if (dims[3] == 2) { # greyscale and alpha
    img <- ga_to_rgba(img)
  } else if (dims[3] == 3) { # RGB
    img <- rgb_to_rgba(img)
  } else if (dims[3] > 4) { # not supported
    stop(paste("`img` must be in G, GA, RGB, or RGBA format.",
               "More than four channels is not supported."))
  }
  dims <- dim(img) # update dimensions
  if (is.null(color)) {
    new_img <- array(c(img[, , 1:3], img[, , 4] * alpha), dim = dims)
  } else {
    cols <- col2rgb(color) / 255
    imglen <- length(img[, , 1])
    new_img <- array(c(rep(cols[1, 1], imglen),
                       rep(cols[2, 1], imglen),
                       rep(cols[3, 1], imglen),
                       img[, , 4] * alpha), dim = dims)
  }
  return(new_img)
}

ga_to_rgba <- function(img) {
  new_img <- array(0, dim = c(dim(img)[1:2], 4))
  new_img[, , 4] <- img[, , 2]
  new_img
}

g_to_rgba <- function(img) {
  new_img <- array(0, dim = c(dim(img)[1:2], 2))
  new_img[, , 2] <- img
  ga_to_rgba(new_img)
}

rgb_to_rgba <- function(img) {
  new_img <- array(0, dim = c(dim(img)[1:2], 4))
  new_img[, , 1:3] <- img[, , 1:3]
  new_img[, , 4] <- 1
  new_img
}

#' @export
recolor_phylopic.Picture <- function(img, alpha = 1, color = NULL,
                                     remove_background = TRUE) {
  img <- recolor_content(img, alpha, color, remove_background)
  if (length(img@content) == 0) stop("Invalid 'Picture' object")
  return(img)
}

#' @importFrom methods slotNames
recolor_content <- function(x, alpha, color, remove_background) {
  tmp <- lapply(x@content, function(element) {
    if (is(element, "PicturePath")) {
      # a bit of a hack until PhyloPic fixes these white backgrounds
      if (remove_background && "gp" %in% slotNames(element) &&
          "fill" %in% names(element@gp) &&
          element@gp$fill %in% c("#FFFFFFFF", "#FFFFFF")) {
        return(NULL)
      } else {
        element@gp$alpha <- alpha
        if (!is.null(color)) {
          element@gp$fill <- color
        }
        return(element)
      }
    } else if (is(element, "PictureGroup")) {
      # need to go another level down
      recolor_content(element, alpha, color, remove_background)
    }
  })
  x@content <- Filter(function(element) !is.null(element), tmp)
  return(x)
}
