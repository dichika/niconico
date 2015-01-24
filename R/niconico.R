#' @export
getInfo <- function(id){
  require(rvest)
  require(XML)
  u <- sprintf("http://ext.nicovideo.jp/api/getthumbinfo/%s",id)
  res <- lapply(u, function(x)html(x) %>% xmlToDataFrame(stringsAsFactors = FALSE))
  res <- do.call("rbind", res)
  return(res)
}
