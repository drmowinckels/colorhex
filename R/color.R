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
#' if(curl::has_internet()){
#' get_popular_colors()
#' }
get_popular_colors <- function(){
  req <- httr2::request(colour_url())
  if(is.null(req))
    return(invisible(NULL))
  req <- httr2::req_url_path_append(
    req,
    "popular-colors.php")
  if(!status_ok(req))
    return(invisible(NULL))

  resp <- httr2::req_perform(req)
  resp <- httr2::resp_body_html(resp)
  cols <- rvest::html_nodes(
    resp,
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

#' Get color information
#'
#' Get color information from www.color-hex.com
#' of a hex-color.
#'
#' @param hex character string that is a hexidecimal color
#'
#' @return list of class 'colorhex'
#' @export
#'
#' @examples
#' if(curl::has_internet()){
#' get_color("#470f0f")
#' }
get_color <- function(hex){
  hex <- fix_hex(hex)
  req <- query_colorhex()
  if(is.null(req))
    return(invisible(NULL))

  req <- httr2::req_url_path_append(
    req,
    "color",
    gsub("^#", "", hex))

  if(!status_ok(req))
    return(invisible(NULL))

  resp <- httr2::req_perform(req)
  resp <- httr2::resp_body_html(resp)
  tables <- rvest::html_nodes(resp, "table")
  tables <- lapply(tables, rvest::html_table, fill = TRUE)
  prim <- as.data.frame(t(tables[[1]]))
  names(prim) <- as.character(unlist(prim[1,]))
  row.names(prim) <- NULL
  prim <- prim[-1,]

  rows <- rvest::html_nodes(resp,
                            xpath = '//*[@class="colordvconline"]')
  rows <- rvest::html_text(rows)
  rows <- gsub(" \n", "", rows)
  rows <- sapply(rows, fix_hex)

  ret <- list(
    hex = hex,
    space = prim,
    base = tables[[2]],
    triadic = NA_character_,
    analogous = NA_character_,
    complementary = NA_character_,
    shades = rows[1:11],
    tints = rows[12:22],
    related = rows[22:length(rows)],
    palettes = get_pals(resp, "palettecontainerlist narrow")
  )

  if(length(tables) > 2){
    ex <- lapply(3:5, function(x){
      j <- unique(unlist(tables[[x]]))
      sapply(j[j!=""], fix_hex)
    })
    ret$triadic = ex[[1]]
    ret$analogous = ex[[2]]
    ret$complementary = ex[[3]]
  }

  colorhex(ret)
}

colorhex <- function(x){
  stopifnot(names(x) %in% c("hex",
                            "space", "base",
                            "complementary", "analogous",
                            "triadic", "shades", "tints",
                            "related", "palettes"))

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
    sprintf("complementary: %s", x$complementary),
    sprintf("used in %s palettes", nrow(x$palettes))
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
                                   "analogous", "shades", "tints",
                                   "related"),
                          labels = TRUE, ...){

  type <- match.arg(type,
                    c("complementary", "triadic",
                      "analogous", "shades", "tints", "related"),
                    several.ok = TRUE)

  x <- lapply(type, function(y) if(y != "hex") c(x$hex, x[[y]]) else x[[y]])
  names(x) <- type

  ncols <- length(type)
  nrows <- max(sapply(x, length))+.5

  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar))
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
      graphics::rect(j, i-.4, j+1, i+.4, col=tmp[j], border = NA)
      if(labels){
        graphics::rect(j+.2, i-.1, j+.8, i+.1, col="white", border = NA)
        graphics::text(j+.5, i, tmp[j], cex = .7)
      }
    }
  }

}
