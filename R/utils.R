
#' Validate Hex
#'
#' validate if string is hexidecimal
#' color code
#'
#' @param x hexidecimal character
#' @return logical. TRUE if object is a hexidecimal code
#'
#' @export
is_hex <- function(x){
  grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", x)
}


chartable <- function(table){
  x <- rvest::html_table(table)[[1]]
  as.character(x[-1, ])[-1]
}

strip_html <- function(x){
    rvest::html_text(
      rvest::read_html(x)
    )
}

get_nums <- function(x){
  as.numeric(strsplit(x, "\\D+")[[1]][-1])
}

get_pal_color <- function(x){
  x <- x[grepl("style", x)]
  get_bkg_color(x)
}

get_bkg_color <- function(x){
  x <- strsplit(x, "background-color:")
  x <- sapply(x, function(x) x[2])

  x <- gsub(';|\\\">|</div>| ', '', x)
  sapply(x, fix_hex)
}

fix_hex <- function(x){
  if(!is_hex(x)){
    cli::cli_abort("'{x}' is not a valid hexidecimal colour.")
  }
  indx <- ifelse(nchar(x) == 4, TRUE, FALSE)

  x[indx] <-  paste0(x[indx], gsub("#", "", x[indx]))
  x
}

nchar <- function(x){
  j <- strsplit(x, "")
  j <- lapply(j, length)
  unlist(j)
}

randcol <- function(){
  sample(1:255, 1)
}
