#' Colour scales for ggplot2
#'
#' Colour and fill scales for ggplot2
#' plots, using object of class \code{palettehex}.
#'
#' The \code{palettehex} class is a data.frame of
#' many palettes. This function takes such a data.frame
#' and a choice of palette by name, id or numeric index
#' can be made for the scale.
#'
#' @param x object of class \code{palettehex}
#' @param which selection of which palette of a set to choose. Either by name,
#'     id or numeric index.
#' @param reverse logical. If scale should b reversed (default: FALSE)
#' @param ... arguments to be passed to \code{\link[ggplot2]{discrete_scale}}
#'
#' @name scale-palettehex
#' @return ggplot2-proto
#' @examples
#' if(colorhex_access()){
#' library(ggplot2)
#'
#' x <- get_popular_palettes()
#'
#' ggplot(mtcars, aes(mpg)) +
#'    geom_density(aes(fill = disp, group = disp)) +
#'    scale_fill_palettehex_c(x)
#'
#' ggplot(mtcars, aes(mpg)) +
#'   geom_density(aes(fill = disp, group = disp)) +
#'   scale_fill_palettehex_c(x, 3)
#'
#' ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
#'    geom_point() +
#'    scale_color_palettehex_d(x)
#'
#' ggplot(mtcars, aes(mpg, disp, colour = factor(cyl))) +
#'    geom_point() +
#'    scale_color_palettehex_d(x, 1872)
#' }
NULL
#> NULL

#' @describeIn scale-palettehex Discrete colour scale
#' @export
scale_colour_palettehex_d <- function(x,
                                    which = 1,
                                    reverse = FALSE,
                                    ...) {
  ggplot2::discrete_scale(
    "colour", "palettehex_d",
    palettehex_pal(x, which, reverse),
    ...
  )
}

#' @describeIn scale-palettehex Discrete colour scale
#' @export
scale_color_palettehex_d <- scale_colour_palettehex_d

#' @describeIn scale-palettehex Discrete fill scale
#' @export
scale_fill_palettehex_d <- function(x,
                                  which = 1,
                                  reverse = FALSE,
                                  ...) {
  ggplot2::discrete_scale(
    "fill", "palettehex_d",
    palettehex_pal(x, which, reverse),
    ...
  )
}

#' @describeIn scale-palettehex Continuous colour scale
#' @export
scale_colour_palettehex_c <- function(x,
                                      which = 1,
                                      reverse = FALSE,
                                    ...) {
  n <- length(find_pal(x, which))
  cols <- palettehex_pal(x, which, reverse)(n)

  ggplot2::scale_colour_gradientn(colours = cols,
                                  ...)
}

#' @describeIn scale-palettehex Continuous colour scale
#' @export
scale_color_palettehex_c <- scale_colour_palettehex_c

#' @describeIn scale-palettehex Continuous fill scale
#' @export
scale_fill_palettehex_c <- function(x,
                                    which = 1,
                                  reverse = FALSE,
                                  ...) {
  n <- length(find_pal(x, which))
  cols <- palettehex_pal(x, which, reverse)(n)

  ggplot2::scale_fill_gradientn(colours = cols,
                                ...)
}

# pal-maker ----
palettehex_pal <- function(x,
                         which = 1,
                         reverse = FALSE) {
  cols <- find_pal(x, which)

  function(n) {
    if (n > length(cols))
      warning(sprintf("palettehex only has %s colors.", length(cols)))

    cols <- cols[1:n]
    cols <- cols[!is.na(cols)]

    if (!reverse) cols else rev(cols)
  }
}


find_pal <- function(x, which){

  idx <- match(which, x$name)
  if(!is.na(idx)) return(x$palette[[idx]])

  idx <- match(which, x$id)
  if(!is.na(idx)) return(x$palette[[idx]])

  x$palette[[which]]

}
