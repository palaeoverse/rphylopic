# Use a taxonomic name from another database to get a PhyloPic image UUID

This function takes a supplied taxonomic name, queries it via the
specified external API, resolves the API's returned taxonomic ID to the
PhyloPic taxonomic node database, then retrieves PhyloPic image uuids
(or urls) for that node.

## Usage

``` r
resolve_phylopic(
  name,
  api = "gbif.org",
  hierarchy = FALSE,
  max_ranks = 5,
  n = 1,
  filter = NULL,
  url = FALSE
)
```

## Arguments

- name:

  `character`. A full or partial taxonomic name to be queried via the
  specified `api`.

- api:

  `character`. The API in which to query `name`. See Details for the
  available options.

- hierarchy:

  `logical`. Whether the taxonomic hierarchy of `name` should be
  retrieved from the API and used to get several sets of PhyloPic image
  uuids (or urls).

- max_ranks:

  `numeric`. The maximum number of taxonomic ranks that should be
  included if `hierarchy` is `TRUE`.

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

A `list` where each value is `n` (or fewer) PhyloPic image uuids (or
urls if `url = TRUE`) and each name is the taxonomic name as matched and
reported by the specified `api`. If `hierarchy` is `FALSE`, the list has
length 1. If `hierarchy` is `TRUE`, the list has maximum length
`max_ranks`.

## Details

If `hierarchy` is `FALSE`, the specified `name` is queried via the
specified `api`. The matched id is then resolved to the matching
taxonomic node in the PhyloPic database. If `hierarchy` is `TRUE`, the
full taxonomic hierarchy for `name` is retrieved from the specified
`api`, those taxonomic names are subset to `max_ranks` ranks (starting
from the specified `name` and ascending the hierarchy). Then each of
those names is resolved to the matching taxonomic node in the PhyloPic
database (where possible). In either case,
[`get_uuid()`](https://rphylopic.palaeoverse.org/reference/get_uuid.md)
is then used to retrieve `n` image UUID(s) for each taxonomic name.

Note that while the names of the returned list are the taxonomic names
as reported by the specified `api`, the PhyloPic images that are
returned are associated with whatever taxonomic node that taxonomic name
resolves to in the PhyloPic database. This means that, if `hierarchy` is
`TRUE`, the same images may be returned for multiple taxonomic names.
Also, if a particular taxonomic name does not resolve to any node in the
PhyloPic database, no images will be returned for that name.

The following APIs are available for querying (`api`):

- "eol.org": the [Encyclopedia of Life](https://eol.org/) (note:
  `hierarchy = TRUE` is not currently available for this API) ("eol" is
  also allowed)

- "gbif.org": the [Global Biodiversity Information
  Facility](https://www.gbif.org/) ("gbif" is also allowed)

- "marinespecies.org": the [World Registor of Marine
  Species](https://marinespecies.org/) ("worms" is also allowed)

- "opentreeoflife.org": the [Open Tree of
  Life](https://tree.opentreeoflife.org/) ("otol" is also allowed)

- "paleobiodb.org": the [Paleobiology
  Database](https://paleobiodb.org/#/) ("pbdb" is also allowed)

## Examples

``` r
if (FALSE) { # \dontrun{
# get a uuid for a single name
resolve_phylopic(name = "Canis lupus")
# get uuids for the taxonomic hierarchy
resolve_phylopic(name = "Velociraptor mongoliensis", api = "paleobiodb.org",
                 hierarchy = TRUE, max_ranks = 3)
} # }
```
