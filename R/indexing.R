#' Convert adjacency list to use zero-based indices
#'
#' Subtracts 1 from each index in the adjacency list and returns a bare list of
#' integer vectors, suitable for providing to C/C++ code that uses zero-based
#' indexing.
#'
#' @param x An adjacency list.
#'
#' @returns A list of integer vectors with zero-based indices.
#'
#' @examples
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' adj_zero_index(a)
#' @export
adj_zero_index <- function(x) {
    if (!is.list(x)) {
        cli::cli_abort("{.arg x} must be an object of class {.cls adj}.")
    }

    .Call(zero_index_c, x)
}
