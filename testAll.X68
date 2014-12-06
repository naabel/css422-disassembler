*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $10000
    
START:                  ; first instruction of program

*        MOVE.B  D0, D3
*        MOVE.B  (A0),D3
*        MOVE.B  (A0)+,D3
*        MOVE.B  -(A0),D3
*        MOVE.B  #2, D3
*        MOVE.B  $3333, D3
*        MOVE.B  $44444444, D3
*        MOVE.B  D0, $3333
*        MOVE.B  D0, $44444444
*        MOVE.B  D0, (A3)
*        MOVE.B  D0, (A3)+
*        MOVE.B  D0, -(A3)
*        
*        MOVE.W  D0, D3
*        MOVE.W  (A0),D3
*        MOVE.W  (A0)+,D3
*        MOVE.W  -(A0),D3
*        MOVE.W  #2, D3
*        MOVE.W  $3333, D3
*        MOVE.W  $44444444, D3
*        MOVE.W  D0, $3333
*        MOVE.W  D0, $44444444
*        MOVE.W  D0, A3
*        MOVE.W  D0,    (A3)
*        MOVE.W  D0, (A3)+
*        MOVE.W  D0, -(A3)
*        
*        MOVE.L  D0, D3
*        MOVE.L  (A0),D3
*        MOVE.L  (A0)+,D3
*        MOVE.L  -(A0),D3
*        MOVE.L  $3333, D3
*        MOVE.L  $44444444, D3
*        MOVE.L  D0, $3333
*        MOVE.L  D0, $44444444
*        MOVE.L  D0, A3
*        MOVE.L  D0,    (A3)
*        MOVE.L  D0, (A3)+
*        MOVE.L  D0, -(A3)    
*        
*        MOVEA.W     A0,   A3
*        MOVEA.W     (A0), A3
*        MOVEA.W     (A0)+,A3
*        MOVEA.W     -(A0),A3
*        MOVEA.W     #2,   A3
*        MOVEA.W     $3333,A3
*        MOVEA.W     $44444444, A3
*        MOVEA.W     A0, A3
*        MOVEA.W     D0, A3
*        MOVEA.W     D0, A3 
*        
*        MOVEA.L     A0,   A3
*        MOVEA.L     (A0), A3
*        MOVEA.L     (A0)+,A3
*        MOVEA.L     -(A0),A3
*        MOVEA.L     #2,   A3
*        MOVEA.L     $3333,A3
*        MOVEA.L     $44444444, A3
*        MOVEA.L     A0, A3
*        MOVEA.L     D0, A3
*        MOVEA.L     D0, A3 

*        MOVEM.W  D0/D1, (A3)
*        MOVEM.W     D0/D1,  -(A3)
*        MOVEM.W  D0/D1, $3333
*        MOVEM.W  D0/D1, $44444444
*        MOVEM.W  (A0),D3/D4
*        MOVEM.W  (A0)+,D3/D4
*        MOVEM.W  $3333, D3
*        MOVEM.W  $44444444, D3
*        
*        MOVEM.L  D0/D1, (A3)
*        MOVEM.L     D0/D1,  -(A3)
*        MOVEM.L  D0/D1, $3333
*        MOVEM.L  D0/D1, $44444444
*        MOVEM.L  (A0),D3/D4
*        MOVEM.L  (A0)+,D3/D4
*        MOVEM.L  $3333, D3
*        MOVEM.L  $44444444, D3
        
*        ADDQ.B  D0, D3
*        ADDQ.B  (A0),D3
*        ADDQ.B  (A0)+,D3
*        ADDQ.B  -(A0),D3
*        ADDQ.B  #2,     D3
*        ADDQ.B  #2,     (A3)
*        ADDQ.B  #2,     -(A3)
*        ADDQ.B  #2,     (A3)+
*        ADDQ.B  #2,     $3333
*        ADDQ.B  #2,     $44444444
*        ADDQ.B  $3333, D3
*        ADDQ.B  $44444444, D3
*        ADDQ.B  D0, $3333
*        ADDQ.B  D0, $44444444
*        ADDQ.B  D0, A3
*        ADDQ.B  D0,    (A3)
*        ADDQ.B  D0, (A3)+
*        ADDQ.B  D0, -(A3)
        
