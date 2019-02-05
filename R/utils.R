globalVariables(
  c(
    "mentions_screen_name",
    "quoted_screen_name",
    "retweet_count",
    "screen_name",
    "created_at",
    "status_id",
    "target",
    "weight",
    "color",
    "label",
    "size",
    "type",
    "v2"
  )
)

"%||%" <- function(x, y) {
  if (length(x) > 0 || !is.null(x)) x else y
}

.get_pal <- function(){
  x <- getOption("chirp_palette")
  rev(x)
}

.get_edge_color <- function(){
  getOption("chirp_edge_color")
}

.get_font <- function(){
  getOption("chirp_font_family")
}

.get_tweet <- function(data){

  url <- URLencode(
    paste0(
      "https://twitter.com/", data$screen_name[1], "/status/", data$status_id[1]
    )
  )

  response <- httr::GET(
    url = paste0("https://publish.twitter.com/oembed?url=", url,
                 "&maxwidth=300&link_color=")
  )
  content <- httr::content(response)
  content$html[1]
}

.rescale <- function(x, t){
  x <- as.numeric(x)
  x <-  (x - min(x)) / (max(x) - min(x))
  x <- x * t
  return(x)
}
