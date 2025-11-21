#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

/* .Call calls */
extern SEXP zero_index_c(SEXP x);

static const R_CallMethodDef CallEntries[] = {
    {"zero_index_c", (DL_FUNC) &zero_index_c, 1},
    {NULL, NULL, 0}
};

void R_init_adj(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}