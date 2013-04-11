#' Get the total number of PhyloPic images.
#' 
#' @examples \dontrun{
#' phylopic_count()
#' }
#' @export
phylopic_count <- function(){
  content(GET("http://phylopic.org/api/a/image/count"))$result
}