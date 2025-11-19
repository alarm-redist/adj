#' @export
vec_proxy_equal.adj <- function(x, ...) {
    lapply(vec_data(x), sort.int, na.last = TRUE)
}
