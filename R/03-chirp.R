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
  } else {
    font <- settings[["style"]][["font"]]
  }

  if(!"chart_theme" %in% names(settings[["style"]])){
    cat(
      crayon::yellow(cli::symbol$warning), "No chart theme set in _chirp.yml, setting to",
      crayon::underline("default.\n")
    )

    echarts4r_theme <- "default"
  } else {
    echarts4r_theme <- settings[["style"]][["chart_theme"]]
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

  ui <- navbarPage(
    title = div(
      img(
        src = "https://auritus.io/logo.png",
        height="28",
        style = "margin-right: 25px;"
      )
    ),
    fluid = TRUE,
    inverse = inverse,
    windowTitle = "auritus",
    header = head,
    theme = shinythemes::shinytheme(theme),
    tabPanel(
      "HOME",
      homeUI("home")
    ),
    footer = tagList(
      hr(),
      div(
        class = "container",
        fluidRow(
          column(
            12, 
            "Developed with",
            class = "pull-right",
            tags$a(
              href = "https://chirp.sh",
              target = "_blank",
              "chirp",
              class = "text-info"
            )
          )
        )
      ),
      br()
    )
  )

  server <- function(input, output, session){
  }

  shinyApp(ui, server)
}