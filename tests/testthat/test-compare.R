test_that("comparisons work", {
    expect_error(sort(adj()), regexp = "not (supported|implemented)")
    expect_error(adj(list(2, 1)) <= adj(list(2, 1)), regexp = "not (supported|implemented)")
})
