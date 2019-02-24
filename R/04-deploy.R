#' Deploy
#' 
#' Creates the necessary \code{app.R} file in the current working directory.
#'
#' @param edit Whether to open the file for edit.
#' 
#' @export
fly <- function(edit = interactive()) {

  file <- "app.R"

  if(file.exists(file)){
    cat(
      crayon::red(cli::symbol$cross), " The app.R file,", file, " already exists.\n",
      sep = ""
    )

  } else {
    file.copy(
      system.file("templates/app.R", package = "chirp"),
      file
    )

    cat(
      crayon::green(cli::symbol$tick), "Copied", file, "\n"
    )
  }

  if(edit) fileEdit(file)
}