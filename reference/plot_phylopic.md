# Preview a PhyloPic silhouette

Preview a raster or vector representation of a PhyloPic silhouette. This
will plot the silhouette on a new page in your default plotting device.

## Usage

``` r
# S3 method for class 'Picture'
plot(x, ...)

# S3 method for class 'phylopic'
plot(x, ...)
```

## Arguments

- x:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object, e.g., from using
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

- ...:

  Other arguments passed on to
  [`grImport2::grid.picture()`](https://rdrr.io/pkg/grImport2/man/grid.picture.html)
  or [`grid::grid.raster()`](https://rdrr.io/r/grid/grid.raster.html).
