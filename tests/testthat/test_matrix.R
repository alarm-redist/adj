test_that("adj_from_matrix works", {
    a = adj(list(c(2, 3), c(1, 3), c(1, 2)))
    x = as.matrix(a)
    expect_identical(x, diag(rep(-1L, 3)) + 1L)
    expect_equal(a, adj_from_matrix(x))

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    x = as.matrix(a)
    expect_equal(a, adj_from_matrix(x, duplicates = "allow"))

    x = diag(3) * 0 + 1
    expect_warning(adj_from_matrix(x), "self-loops")
})
