
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adj <img src="man/figures/logo.svg" align="right" height="144" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/alarm-redist/adj/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/alarm-redist/adj/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`adj` provides a lightweight adjacency list class for R, built on the
[vctrs](https://vctrs.r-lib.org/) package. This allows for pretty
printing along with several validation checks.

## Installation

You can install the development version of adj from
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
#>   area     bridge_to
#> 1    A B, B, C, C, D
#> 2    B       A, A, D
#> 3    C       A, A, D
#> 4    D       A, B, C
```

We can build an adjacency graph using the unique identifiers of each
area.

``` r
adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#> <adj[4]>
#> [1] {2, 2, 3, …} {1, 1, 4}    {1, 1, 4}    {1, 2, 3}
```

Alternatively, we can create an adjacency list from a list of integers.
Here, we set `duplicates = "remove"` to remove any duplicate edges.

``` r
adj_int <- lapply(konigsberg$bridge_to, function(x) match(x, LETTERS))

adj(adj_int, duplicates = "remove")
#> <adj[4]>
#> [1] {2, 3, 4} {1, 4}    {1, 4}    {1, 2, 3}
```
