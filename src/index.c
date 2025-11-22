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