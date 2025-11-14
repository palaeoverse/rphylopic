# Browse PhyloPic for a given taxonomic name or uuid

This function provides a convenient way to browse PhyloPic for a given
taxonomic name of uuid.

## Usage

``` r
browse_phylopic(name = NULL, uuid = NULL)
```

## Arguments

- name:

  `character`. A taxonomic name. Various taxonomic levels are supported
  (e.g. species, genus, family).

- uuid:

  `character`. A PhyloPic image uuid, as acquired by
  [`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md).

## Value

A `character` vector of a valid PhyloPic url for the specified `name` or
`uuid`. If no `name` or `uuid` is supplied, the base url of PhyloPic
images is returned.

## Details

This function returns a PhyloPic url for an input `name` or `uuid` and
opens the user's default web browser at this url. If no `name` or `uuid`
is supplied, the base url of PhyloPic images is returned and opened
instead.

## Examples

``` r
if (FALSE) { # \dontrun{
url <- browse_phylopic(name = "Acropora cervicornis")
} # }
```
