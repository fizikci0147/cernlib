#ifndef CERNLIB_ISAJET_FRGPAR_INC
#define CERNLIB_ISAJET_FRGPAR_INC
*
*
* frgpar.inc
*
      COMMON/FRGPAR/PUD,PBARY,SIGQT,PEND,XGEN(8),PSPIN1(8),
     $PMIX1(3,2),PMIX2(3,2),XGENSS(9)
      SAVE /FRGPAR/
      EQUIVALENCE (PMIX1(1,1),PMIXX1(1))
      EQUIVALENCE (PMIX2(1,1),PMIXX2(1))
      EQUIVALENCE(FRPAR(1),PUD)
      REAL      PUD,PBARY,SIGQT,PEND,XGEN,PSPIN1,PMIX1,PMIX2,XGENSS,
     +          PMIXX1(6),PMIXX2(6),FRPAR(32)

#endif
