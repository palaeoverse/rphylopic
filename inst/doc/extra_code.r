m <- readPNG(system.file("img", "Rlogo.png", package="png"), FALSE)
w <- matrix(rgb(m[,,1],m[,,2],m[,,3], m[,,4] * 0.2), nrow=dim(m)[1]) #0.2 is alpha

qplot(1:10, rnorm(10), geom = "blank") +
  annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf, 
                    rpatternGrob(motif=shit_butt, motif.width = unit(1, "cm"))) +
  geom_point()

shit <- readPNG(getURLContent("http://phylopic.org/assets/images/submissions/9fae30cd-fb59-4a81-a39c-e1826a35f612.thumb.png"))
img <- readPNG(getURLContent("http://phylopic.org/assets/images/submissions/27356f15-3cf8-47e8-ab41-71c6260b2724.512.png"))
shit_butt <- matrix(rgb(shit[,,1],shit[,,2],shit[,,3], shit[,,4] * 0.2), nrow=dim(shit)[1]) #0.2 is alpha

qplot(1:10, rnorm(10), geom = "blank") +
  annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf, rasterGrob(shit_butt)) +
  geom_point()

rasterImage(shit)

library(ggphylo)

plot.args <- list(
  x,
  line.color.by='bootstrap',
  line.color.scale=scale_colour_gradient(limits=c(50, 100), low='red', high='black'), node.size.by='pop.size',
  node.size.scale = scale_size_continuous(limits=c(0, 100000), range=c(1, 5)), label.size=2
)

tree <- rcoal(20)
ggphylo(tree) + annotation_custom(xmin=2.5, ymin=18, xmax=2.8, ymax=20, rasterGrob(shit_butt))



plot(bird.orders, "c", FALSE, font = 1, label.offset = 3,
     x.lim = 31, no.margin = TRUE)
tiplabels(pch = 21, bg = gray(1:23/23), cex = 2, adj = 1.4)