networks_ui <- function(id){

  ns <- NS(id)

  tagList(
    tags$a(
      icon("brain", class = "fa-lg"),
      onclick = "pushbar.open('save_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "save_pushbar",
      style = "position:absolute;z-index:999;right:20px;"
    ),
    fluidRow(
      htmlOutput(ns("display"), style="position:absolute;z-index:999;left:20px;"),
      sigmajs::sigmajsOutput(ns("graph"), height = "80vh")
    ),
    div(
      id = "pushbarLeft",
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
      h4("Stats"),
      p("trend"),
      reactrend::reactrendOutput(ns("trendline"), width = "100%"),
      uiOutput(ns("n_nodes")),
      uiOutput(ns("n_edges")),
      br(),
      br(),
      actionButton(ns("save_img"), "SAVE IMAGE", icon = icon("image")),
      br(),
      br(),
      actionButton(ns("save_svg"), "SAVE SVG", icon = icon("html5")),
      tags$a(
        icon("times"), onclick = "pushbar.close();", class = "btn btn-default",
        style = "bottom:20px;right:20px;position:absolute;"
      )
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

    edges <- twinetverse::edges2sg(graph$edges) %>%
      mutate(
        type = "arrow",
        weight = size
      )

    nodes <- twinetverse::nodes2sg(graph$nodes)

    nodes <- nodes %>%
      mutate(
        color = scales::col_numeric(
          .get_pal(),
          domain = range(size)
        )(size),
        size = scales::rescale(size, to = c(1, 15))
      )

    list(
      nodes = nodes,
      edges = edges
    )

  })

  output$graph <- sigmajs::renderSigmajs({

    sigmajs::sigmajs() %>%
      sigmajs::sg_nodes(graph()$nodes, id, label, size, color) %>%
      sigmajs::sg_edges(graph()$edges, id, source, target, type, weight) %>%
      sigmajs::sg_force(slowDown = 5) %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill() %>%
      sigmajs::sg_force_stop(2500) %>%
      sigmajs::sg_settings(
        batchEdgesDrawing = TRUE,
        edgeColor = "default",
        defaultEdgeColor = .get_edge_color(),
        font = .get_font()
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

  output$trendline <- reactrend::renderReactrend({
    .get_trend <- function(x = "%Y-%m-%d"){
      data() %>%
        mutate(
          created_at = format(created_at, x)
        ) %>%
        count(created_at) %>%
        pull(n)
    }

    trend <- .get_trend()

    if(length(trend) <= 4)
      trend <- .get_trend("%Y-%m-%d %H")

    if(length(trend) <= 1)
      trend <- .get_trend("%Y-%m-%d %H:%M")

    if(length(trend) <= 1)
      trend <- .get_trend("%Y-%m-%d %H:%M:%S")

    trend %>%
      reactrend::reactrend(
        draw = TRUE,
        gradient = .get_pal(),
        smooth = TRUE,
        stroke_width = 2,
        line_cap = "round"
      )
  })

  output$n_nodes <- renderUI({
    p(
      strong("Nodes:"),
      prettyNum(
        nrow(graph()$nodes),
        big.mark = ","
      )
    )
  })

  output$n_edges <- renderUI({
    p(
      strong("Edges:"),
      prettyNum(
        nrow(graph()$edges),
        big.mark = ","
      )
    )
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

    Sys.sleep(.5)

    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_noverlap_p()

  })

  observeEvent(input$delete_nodes, {
    if(isTRUE(input$delete_nodes)){
      showNotification(
        "Click a node to delete it.",
        duration = NULL,
        type = "error"
      )
    }
  })

}
