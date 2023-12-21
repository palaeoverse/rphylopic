test_that("add_phylopic_legend works", {
  skip_if_offline(host = "api.phylopic.org")
  try(dev.off(), silent = TRUE) # clean up any stray plots
  
  # Get UUIDs
  uuids <- get_uuid(name = "Canis lupus", n = 2)
  
  # PhyloPic base R legend
  expect_doppelganger("PhyloPic base legend", function() {
    plot(0:10, 0:10, type = "n", main = "Wolfs")
    add_phylopic_base(uuid = uuids,
                      color = "black", fill = c("blue", "green"),
                      x = c(2.5, 7.5), y = c(2.5, 7.5), ysize = 2)
    add_phylopic_legend(uuid = uuids, 
                        ysize = 0.25, color = "black", 
                        fill = c("blue", "green"), 
                        x = "bottomright", legend = c("Wolf 1", "Wolf 2"),
                        bg = "lightgrey")
  })
  
  # PhyloPic base R legend with legend arguments
  expect_doppelganger("PhyloPic base legend args", function() {
    plot(0:10, 0:10, type = "n", main = "Wolfs")
    add_phylopic_base(uuid = uuids,
                      color = "black", fill = c("blue", "green"),
                      x = c(2.5, 7.5), y = c(2.5, 7.5), ysize = 2)
    add_phylopic_legend(uuid = uuids, 
                        x = "bottomright", legend = c("Wolf 1", "Wolf 2"),
                        col = "black", pt.bg = c("blue", "green"),
                        pt.cex = 0.25)
  })
  
  # PhyloPic base R legend with default ysize
  expect_doppelganger("PhyloPic base legend default size", function() {
    plot(0:10, 0:10, type = "n", main = "Wolfs")
    add_phylopic_base(uuid = uuids,
                      color = "black", fill = c("blue", "green"),
                      x = c(2.5, 7.5), y = c(2.5, 7.5), ysize = 2)
    add_phylopic_legend(uuid = uuids, 
                        x = "bottomright", legend = c("Wolf 1", "Wolf 2"),
                        col = "black", pt.bg = c("blue", "green"))
  })
})
