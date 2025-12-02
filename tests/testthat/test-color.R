same_grps <- function(x, y) {
    cnt <- function(x) length(unique(x))
    all_one <- function(x, y) all(tapply(x, y, cnt) == 1)
    all_one(x, y) && cnt(x) == cnt(y)
}

test_that("graph coloring works", {
    a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    expect_true(same_grps(adj_color(a), c(1L, 2L, 2L, 3L)))
    expect_true(same_grps(adj_color(a, method = "greedy"), c(1L, 2L, 2L, 3L)))
    expect_true(same_grps(adj_color(a, colors = 3), c(1L, 2L, 2L, 3L)))
    expect_true(same_grps(adj_color(a, colors = 5), 1:4))
    expect_error(adj_color(a, colors = 2), "enough")
    expect_true(same_grps(adj_color(a, colors = 3, method = "greedy"), c(1L, 2L, 2L, 3L)))
    expect_true(same_grps(adj_color(a, groups = c("AD", "BC", "BC", "AD")), c(1L, 2L, 2L, 1L)))
})
