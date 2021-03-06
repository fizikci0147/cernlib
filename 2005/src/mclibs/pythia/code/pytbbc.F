 
C*********************************************************************
 
C...PYTBBC
C...Calculates the three-body decay of gluinos into
C...charginos and third generation fermions.
 
      SUBROUTINE PYTBBC(I,NN,XMGLU,GAM)
 
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)
      INTEGER PYK,PYCHGE,PYCOMP
C...Parameter statement to help give large particle numbers.
      PARAMETER (KSUSY1=1000000,KSUSY2=2000000,KTECHN=3000000,
     &KEXCIT=4000000,KDIMEN=5000000)
C...Commonblocks.
      COMMON/PYDAT1/MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      COMMON/PYDAT2/KCHG(500,4),PMAS(500,4),PARF(2000),VCKM(4,4)
      COMMON/PYMSSM/IMSS(0:99),RMSS(0:99)
      COMMON/PYSSMT/ZMIX(4,4),UMIX(2,2),VMIX(2,2),SMZ(4),SMW(2),
     &SFMIX(16,4),ZMIXI(4,4),UMIXI(2,2),VMIXI(2,2)
      SAVE /PYDAT1/,/PYDAT2/,/PYMSSM/,/PYSSMT/
 
C...Local variables.
      EXTERNAL PYSIMP,PYLAMF
      DOUBLE PRECISION PYSIMP,PYLAMF
      INTEGER I,NN,LIN
      DOUBLE PRECISION XMG,XMG2,XMB,XMB2,XMR,XMR2
      DOUBLE PRECISION XMT,XMT2,XMST(4),XMSB(4)
      DOUBLE PRECISION ULR(2),VLR(2),XMQ2,XMQ4,AM,W,SBAR,SMIN,SMAX
      DOUBLE PRECISION SUMME(0:100),A(4,8)
      DOUBLE PRECISION COS2A,SIN2A,COS2C,SIN2C
      DOUBLE PRECISION GRS,XMQ3,XMGBTR,XMGTBR,ANT1,ANT2,ANB1,ANB2
      DOUBLE PRECISION XMGLU,GAM
      DOUBLE PRECISION XX1(2),XX2(2),AAA(2),BBB(2),CCC(2),
     &DDD(2),EEE(2),FFF(2)
      SAVE XX1,XX2,AAA,BBB,CCC,DDD,EEE,FFF
      DOUBLE PRECISION ALPHAW,ALPHAS
      DOUBLE PRECISION AMC(2)
      SAVE AMC
      DOUBLE PRECISION AMBOT,AMSB(2),SINC,COSC
      DOUBLE PRECISION AMTOP,AMST(2),SINA,COSA
      SAVE AMSB,AMST
      LOGICAL IFIRST
      SAVE IFIRST
      DATA IFIRST/.TRUE./
 
      TANB=RMSS(5)
      SINB=TANB/SQRT(1D0+TANB**2)
      COSB=SINB/TANB
      XW=PARU(102)
      AMW=PMAS(24,1)
      COSC=SFMIX(5,1)
      SINC=SFMIX(5,3)
      COSA=SFMIX(6,1)
      SINA=SFMIX(6,3)
      AMBOT=PYMRUN(5,XMGLU**2)
      AMTOP=PYMRUN(6,XMGLU**2)
      W2=SQRT(2D0)
      AMW=PMAS(24,1)
      FAKT1=AMBOT/W2/AMW/COSB
      FAKT2=AMTOP/W2/AMW/SINB
      IF(IFIRST) THEN
        AMC(1)=SMW(1)
        AMC(2)=SMW(2)
        DO 100 JJ=1,2
          CCC(JJ)=FAKT1*UMIX(JJ,2)*SINC-UMIX(JJ,1)*COSC
          EEE(JJ)=FAKT2*VMIX(JJ,2)*COSC
          DDD(JJ)=FAKT1*UMIX(JJ,2)*COSC+UMIX(JJ,1)*SINC
          FFF(JJ)=FAKT2*VMIX(JJ,2)*SINC
          XX1(JJ)=FAKT2*VMIX(JJ,2)*SINA-VMIX(JJ,1)*COSA
          AAA(JJ)=FAKT1*UMIX(JJ,2)*COSA
          XX2(JJ)=FAKT2*VMIX(JJ,2)*COSA+VMIX(JJ,1)*SINA
          BBB(JJ)=FAKT1*UMIX(JJ,2)*SINA
  100   CONTINUE
        AMST(1)=PMAS(PYCOMP(KSUSY1+6),1)
        AMST(2)=PMAS(PYCOMP(KSUSY2+6),1)
        AMSB(1)=PMAS(PYCOMP(KSUSY1+5),1)
        AMSB(2)=PMAS(PYCOMP(KSUSY2+5),1)
        IFIRST=.FALSE.
      ENDIF
 
      ULR(1)=XX1(I)*XX1(I)+AAA(I)*AAA(I)
      ULR(2)=XX2(I)*XX2(I)+BBB(I)*BBB(I)
      VLR(1)=CCC(I)*CCC(I)+EEE(I)*EEE(I)
      VLR(2)=DDD(I)*DDD(I)+FFF(I)*FFF(I)
 
      COS2A=COSA**2-SINA**2
      SIN2A=SINA*COSA*2D0
      COS2C=COSC**2-SINC**2
      SIN2C=SINC*COSC*2D0
 
      XMG=XMGLU
      XMT=PMAS(6,1)
      XMB=PMAS(5,1)
      XMR=AMC(I)
      XMG2=XMG*XMG
      ALPHAW=PYALEM(XMG2)
      ALPHAS=PYALPS(XMG2)
      XMT2=XMT*XMT
      XMB2=XMB*XMB
      XMR2=XMR*XMR
      XMQ2=XMG2+XMT2+XMB2+XMR2
      XMQ4=XMG*XMT*XMB*XMR
      XMQ3=XMG2*XMR2+XMT2*XMB2
      XMGBTR=(XMG2+XMB2)*(XMT2+XMR2)
      XMGTBR=(XMG2+XMT2)*(XMB2+XMR2)
 
      XMST(1)=AMST(1)*AMST(1)
      XMST(2)=AMST(1)*AMST(1)
      XMST(3)=AMST(2)*AMST(2)
      XMST(4)=AMST(2)*AMST(2)
      XMSB(1)=AMSB(1)*AMSB(1)
      XMSB(2)=AMSB(2)*AMSB(2)
      XMSB(3)=AMSB(1)*AMSB(1)
      XMSB(4)=AMSB(2)*AMSB(2)
 
      A(1,1)=-COSA*SINC*CCC(I)*AAA(I)-SINA*COSC*EEE(I)*XX1(I)
      A(1,2)=XMG*XMB*(COSA*COSC*CCC(I)*AAA(I)+SINA*SINC*EEE(I)*XX1(I))
      A(1,3)=-XMG*XMR*(COSA*COSC*CCC(I)*XX1(I)+SINA*SINC*EEE(I)*AAA(I))
      A(1,4)=XMB*XMR*(COSA*SINC*CCC(I)*XX1(I)+SINA*COSC*EEE(I)*AAA(I))
      A(1,5)=XMG*XMT*(COSA*COSC*EEE(I)*XX1(I)+SINA*SINC*CCC(I)*AAA(I))
      A(1,6)=-XMT*XMB*(COSA*SINC*EEE(I)*XX1(I)+SINA*COSC*CCC(I)*AAA(I))
      A(1,7)=XMT*XMR*(COSA*SINC*EEE(I)*AAA(I)+SINA*COSC*CCC(I)*XX1(I))
      A(1,8)=-XMQ4*(COSA*COSC*EEE(I)*AAA(I)+SINA*SINC*CCC(I)*XX1(I))
 
      A(2,1)=-COSA*COSC*DDD(I)*AAA(I)-SINA*SINC*FFF(I)*XX1(I)
      A(2,2)=-XMG*XMB*(COSA*SINC*DDD(I)*AAA(I)+SINA*COSC*FFF(I)*XX1(I))
      A(2,3)=XMG*XMR*(COSA*SINC*DDD(I)*XX1(I)+SINA*COSC*FFF(I)*AAA(I))
      A(2,4)=XMB*XMR*(COSA*COSC*DDD(I)*XX1(I)+SINA*SINC*FFF(I)*AAA(I))
      A(2,5)=XMG*XMT*(COSA*SINC*FFF(I)*XX1(I)+SINA*COSC*DDD(I)*AAA(I))
      A(2,6)=XMT*XMB*(COSA*COSC*FFF(I)*XX1(I)+SINA*SINC*DDD(I)*AAA(I))
      A(2,7)=-XMT*XMR*(COSA*COSC*FFF(I)*AAA(I)+SINA*SINC*DDD(I)*XX1(I))
      A(2,8)=-XMQ4*(COSA*SINC*FFF(I)*AAA(I)+SINA*COSC*DDD(I)*XX1(I))
 
      A(3,1)=-COSA*COSC*EEE(I)*XX2(I)-SINA*SINC*CCC(I)*BBB(I)
      A(3,2)=XMG*XMB*(COSA*SINC*EEE(I)*XX2(I)+SINA*COSC*CCC(I)*BBB(I))
      A(3,3)=XMG*XMR*(COSA*SINC*EEE(I)*BBB(I)+SINA*COSC*CCC(I)*XX2(I))
      A(3,4)=-XMB*XMR*(COSA*COSC*EEE(I)*BBB(I)+SINA*SINC*CCC(I)*XX2(I))
      A(3,5)=-XMG*XMT*(COSA*SINC*CCC(I)*BBB(I)+SINA*COSC*EEE(I)*XX2(I))
      A(3,6)=XMT*XMB*(COSA*COSC*CCC(I)*BBB(I)+SINA*SINC*EEE(I)*XX2(I))
      A(3,7)=XMT*XMR*(COSA*COSC*CCC(I)*XX2(I)+SINA*SINC*EEE(I)*BBB(I))
      A(3,8)=-XMQ4*(COSA*SINC*CCC(I)*XX2(I)+SINA*COSC*EEE(I)*BBB(I))
 
      A(4,1)=-COSA*SINC*FFF(I)*XX2(I)-SINA*COSC*DDD(I)*BBB(I)
      A(4,2)=-XMG*XMB*(COSA*COSC*FFF(I)*XX2(I)+SINA*SINC*DDD(I)*BBB(I))
      A(4,3)=-XMG*XMR*(COSA*COSC*FFF(I)*BBB(I)+SINA*SINC*DDD(I)*XX2(I))
      A(4,4)=-XMB*XMR*(COSA*SINC*FFF(I)*BBB(I)+SINA*COSC*DDD(I)*XX2(I))
      A(4,5)=-XMG*XMT*(COSA*COSC*DDD(I)*BBB(I)+SINA*SINC*FFF(I)*XX2(I))
      A(4,6)=-XMT*XMB*(COSA*SINC*DDD(I)*BBB(I)+SINA*COSC*FFF(I)*XX2(I))
      A(4,7)=-XMT*XMR*(COSA*SINC*DDD(I)*XX2(I)+SINA*COSC*FFF(I)*BBB(I))
      A(4,8)=-XMQ4*(COSA*COSC*DDD(I)*XX2(I)+SINA*SINC*FFF(I)*BBB(I))
 
      SMAX=(XMG-ABS(XMR))**2
      SMIN=(XMB+XMT)**2+0.1D0
 
      DO 120 LIN=0,NN-1
        SBAR=SMIN+DBLE(LIN)*(SMAX-SMIN)/DBLE(NN)
        AM=(XMG2-XMR2)*(XMT2-XMB2)/2D0/SBAR
        GRS=SBAR-XMQ2
        W=PYLAMF(SBAR,XMB2,XMT2)*PYLAMF(SBAR,XMG2,XMR2)
        W=DSQRT(W)/2D0/SBAR
        ANT1=LOG(ABS((GRS/2D0+AM+XMST(1)-W)/(GRS/2D0+AM+XMST(1)+W)))
        ANT2=LOG(ABS((GRS/2D0+AM+XMST(3)-W)/(GRS/2D0+AM+XMST(3)+W)))
        ANB1=LOG(ABS((GRS/2D0-AM+XMSB(1)-W)/(GRS/2D0-AM+XMSB(1)+W)))
        ANB2=LOG(ABS((GRS/2D0-AM+XMSB(2)-W)/(GRS/2D0-AM+XMSB(2)+W)))
        SUMME(LIN)=-ULR(1)*W+(ULR(1)*(XMQ2/2D0-XMST(1)-XMG*XMT*SIN2A)
     &  +2D0*XX1(I)*AAA(I)*XMR*XMB)*ANT1
     &  +(ULR(1)/2D0*(XMST(1)*(XMQ2-XMST(1))-XMGTBR
     &  -2D0*XMG*XMT*SIN2A*(XMST(1)-XMB2-XMR2))
     &  +2D0*XX1(I)*AAA(I)*XMR*XMB*(XMST(1)-XMG2-XMT2)
     &  +4D0*SIN2A*XX1(I)*AAA(I)*XMQ4)
     &  *(1D0/(GRS/2D0+AM+XMST(1)-W)-1D0/(GRS/2D0+AM+XMST(1)+W))
        SUMME(LIN)=SUMME(LIN)-ULR(2)*W
     &  +(ULR(2)*(XMQ2/2D0-XMST(3)+XMG*XMT*SIN2A)
     &  -2D0*XX2(I)*BBB(I)*XMR*XMB)*ANT2
     &  +(ULR(2)/2D0*(XMST(3)*(XMQ2-XMST(3))-XMGTBR
     &  +2D0*XMG*XMT*SIN2A*(XMST(3)-XMB2-XMR2))
     &  -2D0*XX2(I)*BBB(I)*XMR*XMB*(XMST(3)-XMG2-XMT2)
     &  +4D0*SIN2A*XX2(I)*BBB(I)*XMQ4)
     &  *(1D0/(GRS/2D0+AM+XMST(3)-W)-1D0/(GRS/2D0+AM+XMST(3)+W))
        SUMME(LIN)=SUMME(LIN)-VLR(1)*W
     &  +(VLR(1)*(XMQ2/2D0-XMSB(1)-XMG*XMB*SIN2C)
     &  +2D0*CCC(I)*EEE(I)*XMR*XMT)*ANB1
     &  +(VLR(1)/2D0*(XMSB(1)*(XMQ2-XMSB(1))-XMGBTR
     &  -2D0*XMG*XMB*SIN2C*(XMSB(1)-XMT2-XMR2))
     &  +2D0*CCC(I)*EEE(I)*XMR*XMT*(XMSB(1)-XMG2-XMB2)
     &  +4D0*SIN2C*CCC(I)*EEE(I)*XMQ4)
     &  *(1D0/(GRS/2D0-AM+XMSB(1)-W)-1D0/(GRS/2D0-AM+XMSB(1)+W))
        SUMME(LIN)=SUMME(LIN)-VLR(2)*W
     &  +(VLR(2)*(XMQ2/2D0-XMSB(2)+XMG*XMB*SIN2C)
     &  -2D0*DDD(I)*FFF(I)*XMR*XMT)*ANB2
     &  +(VLR(2)/2D0*(XMSB(2)*(XMQ2-XMSB(2))-XMGBTR
     &  +2D0*XMG*XMB*SIN2C*(XMSB(2)-XMT2-XMR2))
     &  -2D0*DDD(I)*FFF(I)*XMR*XMT*(XMSB(2)-XMG2-XMB2)
     &  +4D0*SIN2C*DDD(I)*FFF(I)*XMQ4)
     &  *(1D0/(GRS/2D0-AM+XMSB(2)-W)-1D0/(GRS/2D0-AM+XMSB(2)+W))
        SUMME(LIN)=SUMME(LIN)+2D0*XMG*XMT*COS2A/(XMST(3)-XMST(1))
     &  *((AAA(I)*BBB(I)-XX1(I)*XX2(I))
     &  *((XMST(3)-XMB2-XMR2)*ANT2-(XMST(1)-XMB2-XMR2)*ANT1)
     &  +2D0*(AAA(I)*XX2(I)-XX1(I)*BBB(I))*XMB*XMR*(ANT2-ANT1))
        SUMME(LIN)=SUMME(LIN)+2D0*XMG*XMB*COS2C/(XMSB(2)-XMSB(1))
     &  *((EEE(I)*FFF(I)-CCC(I)*DDD(I))
     &  *((XMSB(2)-XMT2-XMR2)*ANB2-(XMSB(1)-XMT2-XMR2)*ANB1)
     &  +2D0*(EEE(I)*DDD(I)-CCC(I)*FFF(I))*XMT*XMR*(ANB2-ANB1))
        DO 110 J=1,4
          SUMME(LIN)=SUMME(LIN)-2D0*A(J,1)*W
     &    +((-A(J,1)*(XMSB(J)*(GRS+XMSB(J))+XMQ3)
     &    +A(J,2)*(XMSB(J)-XMT2-XMR2)+A(J,3)*(SBAR-XMB2-XMT2)
     &    +A(J,4)*(XMSB(J)+SBAR-XMB2-XMR2)
     &    -A(J,5)*(XMSB(J)+SBAR-XMG2-XMT2)+A(J,6)*(XMG2+XMR2-SBAR)
     &    -A(J,7)*(XMSB(J)-XMG2-XMB2)+2D0*A(J,8))
     &    *LOG(ABS((GRS/2D0+XMSB(J)-AM-W)/(GRS/2D0+XMSB(J)-AM+W)))
     &    -(A(J,1)*(XMST(J)*(GRS+XMST(J))+XMQ3)
     &    +A(J,2)*(XMST(J)+SBAR-XMG2-XMB2)-A(J,3)*(SBAR-XMB2-XMT2)
     &    +A(J,4)*(XMST(J)-XMG2-XMT2)-A(J,5)*(XMST(J)-XMR2-XMB2)
     &    -A(J,6)*(XMG2+XMR2-SBAR)
     &    -A(J,7)*(XMST(J)+SBAR-XMT2-XMR2)-2D0*A(J,8))
     &    *LOG(ABS((GRS/2D0+XMST(J)+AM-W)/(GRS/2D0+XMST(J)+AM+W))))
     &    /(GRS+XMSB(J)+XMST(J))
  110   CONTINUE
  120 CONTINUE
      SUMME(NN)=0D0
      GAM= ALPHAW * ALPHAS * PYSIMP(SUMME,SMIN,SMAX,NN)
     &/ (16D0 * PARU(1) * PARU(102) * XMGLU**3)
 
      RETURN
      END
