#' @export
vec_proxy_equal.adj <- function(x, ...) {
    lapply(unclass(x), sort.int, na.last = TRUE)
}

#' @export
vec_proxy_compare.adj <- function(x, ...) {
    cli::cli_abort("Comparisons are not supported for adjacency lists.")
}
#' @export
vec_proxy_order.adj <- function(x, ...) {
    cli::cli_abort("Comparisons are not supported for adjacency lists.")
}

# Hacky :( to handle indexing
#' @export
vec_proxy.adj <- function(x, ...) {
    seq_along(x)
}
#' @export
vec_restore.adj <- function(x, to, ...) {
    to[x]
}

