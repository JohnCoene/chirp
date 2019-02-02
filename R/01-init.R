#' Initialise
#'
#' Create a \code{_chirp.yml} file as well as \code{www} folder in the current working directory.
#'
#' @import shiny
#' @import dplyr
#' @import graphTweets
#' @importFrom utils URLencode
#'
#' @export
build_nest <- function(){

  dir <- "www"
  config <- "_chirp.yml"

  if(file.exists(config)){
    cat(
      crayon::red(cli::symbol$cross), " The configuration file,", crayon::underline(config), " already exists.\n",
      sep = ""
    )

  } else {
    file.copy(
      system.file("templates/chirp.yml", package = "chirp"),
      config
    )

    cat(
      crayon::green(cli::symbol$tick), "Copied", config, "\n"
    )
  }

}
