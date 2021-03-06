 
*==================================================================
 
      FUNCTION RKZSF(L1,P1,L2,P2)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      COMPLEX RKZSF,RKZPR
      COMPLEX ANSS(-1:1,1:4,-1:1,1:4)
      INTEGER DONS(-1:1,1:4,-1:1,1:4)
      COMMON/RKZSCO/ANSS,DONS
      DIMENSION P1(0:4),P2(0:4)
* CHECK ON CORRECT LABEL INPUT
      IP1=IDINT(P1(4))
      IP2=IDINT(P2(4))
      IF(IABS(L1).NE.1.OR.IABS(L2).NE.1.OR.
     . IP1.LT.1.OR.IP2.GT.4.OR.IP2.LT.1.OR.IP2.GT.4) THEN
       WRITE(6,*)
     .  ' RKZSF: ERROR L1=',L1,' L2=',L2,' IP1=',IP1,' IP2=',IP2
       STOP
      ENDIF
* CHECK WHETER THIS ONE WAS ALREADY COMPUTED
* DONS(,,,)=0: NOT YET COMPUTED, DONS(,,,)=1: ALREADY COMPUTED
* IF NOT YET COMPUTED: COMPUTE IT, AND STORE IN ARRAY 'ANSS'
* IF ALREADY COMPUTED: GET THE RESULT FROM ARRAY 'ANSS'
      IF(DONS(L1,IP1,L2,IP2).EQ.0) THEN
        IF(L1.EQ.L2) THEN
          ANSS(L1,IP1,L2,IP2)=(0.,0.)
        ELSE
          ANSS(L1,IP1,L2,IP2)=RKZPR(L1,P1,P2)
        ENDIF
        DONS(L1,IP1,L2,IP2)=1
      ENDIF
      RKZSF=ANSS(L1,IP1,L2,IP2)
      END
