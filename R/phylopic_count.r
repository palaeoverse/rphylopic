#' Get the total number of PhyloPic images.
#' 
#' @keywords internal
#' @examples \dontrun{
#' phylopic_count()
#' }
phylopic_count <- function(){
  content(GET("http://phylopic.org/api/a/image/count"))$result
}
