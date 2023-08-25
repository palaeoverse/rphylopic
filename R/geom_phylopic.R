#' Geom for adding PhyloPic silhouettes to a plot
#'
#' This geom acts like [ggplot2::geom_point()], except that the specified
#' silhouettes are used as points. Silhouettes can be specified by their `name`,
#' `uuid`, or image objects (`img`).
#'
#' @details One (and only one) of the `img`, `name`, or `uuid` aesthetics must
#'   be specified. The `img` aesthetic can be
#'   [Picture][grImport2::Picture-class] objects or png array objects, e.g.,
#'   from using [get_phylopic()]. Use the `x` and `y` aesthetics to place the
#'   silhouettes at specified positions on the plot. The `size` aesthetic
#'   specifies the height of the silhouettes in the units of the y axis. The
#'   aspect ratio of the silhouettes will always be maintained.
#'
#'   The `color` (default: "black"), `fill` (default: NA), and `alpha` (default:
#'   1) aesthetics can be used to change the outline color, fill color, and
#'   transparency (outline and fill) of the silhouettes, respectively. If
#'   `color` is specified and `fill` is NA the outline and fill color will be
#'   the same. If "original" is specified for the `color` aesthetic, the
#'   original color of the silhouette outline will be used (usually the same as
#'   "transparent"). If "original" is specified for the `fill` aesthetic, the
#'   original color of the silhouette body will be used (usually the same as
#'   "black").
#'
#'   The `horizontal` and `vertical` aesthetics can be used to flip the
#'   silhouettes. The `angle` aesthetic can be used to rotate the silhouettes.
#'   When specifying a horizontal and/or vertical flip **and** a rotation, the
#'   flip(s) will always occur first. If you would like to customize this
#'   behavior, you can flip and/or rotate the image within your own workflow
#'   using [flip_phylopic()] and [rotate_phylopic()].
#'
#'   Note that png array objects can only be rotated by multiples of 90 degrees.
#'   Also, outline colors do not currently work for png array objects.
#'
#' @section Aesthetics: geom_phylopic understands the following aesthetics:
#'
#' - **x** (required)
#' - **y** (required)
#' - **img/uuid/name** (one, and only one, required)
#' - size
#' - color/colour
#' - fill
#' - alpha
#' - horizontal
#' - vertical
#' - angle
#'
#'   Learn more about setting these aesthetics in [add_phylopic()].
#'
#' @param show.legend logical. Should this layer be included in the legends?
#'   `FALSE`, the default, never includes, `NA` includes if any aesthetics are
#'   mapped, and `TRUE` always includes. It can also be a named logical vector
#'   to finely select the aesthetics to display.
#' @param remove_background \code{logical}. Should any white background be
#'   removed from the silhouette(s)? See [recolor_phylopic()] for details.
#' @param verbose \code{logical}. Should the attribution information for the
#'   used silhouette(s) be printed to the console (see [get_attribution()])?
#' @param filter \code{character}. Filter by usage license if using the `name`
#'   aesthetic. Use "by" to limit results to images which do not require
#'   attribution, "nc" for images which allows commercial usage, and "sa" for
#'   images without a StandAlone clause. The user can also combine these
#'   filters as a vector.
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @inheritParams pick_phylopic
#' @importFrom ggplot2 layer
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(x = c(2, 4), y = c(10, 20), name = c("cat", "walrus"))
#' ggplot(df) +
#'   geom_phylopic(aes(x = x, y = y, name = name),
#'                 color = "purple", size = 10) +
#'   facet_wrap(~name) +
#'   coord_cartesian(xlim = c(1,6), ylim = c(5, 30))
geom_phylopic <- function(mapping = NULL, data = NULL,
                          stat = "identity", position = "identity",
                          ...,
                          na.rm = FALSE,
                          show.legend = FALSE,
                          inherit.aes = TRUE,
                          remove_background = TRUE,
                          verbose = FALSE,
                          filter = NULL) {
  if (!is.logical(remove_background)) {
    stop("`remove_background` should be a logical value.")
  }
  if (!is.logical(verbose)) {
    stop("`verbose` should be a logical value.")
  }
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPhylopic,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      remove_background = remove_background,
      verbose = verbose,
      filter = filter,
      ...
    )
  )
}

