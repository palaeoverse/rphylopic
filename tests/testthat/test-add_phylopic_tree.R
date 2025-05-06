test_that("add_phylopic_tree works", {
  skip_if_offline(host = "api.phylopic.org")
  
  if (dev.cur() > 1) {
    # Ensure graphics device is off
    dev.off()
  }
  expect_error(
    add_phylopic_tree(
      ape::read.tree(text = "(cat, mouse);"),
      "mouse",
      uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9", # Silhouette to plot
      fill = "red"
    ),
    "No plotting device is open"
  )
  
  expect_doppelganger("Add individual silhouettes to tree", function() {
    # Load the ape library to work with phylogenetic trees
    library("ape")
    
    # Read a phylogenetic tree
    tree <- ape::read.tree(text = "(cat, (dog, mouse));")
    
    # Fail if no tree has (ever) been plotted
    plot.new() # Open a graphics device without plotting a tree
    expect_error(add_phylopic_tree(
      tree,
      "cat",
      uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
      relWidth = 0.1,
      vjust = 0.2,
      fill = "brown"
    ), "plot\\(tree\\) has not been called")
    
    
    # Set edge of plot = edge of device
    par(mar = rep(0, 4))
    plot(tree)
    
    # Add a PhyloPic silhouette of a cat to the tree
    add_phylopic_tree(
      tree,
      "cat",
      uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
      relWidth = 0.1,
      vjust = 0.2,
      fill = "brown"
    )
    
    # Add a mouse, by taxon name
    expect_warning(
      add_phylopic_tree(
        tree,
        "mouse",
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
        tree,
        "dog",
        relWidth = 0.16,
        padding = -0.08, # Half off the page
        fill = "#665566"
      ),
      "used the .name. argument"
    )
    
    # Fail gracefully if taxon missing
    expect_error(
      add_phylopic_tree(
        tree,
        "maus", # Should throw error
        uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9", # Silhouette to plot
        fill = "red"
      ),
      "Could not find 'maus' in tree.tip.label.  Did you mean 'mouse'\\?"
    )
  })

  expect_doppelganger("Add vector of silhouettes to tree", function() {
    # Load the ape library to work with phylogenetic trees
    library("ape")
    
    # Read a phylogenetic tree
    tree <- ape::read.tree(text = "(cat, (dog, mouse));")
  
    # Set edge of plot = edge of device
    par(mar = rep(0, 4)) 
    plot(tree)
    
    # Add a vector of silhouettes to the tree
    add_phylopic_tree(
      tree = tree,
      uuid = c(cat = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
               mouse = "dd0a795e-4be3-4f99-a084-2427c1319d31",
               dog = "6f3ebbc6-be53-4216-b45b-946f7984669b"),
      relWidth = c(0.1, 0.2, 0.16),
      padding = c(1/200, 0.8, -0.08),
      vjust = c(0.2, 1, 1),
      fill = c("brown", "lightblue", "#665566"),
    )
    
    # Check leaf validation
    expect_error(add_phylopic_tree(
      tree = tree,
      tip = c("cat", "mouse", "dawg", "maus", "non-existent taxon"),
      uuid = c("23cd6aa4-9587-4a2e-8e26-de42885004c9",
               "dd0a795e-4be3-4f99-a084-2427c1319d31",
               "6f3ebbc6-be53-4216-b45b-946f7984669b",
               "dd0a795e-4be3-4f99-a084-2427c1319d31",
               "dd0a795e-4be3-4f99-a084-2427c1319d31"
               ),
      relWidth = c(0.1, 0.2, 0.16, 9, 9),
      padding = c(1/200, 0.8, -0.08, 0, 0),
      vjust = c(0.2, 1, 1, 0.5, 0.5),
      fill = c("brown", "lightblue", "#665566", "red", "red"),
      ),
    "Could not find 'dawg', 'maus', 'no.+on' in tree.+ mean 'dog', 'mouse'\\?"
    )
  })
})
