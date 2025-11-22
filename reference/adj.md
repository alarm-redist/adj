# Create an adjacency list

Create an adjacency list from a list of vectors of adjacent node
identifiers.

## Usage

``` r
adj(
  ...,
  ids = NULL,
  duplicates = c("warn", "error", "allow", "remove"),
  self_loops = c("warn", "error", "allow", "remove")
)

as_adj(x)

is_adj(x)

adj_to_list(x, ids = NULL)
```

## Arguments

- ...:

  Vectors or a single list of vectors. Vectors should be comprised
  either of (1-indexed) indices of adjacent nodes, or of unique
  identifiers, which must match to the provided `ids`. `NULL` can be
  used in place of a length-zero vector for nodes without neighbors.

- ids:

  A vector of unique node identifiers. Each provided vector in `...`
  will be matched to these identifiers. If `NULL`, the identifiers are
  taken to be 1-indexed integers.

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

- x:

  An `adj` list

## Value

An `adj` list

## Details

### Equality

Equality for `adj` lists is evaluated elementwise. Two sets of neighbors
are considered equal if they contain the same neighbors, regardless of
order.

### Number of nodes and edges

The `adj` package is not focused on graph operations. The
[`length()`](https://rdrr.io/r/base/length.html) function will return
the number of nodes. To compute the number of edges in an adjacency list
`a`, use `sum(lengths(a))`, and divide by 2 for undirected graphs.

## Examples

``` r
a1 = adj(list(c(2, 3), c(1, 3), c(1, 2)))
a2 = adj(list(c(3, 2), c(3, 1), c(2, 1)))
a1 == a2
#> [1] TRUE TRUE TRUE

adj(2:3, NULL, 4:5, integer(0), 1)
#> <adj[5]>
#> [1] {2, 3} {}     {4, 5} {}     {1}   
adj(1, 2, 3, self_loops = "remove")
#> <adj[3]>
#> [1] {} {} {}

adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
#> <adj[4]>
#> [1] {2, 2, 3, …} {1, 1, 4}    {1, 1, 4}    {1, 2, 3}   
adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
#> <adj[4]>
#> [1] {2, 3, 4} {1, 4}    {1, 4}    {1, 2, 3}
```
