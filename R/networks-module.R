networks_ui <- function(id){

  ns <- NS(id)

  tagList(
    fluidRow(
      column(
        3,
        selectInput(
          ns("network"),
          "Network type",
          choices = c(
            "Retweets" = "retweet_screen_name",
            "Hashtags" = "hashtags",
            "Conversations" = "mentions_screen_name"
          )
        )
      ),
      column(
        3,
        br(),
        conditionalPanel(
          "input['networks-network'] != 'retweet_screen_name'",
          checkboxInput(
            ns("comentions"),
            "Co-mentions",
            width = "100%"
          )
        )
      )
    ),
    hr(),
    fluidRow(
      column(
        10, sigmajs::sigmajsOutput(ns("graph"), height = "95vh")
      ),
      column(
        2, htmlOutput(ns("display"))
      )
    )
  )

}

networks <- function(input, output, session, data){

  output$graph <- sigmajs::renderSigmajs({

    if(isTRUE(input$comentions) && input$network %in% c("hashtags", "mentions_screen_name"))
      edges <- data() %>% gt_co_edges(!!sym(input$network))
    else
      edges <- data() %>% gt_edges(screen_name, !!sym(input$network))

    graph <- edges %>%
      gt_nodes() %>%
      gt_collect()

    edges <- twinetverse::edges2sg(graph$edges)
    nodes <- twinetverse::nodes2sg(graph$nodes)

    nodes <- nodes %>%
      mutate(
        color = scales::col_numeric(
          .get_pal(),
          domain = range(size)
        )(size)
      )

    sigmajs::sigmajs() %>%
      sigmajs::sg_nodes(nodes, id, label, size, color) %>%
      sigmajs::sg_edges(edges, id, source, target) %>%
      sigmajs::sg_force_start() %>%
      sigmajs::sg_force_stop(10000) %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill()
  })

  output$display <- renderText({
    user <- input$graph_click_node$label

    if(!is.null(input$graph_click_node$label)){
      data() %>%
        filter(screen_name == user | !!sym(input$network) == user) %>%
        arrange(-retweet_count) %>%
        slice(1) %>%
        .get_tweet()
    }

  })

}
