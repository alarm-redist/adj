#' Add and subtract edges from an adjacency list
#'
#' @param x An `adj` list or object coercible to an `adj` list
#' @param v1 vector of vertex identifiers for the first vertex. Can be an
#'   integer index or a value to look up in `ids`, if that argument is provided.
#'   If more than one identifier is present, connects each to corresponding
#'   entry in `v2`.
#' @param v2 vector of vertex identifiers for the second vertex. Can be an
#'   integer index or a value to look up in `ids`, if that argument is provided.
#'   If more than one identifier is present, connects each to corresponding
#'   entry in `v1`.
#' @param ids A vector of unique node identifiers. Each provided vector in `v1`
#'   and `v2` will be matched to these identifiers. If `NULL`, the identifiers
#'   are taken to be 1-indexed integers.
#'
#' @returns An `adj` list
#'
#' @examples
#' a <- adj(c(2, 3), 1, 1)
#' adj_add_edges(a, 2, 3)
#' adj_subtract_edges(a, 1, 2)
#' @name adj_edges
#' @export
adj_add_edges <- function(x, v1, v2, ids = NULL) {
    if (!inherits(x, "adj")) {
        cli::cli_abort("{.arg x} must be an {.cls adj} object.")
    }
    if (length(v1) != length(v2)) {
        cli::cli_abort("{.arg v1} and {.arg v2} lengths are different.")
    }
    if (!is.null(ids) && length(x) != length(ids)) {
        cli::cli_abort("{.arg ids} must be the same length as {.arg x}.")
    }
    duplicates <- attr(x, "duplicates")
    self_loops <- attr(x, "self_loops")

    v1 = as.integer(match_check_ids(list(v1), ids)[[1]])
    v2 = as.integer(match_check_ids(list(v2), ids, check_dups = FALSE)[[1]])

    if (duplicates != "allow") {
        join_fn <- union
    } else {
        join_fn <- c
    }
    for (i in seq_along(v1)) {
        x[[v1[i]]] <- join_fn(x[[v1[i]]], v2[i])
        x[[v2[i]]] <- join_fn(x[[v2[i]]], v1[i])
    }

    validate_adj(x)
}

#' @rdname adj_edges
#' @export
adj_subtract_edges <- function(x, v1, v2, ids = NULL) {
    if (!inherits(x, "adj")) {
        cli::cli_abort("{.arg x} must be an {.cls adj} object.")
    }
    if (length(v1) != length(v2)) {
        cli::cli_abort("{.arg v1} and {.arg v2} lengths are different.")
    }
    if (!is.null(ids) && length(x) != length(ids)) {
        cli::cli_abort("{.arg ids} must be the same length as {.arg x}.")
    }

    v1 = match_check_ids(list(v1), ids)[[1]]
    v2 = match_check_ids(list(v2), ids, check_dups = FALSE)[[1]]

    for (i in seq_along(v1)) {
        x[[v1[i]]] <- setdiff(x[[v1[i]]], v2[i])
        x[[v2[i]]] <- setdiff(x[[v2[i]]], v1[i])
    }

    x
}