      SUBROUTINE ZHTOI (HOLL,INTV,NP)

#include "zebra/zceta.inc"
C--------------    END CDE                             --------------
      INTEGER      INTV(99), HOLL(99)


      DO 39  JWH=1,NP
      MWH  = SHIFT (HOLL(JWH), 24)
      INTW = 0

      DO 29  JL=1,4
      INTW = SHIFT (INTW,6)
      JV   = MWH .AND. 63
      IF (JV.EQ.45)  THEN
          IF (JL.NE.4)             GO TO 29
        ENDIF
      INTW = INTW .OR. IQTCET(JV+1)
   29 MWH  = SHIFT (MWH,54)

   39 INTV(JWH) = INTW
      RETURN
      END
