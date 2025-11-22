#' @export
vec_ptype_abbr.adj <- function(x, ...) {
    "adj"
}

#' @export
vec_ptype_full.adj <- function(x, ...) {
    "adj"
}

#' Format and print methods for adjacency lists
#'
#' Adjacency lists are printed as sets of indices for each node.
#'
#' @param x An `adj` list.
#' @param n Maximum number of neighbors to show before truncating with an ellipsis.
#' @param ... Ignored.
#'
#' @returns A character vector representing each entry in the adjacency list.
#'
#' @examples
#' a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' format(a)
#' print(a, n = 5)
#' @export
format.adj <- function(x, n = 3, ...) {
    if (length(x) == 0) {
        return(invisible(NULL))
    }
    vapply(x, adj_preview, character(1), n_max = n)
}

adj_size <- function(x) {
    lengths(x)
}

adj_preview <- function(x, n_max = 3) {
    n <- length(x)
    ifelse(
        n <= n_max,
        paste0("{", paste0(x, collapse = ", "), "}"),
        paste0("{", paste0(x[seq_len(n_max)], collapse = ", "), ", \u2026}")
    )
}


#' @export
obj_print_data.adj <- function(x, n = 3, ...) {
    if (length(x) == 0) {
        return(invisible(x))
    }
    out <- vec_set_names(format(x, n = n), names(x))
    print(out, quote = FALSE)
}
