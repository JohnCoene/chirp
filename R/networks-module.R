networks_ui <- function(id){

  ns <- NS(id)

  tagList(
    tags$a(
      tags$i(class = "fas fa-cogs"),
      onclick = "pushbar.open('save_pushbar');",
      class = "btn btn-default",
      style = "position:absolute;z-index:999;right:20px;"
    ),
    fluidRow(
      column(
        2, htmlOutput(ns("display"))
      ),
      column(
        10, sigmajs::sigmajsOutput(ns("graph"), height = "80vh")
      )
    ),
    div(
      `data-pushbar-id` = "save_pushbar",
      class = "pushbar from_right",
      style = "padding:25px;",
      h4("Options"),
      br(),
      selectInput(
        ns("network"),
        "NETWORK TYPE",
        choices = c(
          "Retweets" = "retweet_screen_name",
          "Hashtags" = "hashtags",
          "Conversations" = "mentions_screen_name"
        )
      ),
      conditionalPanel(
        "input['networks-network'] != 'retweet_screen_name'",
        checkboxInput(
          ns("comentions"),
          "CO-MENTIONS",
          width = "100%"
        )
      ),
      checkboxInput(ns("delete_nodes"), "DELETE NODES", value = FALSE),
      actionButton(ns("start_layout"), "START LAYOUT", icon = icon("project-diagram")),
      br(),
      br(),
      actionButton(ns("kill_layout"), "STOP LAYOUT", icon = icon("heartbeat")),
      br(),
      br(),
      actionButton(ns("save_img"), "SAVE IMAGE", icon = icon("image")),
      br(),
      br(),
      actionButton(ns("save_svg"), "SAVE SVG", icon = icon("html5"))
    )
  )

}

networks <- function(input, output, session, data){

  shinyjs::hide("save_el")

  observeEvent(input$save_opts, {
    shinyjs::toggle("save_el")
  })

  observeEvent(input$save_img, {
    ns <- session$ns
    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_export_img_p(file = "chirp.png")
  })

  observeEvent(input$save_svg, {
    ns <- session$ns
    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_export_svg_p(file = "chirp.svg")
  })

  graph <- reactive({

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
        )(size),
        size = scales::rescale(size, to = c(3, 15)),
        type = "arrow"
      )

    list(
      nodes = nodes,
      edges = edges
    )

  })

  output$graph <- sigmajs::renderSigmajs({

    sigmajs::sigmajs() %>%
      sigmajs::sg_nodes(graph()$nodes, id, label, size, color, type) %>%
      sigmajs::sg_edges(graph()$edges, id, source, target) %>%
      sigmajs::sg_layout() %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill() %>%
      sigmajs::sg_settings(
        batchEdgesDrawing = TRUE,
        edgeColor = "default",
        defaultEdgeColor = .get_edge_color()
      )

  })

  output$display <- renderText({
    user <- input$graph_click_node$label
    user <- gsub("#", "", user)

    if(!is.null(input$graph_click_node$label) & !isTRUE(input$delete_nodes)){
      data() %>%
        select(
          status_id,
          screen_name,
          retweet_count,
          v2 = !!sym(input$network)
        ) %>%
        tidyr::separate_rows(v2) %>%
        mutate(
          screen_name = tolower(screen_name),
          v2 = tolower(v2)
        ) %>%
        filter(screen_name == user | v2 == user) %>%
        arrange(-retweet_count) %>%
        slice(1) %>%
        .get_tweet()
    }

  })

  observeEvent(input$graph_click_node, {

    node_clicked <- input$graph_click_node$label
    ns <- session$ns

    if(isTRUE(input$delete_nodes)){
      sigmajs::sigmajsProxy(ns("graph")) %>%
        sigmajs::sg_drop_node_p(id = input$graph_click_node$id)
    }
  })

  observeEvent(input$start_layout, {
    ns <- session$ns

    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_force_start_p()

  })

  observeEvent(input$kill_layout, {
    ns <- session$ns

    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_force_kill_p()

  })

}
