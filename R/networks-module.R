networks_ui <- function(id){

  ns <- NS(id)

  tagList(
    tags$a(
      icon("brain", class = "fa-lg"),
      onclick = "pushbar.open('save_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "save_pushbar",
      id = "opts"
    ),
    tags$a(
      icon("search", class = "fa-lg"),
      onclick = "pushbar.open('search_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "search_pushbar",
      id = "search"
    ),
    div(
      id = "pushbarTop",
      `data-pushbar-id` = "search_pushbar",
      class = "pushbar from_left",
      h4("Options"),
      br(),
      textInput(
        ns("q"), 
        "", 
        width = "100%", 
        placeholder = "Query"
      ),
      fluidRow(
        column(
          4,
          actionButton(
            ns("addOpts"), 
            "", 
            icon = icon("plus")
          )
        ),
        column(
          8, 
          actionButton(
            ns("submit"), 
            "Search", 
            icon = icon("search"), 
            width = "100%", 
            class = "btn btn-primary"
          )
        )
      ),
      br(),
      div(
        id = ns("searchOptions"),
        style = "display:none;",
        sliderInput(
          ns("n"),
          label = "Number of tweets",
          min = 500,
          max = 15000,
          value = 1000,
          step = 100,
          width = "100%"
        ),
        selectInput(
          ns("type"),
          "Type",
          choices = c(
            "Recent" = "recent",
            "Mixed" = "mixed",
            "Popular" = "popular"
          ),
          selected = "recent",
          width = "100%"
        ),
        checkboxInput(
          ns("include_rts"),
          "Include retweets",
          TRUE,
          width = "100%"
        ),
        textInput(ns("longitude"), "Longitude", value = "", width = "100%"),
        textInput(ns("latitude"), "Latitude", value = "", width = "100%"),
        textInput(ns("radius"), "Radius", value = "", width = "100%")
      ),
      tags$a(
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger",
        style = "bottom:20px;left:20px;position:absolute;"
      )
    ),
    shinyjs::useShinyjs(),
    htmlOutput(ns("display"), style="position:absolute;z-index:999;left:20px;top:50px;"),
    sigmajs::sigmajsOutput(ns("graph"), height = "99vh"),
    div(
      id = "pushbarLeft",
      `data-pushbar-id` = "save_pushbar",
      class = "pushbar from_right",
      h3("Options"),
      br(),
      fluidRow(
        column(
          6,
          selectInput(
            ns("network"),
            "NETWORK TYPE",
            choices = c(
              "Retweets" = "retweet_screen_name",
              "Hashtags" = "hashtags",
              "Conversations" = "mentions_screen_name"
            )
          )
        ),
        column(
          6, uiOutput(ns("color"))
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
      fluidRow(
        column(
          6, actionButton(ns("start_layout"), "START LAYOUT", icon = icon("project-diagram"))
        ),
        column(
          6, actionButton(ns("kill_layout"), "STOP LAYOUT", icon = icon("heartbeat"))
        )
      ),
      br(),
      h4("Stats"),
      uiOutput(ns("trend_text")),
      reactrend::reactrendOutput(ns("trendline"), width = "100%"),
      uiOutput(ns("n_nodes")),
      uiOutput(ns("n_edges")),
      br(),
      fluidRow(
        column(
          6, actionButton(ns("save_img"), "SAVE IMAGE", icon = icon("image"))
        ),
        column(
          6, actionButton(ns("save_svg"), "SAVE SVG", icon = icon("html5"))
        )
      ),
      tags$a(
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger",
        style = "bottom:20px;right:20px;position:absolute;"
      )
    )
  )

}

networks <- function(input, output, session, tweets){

  tweets <- reactiveVal(tweets)

  observeEvent(input$submit, {
    geocode <- NULL

    if(input$longitude != "" && input$latitude != "" && input$radius != "")
      geocode <- paste0(input$longitude, input$latitude, input$radius)

    if(input$q == ""){
      showModal(modalDialog(
        title = "No search entered!",
        "Enter a search\nCan include boolean operators such as 'OR' and 'AND'.",
        easyClose = TRUE,
        footer = NULL
      ))
    }

    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = paste("Fetching", prettyNum(input$n, big.mark = ","), "tweets"), value = sample(seq(.1, .9, by = .1), 1))

    if(input$q != ""){
      tw <- rtweet::search_tweets(
        input$q,
        n = input$n,
        type = input$type,
        include_rts = input$include_rts,
        geocode = geocode,
        token = .get_token()
      ) 
      tweets(tw)
    }

  })

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
      edges <- tweets() %>% gt_co_edges(!!sym(input$network))
    else
      edges <- tweets() %>% gt_edges(screen_name, !!sym(input$network))

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
        size = scales::rescale(size, to = c(1, 15))
      )

    list(
      nodes = nodes,
      edges = edges
    )

  })

  output$color <- renderUI({
    ns <- session$ns
    
    choices <- colnames(graph()$nodes)
    choices <- choices[!choices %in% c("id", "label")]

    selectInput(ns("colour"), "Colour", choices = choices, selected = "size")
  })

  output$graph <- sigmajs::renderSigmajs({

    req(input$colour, input$type, input$comentions)

    nodes <- graph()$nodes
    nodes <- .color_nodes(nodes , input$colour)

    sigmajs::sigmajs() %>%
      sigmajs::sg_nodes(nodes, id, label, size, color) %>%
      sigmajs::sg_edges(graph()$edges, id, source, target, type, weight) %>%
      sigmajs::sg_force(slowDown = 5) %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill() %>%
      sigmajs::sg_drag_nodes() %>% 
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
      tweets() %>%
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

  trend <- reactive({
   .get_trend <- function(x = "%Y-%m-%d"){
      tweets() %>%
        mutate(
          created_at = format(created_at, x)
        ) %>%
        count(created_at) %>%
        pull(n) %>% 
        list(
          trend = .,
          format = x
        )
    }

    trend <- .get_trend()

    if(length(trend) <= 4)
      trend <- .get_trend("%Y-%m-%d %H")

    if(length(trend) <= 1)
      trend <- .get_trend("%Y-%m-%d %H:%M")

    if(length(trend) <= 1)
      trend <- .get_trend("%Y-%m-%d %H:%M:%S")

    return(trend)
  })

  output$trend_text <- renderUI({
    p(strong("Trend"), .get_time_scale(trend()$format))
  })

  output$trendline <- reactrend::renderReactrend({

    trend()$trend %>%
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

  shinyjs::hide("searchOptions")

  observeEvent(input$addOpts, {
    ns <- session$ns
    shinyjs::toggle("searchOptions")
  })

}

ui <- fluidPage(
  actionButton("create", "create"),
  actionButton("destroy", "destroy"),
  verbatimTextOutput("data")
)
