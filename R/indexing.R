#' @export
`[.adj` <- function(x, i, ...) {
    i = vec_as_location(i, length(x), names = names(x), missing = "error", arg = "i")
    if (anyDuplicated.default(i) > 0) {
        cli::cli_abort("{.arg i} must not contain duplicate indices.")
    }
    vec_restore(.Call(reindex_c, x, i), x)
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
    # Most of the work is in `shift_index_c()` which is highly optimized
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
