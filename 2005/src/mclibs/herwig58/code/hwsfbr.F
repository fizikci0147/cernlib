*
* $Id: hwsfbr.F,v 1.1.1.1 1996/03/08 17:02:16 mclareni Exp $
*
* $Log: hwsfbr.F,v $
* Revision 1.1.1.1  1996/03/08 17:02:16  mclareni
* Herwig58
*
*
*CMZ :          29/08/94  11.51.48  by  Unknown
*-- Author :
CDECK  ID>, HWSFBR.
*CMZ :-        -15/07/92  14.08.45  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSFBR(X,QQ,FORCED,ID,IW,ID1,ID2,IW1,IW2,Z)
C     FINDS BRANCHING (ID1->ID+ID2) AND Z=X/X1 IN BACKWARD
C     EVOLUTION AT ENERGY FRACTION X AND SCALE QQ
C
C     FORCED=.TRUE. FORCES SPLITTING OF NON-VALENCE PARTON
C
C     IW,IW1,IW2 ARE COLOUR CONNECTION WORDS
C
C     ID1.LT.0 ON RETURN MEANS NO PHASE SPACE
C     ID1.EQ.0 ON RETURN FLAGS REJECTED BRANCHINGS
C-----------------------------------------------------------------------
C     15/07/92: USE FIRST/SECOND ORDER ALPHAS ACCORDING TO SUDORD
C     08/08/94: ALLOW ANOMALOUS SPLITTING FOR PHOTON BEAMS
C-----------------------------------------------------------------------
#include "herwig58/herwig58.inc"
      INTEGER ID,IW,ID1,ID2,IW1,IW2,NZ,IDHAD,IP,IZ
      DOUBLE PRECISION HWBVMC,HWRGEN,QP,X,QQ,Z,WQG,WQV,WQP,XQV,ZMIN,
     & ZMAX,YMIN,YMAX,DELY,YY,PSUM,EZ,WQN,WR,ZR,WZ,ZZ,AZ,PVAL,EY,
     & DIST(13),PROB(13,100),HWUALF,HWUAEM,PPHO
      LOGICAL FORCED,HWRLOG,NONF,NONV,HWSVAL,PHOTPR
      ID1=-1
      QP=HWBVMC(ID)
      WQG=1.-QG/QQ
      WQV=1.-QV/QQ
      WQP=1.-QP/QQ
      XQV=X/WQV
      NONV=.NOT.HWSVAL(ID)
      NONF=.NOT.FORCED
    5 IF (ID.EQ.13) THEN
        ZMIN=X
        IF (NONF) THEN
          ZMAX=WQG
        ELSE
          ZMAX=WQV
        ENDIF
      ELSE
        IF (NONV) THEN
          ZMIN=XQV
          IF (NONF) THEN
            ZMAX=WQG
          ELSE
            ZMAX=WQP
          ENDIF
        ELSE
          ZMIN=X
          ZMAX=MAX(WQG,WQP)
        ENDIF
      ENDIF
      IF (ZMIN.GE.ZMAX) RETURN
      ID1=0
C---INTERPOLATION VARIABLE IS Y=LN(Z/(1-Z))
      YMIN=LOG(ZMIN/(1.-ZMIN))
      YMAX=LOG(ZMAX/(1.-ZMAX))
      DELY=YMAX-YMIN
      NZ=MIN(INT(ZBINM*DELY)+1,NZBIN)
      DELY=(YMAX-YMIN)/FLOAT(NZ)
      YY=YMIN+0.5*DELY
      PSUM=0.
      IDHAD=IDHW(INHAD)
C---SET UP TABLES FOR CHOOSING BRANCHING
      DO 40 IZ=1,NZ
      EZ=EXP(YY)
      WR=1.+EZ
      ZR=WR/EZ
      WZ=1./WR
      ZZ=WZ*EZ
      AZ=WZ*ZZ*HWUALF(5-2*SUDORD,MAX(WZ*QQ,QG))
      CALL HWSFUN(X*ZR,QQ,IDHAD,NSTRU,DIST,JNHAD)
      IF (ID.NE.13) THEN