*        ADDQ.W  #2,     D3
*        ADDQ.W  #2,     (A3)
*        ADDQ.W  #2,     -(A3)
*        ADDQ.W  #2,     (A3)+
*        ADDQ.W  #2,     $3333
*        ADDQ.W  #2,     $44444444
*        
*        ADDQ.L  #2,     D3
*        ADDQ.L  #2,     (A3)
*        ADDQ.L  #2,     -(A3)
*        ADDQ.L  #2,     (A3)+
*        ADDQ.L  #2,     $3333
*        ADDQ.L  #2,     $44444444
*        
*        SUB.B  D0, D3
*        SUB.B  (A0),D3
*        SUB.B  (A0)+,D3
*        SUB.B  -(A0),D3
*        SUB.B  #22, D3
*        SUB.B  $3333, D3
*        SUB.B  $44444444, D3
*        SUB.B  D0, $3333
*        SUB.B  D0, $44444444
*        SUB.B  D0,    (A3)
*        SUB.B  D0, (A3)+
*        SUB.B  D0, -(A3)
*        
*		SUB.W  D0, D3
*        SUB.W  (A0),D3
*        SUB.W  (A0)+,D3
*        SUB.W  -(A0),D3
*        SUB.W  #2222, D3
*        SUB.W  $3333, D3
*        SUB.W  $44444444, D3
*        SUB.W  D0, $3333
*        SUB.W  D0, $44444444
*        SUB.W  D0, A3
*        SUB.W  D0,    (A3)
*        SUB.W  D0, (A3)+
*        SUB.W  D0, -(A3)
*        
*		SUB.L  D0, D3
*        SUB.L  (A0),D3
*        SUB.L  (A0)+,D3
*        SUB.L  -(A0),D3
*        SUB.L  #22222222, D3
*        SUB.L  $3333, D3
*        SUB.L  $44444444, D3
*        SUB.L  D0, $3333
*        SUB.L  D0, $44444444
*        SUB.L  D0, A3
*        SUB.L  D0,    (A3)
*        SUB.L  D0, (A3)+
*        SUB.L  D0, -(A3)
*
*        SUBA.W  (A0),A3
*        SUBA.W  (A0)+,A3
*        SUBA.W  -(A0),A3
*        SUBA.W  #2222, A3
*        SUBA.W  $3333, A3
*        SUBA.W  $44444444, A3
*        SUBA.W  D0,     A3
*
*        SUBA.L  (A0),A3
*        SUBA.L  (A0)+,A3
*        SUBA.L  -(A0),A3
*        SUBA.L  #22222222, A3
*        SUBA.L  $3333, a3
*        SUBA.L  $44444444, A3
*        SUBA.L  D0, A3
*
*        SUBI.B  #22,   D3
*        SUBI.B  #%1010101,  D3 
*        SUBI.B  #$AB,   D3
*        SUBI.B  #22, $3333
*        SUBI.B  #22, $44444444
*        SUBI.B  #22,    (A3)
*        SUBI.B  #22, (A3)+
*        SUBI.B  #22, -(A3)
*
*        SUBI.W  #2222,   D3
*        SUBI.W  #%1010101110101010,  D3 
*        SUBI.W  #$ABCD,   D3
*        SUBI.W  #2222, $3333
*        SUBI.W  #2222, $44444444
*        SUBI.W  #2222,    (A3)
*        SUBI.W  #2222, (A3)+
*        SUBI.W  #2222, -(A3)
*        
*        SUBI.L  #2222222222,   D3
*        SUBI.L  #%10101011010101101101011010110101,  D3 
*        SUBI.L  #$ABCDEFAB,   D3
*        SUBI.L  #22, $3333
*        SUBI.L  #22, $44444444
*        SUBI.L  #22,    (A3)
*        SUBI.L  #22, (A3)+
*        SUBI.L  #22, -(A3)
        
