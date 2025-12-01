#' Add and subtract edges from an adjacency list
#'
#' @param adj An `adj` list or object coercible to an `adj` list
#' @param v1 vector of vertex identifiers for the first vertex. Can be an
#'   integer index or a value to look up in `ids`, if that argument is provided.
#'   If more than one identifier is present, connects each to corresponding
#'   entry in `v2`.
#' @param v2 vector of vertex identifiers for the second vertex. Can be an
#'   integer index or a value to look up in `ids`, if that argument is provided.
#'   If more than one identifier is present, connects each to corresponding
#'   entry in `v1`.
#' @param ids A vector of unique node identifiers. Each provided vector in `v1`
#'   and `v2` will be matched to these identifiers. If `NULL`, the identifiers \
#'   are taken to be 1-indexed integers.
#' @param duplicates `r roxy_duplicates()`
#' @param self_loops `r roxy_self_loops()`
#'
#' @returns An `adj` list
#'
#' @examples
#' a <- adj(c(2, 3), 1, 1)
#' adj_add_edges(a, 2, 3)
#' adj_subtract_edges(a, 1, 2)
#' @name adj_edges
#' @export
adj_add_edges <- function(
    adj,
    v1,
    v2,
    ids = NULL,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    duplicates <- rlang::arg_match(duplicates)
    self_loops <- rlang::arg_match(self_loops)
    if (length(v1) != length(v2)) {
        cli::cli_abort("{.arg v1} and {.arg v2} lengths are different.")
    }

    matched <- match_vtxs(adj, v1, v2, ids)
    v1 <- matched$v1
    v2 <- matched$v2

    if (duplicates != "allow") {
        join_fn <- union
    } else {
        join_fn <- c
    }
    for (i in seq_along(v1)) {
        adj[[v1[i]]] <- join_fn(adj[[v1[i]]], v2[i])
        adj[[v2[i]]] <- join_fn(adj[[v2[i]]], v1[i])
    }

    new_adj(adj, duplicates, self_loops)
}

#' @rdname adj_edges
#' @export
adj_subtract_edges <- function(
    adj,
    v1,
    v2,
    ids = NULL,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    duplicates <- rlang::arg_match(duplicates)
    self_loops <- rlang::arg_match(self_loops)
    if (length(v1) != length(v2)) {
        cli::cli_abort("{.arg v1} and {.arg v2} lengths are different.")
    }

    matched <- match_vtxs(adj, v1, v2, ids)
    v1 <- matched$v1
    v2 <- matched$v2

    for (i in seq_along(v1)) {
        adj[[v1[i]]] <- setdiff(adj[[v1[i]]], v2[i])
        adj[[v2[i]]] <- setdiff(adj[[v2[i]]], v1[i])
    }

    new_adj(adj, duplicates, self_loops)
}

match_vtxs <- function(adj, v1, v2, ids = NULL) {
    if (!is.null(ids)) {
        if (length(adj) != length(ids)) {
            cli::cli_abort(
                '{.arg ids} must be the same length as {.arg adj}.',
                call = parent.frame()
            )
        }

        lv1 <- lapply(v1, function(x) which(x == ids))
        lv2 <- lapply(v2, function(x) which(x == ids))

        if (any(lengths(lv1) > 1) || any(lengths(lv2) > 1)) {
            cli::cli_abort(
                c(
                    'Provided {.arg ids} are not unique:',
                    'i' = 'Duplicates: {c(v1[lengths(lv1) > 1], v2[lengths(lv2) > 1])}'
                ),
                call = parent.frame()
            )
        }
        if (any(lengths(lv1) == 0) || any(lengths(lv2) == 0)) {
            cli::cli_abort(
                c(
                    'Some values in {.arg v1} and {.arg v2} are not in {.arg ids}:',
                    'i' = 'Missing: {c(v1[lengths(lv1) == 0], v2[lengths(lv2) == 0])}'
                ),
                call = parent.frame()
            )
        }

        v1 <- unlist(lv1)
        v2 <- unlist(lv2)
    }

    list(v1 = v1, v2 = v2)
}