C---SPLITTING INTO QUARK
        DO 10 IP=1,ID-1
   10   PROB(IP,IZ)=PSUM
        IF (NONF) PSUM=PSUM+DIST(ID)*AZ*CFFAC*(1.+ZZ*ZZ)*WR
        DO 20 IP=ID,12
   20   PROB(IP,IZ)=PSUM
        PSUM=PSUM+DIST(13)*AZ*0.5*(ZZ*ZZ+WZ*WZ)
        PROB(13,IZ)=PSUM
      ELSE
C---SPLITTING INTO GLUON
        DO 30 IP=1,12
        PSUM=PSUM+DIST(IP)*AZ*CFFAC*(1.+WZ*WZ)*ZR
   30   PROB(IP,IZ)=PSUM
        IF (NONF) PSUM=PSUM+DIST(13)*AZ*2.*CAFAC*(WZ*ZR+ZZ*WR+WZ*ZZ)
        PROB(13,IZ)=PSUM
      ENDIF
   40 YY=YY+DELY
   50 PHOTPR=IDHAD.EQ.59.AND.ID.NE.13
      IF (PHOTPR) THEN
C---ALLOW ANOMALOUS PHOTON SPLITTING
         PPHO=HWUAEM(-QQ*QQ)*CAFAC*(ZMIN**2+(1.-ZMIN)**2)
     &        *ICHRG(ID)**2/(18.*PIFAC)
         IF (PPHO.GT.(PPHO+PSUM*DELY)*HWRGEN(2)) THEN
C---ANOMALOUS PHOTON SPLITTING OCCURRED
           ID1=59
           RETURN
         ENDIF
       ENDIF
      IF (PSUM.LE.0.) RETURN
C---CHOOSE Z
      PVAL=PSUM*HWRGEN(0)
      DO 60 IZ=1,NZ
      IF (PROB(13,IZ).GT.PVAL) GO TO 70
   60 CONTINUE
      IZ=NZ
   70 EY=EXP(YMIN+DELY*(FLOAT(IZ)-HWRGEN(1)))
      ZZ=EY/(1.+EY)
C---CHOOSE BRANCHING
      DO 80 IP=1,13
      IF (PROB(IP,IZ).GT.PVAL) GO TO 90
   80 CONTINUE
      IP=13
C---CHECK THAT Z IS INSIDE PHASE SPACE (RETURN IF NOT)
   90 CONTINUE
      IF (ID.NE.13) THEN
        IF (IP.EQ.ID) THEN
          IF ((NONV.AND.ZZ*WQP.LT.XQV).OR.ZZ.GT.WQG) THEN
            IF (PHOTPR) GO TO 50
            RETURN
          ENDIF
        ELSE
          IF (ZZ.LT.XQV.OR.ZZ.GT.WQP) THEN
            IF (PHOTPR) GO TO 50
            RETURN
          ENDIF
        ENDIF
      ELSE
        IF (IP.EQ.ID) THEN
          IF (ZZ.LT.XQV.OR.ZZ.GT.WQG) RETURN
        ELSEIF (.NOT.HWSVAL(IP)) THEN
          WQN=1.-HWBVMC(IP)/QQ
          IF (ZZ*WQN.LT.XQV.OR.ZZ.GT.WQN) RETURN
        ENDIF
      ENDIF
C---EVERYTHING OK: LABEL NEW BRANCHES
      Z=ZZ
      ID1=IP
      IW1=IW*2
      IW2=IW1+1
      IF (ID.LE.6) THEN
        IF (ID1.EQ.13) THEN
          ID2=ID+6
        ELSE
          ID2=13
          IW2=IW1
        ENDIF
      ELSE IF (ID.NE.13) THEN
        IF (ID1.EQ.13) THEN
          ID2=ID-6
          IW2=IW1
        ELSE
          ID2=13
        ENDIF
      ELSE
        ID2=ID1
        IF (ID1.EQ.13) THEN
          IF (HWRLOG(HALF)) IW2=IW1
        ELSE IF (ID1.GT.6) THEN
          IW2=IW1
        END IF
      END IF
      IF (IW2.EQ.IW1) IW1=IW1+1
  999 END
