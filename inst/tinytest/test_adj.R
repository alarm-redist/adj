a = adj(2:3, NULL, 4:5, integer(0), 1)
expect_length(a, 5)
expect_true(is_adj(a))

a = adj(1, 2, 3, self_loops = "remove")
a_manual = adj:::new_adj(
    list(integer(0), integer(0), integer(0)),
    duplicates = "warn",
    self_loops = "error"
)
expect_identical(a, a_manual)
expect_identical(a_manual, validate_adj(a_manual))

expect_warning(
    adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "warn"),
    "Duplicate"
)
expect_error(
    adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "error"),
    "Duplicate"
)
a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "remove")
expect_true(is_adj(a))
expect_true(all(lengths(a) < 4))

a = adj(konigsberg$bridge_to, ids = konigsberg$area, duplicates = "allow")
expect_true(is_adj(a))
expect_identical(to_list(a, ids = konigsberg$area), konigsberg$bridge_to)
