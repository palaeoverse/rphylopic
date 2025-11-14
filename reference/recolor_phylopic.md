# Recolor a PhyloPic image

Function to recolor and change alpha levels of a PhyloPic image.

## Usage

``` r
recolor_phylopic(
  img,
  alpha = 1,
  color = NULL,
  fill = NULL,
  remove_background = TRUE
)
```

## Arguments

- img:

  A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or
  png array object, e.g., from using
  [`get_phylopic()`](https://rphylopic.palaeoverse.org/reference/get_phylopic.md).

- alpha:

  `numeric`. A value between 0 and 1, specifying the opacity of the
  silhouette.

- color:

  `character`. Color to make the outline of the silhouette. If NULL, the
  outline color is not changed.

- fill:

  `character`. Color to make the body of the silhouette. If NULL, the
  body color is not changed.

- remove_background:

  `logical`. Should any white background be removed? Only useful if
  `img` is a
  [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html)
  object. See details.

## Value

A [Picture](https://rdrr.io/pkg/grImport2/man/Picture-class.html) or png
array object (matching the type of `img`)

## Details

Some PhyloPic silhouettes do not have a transparent background.
Consequently, when color is used with vectorized versions of these
images, the entire image–including the background–is recolored. Setting
`remove_background` to `TRUE` (the default) will remove any white parts
of the image (which should only be the background).

## See also

Other transformations:
[`flip_phylopic()`](https://rphylopic.palaeoverse.org/reference/flip_phylopic.md),
[`rotate_phylopic()`](https://rphylopic.palaeoverse.org/reference/rotate_phylopic.md)
