# Pick a PhyloPic image from available options

This function provides a visually interactive way to pick an image and
valid uuid for an input taxonomic name. As multiple silhouettes can
exist for each organism in PhyloPic, this function is useful for
choosing the right image/uuid for the user.

## Usage

``` r
pick_phylopic(
  name = NULL,
  n = 5,
  uuid = NULL,
  view = 1,
  filter = NULL,
  auto = NULL
)
```

## Arguments

- name:

  `character`. A taxonomic name. Different taxonomic levels are
  supported (e.g. species, genus, family).

- n:

  `numeric`. How many uuids should be viewed? Depending on the requested
  `name`, multiple silhouettes may exist. If `n` exceeds the number of
  available images, all available uuids will be returned. Defaults to 5.
  Only relevant if `name` supplied.

- uuid:

  `character`. A vector (or list) of valid PhyloPic silhouette uuids,
  such as that returned by
  [`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md)
  or
  [`resolve_phylopic()`](https://rphylopic.palaeoverse.org/reference/resolve_phylopic.md).

- view:

  `numeric`. Number of silhouettes that should be plotted at the same
  time. Defaults to 1.

- filter:

  `character`. Filter uuid(s) by usage license. Use "by" to limit
  results to image uuids which do not require attribution, "nc" for
  image uuids which allow commercial usage, and "sa" for image uuids
  without a ShareAlike clause. The user can also combine these filters.
  Only relevant if `name` supplied.

- auto:

  `numeric`. This argument allows the user to automate input into the
  menu choice. If the input value is `1`, the first returned image will
  be selected. If the input value is `2`, requested images will be
  automatically cycled through with the final image returned. If the
  input value is `3`, a list of attribution information for each image
  is returned (this functionality is principally intended for testing).
  If `NULL` (default), the user must interactively respond to the called
  menu.

## Value

A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) object
is returned. The uuid of the selected image is saved as the "uuid"
attribute of the returned object and is also printed to console.

## Details

This function allows the user to visually select the desired image from
a pool of silhouettes available for the input `name`.

Note that while the `view` argument can be any positive integer,
weaker/older computers may have issues displaying very large numbers of
images at the same time (i.e. `view` \> 9). If no images are displayed
in your plotting environment, try decreasing the value of `view`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Defaults pane layout
img <- pick_phylopic(name = "Canis lupus", n = 5)
# 3 x 3 pane layout
img <- pick_phylopic(name = "Scleractinia", n = 9, view = 9)
} # }
```