*		 MULS.W  D0, D3
*        MULS.W  (A0),D3
*        MULS.W  (A0)+,D3
*        MULS.W  -(A0),D3
*        MULS.W  #2, D3
*        MULS.W  $3333, D3
*        MULS.W  $44444444, D3
*        MULS.W  D0, $3333
*        MULS.W  D0, $44444444
*        MULS.W  D0, A3
*        MULS.W  D0,    (A3)
*        MULS.W  D0, (A3)+
*        MULS.W  D0, -(A3)
*        
*		 DIVS.W  D0, D3
*        DIVS.W  (A0),D3
*        DIVS.W  (A0)+,D3
*        DIVS.W  -(A0),D3
*        DIVS.W  #2, D3
*        DIVS.W  $3333, D3
*        DIVS.W  $44444444, D3
*        DIVS.W  D0, $3333
*        DIVS.W  D0, $44444444
*        DIVS.W  D0, A3
*        DIVS.W  D0,    (A3)
*        DIVS.W  D0, (A3)+
*        DIVS.W  D0, -(A3)
*        
*		 LEA.W  D0, D3
*        LEA.W  (A0),D3
*        LEA.W  (A0)+,D3
*        LEA.W  -(A0),D3
*        LEA.W  #2, D3
*        LEA.W  $3333, D3
*        LEA.W  $44444444, D3
*        LEA.W  D0, $3333
*        LEA.W  D0, $44444444
*        LEA.W  D0, A3
*        LEA.W  D0,    (A3)
*        LEA.W  D0, (A3)+
*        LEA.W  D0, -(A3)
*        
*		 AND.W  D0, D3
*        AND.W  (A0),D3
*        AND.W  (A0)+,D3
*        AND.W  -(A0),D3
*        AND.W  #2, D3
*        AND.W  $3333, D3
*        AND.W  $44444444, D3
*        AND.W  D0, $3333
*        AND.W  D0, $44444444
*        AND.W  D0, A3
*        AND.W  D0,    (A3)
*        AND.W  D0, (A3)+
*        AND.W  D0, -(A3)
*        

        ORI.W  #2, D3
        ORI.B  #2, D3
        ORI.L  #2, D3

*        
*		 NEG.W  D0, D3
*        NEG.W  (A0),D3
*        NEG.W  (A0)+,D3
*        NEG.W  -(A0),D3
*        NEG.W  #2, D3
*        NEG.W  $3333, D3
*        NEG.W  $44444444, D3
*        NEG.W  D0, $3333
*        NEG.W  D0, $44444444
*        NEG.W  D0, A3
*        NEG.W  D0,    (A3)
*        NEG.W  D0, (A3)+
*        NEG.W  D0, -(A3)
*        
*		 EOR.W  D0, D3
*        EOR.W  (A0),D3
*        EOR.W  (A0)+,D3
*        EOR.W  -(A0),D3
*        EOR.W  #2, D3
*        EOR.W  $3333, D3
*        EOR.W  $44444444, D3
*        EOR.W  D0, $3333
*        EOR.W  D0, $44444444
*        EOR.W  D0, A3
*        EOR.W  D0,    (A3)
*        EOR.W  D0, (A3)+
*        EOR.W  D0, -(A3)
*        

        EORI.W  #2, D3
        EORI.B  #2, D3
        EORI.L  #2, D3

*        
*		 NOT.W  D0, D3
*        NOT.W  (A0),D3
*        NOT.W  (A0)+,D3
*        NOT.W  -(A0),D3
*        NOT.W  #2, D3
*        NOT.W  $3333, D3
*        NOT.W  $44444444, D3
*        NOT.W  D0, $3333
*        NOT.W  D0, $44444444
*        NOT.W  D0, A3
*        NOT.W  D0,    (A3)
*        NOT.W  D0, (A3)+
*        NOT.W  D0, -(A3)
*        
*		 LSR.W  D0, D3
*        LSR.W  #2, D3
*        
*		 LSL.W  D0, D3
*        LSL.W  #2, D3
*        
*		 ASR.W  D0, D3
*        ASR.W  #2, D3
*        
*		 ASL.W  D0, D3
*        ASL.W  #2, D3
*        
*		 ROL.W  D0, D3
*        ROL.W  #2, D3
*        
*		 ROR.W  D0, D3
*        ROR.W  #2, D3
*        

        BTST  #2, D3


*        BTST.B  D0, $3333
*        BTST.B  D0, $44444444
*
*        BTST.B  D0,    (A3)
*        BTST.B  D0, (A3)+
*        BTST.B  D0, -(A3)
*        
*
*
*        BTST  D0, $3333
*        BTST  D0, $44444444
*
*        BTST  D0,  (A3)
*        BTST  D0, (A3)+
*        BTST  D0, -(A3)
*        
*		 CMP.W  D0, D3
*        CMP.W  (A0),D3
*        CMP.W  (A0)+,D3
*        CMP.W  -(A0),D3
*        CMP.W  #2, D3
*        CMP.W  $3333, D3
*        CMP.W  $44444444, D3
*        CMP.W  D0, $3333
*        CMP.W  D0, $44444444
*        CMP.W  D0, A3
*        CMP.W  D0,    (A3)
*        CMP.W  D0, (A3)+
*        CMP.W  D0, -(A3)
*        


        CMPI.W  #2, D3
        CMPI.B  #2, D3
        CMPI.L  #2, D3
