// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// slpALCOVE
List slpALCOVE(List st, NumericMatrix tr, std::string dec, bool humble, bool attcon, double absval, bool xtdo);
RcppExport SEXP catlearn_slpALCOVE(SEXP stSEXP, SEXP trSEXP, SEXP decSEXP, SEXP humbleSEXP, SEXP attconSEXP, SEXP absvalSEXP, SEXP xtdoSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< List >::type st(stSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type tr(trSEXP);
    Rcpp::traits::input_parameter< std::string >::type dec(decSEXP);
    Rcpp::traits::input_parameter< bool >::type humble(humbleSEXP);
    Rcpp::traits::input_parameter< bool >::type attcon(attconSEXP);
    Rcpp::traits::input_parameter< double >::type absval(absvalSEXP);
    Rcpp::traits::input_parameter< bool >::type xtdo(xtdoSEXP);
    __result = Rcpp::wrap(slpALCOVE(st, tr, dec, humble, attcon, absval, xtdo));
    return __result;
END_RCPP
}