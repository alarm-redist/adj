#' @export
vec_ptype_abbr.adj <- function(x, ...) {
    "adj"
}

#' @export
vec_ptype_full.adj <- function(x, ...) {
    "adj"
}

#' @export
format.adj <- function(x, ...) {
    if (length(x) == 0) {
        return(invisible(NULL))
    }
    vapply(x, adj_preview, character(1))
}

adj_size <- function(x) {
    lengths(x)
}

adj_preview <- function(x) {
    n <- length(x)
    ifelse(
        n <= 3,
        paste0("{", paste0(x, collapse = ", "), "}"),
        paste0("{", paste0(x[1:3], collapse = ", "), ", \u2026}")
    )
}


#' @export
obj_print_data.adj <- function(x, ...) {
    if (length(x) == 0) {
        return(invisible(x))
    }
    out <- vec_set_names(format(x), names(x))
    print(out, quote = FALSE)
}
