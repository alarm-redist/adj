#' Create an adjacency list
#'
#' Create an adjacency list from a list of vectors of adjacent node identifiers.
#'
#' ## Equality
#' Equality for `adj` lists is evaluated elementwise. Two sets of neighbors are
#' considered equal if they contain the same neighbors, regardless of order.
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
#'   duplicates, and `"remove"` removes duplicates silently.
#' @param self_loops Controls handling of self-loops (nodes that are adjacent
#'   to themselves). The default `"warn"` warns the user; `"error"` throws an
#'   error; `"allow"` allows self-loops, and `"remove"` removes self-loops silently.
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
    duplicates = rlang::arg_match(duplicates)
    x <- rlang::list2(...)
    if (length(x) == 1 && is.list(x[[1]])) {
        x <- x[[1]]
    }
    if (!is.null(ids)) {
        x <- lapply(x, match, table = ids)
    }
    x <- validate_adj(x, duplicates = duplicates, self_loops = self_loops)
    new_adj(x)
}

new_adj <- function(x = list()) {
    new_list_of(x, ptype = integer(), class = "adj")
}

#' @param x An adjacency list
#' @export
#' @rdname adj
validate_adj <- function(
    x,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    if (!is.list(x)) {
        cli::cli_abort(c(
            "{.arg x} must be a list.",
            "x" = "You supplied an object of class {.cls {class(x)}}."
        ))
    }
    x = as.list(x)

    # handle types
    ints <- vapply(x, rlang::is_integerish, logical(1))
    nulls <- vapply(x, is.null, logical(1))
    if (!all(ints | nulls)) {
        cli::cli_abort(c(
            "{.arg x} must be a list of integer vectors or NULL.",
            "x" = "You supplied an object of class {.cls {class(x)}}."
        ))
    }
    x[nulls] <- lapply(x[nulls], function(x) integer(0))
    x[ints] <- lapply(x[ints], as.integer)

    # check indices
    all_idx = unlist(x[ints])
    invalid = all_idx < 1 | all_idx > length(x) | is.na(all_idx)
    if (any(invalid)) {
        cli::cli_abort(c(
            "Out-of-bounds or missing indices found in adjacency list.",
            "x" = "Found {sort(unique(all_idx[invalid]), na.last=FALSE)}."
        ))
    }

    # handle duplicates
    dup_msg = c(
        "Duplicate neighbors found in adjacency list.",
        "i" = "Found duplicates at node {i}."
    )
    handle_dup = switch(
        rlang::arg_match(duplicates),
        "warn" = function(v, i) {
            cli::cli_warn(dup_msg)
            v
        },
        "error" = function(v, i) cli::cli_abort(dup_msg),
        "allow" = function(v, i) v,
        "remove" = function(v, i) vec_unique(v)
    )
    x = lapply(seq_along(x), function(i) {
        nbors = x[[i]]
        if (vec_duplicate_any(nbors)) handle_dup(nbors, i) else nbors
    })

    # handle self-loops
    loop_msg = c(
        "Self-loops found in adjacency list.",
        "i" = "Found self-loop at node {i}."
    )
    handle_loop = switch(
        rlang::arg_match(self_loops),
        "warn" = function(v, i) {
            cli::cli_warn(loop_msg)
            v
        },
        "error" = function(v, i) cli::cli_abort(loop_msg),
        "allow" = function(v, i) v,
        "remove" = function(v, i) v[v != i]
    )
    x = lapply(seq_along(x), function(i) {
        nbors = x[[i]]
        if (i %in% nbors) handle_loop(nbors, i) else nbors
    })

    invisible(new_adj(x))
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
