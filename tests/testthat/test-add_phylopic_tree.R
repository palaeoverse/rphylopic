test_that("add_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  
  expect_doppelganger("Add cat to tree", function() {
    # Load the ape library to work with phylogenetic trees
    library("ape")
    
    # Read a phylogenetic tree
    tree <- ape::read.tree(text = "(cat, (dog, mouse));")
  
    # Set edge of plot = edge of device
    par(mar = rep(0, 4)) 
    
    # Add a PhyloPic silhouette of a cat to the tree
    add_phylopic_tree(
      tree, # No tree plotted - plot silently
      "cat", # Which leaf should the silhouette be plotted against?
      uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9", # Silhouette to plot
      relWidth = 0.1,
      vjust = 0.2,
      fill = "brown"
    )
    
    # Add a mouse, by taxon name
    expect_warning(
      add_phylopic_tree(
        tree, # Must be the tree that was plotted
        "mouse", # Which leaf should the silhouette be plotted against?
        name = "mus",
        relWidth = 0.2,
        padding = 0.8, # Should appear flush with left margin
        fill = "lightblue",
        vjust = 1
      ),
      "used the .name. argument"
    )
    
    # Add a dog, by name
    expect_warning(
      add_phylopic_tree(
        tree, # Must be the tree that was plotted
        "dog", # Which leaf should the silhouette be plotted against?
        relWidth = 0.16,
        padding = -0.08, # Half off the page
        fill = "#665566"
      ),
      "used the .name. argument"
    )
  })
})
