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
    rtweet_token = rtweet_token
  )

  ui <- navbarPage(
    title = div(
      img(
        src = "chirp-assets/logo.png",
        height="28",
        style = "margin-right: 25px;"
      )
    ),
    fluid = TRUE,
    inverse = inverse,
    windowTitle = "chirp",
    header = head,
    theme = shinythemes::shinytheme(theme),
		id = "tabs",
    tabPanel(
      "HOME",
      shinyjs::useShinyjs(),
      shinyparticles::particles(particles_json),
      div(
        class = "container",
        style = "min-height:90vh;",
        # img(
        #   width = "10%",
        #   src = "chirp-assets/logo.png",
        #   alt = "chirp"
        # ),
        br(),
        br(),
        h1("/tʃɜː(r)p/", class = "center"),
        h3("Free, Open-Source Twitter Network Explorer.", class = "center"),
        br(),
        br(),
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
              style = "display:none;background:rgba(255,255,255,.6);",
              h3("Options"),
              fluidRow(
                column(
                  4,
                  sliderInput(
                    "n",
                    label = "Number of tweets",
                    min = 500,
                    max = 15000,
                    value = 1000,
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
                  4, textInput("longitude", "Longitude", value = "", width = "100%")
                ),
                column(
                  4, textInput("latitude", "Latitude", value = "", width = "100%")
                ),
                column(
                  4, textInput("radius", "Radius", value = "", width = "100%")
                )
              )
            )
          ),
          tabPanel(
            "LOAD",
            fileInput(
              "file",
              label = "Choose an .RData file",
              accept = c(".RData", ".rdata"),
              placeholder = " No file selected"
            )
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

    # tab initialy hidden
		hideTab(inputId = "tabs", target = "NETWORKS")

    shinyjs::hide("options")

    observeEvent(input$opts, {
      shinyjs::toggle("options")
    })

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

        tweets <- rtweet::search_tweets(
          input$q,
          n = input$n,
          type = input$type,
          include_rts = input$include_rts,
          geocode = geocode,
          token = .get_token()
        )

        showTab(inputId = "tabs", target = "NETWORKS")
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
        tweets <- get(load(file$datapath))

        showTab(inputId = "tabs", target = "NETWORKS")
        updateTabsetPanel(session = session, inputId = "tabs", selected = "NETWORKS")
        callModule(networks, "networks", dat = tweets)
      }

    })

  }

  shinyApp(ui, server)
}
