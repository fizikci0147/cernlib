*
* $Id: arvet3.F,v 1.1.1.1 1996/03/08 16:51:04 mclareni Exp $
*
* $Log: arvet3.F,v $
* Revision 1.1.1.1  1996/03/08 16:51:04  mclareni
* Ariadne
*
*
#include "ariadne/pilot.h"
C***********************************************************************
 
      REAL FUNCTION ARVET3()
 
C...ARiadne function VETo factor version 3
 
C...Determine the acceptance factor for chosen x_t^2 and y
C...Suitable for gluon emission with constant alpha_QCD
 
      PARAMETER(MAXDIP=500,MAXPAR=500,MAXSTR=100)
 
      IMPLICIT DOUBLE PRECISION (D)
      IMPLICIT DOUBLE PRECISION (B)
      IMPLICIT LOGICAL (Q)
      COMMON /ARDAT1/ PARA(40),MSTA(40)
      SAVE /ARDAT1/
      COMMON /ARINT1/ BC1,BC3,BZM,BZP,BP1,BM1,BP3,BM3,BPDY,BMDY,
     $                BMRP1,BMR1,BMRP3,BMR3,KQ3,KF3,KQ1,KF1,
     $                B1,B2,B3,XT2,XT,Y,QQ1,QQ3,
     $                QE1,QE3,ALP1,ALP3,XMU1,XMU3,
     $                S,W,C,CN,ALPHA0,XLAM2,IFLG,IFL1,IFL3,
     $                XT2MP,XT2M,XT2C,XTS,XT3,XT1,XT2GG1,XT2GG3,
     $                YINT,YMAX,YMIN,SQ2,YFAC,PTTRUE,
     $                Y1,Y2,Y3,SY1,SY2,SY3,SSY,ZSQEV,
     $                AE1,AE3,NXP1,NXP3,FQ1,FQ3,QFAIL,QEXDY
      SAVE /ARINT1/
 
 
      ARVET3=-(B1**NXP1+B3**NXP3)*(YMAX-YMIN)*0.5/LOG(XT2)
 
      IF (MSTA(19).EQ.0) RETURN
 
      ARVET3=ARVET3*ARVETH()
 
 
      RETURN
 
C**** END OF ARVET3 ****************************************************
      END
