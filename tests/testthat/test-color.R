test_that("graph coloring works", {
    a <- adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    expect_equal(sort(adj_color(a)), 1:4)
    expect_equal(adj_color(a, colors = 3), c(1L, 3L, 3L, 2L))
    expect_equal(adj_color(a, groups = c("AD", "BC", "BC", "AD")), c(1L, 2L, 2L, 1L))
})
