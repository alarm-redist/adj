test_that("comparisons work", {
    expect_error(sort(adj()), regexp = "Comparisons are not")
    expect_error(adj(list(2, 1)) <= adj(list(2, 1)), regexp = "Comparisons are not")
})
