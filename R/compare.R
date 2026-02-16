#' @export
vec_proxy_equal.adj <- function(x, ...) {
    lapply(unclass(x), sort.int, na.last = TRUE)
}

#' @export
`==.adj` <- function(e1, e2) {
    vec_equal(e1, e2)
}
