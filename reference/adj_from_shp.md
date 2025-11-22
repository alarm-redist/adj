# Create an `adj` list from a set of spatial polygons

Create an `adj` list from a set of spatial polygons

## Usage

``` r
adj_from_shp(shp)
```

## Arguments

- shp:

  An object convertible to `geos` geometries representing polygons, such
  as an `sf` object, well-known text strings, or `geos` geometries.

## Value

An `adj` list

## Examples

``` r
shp <- c(
 "POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))",
 "POLYGON ((0 1, 1 1, 1 2, 0 2, 0 1))",
 "POLYGON ((1 0, 2 0, 2 1, 1 1, 1 0))",
 "POLYGON ((1 1, 2 1, 2 2, 1 2, 1 1))"
)

adj_from_shp(shp)
#> <adj[4]>
#> [1] {3, 2} {1, 4} {1, 4} {3, 2}
```
