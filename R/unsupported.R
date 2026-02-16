#' @export
`[<-.adj` <- function(x, i, value) {
    cli::cli_abort("Assignment is not supported for adjacency lists.") # nocov
}

#' @export
`$.adj` <- function(x, i) {
    cli::cli_abort("Use `[[` to extract elements from an adjacency list.") # nocov
}
#' @export
`$<-.adj` <- function(x, i, value) {
    cli::cli_abort("Use `[[<-` to assign elements in an adjacency list.") # nocov
}

#' @export
rep.adj <- function(x, ...) {
    cli::cli_abort("Replication is not supported for adjacency lists.") # nocov
}
#' @export
`length<-.adj` <- function(x, value) {
    cli::cli_abort("Length modification is not supported for adjacency lists.") # nocov
}
#' @export
`dim<-.adj` <- function(x, value) {
    cli::cli_abort("Adjacency lists do not have dimensions.")
}
#' @export
`levels<-.adj` <- function(x, value) {
    cli::cli_abort("Adjacency lists do not have dimensions.")
}


#' @export
vec_proxy_compare.adj <- function(x, ...) {
    cli::cli_abort("Comparisons are not supported for adjacency lists.")
}
#' @export
vec_proxy_order.adj <- function(x, ...) {
    cli::cli_abort("Comparisons are not supported for adjacency lists.")
}

#' @export
sort.adj <- function(x, decreasing = FALSE, ...) {
    cli::cli_abort("Sorting is not supported for adjacency lists.")
}
