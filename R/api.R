query_colorhex <- function(){
  req <- httr2::request(colour_url())
  req <- httr2::req_retry(req, backoff = ~ 10)
  httr2::req_error(req, is_error = function(resp) FALSE)
}

colour_url <- function(full = TRUE){
  url <- "www.color-hex.com"
  if(!full)
    return(url)
  paste0("https://", url, "/")
}

