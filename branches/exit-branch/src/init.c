#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP catlearn_slpALCOVE(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP catlearn_slpCOVIS(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"catlearn_slpALCOVE", (DL_FUNC) &catlearn_slpALCOVE, 7},
    {"catlearn_slpCOVIS",  (DL_FUNC) &catlearn_slpCOVIS,  6},
    {NULL, NULL, 0}
};

void R_init_catlearn(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
