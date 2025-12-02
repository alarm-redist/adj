#' Quotient an adjacency list by a vector
#'
#' Computes the quotient graph of a given adjacency list by a provided grouping
#' vector. Nodes in the same groups are merged into single nodes in the quotient
#' graph. The resulting multi-edges and self-loops are handled according to the
#' specified parameters.
#'
#' @param x An `adj` list
#' @param groups A vector specifying the group membership for each node in `x`.
#'   `adj_quotient()` will process this vector with [vctrs::vec_group_id()];
#'   `adj_quotient_int()` expects an (1-indexed) integer vector.
#' @param n_groups Number of unique groups.
#' @inheritParams adj
#'
#' @returns A new `adj` list.
#'
#' @examples
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' # merge two islands (A and D)
#' adj_quotient(a, c("AD", "B", "C", "AD"))
#' adj_quotient_int(a, c(1L, 2L, 3L, 1L), n_group = 3L, self_loops = "allow")
#' @export
adj_quotient <- function(
    x,
    groups,
    duplicates = c("remove", "allow", "error", "warn"),
    self_loops = c("remove", "allow", "error", "warn")
) {
    groups = vec_group_id(groups)
    adj_quotient_int(
        x,
        groups,
        attr(groups, "n"),
        duplicates = rlang::arg_match(duplicates),
        self_loops = rlang::arg_match(self_loops)
    )
}

#' @rdname adj_quotient
#' @export
adj_quotient_int <- function(
    x,
    groups,
    n_groups,
    duplicates = c("remove", "allow", "error", "warn"),
    self_loops = c("remove", "allow", "error", "warn")
) {
    duplicates = rlang::arg_match(duplicates)
    self_loops = rlang::arg_match(self_loops)
    out = .Call(quotient_c, x, groups, n_groups, duplicates != "remove", self_loops != "remove")

    validate = any(c(duplicates, self_loops) %in% c("warn", "error"))
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

#' Find a coloring of an adjacency list
#'
#' Greedily finds a coloring of an adjacency list, optionally grouped by a
#' provied vector.
#'
#' @param x An `adj` list
#' @param groups An optional vector specifying the group membership for each node
#'   in `x`.
#' @param colors Number of colors to use. If 0 (the default), uses as few colors
#'   as possible with this greedy algorithm.
#' @param method Coloring method to use. `"dsatur"` uses the DSatur algorithm
#'   to try to minimize the number of colors. `"greedy"` traverses nodes in
#'   decreasing order of degree and may be appropriate when more colors
#'   are desired.
#'
#' @returns An integer vector
#'
#' @references
#' Brélaz, Daniel (1979-04-01). "New methods to color the vertices of a graph".
#' _Communications of the ACM_. 22 (4): 251–256.
#'
#' @examples
#' a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#' adj_color(a)
#' adj_color(a, colors = 3)
#' adj_color(a, groups = c("AD", "BC", "BC", "AD"))
#' @export
adj_color <- function(x, groups = NULL, colors = 0, method = c("dsatur", "greedy")) {
    n = length(x)
    if (is.null(groups)) {
        groups = seq_len(n)
        attr(groups, "n") = n
    } else {
        groups = vec_group_id(groups)
    }
    # need to run to remove self-loops in `x` if present
    x = adj_quotient_int(x, groups, attr(groups, "n"), "remove", "remove")

    if (colors == 0) {
        used = integer(2)
    } else {
        if (colors >= n) {
            return(seq_len(n))
        }
        colors = as.integer(colors)
        used = integer(colors)
    }

    method = match.arg(method)
    deg_ord = order(lengths(x), decreasing = TRUE)
    color = integer(length(x))
    for (i in seq_along(x)) {
        idx = if (i == 1L || method == "greedy") {
            deg_ord[i]
        } else {
            uncolored = which(color == 0)
            sat_deg = integer(length(uncolored))
            for (j in seq_along(uncolored)) {
                cols = color[x[[uncolored[j]]]]
                sat_deg[j] = vec_unique_count(cols[cols > 0])
            }
            uncolored[which.max(sat_deg)]
        }

        # faster than setdiff(), somehow
        # negative indexing fails when all colors are 0
        available = which(is.na(match(seq_along(used), color[x[[idx]]])))
        if (length(available) == 0) {
            if (colors > 0) {
                cli::cli_abort("Not enough colors to color the graph.")
            } else {
                used = c(used, 0L)
                available = length(used)
            }
        }
        col = available[which.min(used[available])]
        color[idx] = col
        used[col] = used[col] + 1L
    }

    color[groups]
}