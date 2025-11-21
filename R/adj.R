#' Create an adjacency list
#'
#' Create an adjacency list from a list of vectors of adjacent node identifiers.
#'
#' ## Equality
#' Equality for `adj` lists is evaluated elementwise. Two sets of neighbors are
#' considered equal if they contain the same neighbors, regardless of order.
#'
#' ## Number of nodes and edges
#' The `adj` package is not focused on graph operations. The `length()` function
#' will return the number of nodes. To compute the number of edges in an
#' adjacency list `a`, use `sum(lengths(a))`, and divide by 2 for undirected
#' graphs.
#'
#' @param ... Vectors or a single list of vectors. Vectors should be comprised
#'   either of (1-indexed) indices of adjacent nodes, or of unique identifiers,
#'   which must match to the provided `ids`.
#'   `NULL` can be used in place of a length-zero vector for nodes without
#'   neighbors.
#' @param ids A vector of unique node identifiers. Each provided vector in `...`
#'   will be matched to these identifiers. If `NULL`, the identifiers are taken
#'   to be 1-indexed integers.
#' @param duplicates Controls handling of duplicate neighbors. The default
#'   `"warn"` warns the user; `"error"` throws an error; `"allow"` allows
#'   duplicates, and `"remove"` removes duplicates silently and then sets the
#'   corresponding attribute to `"error"`.
#' @param self_loops Controls handling of self-loops (nodes that are adjacent
#'   to themselves). The default `"warn"` warns the user; `"error"` throws an
#'   error; `"allow"` allows self-loops, and `"remove"` removes self-loops
#'   silently and then sets the corresponding attribute to `"error"`.
#'
#' @returns An `adj` list
#'
#' @examples
#' a1 = adj(list(c(2, 3), c(1, 3), c(1, 2)))
#' a2 = adj(list(c(3, 2), c(3, 1), c(2, 1)))
#' a1 == a2
#'
#' adj(2:3, NULL, 4:5, integer(0), 1)
#' adj(1, 2, 3, self_loops = "remove")
#'
#' adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
#' @export
adj <- function(
    ...,
    ids = NULL,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    x <- rlang::list2(...)
    if (length(x) == 1 && is.list(x[[1]])) {
        x <- x[[1]]
    }

    # match IDs
    if (!is.null(ids)) {
        x <- lapply(x, match, table = ids)
    }

    # handle types
    ints <- vapply(x, rlang::is_integerish, FALSE)
    nulls <- vapply(x, is.null, FALSE)
    if (!all(ints | nulls)) {
        cli::cli_abort(c(
            "{.arg x} must be a list of integer vectors or NULL.",
            "x" = "You supplied an object of class {.cls {class(x)}}."
        ))
    }
    x[nulls] <- lapply(x[nulls], function(x) integer(0))
    x[ints] <- lapply(x[ints], as.integer)

    # handle duplicates and self-loops
    duplicates = rlang::arg_match(duplicates)
    if (duplicates == "remove") {
        duplicates = "error"
        x = lapply(x, vec_unique)
    }
    self_loops = rlang::arg_match(self_loops)
    if (self_loops == "remove") {
        self_loops = "error"
        x = lapply(seq_along(x), function(i) {
            nbors = x[[i]]
            nbors[nbors != i]
        })
    }

    x = validate_adj(new_adj(x, duplicates, self_loops))
    x
}

new_adj <- function(
    x = list(),
    duplicates = "warn",
    self_loops = "warn"
) {
    new_list_of(
        x,
        ptype = integer(),
        duplicates = duplicates,
        self_loops = self_loops,
        class = "adj"
    )
}

#' @param x An adjacency list
#' @export
#' @rdname adj
validate_adj <- function(x) {
    if (!is.list(x)) {
        cli::cli_abort("{.arg x} must be a list.")
    }

    # check indices
    all_idx = unlist(vec_data(x))
    invalid = all_idx < 1 | all_idx > length(x) | is.na(all_idx)
    if (any(invalid)) {
        cli::cli_abort(c(
            "Out-of-bounds or missing indices found in adjacency list.",
            "x" = "Found {sort(unique(all_idx[invalid]), na.last=FALSE)}."
        ))
    }

    # handle duplicates and self-loops
    mode_dups = attr(x, "duplicates")
    if (mode_dups != "allow") {
        dups = vapply(seq_along(x), function(i) vec_duplicate_any(x[[i]]), FALSE)
        if (any(dups)) {
            dup_msg = c(
                "Duplicate neighbors found in adjacency list.",
                "i" = "Found duplicate{?s} at node{?s} {as.character(which(dups))}."
            )
            if (mode_dups == "warn") {
                cli::cli_warn(dup_msg)
            } else if (mode_dups == "error") {
                cli::cli_abort(dup_msg)
            } else {
                cli::cli_abort("{.arg duplicates} must be one of 'warn', 'error', or 'allow'.")
            }
        }
    }

    mode_loops = attr(x, "self_loops")
    if (mode_loops != "allow") {
        loops = vapply(seq_along(x), function(i) i %in% x[[i]], FALSE)
        if (any(loops)) {
            loop_msg = c(
                "Self-loops found in adjacency list.",
                "i" = "Found self-loop{?s} at node{?s} {as.character(which(loops))}."
            )
            if (mode_loops == "warn") {
                cli::cli_warn(loop_msg)
            } else if (mode_loops == "error") {
                cli::cli_abort(loop_msg)
            } else {
                cli::cli_abort("{.arg self_loops} must be one of 'warn', 'error', or 'allow'.")
            }
        }
    }

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
