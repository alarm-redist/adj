#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

// Convert 1-based neighbor indices to 0-based indices
// Requires (but does not verify) that input is a list of integer vectors
SEXP zero_index_c(SEXP x) {
    int n = Rf_length(x);
    SEXP result = PROTECT(Rf_allocVector(VECSXP, n));
    for (int i = 0; i < n; i++) {
        int* pn = INTEGER(VECTOR_ELT(x, i));
        int n_nbors = Rf_length(VECTOR_ELT(x, i));
        SEXP nbors_zero = PROTECT(Rf_allocVector(INTSXP, n_nbors));
        int* pn0 = INTEGER(nbors_zero);
        for (int j = 0; j < n_nbors; j++) {
            pn0[j] = pn[j] - 1;
        }
        SET_VECTOR_ELT(result, i, nbors_zero);
        UNPROTECT(1);
    }
    UNPROTECT(1);
    return result;
}