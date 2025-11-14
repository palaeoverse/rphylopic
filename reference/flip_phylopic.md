# Flip a PhyloPic silhouette along its horizontal and/or vertical axis

The picture can be a
[Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or png
array object, e.g., from using
[`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

## Usage

``` r
flip_phylopic(img, horizontal = TRUE, vertical = FALSE)
```

## Arguments

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object, e.g., from using
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

- horizontal:

  `logical`. Should the silhouette be flipped horizontally?

- vertical:

  `logical`. Should the silhouette be flipped vertically?

## Value

A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or png
array object (matching the type of `img`)

## See also

Other transformations:
[`recolor_phylopic()`](https://rphylopic.palaeoverse.org/reference/recolor_phylopic.md),
[`rotate_phylopic()`](https://rphylopic.palaeoverse.org/reference/rotate_phylopic.md)
