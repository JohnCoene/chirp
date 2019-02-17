networks_ui <- function(id){

  ns <- NS(id)

  tagList(
    tags$a(
      icon("pencil-ruler", class = "fa-lg"),
      onclick = "pushbar.open('save_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "save_pushbar",
      id = "optsBtn"
    ),
    tags$a(
      icon("searchengin", class = "fa-lg"),
      onclick = "pushbar.open('search_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "search_pushbar",
      id = "search"
    ),
		actionButton(
			"stats",
			"",
			icon("brain", class = "fa-lg"),
			class = "btn-primary",
			onclick = "pushbar.open('stats_pushbar');",
		),
		div(
      id = "pushbarBottom",
      `data-pushbar-id` = "stats_pushbar",
      class = "pushbar from_right",
			h4("STATS"),
      uiOutput(ns("trend_text")),
      reactrend::reactrendOutput(ns("trendline"), width = "100%"),
      fluidRow(
        column(6, uiOutput(ns("n_nodes"))),
        column(6, uiOutput(ns("n_edges")))
      ),
      fluidRow(
        column(6, uiOutput(ns("n_tweets")))
      ),
			h5("CENTRALITY"),
			fluidRow(
				column(4, strong("Node"), uiOutput(ns("node_centrality"))),
				column(4, strong("Graph"), uiOutput(ns("graph_centrality"))),
				column(4, strong("Max"), uiOutput(ns("centrality_max")))
			),
			br(),
			uiOutput(ns("selected_node")),
			strong("Degree"), uiOutput(ns("node_degree")),
			strong("Closeness"), uiOutput(ns("node_closeness")),
      tags$a(
        id = "closeStats",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
		),
    div(
      id = "pushbarTop",
      `data-pushbar-id` = "search_pushbar",
      class = "pushbar from_left",
      h4("DATA"),
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "SEARCH",
          br(),
          textInput(
            ns("q"),
            "",
            width = "100%",
            placeholder = "Query"
          ),
					tippy_this(ns("q"), "Your search query"),
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
              max = 18000,
              value = 1000,
              step = 100,
              width = "100%"
            ),
            tippy_this(ns("n"), "Number of tweets to fetch"),
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
            tippy_this(ns("type"), "Type of tweets to fetch"),
            checkboxInput(
              ns("include_rts"),
              "Include retweets",
              TRUE,
              width = "100%"
            ),
            tippy_this(ns("include_rts"), "Whether to include retweets"),
            textInput(ns("longitude"), "Longitude", value = "", width = "100%"),
            textInput(ns("latitude"), "Latitude", value = "", width = "100%"),
            textInput(ns("radius"), "Radius", value = "", width = "100%")
          )
        ),
        tabPanel(
          "LOAD",
          br(),
          br(),
          fileInput(
            ns("file"),
            label = "Choose an .RData file",
            accept = c(".RData", ".rdata"),
            placeholder = " No file selected",
            width = "100%"
          )
        )
      ),
      a(
        "chrip.sh",
        id = "leftLink",
        href = "https://chirp.sh",
        target = "_blank"
      ),
      tags$a(
        id = "closeSearch",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
    ),
    shinyjs::useShinyjs(),
    htmlOutput(ns("display"), style="position:absolute;z-index:999;left:20px;top:70px;"),
    shinycustomloader::withLoader(
      sigmajs::sigmajsOutput(ns("graph"), height = "99vh"),
      type = "html",
      loader = "loader9"
    ),
    div(
      id = "pushbarLeft",
      `data-pushbar-id` = "save_pushbar",
      class = "pushbar from_right",
      h4("OPTIONS"),
      br(),
      fluidRow(
        column(
          7,
          selectInput(
            ns("network"),
            "NETWORK TYPE",
            choices = c(
              "Retweets" = "retweet_screen_name",
              "Hashtags" = "hashtags",
              "Conversations" = "mentions_screen_name"
            )
          ),
          tippy_this(ns("network"), "Type of network to draw")
        ),
        column(
          5, 
          selectInput(
            ns("colour"), 
            "COLOUR", 
            choices = c("Cluster" = "cluster", "Size" = "size", "Type" = "type"), 
            selected = "cluster"
          ),
          tippy_this(ns("colour"), "Variable to colour nodes")
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
			h5("FILTER"),
      fluidRow(
        column(
          8,
          checkboxInput(
            ns("delete_nodes"), 
          "DELETE NODES", value = FALSE
          ),
          tippy_this(ns("delete_nodes"), "Tick and click on nodes to delete them")
        ),
        column(
          4,
          conditionalPanel(
            "input['networks-network'] != 'retweet_screen_name'",
            checkboxInput(
              ns("include_retweets"), 
              "RTs",
              value = TRUE
            )
          )
        )
      ),
			h5("LAYOUT"),
      fluidRow(
        column(
          6, 
          actionButton(
            ns("start_layout"), 
            "START", 
            icon = icon("play"),
            width = "100%"
          )
        ),
        column(
          6, 
          actionButton(
            ns("kill_layout"), "
            STOP", 
            icon = icon("stop"),
            width = "100%"
          )
        )
      ),
      h5("EXPORT"),
      fluidRow(
        column(
          6, 
          actionButton(
            ns("save_img"), 
            "SAVE IMAGE", 
            icon = icon("image"),
            width = "100%"
          )
        ),
        column(
          6, 
          actionButton(
            ns("save_svg"), 
            "SAVE SVG",
            icon = icon("html5"),
            width = "100%"
          )
        )
      ),
      br(),
      downloadButton(ns("downloadData"), "DOWNLOAD DATA", width = "100%"),
      tags$a(
        id = "closeOpts",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
    )
  )

}

networks <- function(input, output, session, dat){

  tweets <- reactiveVal(dat)

  observeEvent(input$submit, {
    geocode <- NULL

    if(input$longitude != "" && input$latitude != "" && input$radius != "")
      geocode <- paste0(input$longitude, input$latitude, input$radius)

    if(input$q == ""){
      showModal(modalDialog(
        title = "No search entered!",
        "Enter a search",
        br(),
        "Can include boolean operators such as 'OR' and 'AND',",
        "visit the", 
        tags$a(
          "official documentation",
          href = "https://developer.twitter.com/en/docs/tweets/search/guides/standard-operators.html",
          target = "_blank"
        ),
        "for more details.",
        easyClose = TRUE,
        footer = NULL
      ))
    }

    if(input$q != ""){

      session$sendCustomMessage(
        "load", 
        paste("Fetching", prettyNum(input$n, big.mark = ","), "tweets")
      )

			lim <- .check_rate_limit()

			if(lim$remaining == 0)
				shinyjs::disable("submit")

			if(lim$remaining != 0){
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

			session$sendCustomMessage("unload", "") # stop loading
    }

  })

  observeEvent(input$file, {
    session$sendCustomMessage(
      "load", 
      "Loading file..."
    )
    tw <- get(load(input$file$datapath))
    tweets(tw)
		session$sendCustomMessage("unload", "") # stop loading
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

    tw <- tweets()  %>% 
      filter(is_retweet %in% c(FALSE, input$include_retweets))

    if(isTRUE(input$comentions) && input$network %in% c("hashtags", "mentions_screen_name"))
      edges <- tw %>% gt_co_edges(!!sym(input$network))
    else
      edges <- tw %>% gt_edges(screen_name, !!sym(input$network))

    graph <- edges %>%
      gt_nodes() %>%
      gt_collect()

    edges <- twinetverse::edges2sg(graph$edges) %>%
      mutate(
        type = "arrow",
        size = scales::rescale(size, to = c(2, 20))
      )

    nodes <- twinetverse::nodes2sg(graph$nodes)

    nodes <- nodes %>%
      mutate(
        size = scales::rescale(size, to = c(1, 15))
      )

    nodes <- sigmajs::sg_get_cluster(nodes, edges) %>%
      mutate(
        cluster = grp
      ) %>%  
      select(-grp) %>% 
      select(-color)

		session$sendCustomMessage("unload", "") # stop loading

		is_directed <- ifelse(isTRUE(input$comentions), FALSE, TRUE)
		igraph <- igraph::graph_from_data_frame(edges, directed = is_directed, vertices = nodes)

		degrees <- igraph::degree(igraph) %>% 
			as.data.frame() 

		degrees$name <- rownames(degrees) 
		
		names(degrees) <- c("degree", "name")

    list(
      nodes = nodes,
      edges = edges,
			igraph = igraph,
			degree = degrees
    )

  })

  output$graph <- sigmajs::renderSigmajs({

    g <- graph()

    nodes <- g$nodes
    nodes <- .color_nodes(nodes , input$colour)
    edges <- g$edges

    sigmajs::sigmajs(type = "webgl") %>%
      sigmajs::sg_nodes(nodes, id, label, size, color) %>%
      sigmajs::sg_edges(edges, id, source, target, type, size) %>%
      sigmajs::sg_force(slowDown = 4) %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill() %>%
      sigmajs::sg_layout() %>% 
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

    input$graph_click_node

    user <- input$graph_click_node$label
    user <- gsub("#", "", user)

    tw <- ""

    if(!is.null(input$graph_click_node$label) & !isTRUE(input$delete_nodes)){
      tw <- tweets() %>%
        filter(is_retweet %in% c(FALSE, input$include_retweets)) %>% 
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
        ) 
				
			src <- tw %>%
        filter(screen_name == user) %>%
        arrange(-retweet_count) 

			if(nrow(src) >= 1)
				tw <- src %>%
					slice(1) %>% 
					.get_tweet()
			else
				tw <- tw %>%
					filter(v2 == user) %>%
					arrange(-retweet_count) %>%
					slice(1) %>%
					.get_tweet()
    }

    if(inherits(tw, "error"))
      tw <- ""

    return(tw)

  })

	output$selected_node <- renderUI({

		if(is.null(input$graph_click_node))
			p(
				"Select a node to see its network metrics",
				class = "text-warning"
			)
		else
			h5(icon("user", class = "text-primary"), input$graph_click_node$label)

	})

  trend <- reactive({

   .get_trend <- function(x = "%Y-%m-%d"){
      tweets() %>%
        filter(is_retweet %in% c(FALSE, input$include_retweets)) %>% 
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

    if(length(trend$trend) < 4)
      trend <- .get_trend("%Y-%m-%d %H")

    if(length(trend$trend) < 3)
      trend <- .get_trend("%Y-%m-%d %H:%M")

    if(length(trend$trend) < 2)
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

  output$n_tweets <- renderUI({
    p(
      strong("Tweets:"),
      prettyNum(
        nrow(tweets() %>% filter(is_retweet %in% c(FALSE, input$include_retweets))),
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

  notification <- NULL
  observeEvent(input$delete_nodes, {
    if(isTRUE(input$delete_nodes)){
      notification <<- showNotification(
        "Click a node to delete it.",
        duration = NULL,
        type = "error",
        closeButton = FALSE
      )
    } else {
      if (!is.null(notification)) removeNotification(notification)
      notification <<- NULL
    }
  })

  shinyjs::hide("searchOptions")

  observeEvent(input$addOpts, {
    ns <- session$ns
    shinyjs::toggle("searchOptions")
  })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste('chirp-', Sys.Date(), '.RData', sep='')
    },
    content = function(file) {
      tw <- tweets() 
      save(tw, file = file)
    }
  )

	# centrality
	centrality <- reactive({

		centrality <- igraph::centr_degree(graph()$igraph, mode = "all")

		list(
			node_centrality = round(centrality$res, 3),
			graph_centrality = round(centrality$centralization, 3),
			centrality_max = round(centrality$theoretical_max, 3)
		)
	})

	output$node_centrality <- renderUI({
		span(
			centrality()$node_centrality
		)
	})

	output$graph_centrality <- renderUI({
		span(
			centrality()$graph_centrality
		)
	})

	output$centrality_max <- renderUI({
		span(
			centrality()$centrality_max
		)
	})

	output$node_degree <- renderUI({

		span(
			graph()$degree %>% 
				filter(name == input$graph_click_node$label) %>% 
				pull(degree) %>% 
				round(.3)
		)
	})

	output$node_closeness <- renderUI({
		.val_sel(input$graph_click_node)

		span(
			igraph::closeness(
				graph()$igraph, 
				igraph::V(graph()$igraph)[igraph::V(graph()$igraph)$label == input$graph_click_node$label] %>% 
					round(.3)
			)
		)
	})

}

.val_sel <- function(x){
	need(
		!is.null(x) || x != "", ""
	)
}