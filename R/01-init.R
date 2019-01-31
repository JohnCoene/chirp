#' Initialise
#'
#' Create a \code{_chirp.yml} file in working directory.
#'
#' @import shiny
#' @import dplyr
#'
#' @export
build_nest <- function(){

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
      crayon::green(cli::symbol$tick), "Copied", crayon::underline(config), "\n"
    )
  }

}
