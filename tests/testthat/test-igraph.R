test_that("phylopic shape is registered with igraph", {
  skip_if_not_installed("igraph")
  
  # Shape should be registered automatically when igraph's namespace loads
  # (via the setHook in .onLoad, or immediately if igraph was already loaded)
  expect_true("phylopic" %in% igraph::shapes())
  
  # The registered shape must expose both a clip and a plot function
  shape_def <- igraph::shapes("phylopic")
  expect_true(is.function(shape_def$clip))
  expect_true(is.function(shape_def$plot))
})

test_that("register_phylopic_shape() is idempotent", {
  skip_if_not_installed("igraph")
  
  # Re-registration should overwrite cleanly without error
  expect_no_error(register_phylopic_shape())
  expect_true("phylopic" %in% igraph::shapes())
})

test_that("igraph plotting with phylopic shape works", {
  skip_if_offline(host = "api.phylopic.org")
  skip_if_not_installed("igraph")
  
  g <- igraph::make_ring(5)
  layout <- igraph::layout_in_circle(g)
  
  # phylopic-by-name on a simple ring
  expect_doppelganger("igraph phylopic by name", function() {
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.name = "Felis silvestris catus",
         vertex.size = 30, vertex.verbose = TRUE,
         vertex.label = NA)
  })
  
  # phylopic-by-uuid
  expect_doppelganger("igraph phylopic by uuid", function() {
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
         vertex.size = 30, vertex.label = NA)
  })
  
  # phylopic-by-pre-fetched image
  expect_doppelganger("igraph phylopic by img", function() {
    cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
    plot(g, layout = layout, vertex.shape = "phylopic", vertex.img = list(cat),
         vertex.size = 30, vertex.label = NA)
  })
})

test_that("igraph plotting respects per-vertex parameters", {
  skip_if_offline(host = "api.phylopic.org")
  skip_if_not_installed("igraph")
  
  # Per-vertex color, angle, and alpha are recycled by igraph's plot machinery
  expect_doppelganger("igraph phylopic per-vertex styling", function() {
    g <- igraph::make_ring(10)
    layout <- igraph::layout_in_circle(g)
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
         vertex.color = rainbow(5),
         vertex.angle = seq(0, 288, length.out = 5),
         vertex.alpha = seq(0.3, 1, length.out = 5),
         vertex.size = 30, vertex.label = NA)
  })
  
  # Per-vertex horizontal and vertical flips
  expect_doppelganger("igraph phylopic with flips", function() {
    g <- igraph::make_ring(4)
    layout <- igraph::layout_in_circle(g)
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
         vertex.horizontal = c(TRUE, FALSE, TRUE, FALSE),
         vertex.vertical  = c(TRUE, TRUE, FALSE, FALSE),
         vertex.size = 30, vertex.label = NA)
  })
  
  # vertex.frame.color and vertex.color map onto outline/fill
  expect_doppelganger("igraph phylopic with frame and fill", function() {
    g <- igraph::make_ring(3)
    layout <- igraph::layout_in_circle(g)
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
         vertex.color = "darkorange",
         vertex.frame.color = "black",
         vertex.size = 40, vertex.label = NA)
  })
  
  # vertex.filter should propagate through to get_uuid() during name lookup
  expect_doppelganger("igraph phylopic with filter", function() {
    g <- igraph::make_ring(3)
    layout <- igraph::layout_in_circle(g)
    plot(g, layout = layout, vertex.shape = "phylopic",
         vertex.name = "Felis silvestris catus",
         vertex.filter = "by",
         vertex.size = 30, vertex.verbose = TRUE, vertex.label = NA)
  })
})

test_that("igraph phylopic warnings and errors propagate", {
  skip_if_offline(host = "api.phylopic.org")
  skip_if_not_installed("igraph")
  
  g <- igraph::make_ring(2)
  
  # Same name-without-verbose warning that add_phylopic_base() emits
  expect_warning(plot(g, vertex.shape = "phylopic",
                      vertex.name = "Felis silvestris catus"),
                 "`name` argument")
  
  # Bogus uuid should forward the get_phylopic() warning
  expect_warning(plot(g, vertex.shape = "phylopic",
                      vertex.uuid = "jkl;daf"),
                 "is not a valid PhyloPic `uuid`")
  
  # Bogus name should forward the get_uuid() warning
  # and add_phylopic_base() warning
  expect_warning(
    expect_warning(plot(g, vertex.shape = "phylopic",
                        vertex.name = "jkl;daf"),
                   "returned no PhyloPic results"),
    "`name` argument"
  )
})

test_that("phylopic_clip handles default and NA clip_scale values", {
  skip_if_not_installed("igraph")
  
  # Two edges out of a single source node
  coords <- matrix(c(0, 0, 1, 0,
                     0, 0, 0, 1), ncol = 4, byrow = TRUE)
  el <- matrix(c(1, 2,
                 1, 3), ncol = 2, byrow = TRUE)
  
  # Default branch: clip_scale unset
  params_unset <- function(type, name) {
    if (type == "vertex" && name == "size") return(20)
    if (type == "vertex" && name == "clip_scale") return(numeric(0))
    NULL
  }
  expect_no_error(phylopic_clip(coords, el, params_unset, "both"))
  
  # NA-patching branch: per-vertex clip_scale with some NAs
  params_partial_na <- function(type, name) {
    if (type == "vertex" && name == "size") return(rep(20, 3))
    if (type == "vertex" && name == "clip_scale") return(c(NA, 0.5, NA))
    NULL
  }
  expect_no_error(phylopic_clip(coords, el, params_partial_na, "both"))
  
  # User-supplied scalar should be honored
  params_scalar <- function(type, name) {
    if (type == "vertex" && name == "size") return(20)
    if (type == "vertex" && name == "clip_scale") return(0.4)
    NULL
  }
  result <- phylopic_clip(coords, el, params_scalar, "both")
  expect_true(is.matrix(result))
  expect_equal(ncol(result), 4)  # both endpoints clipped
})
