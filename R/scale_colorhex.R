#' Colour scales for ggplot2
#'
#' Colour and fill scales for ggplot2
#' plots, using object of class \code{colorhex}
#' as basis for colour choices.
#'
#' The \code{colorhex} class is a list where there
#' is a variety of extra information on the hex
#' colour selected. This information can be used
#' to create colour scales to be used in ggplot2.
#'
#' @param x object of class \code{colorhex}
#' @param type character. Type of colours to use.
#'   One of c("complementary", "triadic" (default), "shades", "tints", "related")
#' @param reverse logical. If scale should b reversed (default: FALSE)
#' @param ... arguments to be passed to \code{\link[ggplot2]{discrete_scale}}
#'
#' @name scale-colorhex
#' @examples
#' library(ggplot2)
#'
#' x <- get_color("#008080")
#'
#' ggplot(mtcars, aes(mpg)) +
#'    geom_density(aes(fill = disp, group = disp)) +
#'    scale_fill_colorhex_c(x)
#'
#' ggplot(mtcars, aes(mpg)) +
#'   geom_density(aes(fill = disp, group = disp)) +
#'   scale_fill_colorhex_c(x, "tints")
#'
#' ggplot(mtcars, aes(mpg)) +
#'   geom_density(aes(fill = disp, group = disp)) +
#'   scale_fill_colorhex_c(x, "shades")
#'
#' ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
#'    geom_point() +
#'    scale_color_colorhex_d(x, "triadic")
#'
#' ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
#'    geom_point() +
#'    scale_color_colorhex_d(x, "shades")
NULL
#> NULL

#' @describeIn scale-colorhex Discrete colour scale
#' @export
scale_colour_colorhex_d <- function(x,
                                    type = "triadic",
                                    reverse = FALSE,
                                    ...) {
  ggplot2::discrete_scale(
    "colour", "colorhex_d",
    colorhex_pal(x, type, reverse),
    ...
  )
}

#' @describeIn scale-colorhex Discrete colour scale
#' @export
scale_color_colorhex_d <- scale_colour_colorhex_d

#' @describeIn scale-colorhex Discrete fill scale
#' @export
scale_fill_colorhex_d <- function(x,
                                  type = "triadic",
                                  reverse = FALSE,
                                  ...) {
  ggplot2::discrete_scale(
    "fill", "colorhex_d",
    colorhex_pal(x, type, reverse),
    ...
  )
}

#' @describeIn scale-colorhex Continuous colour scale
#' @export
scale_colour_colorhex_c <- function(x,
                                    type = "complementary",
                                    reverse = FALSE,
                                    ...) {
  type <- match.arg(type, c("complementary", "triadic",
                            "shades", "tints", "related"))
  n <- length(c(x$hex, x[[type]]))
  cols <- colorhex_pal(x, type, reverse)(n)

  ggplot2::scale_colour_gradientn(colours = cols,
                                  ...)
}

#' @describeIn scale-colorhex Continuous colour scale
#' @export
scale_color_colorhex_c <- scale_colour_colorhex_c

#' @describeIn scale-colorhex Continuous fill scale
#' @export
scale_fill_colorhex_c <- function(x,
                                  type = "complementary",
                                  reverse = FALSE,
                                  ...) {
  type <- match.arg(type, c("complementary", "triadic",
                            "shades", "tints", "related"))
  n <- length(c(x$hex, x[[type]]))
  cols <- colorhex_pal(x, type, reverse)(n)

  ggplot2::scale_fill_gradientn(colours = cols,
                                ...)
}

# pal-maker ----
colorhex_pal <- function(x,
                         type = "complementary",
                         reverse = FALSE) {

  type <- match.arg(type, c("complementary", "triadic",
                            "shades", "tints", "related"))

  function(n) {
    cols <- c(x$hex, x[[type]])

    if (n > length(cols))
      warning(sprintf("colorhex only has %s colors.", length(cols)))

    cols <- cols[1:n]
    cols <- cols[!is.na(cols)]

    if (!reverse) cols else rev(cols)
  }
}
