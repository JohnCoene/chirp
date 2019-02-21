#' Dynamic Plugin
#'
#' @examples
ui <- fluidPage(
  dynamic_ui("time")
)

server <- function(input, output, session){
  callModule(dynamic, "time", tweet = tweets)
}

if(interactive()) shinyApp(ui, server)
#' 
#' @export
dynamic_ui <- function(id){
  ns <- NS(id)
  tagList(
    sliderInput(
      ns("time"), 
      "",
      min = 0, 
      max = 10000, 
      value = 0, 
      step = 1000, 
      animate = animationOptions(
        interval = 1000, 
        loop = FALSE, 
        playButton = icon("play"),
        pauseButton = icon("kill")
      )
    ),
    sigmajsOutput(ns("sg"))
  )
}

dynamic <- function(input, output, session, tweets) {

  net <- tweets %>% 
    gt_edges(screen_name, mentions_screen_name, created_at) %>% 
    gt_nodes() %>% 
    gt_dyn() %>% 
    gt_collect()

  c(edges, nodes) %<-% net

  #' @param x Date time column.
  #' @param t Number of milliseconds to rescale to.
  rescale <- function(x, t){
    x <- as.numeric(x)
    x <-  (x - min(x)) / (max(x) - min(x))
    x <- x * t
    return(x)
  }

  T <- 10000

  nodes <- nodes %>% 
    nodes2sg() %>% 
    mutate(
      start = rescale(start, T),
      start = start - 500, # ensure it is plotted BEFORE edges connected to it
      drop = start + 500
    ) %>% 
    select(id, label, size, start, drop)

  edges <- edges %>% 
    mutate(
      id = 1:n(),
      created_at = as.numeric(created_at),
      created_at = rescale(created_at, T)
    ) %>% 
    select(id, source, target, created_at)

  nodes <- sg_get_layout(nodes, edges) 

  nodes$id <- as.character(nodes$id)
  edges$id <- as.character(edges$id)

  dat <- eventReactive(input$time, {
    n <- nodes %>% 
      filter(start < input$time) 

    e <- edges %>% 
      filter(created_at < input$time)

    n_rm <- nodes %>% 
      filter(start >= input$time) 

    e_rm <- edges %>% 
      filter(created_at >= input$time)

    list(
      nodes = n,
      edges = e,
      nodes_not = n_rm,
      edges_not = e_rm
    )
  })

  on_graph <- list()
  on_graph_react <- reactive({
    on_graph <<- append(list(dat()), on_graph)
  })

  output$sg <- renderSigmajs({
    sigmajs()
  })

  observeEvent(input$time, {

    ns <- session$ns

    should_be_on_graph <- on_graph_react()[[1]]

    # compute
    if(length(on_graph_react()) >= 3){
      
      already_on_graph <- on_graph_react()[[2]]

      add_nodes <- should_be_on_graph$nodes %>% 
        anti_join(already_on_graph$nodes, by = "id")

      drop_nodes <- should_be_on_graph$nodes_not %>% 
        anti_join(already_on_graph$nodes_not, by = "id")

      add_edges <- should_be_on_graph$edges %>% 
        anti_join(already_on_graph$edges, by = "id")

      drop_edges <- should_be_on_graph$edges_not %>% 
        anti_join(already_on_graph$edges_not, by = "id")

      sigmajsProxy(ns("sg")) %>% 
        sg_add_nodes_p(add_nodes, id, label, x, y, size, refresh = FALSE) %>% 
        sg_add_edges_p(add_edges, id, source, target, refresh = FALSE) %>% 
        sg_drop_nodes_p(drop_nodes, id, refresh = TRUE) %>% 
        sg_drop_edges_p(drop_edges, id, refresh = TRUE) 
      
    } else {
      sigmajsProxy(ns("sg")) %>% 
        sg_add_nodes_p(should_be_on_graph$nodes, id, label, size) %>% 
        sg_add_edges_p(should_be_on_graph$edges, id, source, target)
    }

    sigmajsProxy(ns("sg")) %>% 
      sg_refresh_p()
  })
}

dynamic_home_ui <- function(id){
  actionButton("dyn", "dyn")
}

dynamic_home <- function(input, output, session){
  ns <- session$ns
}
