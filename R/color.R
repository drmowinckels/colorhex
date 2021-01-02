#' Get popular colour
#'
#' www.color-hex.com has a list of colours
#' that have been liked by the most users.
#' This function will retrieve all of these.
#'
#' @return character vector of hex colours
#' @export
#'
#' @examples
#' get_popular_colors()
get_popular_colors <- function(){
  url <- paste0(colour_url(), "popular-colors.php")
  resp <- xml2::read_html(url)

  cols <- rvest::html_nodes(resp,
                            xpath = '//*[@class="colordva"]')
  cols <- as.character(cols)
  get_bkg_color(cols)
}

#' Generate random HEX colour
#'
#' @return character hex value
#' @export
#'
#' @examples
#' get_random_color()
get_random_color <- function(){
  grDevices::rgb(randcol(),
                 randcol(),
                 randcol(),
                 maxColorValue = 255)
}

randcol <- function(){
  sample(1:255, 1)
}

#' Get color information
#'
#' Get color information from www.color-hex.com
#' of a hex-color.
#'
#' @param hex character string that is a hexdecimal color
#'
#' @return list of class 'colorhex'
#' @export
#'
#' @examples
#' get_color("#470f0f")
#' get_color("#f2f2f2")
get_color <- function(hex){
  hex <- fix_hex(hex)
  stopifnot(is_hex(hex))

  url <- paste0(colour_url(), "color/", gsub("#", "", hex))

  resp <- xml2::read_html(url)
  tables <- rvest::html_nodes(resp, "table")

  prim <- rvest::html_table(tables[1], fill = TRUE)[[1]]
  prim <- as.data.frame(t(prim))
  names(prim) <- prim[1,]
  row.names(prim) <- NULL
  prim <- prim[-1,]

  ret <- list(
    hex = hex,
    space = prim,
    base = rvest::html_table(tables[2], fill = TRUE)[[1]]
  )

  if(length(tables) > 2){
    ret <- c(
      ret,
      list(
        triadic = fix_hex(chartable(tables[3])),
        analogous = fix_hex(chartable(tables[4])),
        complementary = fix_hex(chartable(tables[5]))
      )
    )
  }else{
    ret <- c(
      ret,
      list(
        triadic = NA_character_,
        analogous = NA_character_,
        complementary = NA_character_
      )
    )
  }

  rows <- rvest::html_nodes(resp,
                            xpath = '//*[@class="colordvconline"]')
  rows <- rvest::html_text(rows)
  rows <- gsub(" \n", "", rows)
  rows <- fix_hex(rows)

  ret <- c(
    ret,
    list(
      shades = rows[1:11],
      tints = rows[12:22]
    )
  )

  colorhex(ret)
}

colorhex <- function(x){
  stopifnot(names(x) %in% c("hex",
                            "space", "base",
                            "complementary", "analogous",
                            "triadic", "shades", "tints"))

  structure(
    x,
    class = "colorhex"
  )
}

#' @export
format.colorhex <- function(x, ...){
  c(
    sprintf("# Color-hex: %s", x$hex),
    sprintf("RGB: %s", paste0(x$space[, "RGB"], collapse=", ")),
    sprintf("HSL: %s", paste0(x$space[, "HSL"], collapse=", ")),
    sprintf("CMYK: %s", paste0(x$space[, "CMYK"], collapse=", ")),
    sprintf("triadic: %s", paste0(x$triadic, collapse = ", ")),
    sprintf("complementary: %s", x$complementary)
  )
}

#' @export
print.colorhex <- function(x, ...){
  cat(format(x), sep="\n")
  invisible(x)
}

#' @export
plot.colorhex <- function(x,
                          type = c("complementary", "triadic",
                                   "analogous", "shades", "tints"),
                          labels = TRUE, ...){

  type <- match.arg(type,
                    c("complementary", "triadic",
                      "analogous", "shades", "tints"),
                    several.ok = TRUE)

  x <- lapply(type, function(y) if(y != "hex") c(x$hex, x[[y]]) else x[[y]])
  names(x) <- type

  ncols <- length(type)
  nrows <- max(sapply(x, length))+.5

  graphics::par(mar = c(0, 0, 0, 0))
  graphics::plot.new()
  graphics::plot(c(-.1, nrows+.3), c(.5, ncols+.5),
       type = "n", xlab = "", ylab = "",
       axes = FALSE
  )

  for(i in 1:length(type)){
    tmp <- x[[type[i]]]
    graphics::text(1, i, type[i], cex = 1, pos = 2)
    for(j in 1:length(tmp)){
      graphics::rect(j, i-.5, j+1, i+.5, col=tmp[j], border = NA)
      if(labels){
        graphics::rect(j+.2, i-.1, j+.8, i+.1, col="white", border = NA)
        graphics::text(j+.5, i, tmp[j], cex = .7)
      }
    }
  }

}
