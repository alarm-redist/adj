# Transpose an adjacency list

Reverse the direction of edges in an adjacency list. For undirected
graphs, this is a no-op.

## Usage

``` r
# S3 method for class 'adj'
t(x)
```

## Arguments

- x:

  An `adj` list

## Value

An `adj` list with edges reversed.

## Examples

``` r
a <- adj(2, 3, 1)
all(t(a) == adj(3, 1, 2))
#> [1] TRUE
```
