*
* $Id: aradg2.F,v 1.1.1.1 1996/03/08 16:51:06 mclareni Exp $
*
* $Log: aradg2.F,v $
* Revision 1.1.1.1  1996/03/08 16:51:06  mclareni
* Ariadne
*
*
#include "ariadne/pilot.h"
C***********************************************************************
C $Id: aradg2.F,v 1.1.1.1 1996/03/08 16:51:06 mclareni Exp $
 
      SUBROUTINE ARADG2(ID)
 
C...Ariadne RADiater initial state G->qq
 
C...Perform an initial-state g->qqbar splitting.
 
 
      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100)
 
      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARPART/ BP(MAXPAR,5),IFL(MAXPAR),QEX(MAXPAR),QQ(MAXPAR),
     $                IDI(MAXPAR),IDO(MAXPAR),INO(MAXPAR),INQ(MAXPAR),
     $                XPMU(MAXPAR),XPA(MAXPAR),PT2GG(MAXPAR),IPART
      SAVE /ARPART/
      COMMON /ARDIPS/ BX1(MAXDIP),BX3(MAXDIP),PT2IN(MAXDIP),
     $                SDIP(MAXDIP),IP1(MAXDIP),IP3(MAXDIP),
     $                AEX1(MAXDIP),AEX3(MAXDIP),QDONE(MAXDIP),
     $                QEM(MAXDIP),IRAD(MAXDIP),ISTR(MAXDIP),
     $                ICOLI(MAXDIP),IDIPS
      SAVE /ARDIPS/
      COMMON /ARSTRS/ IPF(MAXSTR),IPL(MAXSTR),IFLOW(MAXSTR),
     $                PT2LST,PT2MAX,IMF,IML,IO,QDUMP,ISTRS
      SAVE /ARSTRS/
      COMMON /ARSTRF/ KFSAVE(2),XSAVE(2),XQ2SAV(2),XPQSAV(2,-6:6)
      SAVE /ARSTRF/
      COMMON /ARLIST/ B1SAVE(2),B3SAVE(2),IPTOT(MAXPAR),NPTOT,
     $     IPSTQ(MAXPAR),NPSTQ,IPREM(MAXPAR),NPREM,IRDIR(2),
     $     YIQQ(2),PT2IQQ(2),PT2SAV(2),IRASAV(2),A1SAVE(2),A3SAVE(2)
 
      SAVE /ARLIST/
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARHIDE/ PHAR(400),MHAR(400)
      SAVE /ARHIDE/
      COMMON /LEPTOU/ CUT(14),LST(40),PARL(30),X,XY,W2,XQ2,U
      SAVE /LEPTOU/
      COMMON /LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)
      SAVE /LUJETS/
 
 
      IF (ABS(MSTA(33)).EQ.1.AND.MSTA(1).EQ.3.AND.IO.EQ.1) THEN
        LST(24)=3
      ENDIF
      IRP=IRAD(ID)-10000
      IT=IRP+5-MAXPAR
      IR=INQ(IRP)
      NPREM=2
      IPREM(1)=IRP
      IPREM(2)=IR
      KQ=IDO(IRP)
      RMQ=ULMASS(KQ)
      DMQ2=RMQ**2
      DPT2Q=PT2IQQ(IT)
      XI=AEX1(ID)
      PHIQ=BX1(ID)
 
      NPSTQ=0
      DO 110 I=1,IPART
        IF (INO(I).EQ.0) THEN
          IF (INQ(I).GE.0) GOTO 110
          IF (K(-INQ(I),3).LE.2) GOTO 110
        ENDIF
        NPSTQ=NPSTQ+1
        IPSTQ(NPSTQ)=I
 110  CONTINUE
      IF (MSTA(1).NE.2.OR.IDI(IRP).GT.IPART)
     $     CALL ARPADD(-IDI(IRP),NPSTQ,IPSTQ)
 
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
 
      DBEX=(DXR+DXQ)/(DER+DEQ)
      DBEY=(DYR+DYQ)/(DER+DEQ)
      DBEZ=(DZR+DZQ)/(DER+DEQ)
 
      CALL ARROBO(0.0,0.0,-DBEX,-DBEY,-DBEZ,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,0.0,-DBEX,-DBEY,-DBEZ,NPREM,IPREM)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
      DSTOT=(DER+DEQ)**2-(DZR+DZQ)**2-(DYR+DYQ)**2-(DXR+DXQ)**2
      PHI=ULANGL(REAL(DXQ),REAL(DYQ))
      THE=ULANGL(REAL(DZQ),REAL(SQRT(DXQ**2+DYQ**2)))
      CALL ARROBO(0.0,-PHI,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,-PHI,0.0D0,0.0D0,0.0D0,NPREM,IPREM)
      CALL ARROBO(-THE,0.0,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(-THE,0.0,0.0D0,0.0D0,0.0D0,NPREM,IPREM)
      CALL ARSUME(0,DXR,DYR,DZR,DER,DMR,NPREM,IPREM)
      CALL ARSUME(0,DXQ,DYQ,DZQ,DEQ,DMQ,NPSTQ,IPSTQ)
 
      DMS2=DMQ**2
 
      DSH=(DPT2Q+DMQ2*(1.0-XI)+DMS2*XI)/(XI*(1.0-XI))
 
      DPMR=ARPCMS(REAL(DSTOT),REAL(DMR),REAL(SQRT(DSH)))
      DPMR0=DER-DZR
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPMR0**2-DPMR**2)/(DPMR0**2+DPMR**2),NPREM,IPREM)
 
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,-DZQ/DEQ,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,PHI-PHIQ,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
      CALL ARROBO(0.0,0.0,-DSQRT(DPT2Q)/DSQRT(DPT2Q+DMQ**2),
     $     0.0D0,0.0D0,NPSTQ,IPSTQ)
      DPPTOT=SQRT(DSH)
      DPPQ=(1.0-XI)*DPPTOT
      DPPQ2=XI*DPPTOT
      DPPQ02=DPT2Q+DMQ**2
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,
     $     (DPPQ**2-DPPQ02)/(DPPQ**2+DPPQ02),NPSTQ,IPSTQ)
 
