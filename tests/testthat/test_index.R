test_that("basic subsetting works", {
    a = adj(c(2, 3), c(1, 3), c(1, 2))

    expect_identical(a[1], adj(NULL))
    expect_identical(a[2], adj(NULL))
    expect_identical(a[3], adj(NULL))
    expect_error(a[4])

    expect_identical(a[1:2], a[2:1])
    expect_identical(a[1:2], a[2:3])
    expect_identical(a[1:2], a[c(1, 3)])
})

test_that("subsetting with duplicates works", {
    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    expect_identical(a[1], adj(NULL, duplicates = "allow"))
    expect_identical(a[2:3], adj(NULL, NULL, duplicates = "allow"))
    expect_error(a[c(2, 2)])
})

test_that("subsetting compatible with matrix subsetting", {
    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    m = as.matrix(a)

    test_idx = list(
        integer(0),
        4:1,
        c(2, 3, 1)
    )
    for (idx in test_idx) {
        expect_true(all(a[idx] == adj_from_matrix(m[idx, idx], duplicates = "allow")))
    }
})

test_that("c() works for adj", {
    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
    ac = adj(
        list(
            c(2, 2, 3, 3, 4),
            c(1, 1, 4),
            c(1, 1, 4),
            1:3,
            c(6, 6, 7, 7, 8),
            c(5, 5, 8),
            c(5, 5, 8),
            5:7
        ),
        duplicates = "allow"
    )
    expect_equal(c(a, a), ac)
    expect_equal(c(a), a)
})

test_that("adj_factor works", {
    a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")

    af1 = adj(2:3, 1, 1, duplicates = "remove", self_loops = "remove")
    af2 = adj(1:3, 1, 1, duplicates = "remove", self_loops = "allow")
    grp = c(1L, 2L, 3L, 1L)
    expect_equal(adj_factor(a, grp), af1)
    expect_equal(adj_factor_int(a, grp, 3L), af1)
    expect_true(all(af2 == adj_factor(a, grp, self_loops = "allow")))
    expect_true(all(af2 == adj_factor_int(a, grp, 3L, self_loops = "allow")))

    expect_error(adj_factor(a, 1:5), "match length")
    expect_error(adj_factor(a, 1:2), "match length")
    expect_equal(
        adj_factor(a, rep(1, 4)),
        adj(NULL, duplicates = "error", self_loops = "error")
    )
    expect_equal(adj_factor(a, rep(1, 4)), adj_factor(a, rep(-1, 4)))
    expect_equal(adj_factor(a, LETTERS[1:4], duplicates = "allow", self_loops = "warn"), a)
})
