\name{make_phylo}
\alias{make_phylo}
\title{Make phylogeny with Phylopic images}
\usage{
  make_phylo(pngobj, phytheme = theme_phylo_blank2())
}
\arguments{
  \item{pngobj}{Object from get_image function}

  \item{phytheme}{The ggplot2 style layout. You can write
  your own theme and pass it in to the function. See
  example below.}
}
\description{
  Make phylogeny with Phylopic images
}
\examples{
toget <- c("27356f15-3cf8-47e8-ab41-71c6260b2724", "bd88f674-6976-4cb2-a46e-e6a12a8ba463", "e547cd01-7dd1-495b-8239-52cf9971a609", "9c6af553-390c-4bdd-baeb-6992cbc540b1", "e547cd01-7dd1-495b-8239-52cf9971a609", "bd88f674-6976-4cb2-a46e-e6a12a8ba463")
myobjs <- get_image(uuids = toget, size = "thumb")
make_phylo(pngobj=myobjs)
make_phylo(pngobj=myobjs, phytheme=NULL)

# Make your own theme
mytheme <- theme_phylo_blank2() + ggplot2::theme(panel.background=element_rect(fill="lightblue"))
make_phylo(pngobj=myobjs, phytheme=mytheme)
}

