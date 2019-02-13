.onLoad <- function(libname, pkgname) {
  shiny::addResourcePath(
    "chirp-assets",
    system.file("assets", package = "chirp")
  )
}
