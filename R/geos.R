#' Create an `adj` list from a set of spatial polygons
#'
#' Requires that the `geos` package be installed.
#'
#' @param shp An object convertible to `geos` geometries representing polygons, such
#' as an `sf` object, well-known text strings, or `geos` geometries.
#'
#' @returns An `adj` list
#'
#' @examples
#' shp <- c(
#'  "POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))",
#'  "POLYGON ((0 1, 1 1, 1 2, 0 2, 0 1))",
#'  "POLYGON ((1 0, 2 0, 2 1, 1 1, 1 0))",
#'  "POLYGON ((1 1, 2 1, 2 2, 1 2, 1 1))"
#' )
#'
#' adj_from_shp(shp)
#' @export
adj_from_shp <- function(shp) {
    rlang::check_installed("geos", "to perform spatial operations")

    shp <- geos::as_geos_geometry(shp)
    nby <- geos::geos_strtree_query(geos::geos_strtree(shp), shp)

    out <- lapply(seq_len(length(shp)), function(i) {
        x <- geos::geos_relate(shp[[i]], shp[[nby[[i]]]])
        is_adj <- geos::geos_relate_pattern_match(x, "F***1****") |
            geos::geos_relate_pattern_match(x, "2121**2*2")
        nby[[i]][is_adj]
    })

    out = new_adj(out, duplicates = "error", self_loops = "error")
    validate_adj(out)
    out
}