#' @importFrom ggplot2 ggproto ggproto_parent Geom aes remove_missing
#' @importFrom grid gTree gList nullGrob
GeomPhylopic <- ggproto("GeomPhylopic", Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size", "alpha", "color",
                      "horizontal", "vertical", "angle"),
  optional_aes = c("img", "name", "uuid"), # one and only one of these
  default_aes = aes(size = 1.5, alpha = 1,
                    color = "black", fill = NA,
                    horizontal = FALSE, vertical = FALSE, angle = 0),
  extra_params = c("na.rm", "remove_background", "verbose", "filter"),
  setup_data = function(data, params) {
    if (is.list(params$filter)) params$filter <- params$filter[[1]]
    # Check that only one silhouette aesthetic exists
    data_cols <- sapply(c("img", "name", "uuid"),
                        function(col) col %in% colnames(data))
    param_cols <- sapply(c("img", "name", "uuid"),
                         function(col) col %in% names(params))
    cols <- data_cols | param_cols
    if (sum(cols) != 1) {
      stop(paste("Must specify one (and only one) of the `img`, `name`, or",
                 "`uuid` aesthetics."))
    }
    
    # Check supplied data types and retrieve silhouettes if need be
    if (cols["name"]) {
      if (!params$verbose) {
        warning(paste("You've used the `name` aesthetic/argument. You may want",
                      "to use `verbose = TRUE` to get attribution information",
                      "for the silhouette(s)."), call. = FALSE)
      }
      names <- if (data_cols["name"]) data$name else params$name
      if (!is.character(names)) {
        stop("The `name` aesthetic should be of class character.")
      }
      # Get PhyloPic for each unique name
      name_unique <- unique(names)
      imgs <- sapply(name_unique, function(name) {
        uuid <- tryCatch(get_uuid(name = name, filter = params$filter),
                        error = function(cond) NA)
        if (is.na(uuid)) {
          text <- paste0("`name` ", '"', name, '"')
          if (!is.null(params$filter)) {
            text <- paste0(text, " with `filter` ", '"',
                           paste0(filter, collapse = "/"), '"')
          }
          warning(paste0(text, " returned no PhyloPic results."))
          return(NULL)
        }
        get_phylopic(uuid)
      })
      imgs <- imgs[names]
    } else if (cols["uuid"]) {
      uuids <- if (data_cols["uuid"]) data$uuid else params$uuid
      if (!is.character(uuids)) {
        stop("The `uuid` aesthetic should be of class character.")
      }
      # Get PhyloPic for each unique uuid
      uuid_unique <- unique(uuids)
      imgs <- sapply(uuid_unique, function(uuid) {
        img <- tryCatch(get_phylopic(uuid),
                        error = function(cond) NULL)
        if (is.null(img)) {
          warning(paste0('"', uuid, '"', " is not a valid PhyloPic `uuid`."),
                  call. = FALSE)
        }
        img
      })
      imgs <- imgs[uuids]
    } else {
      imgs <- if (data_cols["img"]) data$img else params$img
      if (any(sapply(imgs, function(img) {
        !is(img, "Picture") && !is.array(img)
      }))) {
        stop(paste("The `img` aesthetic should be of class Picture (for a",
                   "vector image) or class array (for a raster image)."))
      }
    }
    if (params$verbose) {
      get_attribution(img = imgs, text = TRUE)
    }
    data$name <- NULL
    data$uuid <- NULL
    data$img <- imgs
    data
  },
  use_defaults = function(self, data, params = list(), modifiers = aes()) {
    # if fill isn't specified in the original data, copy over the colour column
    col_fill <- c("colour", "fill") %in% colnames(data) |
      c("colour", "fill") %in% names(params)
    data <- ggproto_parent(Geom, self)$use_defaults(data, params, modifiers)
    if (col_fill[1] && !col_fill[2]) {
      data$fill <- data$colour
    }
    data
  },
  draw_panel = function(self, data, panel_params, coord, na.rm = FALSE,
                        remove_background = TRUE, filter = NULL) {
    # Check that aesthetics are valid
    if (any(data$alpha > 1 | data$alpha < 0)) {
      stop("`alpha` must be between 0 and 1.")
    }
    # Clean and transform data
    data <- remove_missing(data, na.rm = na.rm, c("img", "name", "uuid"))
    data <- coord$transform(data, panel_params)

    # Calculate height as percentage of y limits
    # (or r limits for polar coordinates)
    if ("y.range" %in% names(panel_params)) {
      heights <- data$size / diff(panel_params$y.range)
    } else if ("r.range" %in% names(panel_params)) {
      heights <- data$size / diff(panel_params$r.range)
    } else {
      heights <- data$size
    }
    # Hack to make silhouettes the full height of the plot
    heights[is.infinite(heights)] <- 1

    # Make a grob for each silhouette
    grobs <- lapply(seq_len(nrow(data)), function(i) {
      if (is.null(data$img[[i]])) {
        nullGrob()
      } else {
        phylopicGrob(data$img[[i]], data$x[i], data$y[i], heights[i],
                     data$colour[i], data$fill[i], data$alpha[i],
                     data$horizontal[i], data$vertical[i], data$angle[i],
                     remove_background)
      }
    })
    # Return the grobs as a gTree
    ggname("geom_phylopic", gTree(children = do.call(gList, grobs)))
  }
)

