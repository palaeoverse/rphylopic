# Rotate a PhyloPic silhouette

The picture can be a
[Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or png
array object, e.g., from using
[`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).
Note that png array objects can only be rotated by multiples of 90
degrees.

## Usage

``` r
rotate_phylopic(img, angle = 90)
```

## Arguments

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object, e.g., from using
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

- angle:

  `numeric`. The number of degrees to rotate the silhouette clockwise.

## Value

A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or png
array object (matching the type of `img`)

## See also

Other transformations:
[`flip_phylopic()`](https://rphylopic.palaeoverse.org/reference/flip_phylopic.md),
[`recolor_phylopic()`](https://rphylopic.palaeoverse.org/reference/recolor_phylopic.md)
