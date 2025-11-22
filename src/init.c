#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

/* .Call calls */
extern SEXP reindex_c(SEXP x, SEXP i);
extern SEXP factor_c(SEXP x, SEXP g, SEXP n_group, SEXP dups, SEXP loops);
extern SEXP shift_index_c(SEXP x, SEXP shift);

static const R_CallMethodDef CallEntries[] = {
    {"reindex_c", (DL_FUNC) &reindex_c, 2},
    {"factor_c", (DL_FUNC) &factor_c, 5},
    {"shift_index_c", (DL_FUNC) &shift_index_c, 2},
    {NULL, NULL, 0}
};

void R_init_adj(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}