*        
*		 CMPA.W  D0, D3
*        CMPA.W  (A0),D3
*        CMPA.W  (A0)+,D3
*        CMPA.W  -(A0),D3
*        CMPA.W  #2, D3
*        CMPA.W  $3333, D3
*        CMPA.W  $44444444, D3
*        CMPA.W  D0, $3333
*        CMPA.W  D0, $44444444
*        CMPA.W  D0, A3
*        CMPA.W  D0,    (A3)
*        CMPA.W  D0, (A3)+
*        CMPA.W  D0, -(A3)
*        
*		 BEQ.W  D0, D3
*        BEQ.W  (A0),D3
*        BEQ.W  (A0)+,D3
*        BEQ.W  -(A0),D3
*        BEQ.W  #2, D3
*        BEQ.W  $3333, D3
*        BEQ.W  $44444444, D3
*        BEQ.W  D0, $3333
*        BEQ.W  D0, $44444444
*        BEQ.W  D0, A3
*        BEQ.W  D0,    (A3)
*        BEQ.W  D0, (A3)+
*        BEQ.W  D0, -(A3)
*        
*		 BNE.W  D0, D3
*        BNE.W  (A0),D3
*        BNE.W  (A0)+,D3
*        BNE.W  -(A0),D3
*        BNE.W  #2, D3
*        BNE.W  $3333, D3
*        BNE.W  $44444444, D3
*        BNE.W  D0, $3333
*        BNE.W  D0, $44444444
*        BNE.W  D0, A3
*        BNE.W  D0,    (A3)
*        BNE.W  D0, (A3)+
*        BNE.W  D0, -(A3)
*        
*		 BLT.W  D0, D3
*        BLT.W  (A0),D3
*        BLT.W  (A0)+,D3
*        BLT.W  -(A0),D3
*        BLT.W  #2, D3
*        BLT.W  $3333, D3
*        BLT.W  $44444444, D3
*        BLT.W  D0, $3333
*        BLT.W  D0, $44444444
*        BLT.W  D0, A3
*        BLT.W  D0,    (A3)
*        BLT.W  D0, (A3)+
*        BLT.W  D0, -(A3)
*        
*		 BHI.W  D0, D3
*        BHI.W  (A0),D3
*        BHI.W  (A0)+,D3
*        BHI.W  -(A0),D3
*        BHI.W  #2, D3
*        BHI.W  $3333, D3
*        BHI.W  $44444444, D3
*        BHI.W  D0, $3333
*        BHI.W  D0, $44444444
*        BHI.W  D0, A3
*        BHI.W  D0,    (A3)
*        BHI.W  D0, (A3)+
*        BHI.W  D0, -(A3)
*        
*		 BRA.W  D0, D3
*        BRA.W  (A0),D3
*        BRA.W  (A0)+,D3
*        BRA.W  -(A0),D3
*        BRA.W  #2, D3
*        BRA.W  $3333, D3
*        BRA.W  $44444444, D3
*        BRA.W  D0, $3333
*        BRA.W  D0, $44444444
*        BRA.W  D0, A3
*        BRA.W  D0,    (A3)
*        BRA.W  D0, (A3)+
*        BRA.W  D0, -(A3)
*        
*		 JSR.W  D0, D3
*        JSR.W  (A0),D3
*        JSR.W  (A0)+,D3
*        JSR.W  -(A0),D3
*        JSR.W  #2, D3
*        JSR.W  $3333, D3
*        JSR.W  $44444444, D3
*        JSR.W  D0, $3333
*        JSR.W  D0, $44444444
*        JSR.W  D0, A3
*        JSR.W  D0,    (A3)
*        JSR.W  D0, (A3)+
*        JSR.W  D0, -(A3)
*        
*		 RTS.W  D0, D3
*        RTS.W  (A0),D3
*        RTS.W  (A0)+,D3
*        RTS.W  -(A0),D3
*        RTS.W  #2, D3
*        RTS.W  $3333, D3
*        RTS.W  $44444444, D3
*        RTS.W  D0, $3333
*        RTS.W  D0, $44444444
*        RTS.W  D0, A3
*        RTS.W  D0,    (A3)
*        RTS.W  D0, (A3)+
*        RTS.W  D0, -(A3)
        
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
