# Format and print methods for adjacency lists

Adjacency lists are printed as sets of indices for each node.

## Usage

``` r
# S3 method for class 'adj'
format(x, n = 3, ...)
```

## Arguments

- x:

  An `adj` list.

- n:

  Maximum number of neighbors to show before truncating with an
  ellipsis.

- ...:

  Ignored.

## Value

A character vector representing each entry in the adjacency list.

## Examples

``` r
a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
format(a)
#> [1] "{2, 2, 3, …}" "{1, 1, 4}"    "{1, 1, 4}"    "{1, 2, 3}"   
print(a, n = 5)
#> <adj[4]>
#> [1] {2, 2, 3, 3, 4} {1, 1, 4}       {1, 1, 4}       {1, 2, 3}      
```
