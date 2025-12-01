
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adj <img src="man/figures/logo.svg" align="right" height="144" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/alarm-redist/adj/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/alarm-redist/adj/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/alarm-redist/adj/graph/badge.svg)](https://app.codecov.io/gh/alarm-redist/adj)
<!-- badges: end -->

`adj` provides a lightweight adjacency list class for R, built on the
[vctrs](https://vctrs.r-lib.org/) package. Adjacency lists are validated
on creation, automatically reindex when subsetted or indexed, and
support pretty-printing. Lists can be easily converted to a zero-index
basis, which allows for easy passing of objects to low-level languages
for processing. Creation of adjacency lists from shapefiles is supported
through an optional dependency on `geos`.

## Installation

You can install the development version of `adj` from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("alarm-redist/adj")
```

## Examples

`adj` comes loaded with example data for the seven bridges of
Königsberg.

``` r
library(adj)
data("konigsberg")

konigsberg
#>   area     bridge_to       x      y
#> 1    A B, B, C, C, D 20.5100 54.706
#> 2    B       A, A, D 20.5115 54.709
#> 3    C       A, A, D 20.5110 54.703
#> 4    D       A, B, C 20.5170 54.705
```

We can build an adjacency graph using the unique identifiers of each
area.

``` r
a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
print(a, n = 5)
#> <adj[4]>
#> [1] {2, 2, 3, 3, 4} {1, 1, 4}       {1, 1, 4}       {1, 2, 3}
```

Alternatively, we can create an adjacency list from a list of integers.
Here, we set `duplicates = "remove"` to remove any duplicate edges.

``` r
adj(c(2, 3, 3), c(1, 3), c(1, 1, 2), duplicates = "remove")
#> <adj[3]>
#> [1] {2, 3} {1, 3} {1, 2}
```

Once created, adjacency lists can be subsetted using standard R
indexing, and the internal indices will be automatically updated.

``` r
a[1:2]
#> <adj[2]>
#> [1] {2, 2} {1, 1}
rev(a)
#> <adj[4]>
#> [1] {4, 3, 2}    {4, 4, 1}    {4, 4, 1}    {3, 3, 2, …}
```

Quotient graphs can be created from adjacency lists and a grouping
vector. Here, we create a quotient graph by grouping the two islands
(areas A and D) together.

``` r
adj_quotient(a, c("AD", "B", "C", "AD"))
#> <adj[3]>
#> [1] {2, 3} {1}    {1}
```

Finally, adjacency lists can be converted to a matrix or zero-indexed.

``` r
as.matrix(a)
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    2    2    1
#> [2,]    2    0    0    1
#> [3,]    2    0    0    1
#> [4,]    1    1    1    0

adj_zero_index(a)
#> [[1]]
#> [1] 1 1 2 2 3
#> 
#> [[2]]
#> [1] 0 0 3
#> 
#> [[3]]
#> [1] 0 0 3
#> 
#> [[4]]
#> [1] 0 1 2
```
