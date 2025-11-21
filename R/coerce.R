#' Coercing `adj` lists
#'
#' Coercion methods for [vctrs::vec_ptype2()]
#'
#' @inheritParams vctrs::vec_ptype2
#'
#' @return a list of the same length, as class `adj` if convertible, otherwise `list`
#'
#' @keywords internal
#' @method vec_ptype2 adj
#' @export
#' @export vec_ptype2.adj
vec_ptype2.adj <- function(x, y, ...) {
    UseMethod("vec_ptype2.adj", y)
}

#' @method vec_ptype2.adj default
#' @export
vec_ptype2.adj.default <- function(x, y, ..., x_arg = "", y_arg = "") {
    vec_default_ptype2(x, y, ..., x_arg = x_arg, y_arg = y_arg)
}

#' @method vec_ptype2.adj adj
#' @export
vec_ptype2.adj.adj <- function(x, y, ...) {
    new_adj()
}

#' @method vec_ptype2.adj list
#' @export
vec_ptype2.adj.list <- function(x, y, ...) {
    list()
}

#' @method vec_ptype2.list adj
#' @export
vec_ptype2.list.adj <- function(x, y, ...) {
    list()
}
