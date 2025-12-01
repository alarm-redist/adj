# Subtract edges from an `adj` list

Subtract edges from an `adj` list

## Usage

``` r
adj_subtract_edges(
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
a <- adj(list(c(2, 3), c(1, 3), c(1, 2)))
adj_subtract_edges(a, 2, 3)
#> <adj[3]>
#> [1] {2, 3} {1}    {1}   
```
