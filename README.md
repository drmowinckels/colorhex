
<!-- README.md is generated from README.Rmd. Please edit that file -->

# colorhex

<!-- badges: start -->

[![R build
status](https://github.com/Athanasiamo/colorhex/workflows/R-CMD-check/badge.svg)](https://github.com/Athanasiamo/colorhex/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/colorhex)](https://CRAN.R-project.org/package=colorhex)
<!-- badges: end -->

The goal of colorhex is to create an interface to
[www.color-hex.com](www.color-hex.com), a website with hexidecimal
colors and information about them. It also has lots of user-made
palettes that can be used and browsed.

## Installation

<!-- You can install the released version of colorhex from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("colorhex") -->

<!-- ``` -->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Athanasiamo/colorhex")
```

## Example

### Single colors

``` r
library(colorhex)

x <- get_color("#470f0f")
x
#> # Color-hex: #470f0f
#> RGB: 71, 15, 15
#> HSL: 0.00, 0.65, 0.17
#> CMYK: 0.00, 0.79, 0.79   0.72
#> triadic: #0f470f, #0f0f47
#> complementary: #0f4747
#> used in 2 palettes
plot(x)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
x <- get_popular_colors()
x
#>  [1] "#696969" "#bada55" "#7fe5f0" "#ff0000" "#ff80ed" "#407294" "#cbcba9"
#>  [8] "#ffffff" "#420420" "#133337" "#065535" "#c0c0c0" "#5ac18e" "#000000"
#> [15] "#666666" "#dcedc1" "#f7347a" "#576675" "#ffc0cb" "#ffe4e1" "#696966"
#> [22] "#008080" "#ffd700" "#e6e6fa" "#ffa500" "#ff7373" "#00ffff" "#40e0d0"
#> [29] "#0000ff" "#f0f8ff" "#d3ffce" "#b0e0e6" "#c6e2ff" "#faebd7" "#003366"
#> [36] "#fa8072" "#ffff00" "#7fffd4" "#ffb6c1" "#800000" "#c39797" "#800080"
#> [43] "#eeeeee" "#00ff00" "#f08080" "#fff68f" "#cccccc" "#ffc3a0" "#20b2aa"
#> [50] "#333333" "#66cdaa" "#ff6666" "#ff00ff" "#4ca3dd" "#ffdab9" "#c0d6e4"
#> [57] "#ff7f50" "#468499" "#f6546a" "#afeeee" "#008000" "#660066" "#cbbeb5"
#> [64] "#00ced1" "#b6fcd5" "#0e2f44" "#990000" "#088da5" "#daa520" "#b4eeb4"
#> [71] "#101010" "#808080" "#f5f5f5" "#8b0000" "#6897bb" "#ffff66" "#000080"
#> [78] "#f5f5dc" "#81d8d0" "#ccff00" "#ff4040" "#dddddd" "#66cccc" "#8a2be2"
scales::show_col(x)
```

<img src="man/figures/README-pop-cols-1.png" width="100%" />

### Palettes

``` r
latest <- get_latest_palettes()
plot(latest)
```

<img src="man/figures/README-latest-1.png" width="100%" />

``` r
popular <- get_popular_palettes()
plot(popular)
```

<img src="man/figures/README-popular-palettes-1.png" width="100%" />

### ggplot2 scales

``` r
library(ggplot2)

ggplot(mtcars, aes(mpg)) +
   geom_density(aes(fill = disp, group = disp)) +
   scale_fill_palettehex_c(popular)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg)) +
  geom_density(aes(fill = disp, group = disp)) +
  scale_fill_palettehex_c(popular, 3)
```

<img src="man/figures/README-unnamed-chunk-2-2.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
   geom_point() +
   scale_color_palettehex_d(popular)
```

<img src="man/figures/README-unnamed-chunk-2-3.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
   geom_point() +
   scale_color_palettehex_d(popular, 1872)
```

<img src="man/figures/README-unnamed-chunk-2-4.png" width="100%" />

``` r
x <- get_color("#008080")

ggplot(mtcars, aes(mpg)) +
   geom_density(aes(fill = disp, group = disp)) +
   scale_fill_colorhex_c(x)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg)) +
  geom_density(aes(fill = disp, group = disp)) +
  scale_fill_colorhex_c(x, "tints")
```

<img src="man/figures/README-unnamed-chunk-3-2.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg)) +
  geom_density(aes(fill = disp, group = disp)) +
  scale_fill_colorhex_c(x, "shades")
```

<img src="man/figures/README-unnamed-chunk-3-3.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
   geom_point() +
   scale_color_colorhex_d(x, "triadic")
```

<img src="man/figures/README-unnamed-chunk-3-4.png" width="100%" />

``` r

ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
   geom_point() +
   scale_color_colorhex_d(x, "shades")
```

<img src="man/figures/README-unnamed-chunk-3-5.png" width="100%" />
