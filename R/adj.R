#' Create an adjacency list
#'
#' @param ... Integer vectors or a single list of integer vectors.
#'
#' @returns An `adj` list
#' @export
#'
#' @examples
#' adj(1:3, NULL, 4:5)
adj <- function(...) {
  x <- rlang::list2(...)
  if (length(x) == 1 && is.list(x[[1]])) {
    x <- x[[1]]
  }
  x <- validate_adj(x)
  new_adj(x)
}

new_adj <- function(x = list()) {
  new_list_of(x, ptype = integer(), class = 'adj')
}

#' @export
#' @rdname adj
validate_adj <- function(x) {
  if (!is.list(x)) {
    cli::cli_abort(c(
      '{.arg x} must be a list.',
      'x' = 'You supplied an object of class {.cls {class(x)}}.'
    ))
  }

  ints <- vapply(x, rlang::is_integerish, logical(1))
  nulls <- vapply(x, is.null, logical(1))

  if (!all(ints | nulls)) {
    cli::cli_abort(c(
      '{.arg x} must be a list of integer vectors or NULL.',
      'x' = 'You supplied an object of class {.cls {class(x)}}.'
    ))
  }

  x[nulls] <- lapply(x[nulls], function(x) integer(0))

  invisible(x)
}

#' @export
#' @rdname adj
as_adj <- function(x) {
  vec_cast(x, to = new_adj())
}

#' @export
#' @rdname adj
is_adj <- function(x) {
  vec_is(x, ptype = new_adj())
}
