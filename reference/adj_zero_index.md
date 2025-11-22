# Convert adjacency list to use zero-based indices

Subtracts 1 from each index in the adjacency list and returns a bare
list of integer vectors, suitable for providing to C/C++ code that uses
zero-based indexing.

## Usage

``` r
adj_zero_index(x)
```

## Arguments

- x:

  An adjacency list.

## Value

A list of integer vectors with zero-based indices.

## Examples

``` r
a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
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
#> 
```
