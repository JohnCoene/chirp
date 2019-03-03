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
      icon("database", class = "fa-lg"),
      onclick = "pushbar.open('search_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "search_pushbar",
      id = "search"
    ),
    tags$a(
      icon("searchengin", class = "fa-lg"),
      onclick = "pushbar.open('search_node_pushbar');",
      class = "btn btn-primary",
      `data-pushbar-target` = "search_node_pushbar",
      id = "searchNode"
    ),
    shinyjs::hidden(
      actionButton(
        ns("hide_tweet"),
        "",
        icon = icon("times"),
        class = "btn-danger"
      )
    ),
		conditionalPanel(
    	"input['networks-network'] != 'hashtags'",
			tags$a(
				icon("layer-group", class = "fa-lg"),
				onclick = "pushbar.open('legend_pushbar');",
				class = "btn btn-primary",
				`data-pushbar-target` = "legend_pushbar",
				id = "legendBottom"
			)
		),
    div(
      id = "pushbarSearchNode",
      `data-pushbar-id` = "search_node_pushbar",
      class = "pushbar from_left",
      h4("SEARCH"),
      fluidRow(
        column(9, uiOutput(ns("node_search_ui"))),
        column(
          3,
          br(),
          actionButton(
            ns("search_node"),
            "",
            icon = icon("search-plus"),
            width = "100%",
            class = "btn-primary"
          )
        )
      ),
      radioButtons(
        ns("zoom"),
        "Zoom level",
        choices = c(
          "High" = "high",
          "Medium" = "medium",
          "Low" = "low"
        ),
        inline = TRUE,
        width = "100%",
        selected = "medium"
      ),
      tags$a(
        id = "closeSearchNode",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
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
      uiOutput(ns("selected_headline")),
      uiOutput(ns("selected_source")),
			fluidRow(
        column(6, uiOutput(ns("source_indegree"))),
        column(6, uiOutput(ns("source_outdegree")))
      ),
			fluidRow(
        column(6, uiOutput(ns("source_pagerank"))),
        column(6, uiOutput(ns("source_eigen")))
      ),
      uiOutput(ns("arrow_down")),
      uiOutput(ns("selected_target")),
      fluidRow(
        column(6, uiOutput(ns("target_indegree"))),
        column(6, uiOutput(ns("target_outdegree")))
      ),
      fluidRow(
        column(6, uiOutput(ns("target_pagerank"))),
        column(6, uiOutput(ns("target_eigen")))
      ),
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
          "SEARCH ",
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
              min = .get_tweet_range("min"),
              max = .get_tweet_range("max"),
              value = .get_tweet_range("min"),
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
            fluidRow(
              column(
                7,
                checkboxInput(
                  ns("include_rts"),
                  "Include retweets",
                  TRUE,
                  width = "100%"
                )
              ),
              column(5, checkboxInput(ns("append"), "Append"))
            ),
            tippy_this(ns("include_rts"), "Whether to include retweets"),
            textInput(ns("longitude"), "Longitude", value = "", width = "100%"),
            textInput(ns("latitude"), "Latitude", value = "", width = "100%"),
            fluidRow(
							column(6,textInput(ns("radius"), "Radius", value = "", width = "100%")),
							column(6, selectInput(ns("metric"), "Metric", choices = c("Kilometer" = "km", "Miles" = "mi")))
						)
          )
        ),
        tabPanel(
          "LOAD",
          fileInput(
            ns("file"),
            label = "Choose one or more previously downloaded Chirp file(s) (.RData)",
            accept = c(".RData", ".rdata"),
            placeholder = " No file selected",
            width = "100%",
            multiple = TRUE
          ),
					checkboxInput(ns("append_file"), "Append")
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
    div(
      `data-pushbar-id` = "legend_pushbar",
      class = "pushbar from_bottom",
			fluidRow(
				column(12, uiOutput(ns("legend"), class = "center"))
			),
      tags$a(
        style = "right:20px;bottom:20px;position:absolute;",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
		),
    div(
      id = "pushbarLeft",
      `data-pushbar-id` = "save_pushbar",
      class = "pushbar from_right",
      h4("OPTIONS"),
      br(),
      selectInput(
        ns("network"),
        "NETWORK TYPE",
        choices = c(
          "Retweets" = "retweet_screen_name",
          "Hashtags" = "hashtags",
          "Conversations" = "mentions_screen_name"
        ),
        width = "100%"
      ),
      tippy_this(ns("network"), "Type of network to draw"),
      conditionalPanel(
        "input['networks-network'] != 'retweet_screen_name'",
        checkboxInput(
          ns("comentions"),
          "Co-mentions",
          width = "100%"
        )
      ),
      conditionalPanel(
        "input['networks-network'] == 'retweet_screen_name'",
        checkboxInput(
          ns("quoted"),
          "Include quoted",
          width = "100%",
					value = TRUE
        )
      ),
      fluidRow(
        column(
          6, 
          selectInput(
            ns("size"), 
            "NODES SIZE", 
            choices = c(
              "# tweets" = "n_tweets",
              "In-degree" = "in_degree",
              "Out-degree" = "out_degree",
              "Closeness" = "closeness",
              "Pagerank" = "pagerank",
              "Authority" = "authority",
              "Eigen" = "eigen"
            ),
            width = "100%"
          ),
          tippy_this(ns("size"), "Variable to size nodes")
        ),
        column(
          6, 
          selectInput(
            ns("colour"), 
            "NODES COLOUR", 
            choices = c(
              "Cluster" = "group",
              "# tweets" = "n_tweets",
              "Components" = "components", 
              "In-degree" = "in_degree",
              "Out-degree" = "out_degree",
              "Closeness" = "closeness",
              "Pagerank" = "pagerank",
              "Authority" = "authority",
              "Eigen" = "eigen",
              "Type" = "type"
            ),
            width = "100%"
          ),
          tippy_this(ns("colour"), "Variable to colour nodes")
        )
      ),
      selectInput(
        ns("edges_colour"),
        "EDGES COLOUR",
        choices = c(
          "None" = "none",
          "Sentiment" = "sentiment",
          "# tweets" = "size"
        ),
        width = "100%"
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
			sliderInput(
				ns("node_size"),
				"Filter node by size",
				width = "100%",
				min = 3,
				max = 17,
				value = c(3, 17)
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
      br(),
      actionButton(
        ns("noverlap"), 
        "NO OVERLAP", 
        icon = icon("magnet"),
        width = "100%"
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
      downloadButton(ns("downloadData"), "DOWNLOAD DATA", style = "width:100%;"),
      tags$a(
        id = "closeOpts",
        icon("times"), onclick = "pushbar.close();", class = "btn btn-danger"
      )
    ),
    actionButton(
			ns("vr"),
			"",
      icon = icon("vr-cardboard", class = "fa-lg"),
      class = "btn btn-primary"
    ),
		shinyjqui::jqui_draggable(
			htmlOutput(
				ns("display"), style="position:absolute;z-index:99;left:20px;top:70px;"
			)
		),
		shinycustomloader::withLoader(
			sigmajs::sigmajsOutput(ns("graph"), height = "99vh"),
			type = "html",
			loader = "loader9"
		),
		uiOutput(ns("aforce"))
  )

}

networks <- function(input, output, session, dat){

  tweets <- reactiveVal(dat)

	shinyjs::hide("aforce")

  observeEvent(input$submit, {
    geocode <- NULL

		if(input$longitude != "" && input$latitude != "" && input$radius != "")
			geocode <- paste(input$longitude, input$latitude, paste0(input$radius, input$metric), sep = ",")

    if(input$q != ""){

      session$sendCustomMessage(
        "load", 
        paste("Fetching", prettyNum(input$n, big.mark = ","), "tweets")
      )

			lim <- .check_rate_limit()

      options(search_query = .clean_input(input$q))

			if(lim$remaining == 0){
				shinyjs::disable("submit")
        shinyjs::delay(difftime(Sys.time(), lim$reset_at, units = "secs") * 1000, shinyjs::enable("submit"))
        time <- difftime(Sys.time(), lim$reset_at, units = "mins")
        time <- ceiling(time)
        showModal(
					modalDialog(
						title = "Rate limit hit!",
						"You have hit the rate limit, wait until",
            time 
            , "to make another search.",
						easyClose = TRUE,
						footer = NULL
        	)
				)
			} else {
        tw <- rtweet::search_tweets(
          input$q,
          n = input$n,
          type = input$type,
          include_rts = input$include_rts,
          geocode = geocode,
          token = .get_token()
        )
        if(isTRUE(input$append))
          rbind.data.frame(tweets(), tw) %>% 
            tweets()
        else
          tweets(tw)
      }

			session$sendCustomMessage("unload", "") # stop loading
    }

  })

  observeEvent(input$file, {

    file <- input$file

    s <- ""
    if(length(file$datapath))
      s <- "s"

    session$sendCustomMessage(
      "load", 
      paste0("Loading file", s, "...")
    )
    tw <- file$datapath %>% 
      purrr::map_df(function(x){
      get(load(x))
    })
		if(isTRUE(input$append_file))
			rbind.data.frame(tweets(), tw) %>% 
				tweets()
		else
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

    tw <- tweets() %>% 
      filter(is_retweet %in% c(FALSE, input$include_retweets)) %>% 
      .compute_sentiment()

    if(isTRUE(input$comentions) && input$network %in% c("hashtags", "mentions_screen_name"))
      edges <- tw %>% gt_co_edges(!!sym(input$network))
    else
      edges <- tw %>% 
        gt_edges(screen_name, !!sym(input$network), sentiment) %>% 
        gt_preproc_edges(.preproc)

		if(isTRUE(input$quoted) && input$network == "retweet_screen_name")
			edges <- edges %>% 
				gt_edges_bind(screen_name, quoted_screen_name) 

    graph <- edges %>%
      gt_nodes() %>%
      gt_collect()
    
    graph <- tbl_graph(
      nodes = graph$nodes, 
      edges = graph$edges
    ) %>% 
      activate(nodes) %>% 
      mutate(
        name = nodes,
        id = name,
        label = name,
        n_tweets = n,
        out_degree = centrality_degree(mode = "out"),
        in_degree = centrality_degree(mode = "in"),
        authority = centrality_authority(),
        pagerank = centrality_pagerank(),
        closeness = centrality_closeness(),
        eigen = centrality_eigen(),
        components = group_components(type = "weak"),
        group = group_walktrap()
      ) %>% 
      igraph::as_data_frame("both")
    
    edges <- graph$edges %>% 
      mutate(
        id = 1:n(),
        source = from,
        target = to,
        size = n,
        type = "arrow"
      ) %>% 
      select(-one_of("to", "from"))
    
    nodes <- graph$vertices %>% 
      mutate(
        group = as.factor(group),
        components = as.factor(components)
      ) %>% 
      select(-one_of("n", "nodes"))
    
    session$sendCustomMessage("unload", "") # stop loading

    list(
      nodes = nodes,
      edges = edges
    )

  })

  output$legend <- renderUI({

    nodes <- .color_nodes(graph()$nodes, "group") %>% 
      select(label, group, color)

		if(input$network == "hashtags"){
			return("")
		}

    leg <- tweets() %>% 
      select_("hashtags", "screen_name", "v2" = input$network) %>% 
      mutate(
        screen_name = tolower(screen_name),
        v2 = tolower(v2)
      ) %>% 
      left_join(nodes, by = c("screen_name" = "label")) %>% 
      left_join(nodes, by = c("v2" = "label"), suffix = c("_source", "_target")) %>% 
      mutate(
        group_source = case_when(
          is.na(group_source) ~ group_target,
          TRUE ~ group_source,
        ),
        color_source = case_when(
          is.na(color_source) ~ color_target,
          TRUE ~ color_source,
        ),
        grp = case_when(
          group_source == group_target ~ group_source,
          TRUE ~ group_source
        ),
        color = case_when(
          color_source == color_target ~ color_source,
          TRUE ~ color_source
        )
      )  %>% 
      filter(!is.na(grp)) %>% 
      tidyr::unnest(hashtags) %>% 
			mutate(hashtgas = tolower(hashtags)) %>% 
      group_by(grp, color) %>% 
      count(hashtags, sort = TRUE) %>%  
      filter(hashtags != .get_search_query()) %>% 
      filter(!is.na(hashtags)) %>% 
      slice(1) %>% 
      ungroup() %>% 
      mutate(grp = as.integer(grp)) %>% 
      arrange(grp) %>% 
      slice(1:10) 

    ch <- as.character(unlist(leg$grp))
    ch <- c("all", ch)
    names(ch) <- c("All nodes", paste0("#", as.character(unlist(leg$hashtags))))

    ns <- session$ns
    tgs <- radioButtons(
      ns("legendOut"),
      "FILTER CLUSTERS",
      choices = ch,
      inline = TRUE,
      width = "100%"
    )

    tgs
    
  })

  observeEvent(input$legendOut, {
    ns <- session$ns
    if(input$legendOut != "all")
      sigmajs::sigmajsProxy(ns("graph")) %>% 
        sigmajs::sg_filter_undo_p("legend-filter") %>% 
        sigmajs::sg_filter_eq_p(input$legendOut, "group", name = "legend-filter")
    else if(input$legendOut == "all")
      sigmajs::sigmajsProxy(ns("graph")) %>% 
        sigmajs::sg_filter_undo_p("legend-filter") 
  })

  output$graph <- sigmajs::renderSigmajs({

    g <- graph()

    nodes <- g$nodes
    nodes <- .color_nodes(nodes, "group")
    nodes <- .size_nodes(nodes, "n_tweets")
    edges <- g$edges

    sigmajs::sigmajs(type = "webgl") %>%
      sigmajs::sg_nodes(nodes, id, label, size, color, group) %>%
      sigmajs::sg_edges(edges, id, source, target, type, size) %>%
      sigmajs::sg_force(slowDown = 4) %>%
      sigmajs::sg_neighbours() %>%
      sigmajs::sg_kill() %>%
      sigmajs::sg_drag_nodes() %>%
      sigmajs::sg_force_stop(2500) %>%
			sigmajs::sg_layout() %>% 
      sigmajs::sg_settings(
        minArrowSize = 1,
        batchEdgesDrawing = TRUE,
        edgeColor = "default",
        defaultEdgeColor = .get_edge_color(),
        font = .get_font(),
        labelThreshold = 9999
      )

  })


  observeEvent(input$edges_colour, {

    ns <- session$ns

    edges <- isolate(graph()$edges)

    df <- .color_edges(edges, input$edges_colour)

		sigmajs::sigmajsProxy(ns("graph")) %>% 
			sigmajs::sg_change_edges_p(df, color, "color")
  })

	observeEvent(input$colour, {
		ns <- session$ns

		nodes <- isolate(graph()$nodes)

		df = .color_nodes(nodes, input$colour)

		sigmajs::sigmajsProxy(ns("graph")) %>% 
			sigmajs::sg_change_nodes_p(df, color, "color")
	})

	observeEvent(input$size, {
		ns <- session$ns

		nodes <- isolate(graph()$nodes)

		df = .size_nodes(nodes, input$size)

		sigmajs::sigmajsProxy(ns("graph")) %>% 
			sigmajs::sg_change_nodes_p(df, size, "size")
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

    if(inherits(tw, "error")){
      tw <- ""
      shinyjs::hide("display")
    }

    return(tw)

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
    p(strong("Tweets"), .get_time_scale(trend()$format))
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

    if(isTRUE(input$delete_nodes))
      sigmajs::sigmajsProxy(ns("graph")) %>%
        sigmajs::sg_drop_node_p(id = input$graph_click_node$id)
    else {
      shinyjs::show("display")
      shinyjs::show("hide_tweet")
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

  observeEvent(input$noverlap, {
    ns <- session$ns

    sigmajs::sigmajsProxy(ns("graph")) %>%
      sigmajs::sg_noverlap_p(nodeMargin = .05)

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

  nodes <- data.frame()

  nodes_clicked <- reactive({
    if(!is.null(input$graph_click_nodes))
      nodes <<- rbind.data.frame(input$graph_click_nodes, nodes) %>% 
				slice(1:2)
  })

	output$source_indegree <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

    if(is.null(sel))
      return("")

		span(
      strong("In-degree"),
			graph()$nodes %>% 
			  filter(label == sel) %>% 
			  pull(in_degree) %>% 
			  round(.3)
		)
	})

	output$source_outdegree <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

    if(is.null(sel))
      return("")

		span(
      strong("Out-degree"),
			graph()$nodes %>% 
			  filter(label == sel) %>% 
			  pull(out_degree) %>% 
			  round(.3)
		)
	})

	output$source_pagerank <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

    if(is.null(sel))
      return("")

		span(
      strong("Pagerank"),
			graph()$nodes %>% 
			  filter(label == sel) %>% 
			  pull(pagerank) %>% 
			  round(.3)
		)
	})

	output$source_eigen <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

    if(is.null(sel))
      return("")

		span(
      strong("Eigen"),
			graph()$nodes %>% 
			  filter(label == sel) %>% 
			  pull(eigen) %>% 
			  round(.3)
		)
	})

	output$target_indegree <- renderUI({

    sel <- .slice_node(nodes_clicked(), 2)

    if(!length(sel))
      return("")

		span(
      strong("In-degree"),
      graph()$nodes %>% 
        filter(label == sel) %>% 
        pull(in_degree) %>% 
        round(.3)
		)
	})

	output$target_outdegree <- renderUI({

    sel <- .slice_node(nodes_clicked(), 2)

    if(!length(sel))
      return("")

		span(
      strong("Out-degree"),
      graph()$nodes %>% 
        filter(label == sel) %>% 
        pull(out_degree) %>% 
        round(.3)
		)
	})

  observeEvent(input$graph_click_stage, {
    shinyjs::hide("display")
    shinyjs::hide("hide_tweet")
  })

  observeEvent(input$hide_tweet, {
    shinyjs::hide("display")
    shinyjs::hide("hide_tweet")
  })

	output$target_pagerank <- renderUI({

    sel <- .slice_node(nodes_clicked(), 2)

    if(!length(sel))
      return("")

		span(
      strong("Pagerank"),
      graph()$nodes %>% 
        filter(label == sel) %>% 
        pull(pagerank) %>% 
        round(.3)
		)
	})

	output$target_eigen <- renderUI({

    sel <- .slice_node(nodes_clicked(), 2)

    if(!length(sel))
      return("")

		span(
      strong("Eigen"),
      graph()$nodes %>% 
        filter(label == sel) %>% 
        pull(eigen) %>% 
        round(.3)
		)
	})

	output$selected_headline <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

		if(!is.null(sel))
			h5(
				"SELECTED NODES"
			)

	})

	output$selected_source <- renderUI({

    sel <- .slice_node(nodes_clicked(), 1)

		if(is.null(sel))
			p(
				"Select nodes to see their network metrics",
				class = "text-warning"
			)
		else
			h5(
        tags$a(
          .get_random_icon(),
          href = paste0("https://twitter.com/", sel),
          target = "_blank"
        ),
        sel
      )

	})

  output$arrow_down <- renderUI({
   sel <- .slice_node(nodes_clicked(), 2)

		if(!length(sel))
      ""
    else
      icon("chevron-down", class = "fa-lg center_arrow")
  })

	output$selected_target <- renderUI({

    sel <- .slice_node(nodes_clicked(), 2)

		if(!length(sel))
			span("")
		else
			h5(
        tags$a(
          .get_random_icon(),
          href = paste0("https://twitter.com/", sel),
          target = "_blank"
        ),
        sel
      )

	})

  output$node_search_ui <- renderUI({
    ns <- session$ns

    ch <- graph()$nodes %>% 
      pull(label)
    
    selectizeInput(
      ns("node_searched"),
      "Search for a node",
      multiple = FALSE,
      choices = ch,
      width = "100%"
    )
  })

  observeEvent(input$search_node, {
    ns <- session$ns

    ratio <- .zoom(input$zoom)
    
    id <- graph()$nodes  %>% 
      mutate(id = 1:n()) %>% 
      filter(label == input$node_searched) %>% 
      pull(id)

    sigmajs::sigmajsProxy(ns("graph")) %>% 
      sigmajs::sg_zoom_p(id - 1, duration = 1500, ratio = ratio)
  })

	observeEvent(input$node_size, {
		ns <- session$ns
    sigmajs::sigmajsProxy(ns("graph")) %>% 
      sigmajs::sg_filter_undo_p("lt") %>% 
      sigmajs::sg_filter_undo_p("gt") %>% 
      sigmajs::sg_filter_lt_p(input$node_size[2] + 1, "size", name = "lt") %>% 
      sigmajs::sg_filter_gt_p(input$node_size[1] - 1, "size", name = "gt")
	})

  aforce <- eventReactive(input$vr, {

    vr <- ""

    if(input$vr %% 2 == 1){
      session$sendCustomMessage(
        "load", 
        "Get your headset!"
      )
			
      g <- graph()

      nodes <- g$nodes
      nodes <- .color_nodes(nodes, "group")
      nodes <- .size_nodes(nodes, "n_tweets")

      vr <- aforce::aForce$
        new(n_label = "label")$ # initialise
        nodes(nodes, id, size, color, label)$ # add nodes
        links(graph()$edges, source, target)$ # add edges
        build( # build
          aframer::a_camera(
            `wasd-controls` = "fly: true; acceleration: 600",
            aframer::a_cursor(opacity = 0.5)
          ),
          aframer::a_sky(color=getOption("vr_background"))
        )$ 
        embed(width="100%", height = "80vh")

      session$sendCustomMessage(
        "unload", 
        ""
      )
    } 

    return(vr)
  })

	output$aforce <- renderUI({
    aforce()
	})

  observeEvent(input$vr, {
    shinyjs::toggle("aforce")
  })

}
