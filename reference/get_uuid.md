# Get a PhyloPic uuid

This function provides a convenient way to obtain a valid uuid or image
url for an input taxonomic name. As multiple silhouettes can exist for
each species in PhyloPic, this function extracts the primary image.

## Usage

``` r
get_uuid(name = NULL, img = NULL, n = 1, filter = NULL, url = FALSE)
```

## Arguments

- name:

  `character`. A taxonomic name. Various taxonomic levels are supported
  (e.g. species, genus, family). NULL can also be supplied which will
  skip the taxonomic filtering of the PhyloPic database.

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object from
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).
  A list of these objects can also be supplied. If `img` is supplied,
  `name` and `n` are ignored. Defaults to NULL.

- n:

  `numeric`. How many uuids should be returned? Depending on the
  requested `name`, multiple silhouettes might exist. If `n` exceeds the
  number of available images, all available uuids will be returned. This
  argument defaults to 1.

- filter:

  `character`. Filter uuid(s) by usage license. Use "by" to limit
  results to image uuids which do not require attribution, "nc" for
  image uuids which allow commercial usage, and "sa" for image uuids
  without a ShareAlike clause. The user can also combine these filters
  as a vector.

- url:

  `logical`. If `FALSE` (default), only the uuid is returned. If `TRUE`,
  a valid PhyloPic image url of the uuid is returned.

## Value

A `character` vector of a valid PhyloPic uuid or svg image url.

## Details

This function returns uuid(s) or image url (svg) for an input `name`. If
a specific image is desired, the user can make use of
[pick_phylopic](https://rphylopic.palaeoverse.org/reference/pick_phylopic.md)
to visually select the desired uuid/url.

## Examples

``` r
if (FALSE) { # \dontrun{
uuid <- get_uuid(name = "Acropora cervicornis")
uuid <- get_uuid(name = "Dinosauria", n = 5, url = TRUE)
} # }
```
