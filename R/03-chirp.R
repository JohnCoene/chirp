#' Launch
#'
#' Launch dashboard.
#'
#' @export
chirp <- function(){

	file <- "_chirp.yml"

	if(!file.exists(file)){
		cat(
			crayon::red(cli::symbol$cross), "No", file, "in working directory\n"
		)
		return(NULL)
	}

  settings <- yaml::read_yaml(file)

  if(length(settings$credentials) == 0 || length(unlist(settings$credentials)) == 0){

    rtweet_token <- tryCatch(rtweet::get_token(), error = function(e) NULL)

    if(!is.null(rtweet_token)){
      cat(
        crayon::yellow(cli::symbol$warning), "No credentials in", file, 
        ". Using stored credentials found on machine.\n"
      )
    } else {
      cat(
        crayon::red(cli::symbol$cross), "No credentials in", file, "\n"
      )
      return(NULL)  
    }

  } else {
    rtweet_token <- tryCatch(
      rtweet::create_token(
        app = "chirp",
        consumer_key = settings$credentials$consumer_key,
        consumer_secret = settings$credentials$consumer_secret,
        access_token = settings$credentials$access_token,
        access_secret = settings$credentials$access_secret
      ),
      error = function(e) e
    )

    if(inherits(rtweet_token, "error")){
      cat(
        crayon::red(cli::symbol$cross), "Invalid credentials in", file, "\n"
      )
      return(NULL)
    }
  }

  if(!"theme" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No theme set in _chirp.yml, setting to",
      crayon::underline("paper.\n")
    )
    theme <- "paper"
  } else {
    theme <- settings[["style"]][["theme"]]
  }

	if(!"sliders" %in% names(settings[["style"]])){
		cat(
			crayon::yellow(cli::symbol$warning), "No sliders color in _chirp.yml, defaulting to white\n"
		)
		slider_color <- "white"
	} else {
		slider_color <- settings[["style"]][["sliders"]]
	}

  if(!"font" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No font set in _chirp.yml, defaulting to",
      crayon::underline("Raleway.\n")
    )

    font <- "Raleway"
    font_family <- "'Raleway', sans-serif"
  } else {
    font <- settings[["style"]][["font"]]
    font_family <- settings[["style"]][["font_family"]]
  }

  if(!"continuous" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No continuous palette set in _chirp.yml, setting to default.\n"
    )

    palette <- c("#4b2991", "#872ca2", "#c0369d", "#ea4f88", "#fa7876", "#f6a97a", "#edd9a3")
  } else {
    palette <- settings[["style"]][["continuous"]]
  }

  if(!"discrete" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No discrete palette set in _chirp.yml, setting to default discrete palette.\n"
    )

    discrete <- c("#E58606", "#5D69B1", "#52BCA3", "#99C945", "#CC61B0", "#24796C", "#DAA51B",
                  "#2F8AC4", "#764E9F", "#ED645A", "#CC3A8E", "#A5AA99")
  } else {
    discrete <- settings[["style"]][["discrete"]]
  }

  if(!"edges_color" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No edges_color set in _chirp.yml, setting to default.\n"
    )

    edge_color <- "#bababa"
  } else {
    edge_color <- settings[["style"]][["edges_color"]]
  }

  font_name <- gsub("[[:space:]]", "+", font)

  inverse <- settings$style$inverse %||% FALSE

  # head
  head <- tagList(
    tags$link(
      href = paste0("https://fonts.googleapis.com/css?family=", font_name),
      rel = "stylesheet"
    ),
    tags$style(
      paste0("*{font-family: '", font, "', sans-serif;}")
    ),
    tags$link(
      href = "chirp-assets/pushbar.css",
      rel="stylesheet",
      type="text/css"
    ),
    tags$link(
      href = "chirp-assets/custom.css",
      rel = "stylesheet",
      type = "text/css"
    ),
    tags$script(
      src = "chirp-assets/pushbar.js"
    ),
    tags$link(
      href = "chirp-assets/please-wait.css",
      rel = "stylesheet",
      type = "text/css"
    ),
    tags$script(
      src = "chirp-assets/please-wait.min.js"
    ),
    tags$script(
      src = "chirp-assets/custom.js"
    ),
		tags$link(
			rel="shortcut icon",
			href = "https://chirp.sh/img/chirp_favicon.png"
		),
		tags$style(
			paste0(".pushbar{background-color:", slider_color, ";}")
		)
  )

  # add google analytics if present
  if("ganalytics" %in% names(settings$tracking)){

    ga_id <- settings$tracking$ganalytics %||% ""

    ga_tag <- tagList(
      tags$script(
        async = NA,
        src = paste0("https://www.googletagmanager.com/gtag/js?id={{", ga_id, "}}")
      ),
      tags$script(
        paste0(
          "window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', '{{", ga_id, "}}');"
        )
      )
    )

    head <- tagAppendChild(head, ga_tag)
  }

  particles_json <- jsonlite::fromJSON(
    system.file("assets/particles.json", package = "chirp")
  )

  options(
    chirp_discrete = discrete,
    chirp_palette = palette,
    chirp_edge_color = edge_color,
    chirp_font_family = font_family,
    rtweet_token = rtweet_token,
    search_query = ""
  )

  ui <- navbarPage(
    title = "|tʃəːp|",
    fluid = TRUE,
    inverse = inverse,
    windowTitle = "chirp",
    header = head,
    theme = shinythemes::shinytheme(theme),
		id = "tabs",
    tabPanel(
      "HOME",
      shinyjs::useShinyjs(),
      div(
        class = "container",
        style = "min-height:90vh;",
        div(
          style = "width: 100%; height: 300px; position: relative;z-index:-9;",
          div(
            id = "particles-target",
            style = "position: absolute; top: 0; bottom: 0; right: 0; left: 0;"
          ),
          div(
            style = "padding-top:60px;",
            h1("|tʃəːp|", class = "center"),
            h3("Twitter Network Explorer.", class = "center")
          )
        ),
        shinyparticles::particles(particles_json, target_id = "particles-target", element_id = "particles"),
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "SEARCH",
            fluidRow(
              column(
                1, 
								br(), 
								actionButton("opts", "", icon = icon("plus")),
								tippy_this("opts", "More options")
              ),
              column(
                9, 
								textInput("q", "", width = "100%", placeholder = "Enter your search query here."),
								tippy_this("q", "Your search query")
              ),
              column(
                2,
                br(),
                actionButton(
                  "submit", 
                  "Search", 
                  icon = icon("search"), 
                  width = "100%", 
                  class = "btn btn-primary"
                )
              )
            ),
            div(
              id = "options",
              style = "display:none;",
              h3("Options"),
              fluidRow(
                column(
                  4,
                  sliderInput(
                    "n",
                    label = "Number of tweets",
                    min = 500,
                    max = 18000,
                    value = 500,
                    step = 100,
                    width = "100%"
                  ),
									tippy_this("n", "Number of tweets to fetch")
                ),
                column(
                  4, 
									selectInput(
                    "type",
                    "Type",
                    choices = c(
                      "Recent" = "recent",
                      "Mixed" = "mixed",
                      "Popular" = "popular"
                    ),
                    selected = "recent",
                    width = "100%"
                  ),
									tippy_this("type", "Type of tweets to fetch")
                ),
                column(
                  4, 
									checkboxInput(
                    "include_rts",
                    "Include retweets",
                    TRUE,
                    width = "100%"
                  ),
									tippy_this("include_rts", "Whether to include retweets")
                )
              ),
              fluidRow(
                column(
                  3, textInput("longitude", "Longitude", value = "", width = "100%")
                ),
                column(
                  3, textInput("latitude", "Latitude", value = "", width = "100%")
                ),
                column(
                  4, textInput("radius", "Radius", value = "", width = "100%")
                ),
								column(
									2, selectInput("metric", "Metric", choices = c("Kilometer" = "km", "Miles" = "mi"))
								)
              )
            )
          ),
          tabPanel(
            "LOAD",
            fileInput(
              "file",
              label = "Choose one or more previously downloaded Chirp file (.RData)",
              accept = c(".RData", ".rdata"),
              placeholder = " No file selected",
              multiple = TRUE,
              width = "80%"
            )
          )
        ),
        br(),
        br(),
        div(
          style = "position:fixed;bottom:0px;right:43%;",
          p(
            class = "center",
            "Visit", 
            a(
              "chrip.sh",
              href = "https://chirp.sh",
              target = "_blank"
            ),
            "for more information."
          )
        )
      )
    ),
		tabPanel(
			"NETWORKS",
			networks_ui("networks")
		)
  )

  server <- function(input, output, session){

    shinyjs::hide("options")

    observeEvent(input$opts, {
      shinyjs::toggle("options")
    })

    observeEvent(input$submit, {

      geocode <- NULL

      if(input$longitude != "" && input$latitude != "" && input$radius != "")
        geocode <- paste(input$longitude, input$latitude, paste0(input$radius, input$metric), sep = ",")

			lim <- .check_rate_limit()

			if(lim$remaining == 0){
				shinyjs::disable("submit")
        showModal(
					modalDialog(
						title = "Rate limit hit!",
						"You have hit the rate limit, wait until", lim$reset_at, "to make another search.",
						easyClose = TRUE,
						footer = NULL
        	)
				)
			}

			session$sendCustomMessage(
				"load", 
				paste("Fetching", prettyNum(input$n, big.mark = ","), "tweets")
			)

			if(lim$remaining != 0){
				tweets <- rtweet::search_tweets(
					input$q,
					n = input$n,
					type = input$type,
					include_rts = input$include_rts,
					geocode = geocode,
					token = .get_token()
				)

        options(search_query = .clean_input(input$q))
        
				updateTabsetPanel(session = session, inputId = "tabs", selected = "NETWORKS")
				callModule(networks, "networks", dat = tweets)
			}

    })

    observeEvent(input$file, {

      file <- input$file

      if (!is.null(file)){
        session$sendCustomMessage(
          "load", 
          "Loading file..."
        )
        
        tweets <- file$datapath %>% 
          purrr::map_df(function(x){
          get(load(x))
        })

        showTab(inputId = "tabs", target = "NETWORKS")
        updateTabsetPanel(session = session, inputId = "tabs", selected = "NETWORKS")
        callModule(networks, "networks", dat = tweets)
      }

    })

  }

  shinyApp(ui, server)
}
