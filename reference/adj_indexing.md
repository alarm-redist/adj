# Indexing operations on adjacency lists

`adj` overrides the default `[` and
[`c()`](https://rdrr.io/r/base/c.html) methods to allow for filtering,
reordering, and concatenating adjacency lists while ensuring that
indices remain internally consistent.

## Usage

``` r
# S3 method for class 'adj'
x[i, ...]

# S3 method for class 'adj'
c(...)
```

## Arguments

- x:

  An adjacency list of class `adj`

- i:

  Indexing vector

- ...:

  For [`c()`](https://rdrr.io/r/base/c.html), adjacency lists to
  concatenate. Ignored for `[`.

## Value

A reindexed adjacency list for `[`, and a concatenated adjacency list
for [`c()`](https://rdrr.io/r/base/c.html).

## Details

When duplicate indices are present in the adjacency list, indexing is
performed by slicing the adjacency matrix, which is slower and requires
more memory. For large adjacency lists, slicing with duplicates will
error for this reason; set `options(adj.max_matrix_slice = Inf)` to
allow it, but be aware of the possible memory usage implications.

## Examples

``` r
a <- adj(c(2, 3), c(1, 3), c(1, 2))
a[1:2]
#> <adj[2]>
#> [1] {2} {1}
all(sample(a) == a) # any permutation yields the same graph
#> [1] TRUE

a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
c(a, a) # concatenates graphs with no connecting edges
#> <adj[8]>
#> [1] {2, 3, 4} {1, 4}    {1, 4}    {1, 2, 3} {6, 7, 8} {5, 8}    {5, 8}   
#> [8] {5, 6, 7}
```
