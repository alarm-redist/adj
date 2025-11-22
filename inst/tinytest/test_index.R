# subsetting
a = adj(c(2, 3), c(1, 3), c(1, 2))

expect_identical(a[1], adj(NULL))
expect_identical(a[2], adj(NULL))
expect_identical(a[3], adj(NULL))
expect_error(a[4])

expect_identical(a[1:2], a[2:1])
expect_identical(a[1:2], a[2:3])
expect_identical(a[1:2], a[c(1, 3)])

a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
m = as.matrix(a)
expect_identical(a[1], adj(NULL, duplicates = "allow"))
expect_identical(a[2:3], adj(NULL, NULL, duplicates = "allow"))
expect_error(a[c(2, 2)])

test_idx = list(
    integer(0),
    4:1,
    c(2, 3, 1)
)
for (idx in test_idx) {
    expect_true(all(a[idx] == adj_from_matrix(m[idx, idx], duplicates = "allow")))
}


# c.adj
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
