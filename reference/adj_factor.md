# Factor adjacency list

Computes the factor graph of a given adjacency list by a provided
grouping vector. Nodes in the same groups are merged into single nodes
in the factor graph. The resulting multi-edges and self-loops are
handled according to the specified parameters.

## Usage

``` r
adj_factor(
  x,
  groups,
  duplicates = c("remove", "allow", "error", "warn"),
  self_loops = c("remove", "allow", "error", "warn")
)

adj_factor_int(
  x,
  groups,
  n_groups,
  duplicates = c("remove", "allow", "error", "warn"),
  self_loops = c("remove", "allow", "error", "warn")
)
```

## Arguments

- x:

  An `adj` list

- groups:

  A vector specifying the group membership for each node in `x`.
  `adj_factor()` will process this vector with
  [`vctrs::vec_group_id()`](https://vctrs.r-lib.org/reference/vec_group.html);
  `adj_factor_int()` expects an (1-indexed) integer vector.

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

- n_groups:

  Number of unique groups.

## Value

A new `adj` list.

## Examples

``` r
a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
# merge two islands (A and D)
adj_factor(a, c("AD", "B", "C", "AD"))
#> <adj[3]>
#> [1] {2, 3} {1}    {1}   
adj_factor_int(a, c(1L, 2L, 3L, 1L), n_group = 3L, self_loops = "allow")
#> <adj[3]>
#> [1] {2, 3, 1} {1}       {1}      
```
