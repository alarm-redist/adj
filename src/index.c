#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

// Reindex an adjacency list (including dropping indices)
// Requires (but does not verify) that x is a list of integer vectors
//  and i is a vector of in-bounds integers
SEXP reindex_c(SEXP x, SEXP i) {
    int n_in = Rf_length(x);
    int n_out = Rf_length(i);

    int* pi = INTEGER(i);

    // Build lookup table; 0 is default (no match; drop)
    int* lookup = (int*) R_alloc(n_in, sizeof(int));
    for (int idx = 0; idx < n_in; idx++) {
        lookup[idx] = 0;
    }
    for (int idx = 0; idx < n_out; idx++) {
        int i_idx = pi[idx] - 1;
        if (lookup[i_idx] != 0) {
            Rf_error("Duplicate indices in reindexing vector");
        }
        lookup[i_idx] = idx + 1;
    }

    // Reindex adjacency list
    SEXP result = PROTECT(Rf_allocVector(VECSXP, n_out));
    for (int idx = 0; idx < n_in; idx++) {
        int new_idx = lookup[idx];
        if (new_idx == 0) continue;

        SEXP nbors_in = VECTOR_ELT(x, idx);
        int n_nbors_in = Rf_length(nbors_in);
        int* pn_in = INTEGER(nbors_in);

        PROTECT_INDEX ipx;
        SEXP nbors_out;
        PROTECT_WITH_INDEX(nbors_out = Rf_allocVector(INTSXP, n_nbors_in), &ipx);
        int* pn_out = INTEGER(nbors_out);
        int n_nbors_out = 0;
        for (int j = 0; j < n_nbors_in; j++) {
            int new_j = lookup[pn_in[j] - 1];
            if (new_j > 0) {
                pn_out[n_nbors_out] = new_j;
                n_nbors_out++;
            }
        }
        if (n_nbors_out != n_nbors_in) { // resize
            REPROTECT(nbors_out = Rf_lengthgets(nbors_out, n_nbors_out), ipx);
        }
        SET_VECTOR_ELT(result, new_idx - 1, nbors_out);
        UNPROTECT(1); // nbors_out
    }

    UNPROTECT(1); // result
    return result;
}


// Build quotient graph an adjacency list
// Requires (but does not verify) that x is a list of integer vectors
//  and g is an equal-length vector of integers between 1 and `n_g`
// `dups` and `loops` control whether duplicates and self-loops are allowed
SEXP quotient_c(SEXP x, SEXP g, SEXP n_group, SEXP dups, SEXP loops) {
    int n = Rf_length(x);
    if (n != Rf_length(g)) {
        Rf_error("Length of group vector must match length of adjacency list");
    }
    int n_g = Rf_asInteger(n_group);
    int* pg = INTEGER(g);
    int rem_dups = !Rf_asLogical(dups); // bool
    int rem_loops = !Rf_asLogical(loops); // bool

    // determine output sizes
    int* n_nbors_out = (int*) R_alloc(n_g, sizeof(int));
    int* n_added = (int*) R_alloc(n_g, sizeof(int));
    for (int i = 0; i < n_g; i++) {
        n_nbors_out[i] = 0;
        n_added[i] = 0;
    }
    for (int i = 0; i < n; i++) {
        int n_nbors = Rf_length(VECTOR_ELT(x, i));
        int group = pg[i] - 1;
        n_nbors_out[group] += n_nbors;
    }

    // allocate output
    SEXP result = PROTECT(Rf_allocVector(VECSXP, n_g));
    for (int i = 0; i < n_g; i++) {
        int alloc_size;
        if (rem_dups && n_nbors_out[i] >= n_g) {
            alloc_size = n_g;
        } else {
            alloc_size = n_nbors_out[i];
        }
        SEXP nbors = PROTECT(Rf_allocVector(INTSXP, alloc_size));
        SET_VECTOR_ELT(result, i, nbors);
        UNPROTECT(1); // nbors
    }

    // fill output
    for (int i = 0; i < n; i++) {
        SEXP nbors_in = VECTOR_ELT(x, i);
        int n_nbors_in = Rf_length(nbors_in);
        int* pn_in = INTEGER(nbors_in);

        int group = pg[i] - 1;
        int* pn_out = INTEGER(VECTOR_ELT(result, group));
        int idx = n_added[group];
        for (int k = 0; k < n_nbors_in; k++) {
            int new_grp = pg[pn_in[k] - 1];
            // self-loops
            if (rem_loops && new_grp == group + 1) {
                continue;
            }
            // duplicates
            if (rem_dups) {
                for (int j = 0; j < idx; j++) {
                    if (pn_out[j] == new_grp) {
                        new_grp = -1;
                        break;
                    }
                }
            }
            if (new_grp >= 0) {
                pn_out[idx] = new_grp;
                idx++;
            }
        }
        n_added[group] = idx;
    }

    // shrink vectors
    if (rem_dups || rem_loops) {
        for (int i = 0; i < n_g; i++) {
            SEXP nbors = VECTOR_ELT(result, i);
            int len = n_added[i];
            if (len != Rf_length(nbors)) {
                SET_VECTOR_ELT(result, i, Rf_lengthgets(nbors, len));
            }
        }
    }

    UNPROTECT(1); // result
    return result;
}


// Shift neighbor indices by provided integer
// Requires (but does not verify) that input is a list of integer vectors
SEXP shift_index_c(SEXP x, SEXP shift) {
    int n = Rf_length(x);
    int s = Rf_asInteger(shift);
    SEXP result = PROTECT(Rf_allocVector(VECSXP, n));
    for (int i = 0; i < n; i++) {
        int* pn = INTEGER(VECTOR_ELT(x, i));
        int n_nbors = Rf_length(VECTOR_ELT(x, i));
        SEXP nbors_zero = PROTECT(Rf_allocVector(INTSXP, n_nbors));
        int* pn0 = INTEGER(nbors_zero);
        for (int j = 0; j < n_nbors; j++) {
            pn0[j] = pn[j] + s;
        }
        SET_VECTOR_ELT(result, i, nbors_zero);
        UNPROTECT(1); // nbors_zero
    }
    UNPROTECT(1); // result
    return result;
}