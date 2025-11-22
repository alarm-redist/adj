test_that("adj_from_shp works", {
    shp <- c(
        "POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))",
        "POLYGON ((0 1, 1 1, 1 2, 0 2, 0 1))",
        "POLYGON ((1 0, 2 0, 2 1, 1 1, 1 0))",
        "POLYGON ((1 1, 2 1, 2 2, 1 2, 1 1))"
    )

    a <- adj_from_shp(shp)

    expect_equal(a[[1]], c(3, 2))
    expect_equal(a[[2]], c(1, 4))
    expect_equal(a[[3]], c(1, 4))
    expect_equal(a[[4]], c(3, 2))
})
