# Compute the Laplacian matrix of an adjacency list

The Laplacian matrix of a graph is defined as `L = D - A`, where `D` is
the degree matrix (a diagonal matrix where `D[i, i]` is the degree of
node `i`) and `A` is the adjacency matrix.

## Usage

``` r
adj_laplacian(x, sparse = TRUE)
```

## Arguments

- x:

  An `adj` list

- sparse:

  Whether to return a sparse matrix (of class `dgCMatrix`) or a dense
  matrix. Requires the `Matrix` package for sparse output.

## Value

A matrix representing the Laplacian of the graph.

## Examples

``` r
a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
L <- adj_laplacian(a, sparse = FALSE)
L
#>      [,1] [,2] [,3] [,4]
#> [1,]    5   -2   -2   -1
#> [2,]   -2    3    0   -1
#> [3,]   -2    0    3   -1
#> [4,]   -1   -1   -1    3

# count spanning trees (any minor of the Laplacian)
det(L[-1, -1])
#> [1] 21
```
