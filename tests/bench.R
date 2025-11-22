a = adj(readRDS("data-raw/wa_adj.rds"))
a0 = adj_zero_index(a)

bench::mark(
    adj = adj_zero_index(a),
    naive = lapply(a, function(nbors) nbors - 1L),
)

check_equiv <- function(x_redist, x_adj) {
    x_redist = new_adj(.Call(adj:::shift_index_c, x = x_redist, shift = 1L))
    all(x_redist == x_adj)
}

set.seed(5118)
g10 = sample.int(10, length(a), replace = TRUE)
g100 = sample.int(100, length(a), replace = TRUE)
g1000 = sample.int(1000, length(a), replace = TRUE)
g10_0 = g10 - 1L
g100_0 = g100 - 1L
g1000_0 = g1000 - 1L

check_equiv(
    redist:::collapse_adj(a0, g1000_0),
    adj_factor_int(a, g1000, n_groups = 1000L)
)
check_equiv(
    redist::redist.coarsen.adjacency(a0, g1000),
    adj_factor_int(a, g1000, n_groups = 1000L)
)

bench::mark(
    adj = adj_factor_int(a, g10, n_groups = 10L),
    adj_dup = adj_factor_int(
        a,
        g10,
        n_groups = 10L,
        duplicates = "allow",
        self_loops = "allow"
    ),
    redist_collapse = redist:::collapse_adj(a0, g10_0),
    redist_coarsen = redist::redist.coarsen.adjacency(a0, g10),
    check = FALSE
)
bench::mark(
    adj = adj_factor_int(a, g100, n_groups = 100L),
    adj_dup = adj_factor_int(
        a,
        g100,
        n_groups = 100L,
        duplicates = "allow",
        self_loops = "allow"
    ),
    redist_collapse = redist:::collapse_adj(a0, g100_0),
    redist_coarsen = redist::redist.coarsen.adjacency(a0, g100),
    check = FALSE
)
bench::mark(
    adj = adj_factor_int(a, g1000, n_groups = 1000L),
    adj_dup = adj_factor_int(
        a,
        g1000,
        n_groups = 1000L,
        duplicates = "allow",
        self_loops = "allow"
    ),
    redist_collapse = redist:::collapse_adj(a0, g1000_0),
    redist_coarsen = redist::redist.coarsen.adjacency(a0, g1000),
    check = FALSE
)
