# Convert adjacency lists to and from adjacency matrices

Adjacency lists can be converted to adjacency matrices and vice versa
without loss.

## Usage

``` r
adj_from_matrix(
  x,
  duplicates = c("warn", "error", "allow", "remove"),
  self_loops = c("warn", "error", "allow", "remove")
)

# S3 method for class 'adj'
as.matrix(x, sparse = FALSE, ...)
```

## Arguments

- x:

  An adjacency list or matrix

- duplicates:

  Controls handling of duplicate neighbors. The value `"warn"` warns the
  user; `"error"` throws an error; `"allow"` allows duplicates, and
  `"remove"` removes duplicates silently and then sets the corresponding
  attribute to `"error"`.

- self_loops:

  Controls handling of self-loops (nodes that are adjacent to
  themselves). The value `"warn"` warns the user; `"error"` throws an
  error; `"allow"` allows self-loops, and `"remove"` removes self-loops
  silently and then sets the corresponding attribute to `"error"`.

- sparse:

  If `TRUE`, return a sparse matrix, which is often preferable for
  computation. See
  [Matrix::sparseMatrix](https://rdrr.io/pkg/Matrix/man/sparseMatrix.html)
  for details on this class.

- ...:

  Ignored.

## Value

`adj_from_matrix()` returns an `adj` list;
[`as.matrix()`](https://rdrr.io/r/base/matrix.html) returns a matrix.

## Examples

``` r
adj_from_matrix(1 - diag(3))
#> <adj[3]>
#> [1] {2, 3} {1, 3} {1, 2}

a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
mat = as.matrix(a)
all(a == adj_from_matrix(mat, duplicates = "allow")) # TRUE
#> [1] TRUE
```
