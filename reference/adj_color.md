# Find a coloring of an adjacency list

Greedily finds a coloring of an adjacency list, optionally grouped by a
provided vector.

## Usage

``` r
adj_color(x, groups = NULL, colors = 0, method = c("dsatur", "greedy"))
```

## Arguments

- x:

  An `adj` list

- groups:

  An optional vector specifying the group membership for each node in
  `x`.

- colors:

  Number of colors to use. If 0 (the default), uses as few colors as
  possible with this greedy algorithm.

- method:

  Coloring method to use. `"dsatur"` uses the DSatur algorithm to try to
  minimize the number of colors. `"greedy"` traverses nodes in
  decreasing order of degree and may be appropriate when more colors are
  desired.

## Value

An integer vector

## References

Brélaz, Daniel (1979-04-01). "New methods to color the vertices of a
graph". *Communications of the ACM*. 22 (4): 251–256.

## Examples

``` r
a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
adj_color(a)
#> [1] 1 2 2 3
adj_color(a, colors = 3)
#> [1] 1 2 2 3
adj_color(a, groups = c("AD", "BC", "BC", "AD"))
#> [1] 1 2 2 1
```
