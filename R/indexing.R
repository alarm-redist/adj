#' @export
`[.adj` <- function(x, i, ...) {
    i = vec_as_location(i, length(x), names = names(x), missing = "error", arg = "i")
    out = .Call(reindex_c, x, i)
    vec_restore(out, x)
}
#' @export
`[<-.adj` <- function(x, i, value) {
    cli::cli_abort("Assignment is not supported for adjacency lists.")
}

#' @export
c.adj <- function(...) {
    args = vec_cast_common(..., .to = new_adj())
    n = length(args)
    if (n == 1) {
        return(args[[1]])
    }

    # Concatenating lists is a rare operation, so we won't optimize much
    # Most of the work is in `shift_index_c()` anyway, which is highly optimized
    ll = cumsum(lengths(args))
    out = vector("list", ll[n])
    out[seq_len(ll[1])] = args[[1]]
    for (i in seq_len(n - 1L)) {
        start = ll[i] + 1L
        end = ll[i + 1L]
        if (end >= start) {
            out[start:end] = .Call(shift_index_c, args[[i + 1L]], ll[i])
        }
    }

    vec_restore(out, args[[1]])
}

#' Factor adjacency list
#'
#' Computes the factor graph of a given adjacency list by a provided grouping
#' vector. Nodes in the same groups are merged into single nodes in the factor
#' graph. The resulting multi-edges and self-loops are handled according to the
#' specified parameters.
#'
#' @param x An `adj` list
#' @param groups A vector specifying the group membership for each node in `x`.
#'   `adj_factor()` will process this vector with [vctrs::vec_group_id()].
#' @param n_groups Number of unique groups.
#' @inheritParams adj
#'
#' @returns A new `adj` list.
#'
#' @examples
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' # merge two islands (A and D)
#' adj_factor(a, c("AD", "B", "C", "AD"))
#' adj_factor_int(a, c(1L, 2L, 3L, 1L), n_group = 3L, self_loops = "allow")
#' @export
adj_factor <- function(
    x,
    groups,
    duplicates = c("remove", "allow", "error", "warn"),
    self_loops = c("remove", "allow", "error", "warn")
) {
    groups = vec_group_id(groups)
    adj_factor_int(
        x,
        groups,
        attr(groups, "n"),
        duplicates = rlang::arg_match(duplicates),
        self_loops = rlang::arg_match(self_loops)
    )
}

#' @rdname adj_factor
#' @export
adj_factor_int <- function(
    x,
    groups,
    n_groups,
    duplicates = c("remove", "allow", "error", "warn"),
    self_loops = c("remove", "allow", "error", "warn")
) {
    duplicates = rlang::arg_match(duplicates)
    self_loops = rlang::arg_match(self_loops)
    out = .Call(factor_c, x, groups, n_groups, duplicates != "remove", self_loops != "remove")

    validate = all(c(duplicates, self_loops) %in% c("warn", "error"))
    if (duplicates == "remove") {
        duplicates = "error"
    }
    if (self_loops == "remove") {
        self_loops = "error"
    }
    out = new_adj(out, duplicates = duplicates, self_loops = self_loops)
    if (validate) {
        validate_adj(out)
    }
    out
}

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

    .Call(shift_index_c, x, -1L)
}
