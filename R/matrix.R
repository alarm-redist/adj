#' Convert adjacency lists to and from adjacency matrices
#'
#' Adjacency lists can be converted to adjacency matrices and vice versa without
#' loss.
#'
#' @param x An adjacency list or matrix
#' @inheritParams adj
#' @param ... Ignored.
#'
#' @returns `from_matrix()` returns an `adj` list; `as.matrix()` returns a matrix.
#'
#' @examples
#' from_matrix(1 - diag(3))
#'
#' a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' mat = as.matrix(a)
#' all(a == from_matrix(mat, duplicates = "allow")) # TRUE
#' @export
from_matrix <- function(
    x,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    if (!is.matrix(x)) {
        cli::cli_abort("{.arg x} must be a matrix.")
    }
    n = nrow(x)
    if (n != ncol(x)) {
        cli::cli_abort("{.arg x} must be a square matrix.")
    }

    out = vector("list", n)
    for (i in seq_len(n)) {
        out[[i]] = rep.int(seq_len(n), times = x[i, ])
    }

    out = new_adj(
        out,
        duplicates = rlang::arg_match(duplicates),
        self_loops = rlang::arg_match(self_loops)
    )
    validate_adj(out)
}

#' @rdname from_matrix
#' @export
as.matrix.adj <- function(x, ...) {
    n = length(x)
    out = matrix(0L, nrow = n, ncol = n)
    for (i in seq_len(n)) {
        out[i, ] = tabulate(x[[i]], nbins = n)
    }
    out
}
