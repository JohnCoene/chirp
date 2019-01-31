"%||%" <- function(x, y) {
  if (length(x) > 0 || !is.null(x)) x else y
}
