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

  if(length(settings$credentials) == 0){
    cat(
      crayon::red(cli::symbol$cross), "No credentials in", file, "\n"
    )
    return(NULL)
  }

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

  if(!"palette" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No palette set in _chirp.yml, setting to default palette.\n"
    )

    palette <- c("#4b2991", "#872ca2", "#c0369d", "#ea4f88", "#fa7876", "#f6a97a", "#edd9a3")
  } else {
    palette <- settings[["style"]][["palette"]]
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
      rel="stylesheet",
      type="text/css"
    ),
    tags$script(
      src = "chirp-assets/pushbar.js"
    ),
    tags$script(
      src = "chirp-assets/custom.js"
    )
  )

  # add google analytics if present
  if("ganalytics" %in% names(settings$tracking)){

    ga_id <- settings$tracking$ganalytics

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

  options(
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
      br(),
      br(),
      div(
        class = "container",
        style = "min-height:90vh;",
        br(),
        br(),
        img(
          width = "20%",
          src = "chirp-assets/logo.png",
          alt = "chirp",
          align = "right"
        ),
        br(),
        br(),
        h2("Free, Open-Source Twitter Network Explorer."),
        br(),
        br(),
        fluidRow(
          column(
            1, br(), actionButton("opts", "", icon = icon("plus"))
          ),
          column(
            9, textInput("q", "", width = "100%", placeholder = "Enter your search query here.")
          ),
          column(
            2, br(), actionButton("submit", "Search", icon = icon("search"), width = "100%", class = "btn btn-primary")
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
                min = 100,
                max = 15000,
                value = 1000,
                step = 100,
                width = "100%"
              )
            ),
            column(
              4, selectInput(
                "type",
                "Type",
                choices = c(
                  "Recent" = "recent",
                  "Mixed" = "mixed",
                  "Popular" = "popular"
                ),
                selected = "recent",
                width = "100%"
              )
            ),
            column(
              4, checkboxInput(
                "include_rts",
                "Include retweets",
                TRUE,
                width = "100%"
              )
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
          "Enter a search\nCan include boolean operators such as 'OR' and 'AND'.",
          easyClose = TRUE,
          footer = NULL
        ))
      }

      progress <- shiny::Progress$new()
      on.exit(progress$close())
      progress$set(message = "Fetching tweets", value = sample(seq(.1, .9, by = .1), 1))

      if(input$q != ""){
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
        callModule(networks, "networks", tweets = tweets)
      }

    })

  }

  shinyApp(ui, server)
}
