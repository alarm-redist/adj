#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

/* .Call calls */
extern SEXP shift_index_c(SEXP x, SEXP shift);
extern SEXP reindex_c(SEXP x, SEXP i);

static const R_CallMethodDef CallEntries[] = {
    {"shift_index_c", (DL_FUNC) &shift_index_c, 2},
    {"reindex_c", (DL_FUNC) &reindex_c, 2},
    {NULL, NULL, 0}
};

void R_init_adj(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}