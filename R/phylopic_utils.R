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
rotate_phylopic <- function(img, angle = pi/2) {
  UseMethod("rotate_phylopic")
}

#' @export
#' @importFrom grImport2 applyTransform
rotate_phylopic.Picture <- function(img, angle = pi/2) {
  # modified from
  # https://github.com/thomasp85/ggforce/blob/main/R/trans_linear.R
  mat <- matrix(c(cos(angle), sin(angle), 0,
                  -sin(angle), cos(angle), 0,
                  0, 0, 1), ncol = 3, byrow = TRUE)
  transform_picture(img, mat)
}

transform_picture <- function(img, mat) {
  img@content <- lapply(img@content, function(cont) applyTransform(cont, mat))
  img@summary <- transform_summary(img@summary, mat)
  img
}

transform_summary <- function(summary, mat) {
  corners <- expand.grid(x = summary@xscale, y = summary@yscale)
  corners_rot <- mat %*% rbind(corners$x, corners$y, z = 1)
  rev_x <- summary@xscale[1] > summary@xscale[2]
  rev_y <- summary@yscale[1] > summary@yscale[2]
  summary@xscale <- range(corners_rot[1, ])
  if (rev_x) summary@xscale <- rev(summary@xscale)
  summary@yscale <- range(corners_rot[2, ])
  if (rev_y) summary@yscale <- rev(summary@yscale)
  summary
}
