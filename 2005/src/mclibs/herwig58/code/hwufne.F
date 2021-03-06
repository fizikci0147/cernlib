*
* $Id: hwufne.F,v 1.1.1.1 1996/03/08 17:02:17 mclareni Exp $
*
* $Log: hwufne.F,v $
* Revision 1.1.1.1  1996/03/08 17:02:17  mclareni
* Herwig58
*
*
*CMZ :          29/08/94  11.51.48  by  Unknown
*-- Author :
CDECK  ID>, HWUFNE.
*CMZ :-        -16/10/93  12.42.15  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWUFNE
C     FINALISES THE EVENT BY UNDOING THE LORENTZ BOOST IF THERE WAS ONE,
C     CHECKING FOR ERRORS, AND PRINTING
C-----------------------------------------------------------------------
#include "herwig58/herwig58.inc"
      LOGICAL CALLED
      COMMON/HWDBUG/CALLED
      CALLED=.TRUE.
C---UNBOOST EVENT RECORD IF NECESSARY
      CALL HWUBST(0)
C---CHECK FOR FATAL ERROR
      IF (IERROR.NE.0) THEN
        IF (IERROR.GT.0) THEN
          NUMER=NUMER+1
        ELSE
          NUMERU=NUMERU+1
        ENDIF
        IF (NUMER.GT.MAXER) CALL HWWARN('HWUFNE',300,*999)
        NEVHEP=NEVHEP-1
C---PRINT FIRST MAXPR EVENTS
      ELSEIF (NEVHEP.LE.MAXPR) THEN
        CALL HWUEPR
      END IF
  999 END
