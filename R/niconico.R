#' @export
getInfo <- function(id){
  require(rvest)
  require(XML)
  u <- sprintf("http://ext.nicovideo.jp/api/getthumbinfo/%s",id)
  res <- lapply(u, function(x)html(x) %>% xmlToDataFrame(stringsAsFactors = FALSE))
  res <- do.call("rbind", res)
  return(res)
}

#' @export
getSearch <- function(query, size=100, type=c("word","tag")){
  require(RCurl)
  type <- match.arg(type)
  res <- postForm("http://api.search.nicovideo.jp/api/snapshot/",
                  .opts = list(postfields = 
                                 jsonlite::toJSON(list(query = query,
                                             service = list("video"),
                                             search = ifelse(type=="word",
                                                             list("title","description","tags"),
                                                             list("tags_exact")),
                                             join = list("cmsid","title","description","tags","start_time",
                                                         "thumbnail_url","view_counter",
                                                         "comment_counter","mylist_counter",
                                                         "last_res_body","length_seconds"),
                                             #                                            filters = list(list(type = "range",
                                             #                                                                field = "view_counter",
                                             #                                                                to = 10000)),
                                             size = size,
                                             issuer = "yourservice/applicationname"
                                 ),auto_unbox=TRUE
                                 )
                               ,
                               httpheader = c('Content-Type' = 'application/json', Accept = 'application/json'),
                               ssl.verifypeer = FALSE))
  res <- as.data.frame(do.call("rbind", rjson::fromJSON(res)$values), stringsAsFactors=FALSE)
  return(res)
}
