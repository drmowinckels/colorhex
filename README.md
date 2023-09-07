
<!-- README.md is generated from README.Rmd. Please edit that file -->

# colorhex

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/colorhex)](https://CRAN.R-project.org/package=colorhex)
[![R-CMD-check](https://github.com/Athanasiamo/colorhex/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Athanasiamo/colorhex/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of colorhex is to create an interface to
[color-hex.com](https://www.color-hex.com/), a website with hexidecimal
colors and information about them.

It also has lots of user-made palettes that can be used and browsed.

## Installation

<!-- You can install the released version of colorhex from [CRAN](https://CRAN.R-project.org) with: -->
<!-- ``` r -->
<!-- install.packages("colorhex") -->
<!-- ``` -->

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("drmowinckels/colorhex", ref = "main")
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
#>  [1] "#ff80ed" "#065535" "#000000" "#133337" "#ffc0cb" "#ffffff" "#ffe4e1"
#>  [8] "#008080" "#ff0000" "#e6e6fa" "#ffd700" "#00ffff" "#ffa500" "#0000ff"
#> [15] "#ff7373" "#c6e2ff" "#40e0d0" "#b0e0e6" "#d3ffce" "#f0f8ff" "#666666"
#> [22] "#bada55" "#faebd7" "#fa8072" "#003366" "#ffb6c1" "#c0c0c0" "#ffff00"
#> [29] "#800000" "#800080" "#c39797" "#00ff00" "#7fffd4" "#eeeeee" "#fff68f"
#> [36] "#cccccc" "#f08080" "#20b2aa" "#ffc3a0" "#333333" "#66cdaa" "#c0d6e4"
#> [43] "#ff6666" "#ff00ff" "#ffdab9" "#cbbeb5" "#ff7f50" "#468499" "#afeeee"
#> [50] "#b4eeb4" "#00ced1" "#008000" "#f6546a" "#660066" "#0e2f44" "#b6fcd5"
#> [57] "#990000" "#696969" "#f5f5f5" "#daa520" "#000080" "#6897bb" "#808080"
#> [64] "#f5f5dc" "#088da5" "#8b0000" "#8a2be2" "#81d8d0" "#ccff00" "#ff4040"
#> [71] "#ffff66" "#dddddd" "#2acaea" "#101010" "#0a75ad" "#420420" "#ff1493"
#> [78] "#66cccc" "#a0db8e" "#999999" "#794044" "#3399ff" "#cc0000" "#00ff7f"
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
