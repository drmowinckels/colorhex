#' Get latest palettes
#'
#' Retrieve the most recently made palettes
#' from www.color-hex.com
#'
#' @return data.frame with name, id and colours
#' @export
#'
#' @examples
#' get_latest_palettes()
get_latest_palettes <- function(){
  url <- paste0(colour_url(), "color-palettes/")
  resp <- xml2::read_html(url)
  get_pals(resp)
}

#' Get most popular palettes
#'
#' Retrieve the palettes most users have favourited
#' from www.color-hex.com
#'
#' @return data.frame with name, id and colours
#' @export
#'
#' @examples
#' get_popular_palettes()
get_popular_palettes <- function(){
  url <- paste0(colour_url(), "color-palettes/popular.php")
  resp <- xml2::read_html(url)
  get_pals(resp)
}

get_pal <- function(id){
  url <- paste0(colour_url(), "color-palette/", id)
  resp <- xml2::read_html(url)

  tables <- rvest::html_nodes(resp, "table")
  tables <- rvest::html_table(tables[1], fill = TRUE)[[1]]


  palettehex(
    gsub(" Color Palette", "",
         rvest::html_text(rvest::html_nodes(resp, "h1"))),
    id,
    list(tables[,2])
  )
}

#' Get palettes from id
#'
#' Get palette information from www.color-hex.com
#' based on the palette id (can be found in the url)
#'
#' @param id numeric id of a palette
#'
#' @return data.frame with palette information
#' @export
#'
#' @examples
#' get_palette(103107)
#'
#' # Lookup multiple palettes
#' id <- c(103161, 103107)
#' get_palette(id)
get_palette <- function(id){
  x <- lapply(id, get_pal)
  do.call(rbind, x)
}

#' @export
plot.palettehex <- function(x, ...){
  colr <- apply(x, 1, unnest_pal)

  nrows <- max(sapply(colr, nrow))+1
  ncols <- length(colr)

  graphics::par(mar = c(0, 0, 0, 0))
  graphics::plot.new()
  graphics::plot(c(-2, nrows-.2), c(.6, ncols+.3),
       type = "n", xlab = "", ylab = "",
       axes = FALSE
  )
  for(i in 1:length(colr)){
    tmp <- colr[[i]]
    graphics::text(1, i+.1,
                   sprintf("%s (%s)", tolower(tmp$name[[1]]), tmp$id[[1]]),
                   cex = .7, pos = 2)
    for(j in 1:nrow(tmp)){
      graphics::rect(j, i-.3, j+1, i+.3, col=tmp$hex[[j]], border = NA)
    }
  }

}

# helpers ----
get_pals <- function(resp, class = "palettecontainerlist"){
  path <- paste0('//*[@class="',class, '"]')
  pal <- rvest::html_nodes(resp, xpath = path)
  pal2 <- as.character(pal)
  pal2 <- strsplit(pal2, "\n")

  title <- sapply(pal2, function(x) strip_html(x[length(x)-1]))
  number <- unlist(sapply(pal2, function(x) get_nums(x[2])[[1]]))

  palettehex(
    title,
    number,
    lapply(pal2, get_pal_color)
  )
}


palettehex <- function(name, id, palette){
  ret <- data.frame(
    name = name,
    id = id,
    stringsAsFactors = FALSE
  )
  ret$palette <- palette

  structure(
    ret,
    class = c("palettehex", "data.frame"))
}



unnest_pal <- function(x){
  k <- cbind(x[1], x[2], unname(unlist(x[3])))
  k <- as.data.frame(k, stringsAsFactors = FALSE)
  names(k) <- c("name", "id", "hex")
  row.names(k) <- NULL
  k$num <- 1:nrow(k)
  k
}

