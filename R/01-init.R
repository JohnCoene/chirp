#' Initialise
#'
#' Create a \code{_chirp.yml} file in the current working directory.
#'
#' @param edit Whether to open the file for edit.
#'
#' @import tippy
#' @import shiny
#' @import dplyr
#' @import tidygraph
#' @import graphTweets
#' @importFrom utils URLencode
#'
#' @export
build_nest <- function(edit = interactive()){

  config <- "_chirp.yml"

  if(file.exists(config)){
    cat(
      crayon::red(cli::symbol$cross), " The configuration file,", config, " already exists.\n",
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

  if(edit) fileEdit(config)
}

fileEdit <- function(file) {
  fileEditFunc <- eval(parse(text = "file.edit"), envir = globalenv())
  fileEditFunc(file)
}