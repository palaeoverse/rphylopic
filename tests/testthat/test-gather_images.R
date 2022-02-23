test_that("gather_images works", {
  
  species <- c("Mus_musculus","Pan_troglodytes","Homo_sapiens")
  res <- rphylopic::gather_images(species=species)
  
  testthat::expect_equal(gsub("_"," ",species), res$species)
  testthat::expect_true(
    all(c("species","uid","namebankID","species","picid") %in% colnames(res))
  )
})
