*
* $Id: strdo1.F,v 1.1.1.2 1996/10/30 08:31:01 cernlib Exp $
*
* $Log: strdo1.F,v $
* Revision 1.1.1.2  1996/10/30 08:31:01  cernlib
* Version 7.04
*
* Revision 1.1.1.1  1996/04/12 15:29:49  plothow
* Version 7.01
*
*
#include "pdf/pilot.h"
C
      SUBROUTINE STRDO1(X,SCALE,UPV,DNV,SEA,STR,CHM,GL)
C :::::::::::: DUKE OWENS SET 1 ::::::::::::::::::::::::::::
#include "pdf/impdp.inc"
#include "pdf/expdp.inc"
     +       F(5),A(6,5),B1(3,6,5)
      DATA Q0,QL1/2.D0,.2D0/
      DATA B1/3.D0,0.D0,0.D0,.419D0,.004383D0,-.007412D0,
     &3.46D0,.72432D0,-.065998D0,4.4D0,-4.8644D0,1.3274D0,
     &6*0.D0,1.D0,
     &0.D0,0.D0,.763D0,-.23696D0,.025836D0,4.D0,.62664D0,-.019163D0,
     &0.D0,-.42068D0,.032809D0,6*0.D0,1.265D0,-1.1323D0,.29268D0,
     &0.D0,-.37162D0,-.028977D0,8.05D0,1.5877D0,-.15291D0,
     &0.D0,6.3059D0,-.27342D0,0.D0,-10.543D0,-3.1674D0,
     &0.D0,14.698D0,9.798D0,0.D0,.13479D0,-.074693D0,
     &-.0355D0,-.22237D0,-.057685D0,6.3494D0,3.2649D0,-.90945D0,
     &0.D0,-3.0331D0,1.5042D0,0.D0,17.431D0,-11.255D0,
     &0.D0,-17.861D0,15.571D0,1.564D0,-1.7112D0,.63751D0,
     &0.D0,-.94892D0,.32505D0,6.D0,1.4345D0,-1.0485D0,
     &9.D0,-7.1858D0,.25494D0,0.D0,-16.457D0,10.947D0,
     &0.D0,15.261D0,-10.085D0/
      WN=1.D0
      S= LOG( LOG( MAX(Q0,SCALE)/QL1)/ LOG(Q0/QL1))
      DO 10 I=1,5
      DO 10 J=1,6
   10 A(J,I)=B1(1,J,I)+S*(B1(2,J,I)+S*B1(3,J,I))
      DO 40 I=1,5
   40 F(I)=A(1,I)*X**A(2,I)*(WN-X)**A(3,I)*(WN+X*
     &    (A(4,I)+X*(A(5,I)+X*A(6,I))))
      DO 50 I=1,2
      AA=WN+A(2,I)+A(3,I)
   50 F(I)=F(I)*GAMFUN(AA)/((WN+A(2,I)*A(4,I)/AA)*GAMFUN(A(2,I))
     &*GAMFUN(WN+A(3,I)))
      UPV=F(1)-F(2)
      DNV=F(2)
      SEA=F(3)/6.D0
      STR=SEA
      CHM=F(4)
      GL =F(5)
      RETURN
      END
