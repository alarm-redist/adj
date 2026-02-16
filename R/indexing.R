#' Indexing operations on adjacency lists
#'
#' `adj` overrides the default `[` and `c()` methods to allow for filtering,
#' reordering, and concatenating adjacency lists while ensuring that indices
#' remain internally consistent.
#'
#' @param x An adjacency list of class `adj`
#' @param i Indexing vector
#' @param ... For `c()`, adjacency lists to concatenate. Ignored for `[`.
#'
#' @returns A reindexed adjacency list for `[`, and a concatenated adjacency list for `c()`.
#'
#' @examples
#' a <- adj(c(2, 3), c(1, 3), c(1, 2))
#' a[1:2]
#' all(sample(a) == a) # any permutation yields the same graph
#'
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
#' c(a, a) # concatenates graphs with no connecting edges
#' @name adj_indexing
NULL

#' @rdname adj_indexing
#' @export
`[.adj` <- function(x, i, ...) {
    i = vec_as_location(i, length(x), names = names(x), arg = "i")
    out = .Call(reindex_c, x, i)
    if (is.null(out)) {
        slice_adj(x, i) # duplicate indices
    } else {
        reconstruct_adj(out, x)
    }
}

# slow reindexing but correct with duplicate indices
slice_adj <- function(x, i) {
    adj_from_matrix(
        x = as.matrix(x)[i, i],
        duplicates = attr(x, "duplicates"),
        self_loops = attr(x, "self_loops")
    )
}

#' @export
unique.adj <- function(x, incomparables = FALSE, ...) {
    vec_unique(x)
}

#' @rdname adj_indexing
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

    reconstruct_adj(out, args[[1]])
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
        cli::cli_abort("{.arg x} must be an object of class {.cls adj}.") # nocov
    }

    .Call(shift_index_c, x, -1L)
}