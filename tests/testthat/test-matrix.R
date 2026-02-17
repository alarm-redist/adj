test_that("adj_from_matrix works", {
    a = adj(list(c(2, 3), c(1, 3), c(1, 2)))
    x = as.matrix(a)
    expect_identical(x, diag(rep(-1L, 3)) + 1L)
    expect_equal(a, adj_from_matrix(x))

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    x = as.matrix(a)
    expect_equal(a, adj_from_matrix(x, duplicates = "allow"))

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
    x = as.matrix(a)
    expect_equal(a, adj_from_matrix(x, duplicates = "error"))

    x = diag(3) * 0 + 1
    expect_warning(adj_from_matrix(x), "self-loops")

    a = adj(2, 3, 1)
    x = as.matrix(a)
    expect_equal(adj_from_matrix(t(x)), t(a))
    expect_equal(t(x), as.matrix(t(a)))
})

test_that("sparse and dense matrix methods agree", {
    skip_if_not_installed("Matrix")
    a = adj(2, 3, 1)
    expect_equal(as.matrix(as_sparse_matrix(a)), as.matrix(a))

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    expect_equal(as.matrix(as_sparse_matrix(a)), as.matrix(a))

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
    expect_equal(1L * as.matrix(as_sparse_matrix(a)), as.matrix(a))
})

test_that("sparse matrix round trip works", {
    skip_if_not_installed("Matrix")
    a = adj(2, 3, 1)
    x = as_sparse_matrix(a)
    x2 = as(x, "RsparseMatrix")
    expect_equal(adj_from_matrix(x), a)
    expect_equal(adj_from_matrix(x2), a)

    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    x = as_sparse_matrix(a)
    x2 = as(x, "RsparseMatrix")
    expect_equal(adj_from_matrix(x, duplicates = "allow"), a)
    expect_equal(adj_from_matrix(x2, duplicates = "allow"), a)
})
