\name{get_image}
\alias{get_image}
\title{Get an image from a uuid.}
\usage{
  get_image(uuids, size)
}
\arguments{
  \item{uuids}{One to many uuids, possibly from the
  function search_images}
}
\description{
  Get an image from a uuid.
}
\examples{
\dontrun{
toget <- c("27356f15-3cf8-47e8-ab41-71c6260b2724", "bd88f674-6976-4cb2-a46e-e6a12a8ba463", "e547cd01-7dd1-495b-8239-52cf9971a609")
get_image(uuids = toget, size = "512")
get_image(uuids = toget, size = "thumb")
}
}
\seealso{
  \code{\link{search_images}}
}

