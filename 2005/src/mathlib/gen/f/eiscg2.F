*
* $Id: eiscg2.F,v 1.1.1.1 1996/04/01 15:02:38 mclareni Exp $
*
* $Log: eiscg2.F,v $
* Revision 1.1.1.1  1996/04/01 15:02:38  mclareni
* Mathlib gen
*
*
#include "gen/pilot.h"
      SUBROUTINE EISCG2(NM,N,AR,AI,WR,WI,IERR)
C     ALL EIGENVALUES OF A COMPLEX GENERAL MATRIX
C
      DIMENSION AR(NM,NM),AI(NM,NM),WR(N),WI(N)
      CALL CBAL(NM,N,AR,AI,LOW,IGH,WR)
      CALL COMHES(NM,N,LOW,IGH,AR,AI,WR)
      CALL COMLR(NM,N,LOW,IGH,AR,AI,WR,WI,IERR)
      RETURN
      END
