\name{search_images}
\alias{search_images}
\title{Search for images for the taxa}
\usage{
  search_images(uuid, subtaxa = NULL, options = NULL,
    cleanoutput = TRUE)
}
\arguments{
  \item{uuid}{The UUID of the taxonomic name.}

  \item{subtaxa}{If set to "true", includes subtaxa in the
  search.}

  \item{supertaxa}{If not set to "false", includes
  supertaxa in the search.}

  \item{options}{Space-separated list of options for the
  result value.}

  \item{cleanoutput}{If TRUE, remove elements with no
  data.}
}
\description{
  Search for images for the taxa
}
\examples{
\dontrun{
someuuids <- search_text(text = "Homo sapiens", options = "names")
search_images(uuid=someuuids[[12]], options=c("pngFiles", "credit", "canonicalName"))

# all of them
search_images(uuid=someuuids, options=c("pngFiles", "credit", "canonicalName"))
}
}

