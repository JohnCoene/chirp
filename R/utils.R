globalVariables(
  c(
    "mentions_screen_name",
    "quoted_screen_name",
    "retweet_count",
    "screen_name",
    "target",
    "color",
    "label",
    "size"
  )
)

"%||%" <- function(x, y) {
  if (length(x) > 0 || !is.null(x)) x else y
}

.get_pal <- function(){
  x <- getOption("chirp_palette")
  rev(x)
}

.get_tweet <- function(data){

  url <- URLencode(
    paste0(
      "https://twitter.com/", data$screen_name[1], "/status/", data$status_id[1]
    )
  )

  response <- httr::GET(
    url = paste0("https://publish.twitter.com/oembed?url=", url,
                 "&maxwidth=220&link_color=")
  )
  content <- httr::content(response)
  content$html[1]
}

