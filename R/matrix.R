#' Convert adjacency lists to and from adjacency matrices
#'
#' Adjacency lists can be converted to adjacency matrices and vice versa without
#' loss.
#'
#' @param x An adjacency list or matrix
#' @param sparse If `TRUE`, return a sparse matrix, which is often preferable
#'   for computation. See [Matrix::sparseMatrix] for details on this class.
#' @inheritParams adj
#' @param ... Ignored.
#'
#' @returns `adj_from_matrix()` returns an `adj` list; `as.matrix()` returns a matrix.
#'
#' @examples
#' adj_from_matrix(1 - diag(3))
#'
#' a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' mat = as.matrix(a)
#' all(a == adj_from_matrix(mat, duplicates = "allow")) # TRUE
#' @name adj_matrix
NULL

#' @rdname adj_matrix
#' @export
adj_from_matrix <- function(
    x,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    if (inherits(x, "sparseMatrix")) {
        return(adj_from_sparse_matrix(x, duplicates, self_loops))
    }
    if (!is.matrix(x)) {
        cli::cli_abort("{.arg x} must be a matrix.") # nocov
    }
    n = nrow(x)
    if (n != ncol(x)) {
        cli::cli_abort("{.arg x} must be a square matrix.") # nocov
    }

    out = vector("list", n)
    for (i in seq_len(n)) {
        nrep = x[i, ]
        pos = which(nrep > 0L)
        out[[i]] = rep.int(pos, times = nrep[pos])
    }

    out = new_adj(
        out,
        duplicates = rlang::arg_match(duplicates),
        self_loops = rlang::arg_match(self_loops)
    )
    validate_adj(out)
    out
}

adj_from_sparse_matrix <- function(
    x,
    duplicates = c("warn", "error", "allow", "remove"),
    self_loops = c("warn", "error", "allow", "remove")
) {
    rlang::check_installed("Matrix", "for sparse matrix conversion")
    if (inherits(x, "TsparseMatrix")) {
        cli::cli_abort("{.cls TsparseMatrix} objects are not supported.") # nocov
    }
    n = nrow(x)
    if (n != ncol(x)) {
        cli::cli_abort("{.arg x} must be a square matrix.") # nocov
    }


    if (!inherits(x, "RsparseMatrix")) {
        x = methods::as(x, "RsparseMatrix")
    }
    out = vector("list", n)
    pdiff = diff(x@p)
    if (methods::.hasSlot(x, "x")) {
        for (i in seq_len(n)) {
            idx = x@p[i] + seq_len(pdiff[i])
            out[[i]] = rep.int(x@j[idx], times = x@x[idx])
        }
    } else {
        for (i in seq_len(n)) {
            out[[i]] = x@j[x@p[i] + seq_len(pdiff[i])]
        }
    }

    out = new_adj(
        .Call(shift_index_c, out, 1L),
        duplicates = rlang::arg_match(duplicates),
        self_loops = rlang::arg_match(self_loops)
    )
    validate_adj(out)
    out
}


#' @rdname adj_matrix
#' @export
as.matrix.adj <- function(x, sparse = FALSE, ...) {
    if (isTRUE(sparse)) {
        return(as_sparse_matrix(x))
    }
    n = length(x)
    out = matrix(0L, nrow = n, ncol = n)
    if (assume_duplicates(x)) {
        for (i in seq_len(n)) {
            out[i, ] = tabulate(x[[i]], nbins = n)
        }
    } else {
        for (i in seq_len(n)) {
            out[i, x[[i]]] = 1L
        }
    }
    out
}

as_sparse_matrix <- function(x) {
    rlang::check_installed("Matrix", "for sparse matrix conversion")
    n = length(x)
    n_elem = sum(lengths(x))
    p = integer(n + 1)
    j = integer(0)
    out = integer(0)
    if (assume_duplicates(x)) {
        for (k in seq_len(n)) {
            entries = tabulate(x[[k]], nbins = n)
            pres = which(entries > 0L)
            p[k + 1] = length(pres)
            j = c(j, pres)
            out = c(out, entries[pres])
        }

        Matrix::sparseMatrix(
            j = j,
            p = cumsum(p),
            x = out,
            dims = c(n, n),
            repr = "C",
            check = FALSE
        )
    } else {
        Matrix::sparseMatrix(
            j = unlist(x),
            p = c(0L, cumsum(lengths(x))),
            dims = c(n, n),
            index1 = TRUE,
            repr = "C",
            check = FALSE
        )
    }
}
