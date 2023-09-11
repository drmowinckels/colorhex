query_colorhex <- function(){
  if(!curl::has_internet()){
    cli::cli_alert_warning("Not connected to internet.")
    return(invisible(NULL))
  }
  req <- httr2::request(colour_url())
  req <- httr2::req_retry(req,
                          backoff = ~ 10,
                          is_transient = ~ httr2::resp_status(.x) > 400)
  req <- httr2::req_error(req,
                   is_error = function(resp) FALSE,
                   body = error_body)
  req
}

colour_url <- function(full = TRUE){
  url <- "www.color-hex.com"
  if(!full)
    return(url)
  paste0("https://", url, "/")
}

error_body <- function(resp) {
  httr2::resp_body_json(resp)$error
}

status_ok <- function(req){
  test <- httr2::req_perform(req)
  if(httr2::resp_status(test) > 400 ){
    cli::cli_alert_warning("Cannot connect to service.")
    cli::cli_inform(httr2::resp_status_desc(test))
    return(FALSE)
  }
  TRUE
}