#' @importFrom grImport2 pictureGrob
#' @importFrom grid rasterGrob gList gTree nullGrob
#' @importFrom methods slotNames
phylopicGrob <- function(img, x, y, height, color, fill, alpha,
                         horizontal, vertical, angle,
                         remove_background) {
  # modified from add_phylopic for now
  if (horizontal || vertical) img <- flip_phylopic(img, horizontal, vertical)
  if (!is.na(angle) && angle != 0) img <- rotate_phylopic(img, angle)

  # recolor if necessary
  color <- if (is.na(color) || color == "original") NULL else color
  if (is.na(fill)) fill <- color
  fill <- if (!is.null(fill) && fill == "original") NULL else fill
  img <- recolor_phylopic(img, alpha, color, fill, remove_background)

  # grobify
  if (is(img, "Picture")) { # svg
    if ("summary" %in% slotNames(img) &&
        all(c("xscale", "yscale") %in% slotNames(img@summary)) &&
        is.numeric(img@summary@xscale) && length(img@summary@xscale) == 2 &&
        all(is.finite(img@summary@xscale)) && diff(img@summary@xscale) != 0 &&
        is.numeric(img@summary@yscale) && length(img@summary@yscale) == 2 &&
        all(is.finite(img@summary@yscale)) && diff(img@summary@yscale) != 0) {
      # modified from
      # https://github.com/k-hench/hypoimg/blob/master/R/hypoimg_recolor_svg.R
      img_grob <- pictureGrob(img, x = x, y = y, height = height,
                              default.units = "native", expansion = 0)
      img_grob <- gList(img_grob)
      img_grob <- gTree(children = img_grob)
    } else {
      img_grob <- nullGrob()
    }
  } else { # png
    img_grob <- rasterGrob(img, x = x, y = y, height = height,
                           default.units = "native")
  }
  return(img_grob)
}

#' @importFrom grid grobName
ggname <- function(prefix, grob) {
  # copied from ggplot2
  grob$name <- grobName(grob, prefix)
  grob
}
