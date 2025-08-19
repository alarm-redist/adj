#' @export
vec_ptype_abbr.adj <- function(x, ...) {
  'adj'
}

#' @export
vec_ptype_full.adj <- function(x, ...) {
  'adj'
}

#' @export
format.adj <- function(x, ...) {
  if (length(x) == 0) {
    return(invisible(NULL))
  }

  paste0('adj', adj_preview(x))
}

adj_size <- function(x) {
  lengths(x)
}

adj_preview <- function(x) {
  vapply(x, function(y) {
    n <- length(y)
    ifelse(
      n == 0,
      '[ ]',
      ifelse(
        n <= 3,
        paste0('[', paste(y, collapse = ','), ']'),
        paste0(
          '[',
          paste(head(y, 2), collapse = ','),
          ',...]'
        )
      )
    )
  }, character(1))
}

#' @export
obj_print_data.adj <- function(x, ...) {
  cat(format(x), sep = "\n")
}
