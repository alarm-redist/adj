#' Casting `adj` lists
#'
#' Dispatch methods for [vctrs::vec_cast()]
#'
#' @inheritParams vctrs::vec_cast
#'
#' @return a vector of the same length, as class `adj` if convertible, otherwise `list`
#'
#' @keywords internal
#' @method vec_cast adj
#' @export
#' @export vec_cast.adj
vec_cast.adj <- function(x, to, ...) {
    UseMethod("vec_cast.adj") # nocov
}

#' @method vec_cast.adj default
#' @export
vec_cast.adj.default <- function(x, to, ...) {
    vec_default_cast(unclass(x), to, ...) # nocov
}

#' @method vec_cast.adj adj
#' @export
vec_cast.adj.adj <- function(x, to, ...) {
    x
}

#' @method vec_cast.adj list
#' @export
vec_cast.adj.list <- function(x, to, ...) {
    out = new_adj(lapply(x, as.integer))
    validate_adj(out)
    out
}

#' @method vec_cast.list adj
#' @export
vec_cast.list.adj <- function(x, to, ...) {
    as.list(x)
}

#' @rdname adj
#' @export
adj_to_list <- function(x, ids = NULL) {
    x = vec_cast(x, to = list())
    if (!is.null(ids)) {
        if (length(ids) != length(x)) {
            cli::cli_abort("{.arg ids} must have the same length as {.arg x}.")
        }
        x <- lapply(x, function(nbors) ids[nbors])
    }
    x
}

#' @export
as.data.frame.adj <- function(
    x,
    row.names = NULL,
    optional = FALSE,
    ...,
    nm = paste(deparse(substitute(x), width.cutoff = 500L), collapse = " ")
) {
    force(nm)
    cols <- list(x)
    if (!optional) {
        names(cols) <- nm
    }
    new_data_frame(cols, n = length(x))
}
