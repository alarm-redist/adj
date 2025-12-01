#' Basic plotting for adjacency lists
#'
#' Plots an adjacency list as a set of nodes and edges, with optional coordinate
#' values for each node. Edge thickness is proportional to the number of edges
#' between each pair of nodes. Self loops are represented with larger points.
#'
#' @param x An `adj` list
#' @param y Optional matrix of coordinates for each node. If `NULL`, nodes are
#'   plotted along the diagonal. Other types are accepted as long as they are
#'   convertible to a 2-column matrix with `as.matrix(y)[, 1:2]`, which is run
#'   internally.
#' @param edges Type of line to use when drawing edges. Passed to [graphics::lines()].
#'   When `y` is `NULL`, defaults to `"s"` (step function); otherwise defaults
#'   to `"l"` for a straight line.
#' @param nodes If `TRUE`, nodes are plotted as points; if `FALSE`, only edges are plotted.
#' @param xlab,ylab Labels for the x- and y-axes.
#' @param ... Additional arguments passed on to the initial `plot()` of the nodes.
#'
#' @returns `NULL`, invisibly.
#'
#' @examples
#' plot(adj(2, c(1, 3), 2))
#' plot(adj(2, c(1, 2, 3), c(2, 2, 2), self_loops="allow", duplicates="allow"))
#'
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area)
#' plot(a, konigsberg[c("x", "y")])
#' @export
plot.adj <- function(x, y = NULL, edges = NULL, nodes = TRUE, xlab = NULL, ylab = NULL, ...) {
    am = as.matrix(x)
    m = which(am > 0, arr.ind = TRUE)
    n = length(x)

    if (is.null(y)) {
        y = cbind(seq_along(x), seq_along(x))
        if (is.null(xlab)) {
            xlab = "Starting Node"
        }
        if (is.null(ylab)) {
            ylab = "Ending Node"
        }
        if (is.null(edges)) {
            edges = "s"
        }
    } else {
        y = tryCatch(as.matrix(y)[, 1:2], error = function(e) {
            cli::cli_abort("{.arg y} must be convertible to a numeric matrix with two columns.")
        })
    }
    if (is.null(edges)) {
        edges = "l"
    }

    typ = if (isTRUE(nodes)) "p" else "n"
    plot(y, type = typ, pch = 16, cex = diag(am) + 1, xlab = xlab, ylab = ylab, ...)
    for (i in seq_len(nrow(m))) {
        edge = m[i, , drop = FALSE]
        lines(y[edge, 1], y[edge, 2], lwd = am[edge], type = edges)
    }
}
