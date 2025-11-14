# Get PhyloPic attribution data

This function provides a convenient way to obtain attribution data for
PhyloPic images via an image uuid returned by
[`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md).

## Usage

``` r
get_attribution(uuid = NULL, img = NULL, text = FALSE, permalink = FALSE)
```

## Arguments

- uuid:

  `character`. A vector of valid uuid(s) for PhyloPic silhouette(s) such
  as that returned by
  [`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md)
  or
  [`pick_phylopic()`](https://rphylopic.palaeoverse.org/reference/pick_phylopic.md).

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object from
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).
  A list of these objects can also be supplied. If `img` is supplied,
  `uuid` is ignored. Defaults to NULL.

- text:

  `logical`. Should attribution information be returned as a text
  paragraph? Defaults to `FALSE`.

- permalink:

  `logical`. Should a permalink be created for this collection of
  `uuid`(s)? Defaults to `FALSE`.

## Value

A `list` of PhyloPic attribution data for an image `uuid` or a text
output of relevant attribution information.

## Details

This function returns image `uuid` specific attribution data, including:
contributor name, contributor uuid, contributor contact, image uuid,
license, and license abbreviation. If `text` is set to `TRUE`, a text
paragraph with the contributor name, year of contribution, and license
type is printed and image attribution data is returned invisibly (i.e.
using [`invisible()`](https://rdrr.io/r/base/invisible.html). If
`permalink` is set to `TRUE`, a permanent link (hosted by
[PhyloPic](https://www.phylopic.org)) will be generated. This link can
be used to view and share details about the image silhouettes, including
contributors and licenses.

## Examples

``` r
if (FALSE) { # \dontrun{
# Get valid uuid
uuid <- get_uuid(name = "Acropora cervicornis")
# Get attribution data for uuid
attri <- get_attribution(uuid = uuid)

# Get list of valid uuids
uuids <- get_uuid(name = "Scleractinia", n = 5)
# Get attribution data for uuids
get_attribution(uuid = uuids, text = TRUE)
# Get attribution data for uuids and create permalink
get_attribution(uuid = uuids, text = TRUE, permalink = TRUE)
} # }
```