C...Insert new quark
      IPART=IPART+1
      IQ2=IPART
      IFL(IQ2)=-KQ
      IF (MSTA(30).LT.2.OR.MSTA(30).EQ.3) THEN
        QEX(IQ2)=.FALSE.
        XPMU(IQ2)=0.0
        XPA(IQ2)=0.0
      ELSE
        QEX(IQ2)=.TRUE.
        IF (PARA(14).GE.0) THEN
          XPMU(IQ2)=SQRT(XQ2SAV(IT))*PARA(14)
        ELSE
          XPMU(IQ2)=ABS(PARA(14))
        ENDIF
        XPA(IQ2)=PARA(15)
      ENDIF
CERROR      QEX(IQ2)=.FALSE.
      QQ(IQ2)=.TRUE.
      INO(IQ2)=IO
      INQ(IQ2)=0
      BP(IQ2,1)=SQRT(DPT2Q)
      BP(IQ2,2)=0.0
      BP(IQ2,3)=0.5*(DPPQ2-(DPT2Q+DMQ2)/DPPQ2)
      BP(IQ2,4)=0.5*(DPPQ2+(DPT2Q+DMQ2)/DPPQ2)
      BP(IQ2,5)=RMQ
 
      NPSTQ=NPSTQ+1
      IPSTQ(NPSTQ)=IQ2
 
      CALL ARROBO(0.0,PHIQ-PHI,0.0D0,0.0D0,0.0D0,NPSTQ,IPSTQ)
 
      DZ=ARZCMS(REAL(DSTOT),REAL(SQRT(DSH)),REAL(DMR))
      CALL ARROBO(0.0,0.0,0.0D0,0.0D0,DZ/SQRT((DZ**2+DSH)),NPSTQ,IPSTQ)
 
C...Insert new remnant
 100  IPART=IPART+1
      IR=IPART
      IPREM(1)=IR
      IFL(IR)=INO(IRP)
      QEX(IR)=QEX(IRP)
      QQ(IR)=.TRUE.
      INO(IR)=0
      INQ(IR)=0
      XPMU(IR)=XPMU(IRP)
      XPA(IR)=XPA(IRP)
      BP(IR,1)=BP(IRP,1)
      BP(IR,2)=BP(IRP,2)
      BP(IR,3)=BP(IRP,3)
      BP(IR,4)=BP(IRP,4)
      BP(IR,5)=BP(IRP,5)
      QQ(IRP)=.FALSE.
 
C...Fix new string and dipole
      IDIPS=IDIPS+1
      ISTRS=ISTRS+1
      CALL ARCRDI(IDIPS,IQ2,IR,ISTRS,.FALSE.)
      IDI(IQ2)=0
      IDO(IR)=0
      IPF(ISTRS)=IQ2
      IPL(ISTRS)=IR
      IFLOW(ISTRS)=SIGN(1,-KQ)
      CALL ARCOLI(IDIPS,ID)
 
C...Reset all dipole flags
      DO 200 IDD=1,IDIPS
        QDONE(IDD)=.FALSE.
 200  CONTINUE
 
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,NPSTQ,IPSTQ)
      CALL ARROBO(THE,PHI,DBEX,DBEY,DBEZ,NPREM,IPREM)
 
      CALL ARCHEM(0)
 
      IF (IO.EQ.1) THEN
        PHAR(121)=0.5*LOG(MAX(BP(IQ2,4)+BP(IQ2,3),1.0D-30)/
     $       MAX(BP(IQ2,4)-BP(IQ2,3),1.0D-30))
        PHAR(122)=BP(IQ2,1)**2+BP(IQ2,2)**2
      ENDIF
 
      RETURN
 
C**** END OF ARADG2 ****************************************************
      END
