# Add edges to an `adj` list

Add edges to an `adj` list

## Usage

``` r
adj_add_edges(
  adj,
  v1,
  v2,
  ids = NULL,
  duplicates = c("warn", "error", "allow", "remove"),
  self_loops = c("warn", "error", "allow", "remove")
)
```

## Arguments

- adj:

  An `adj` list or object coercible to an `adj` list

- v1:

  vector of vertex identifiers for the first vertex. Can be an integer
  index or a value to look up in `ids`, if that argument is provided. If
  more than one identifier is present, connects each to corresponding
  entry in v2.

- v2:

  vector of vertex identifiers for the second vertex. Can be an integer
  index or a value to look up in `ids`, if that argument is provided. If
  more than one identifier is present, connects each to corresponding
  entry in v2.

- ids:

  A vector of unique node identifiers. Each provided vector in `v1` and
  `v2` will be matched to these identifiers. If `NULL`, the identifiers
  \\ are taken to be 1-indexed integers.

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

## Value

An `adj` list

## Examples

``` r
a <- adj(list(c(2, 3), c(1), c(1)))
adj_add_edges(a, 2, 3)
#> $v1
#> [1] 2
#> 
#> $v2
#> [1] 3
#> 
#> [[1]]
#> [1] 2 3
#> 
#> [[2]]
#> [1] 1 3
#> 
#> [[3]]
#> [1] 1 2
#> 
#> attr(,"duplicates")
#> [1] "warn"
#> attr(,"self_loops")
#> [1] "warn"
#> <adj[3]>
#> [1] {2, 3} {1, 3} {1, 2}
```
