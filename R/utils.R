globalVariables(
  c(
    "mentions_screen_name",
    "quoted_screen_name",
		"degree(igraph)",
    "retweet_count",
    "rtweet_token",
    "screen_name",
    "created_at",
    "is_retweet",
    "components",
    "out_degree",
		"remaining",
    "status_id",
    "in_degree",
    "sentiment",
		"reset_at",
    "pagerank",
    "hashtags",
    "negative",
    "positive",
    "target",
    "tweets",
    "weight",
		"degree",
    "group",
    "color",
    "label",
		"name",
    "size",
    "type",
    "from",
    "text",
    "word",
    "grp",
    "v2",
    "to",
    "."
  )
)

"%||%" <- function(x, y) {
  if (length(x) > 0 || !is.null(x)) x else y
}

.get_pal <- function(){
  getOption("chirp_palette")
}

.get_discrete <- function(){
  getOption("chirp_discrete")
}

.get_search_query <- function(){
  getOption("search_query")
}

.get_edge_color <- function(){
  getOption("chirp_edge_color")
}

.get_font <- function(){
  getOption("chirp_font_family")
}

.get_token <- function(){
  getOption("rtweet_token")
}

.get_sentiment_pal <- function(){
  getOption("sentiment_palette")
}

.get_tweet_range <- function(v){
  switch(
    v,
    max = getOption("max_tweets"),
    min = getOption("min_tweets")
  )
}

.get_tweet <- function(data){

  url <- URLencode(
    paste0(
      "https://twitter.com/", data$screen_name[1], "/status/", data$status_id[1]
    )
  )

  response <- httr::GET(
    url = paste0(
      "https://publish.twitter.com/oembed?url=", url,
      "&maxwidth=300&omit_script=false&link_color="
    )
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

.get_time_scale <- function(x){
  if(x == "%Y-%m-%d") return("daily")
  if(x == "%Y-%m-%d %H") return("hourly")
  if(x == "%Y-%m-%d %H:%M") return("minute by minute")
  if(x == "%Y-%m-%d %H:%M:%S") return("second by second")
}

.color_nodes <- function(nodes, x){
  var = pull(nodes, x)
  
  if(inherits(var, "factor") || inherits(var, "character")){
    var_unique <- unique(var)
    colors <- scales::col_factor(
      .get_discrete(), 
      var_unique
    )(var)
  } else {
    colors <- scales::col_numeric(
      .get_pal(), domain = NULL
    )(var)
  }

  nodes$color <- colors

  return(nodes)
}

.compute_sentiment <- function(tweets){

  lexicon <- tidytext::get_sentiments("bing")  

  tweets %>% 
    select(status_id, text) %>% 
    tidytext::unnest_tokens(word, text) %>% 
    inner_join(lexicon, by = "word") %>% 
    count(status_id, sentiment) %>%
    tidyr::spread(sentiment, n, fill = 0) %>% 
    mutate(sentiment = positive - negative) %>% 
    left_join(tweets, ., by = "status_id") %>% 
    mutate(
      sentiment = ifelse(is.na(sentiment), 0, sentiment),
      sentiment = case_when(
        sentiment > 0 ~ 1,
        sentiment < 0 ~ -1,
        TRUE ~ 0
      )
    )
}

.color_edges <- function(edges, x){

  if(x != "sentiment")
    palette <- .get_pal()
  else 
    palette <- .get_sentiment_pal()

  if(x != "none"){
    var <- edges %>% 
      pull(x)

    colors <- scales::col_numeric(
      palette, domain = c(-1, 1)
    )(var)
  } else {
    colors <- rep(.get_edge_color(), nrow(edges))
  }

  data.frame(color = colors)

}

.size_nodes <- function(nodes, x){
  var = pull(nodes, x)
  var <- scales::rescale(var, to = c(3, 17))
  nodes$size <- var
  return(nodes)
}

.check_rate_limit <- function(){
	rtweet::rate_limit(.get_token(), "search_tweets") %>% 
		select(remaining, reset_at)
}

.zoom <- function(x){
  switch(
    x,
    low = .1,
    medium = .05,
    high = .01
  )
}

.get_random_icon <- function(){
  x <- c(
    "user-tie",
    "user-secret",
    "user-ninja",
    "user-md",
    "user-graduate",
    "user-astronaut"
  )
  icn <- sample(x, 1)
  icon(icn, class = "text-primary")
}

.clean_input <- function(x){
	x <- tolower(x)
	gsub("#", "", x)
}

.slice_node <- function(x, i){

  if(is.null(x))
    return(NULL)

  x %>% 
    slice(i) %>% 
    pull(label)
}

.preproc <- function(df){
  df %>% 
    group_by(source, target) %>% 
    summarise(
      n = sum(n),
      sentiment = sum(sentiment)
    ) %>% 
    ungroup()
}