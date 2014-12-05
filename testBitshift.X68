*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $10000
START:                  ; first instruction of program
            LSR.L       #4, D4
            LSL.L       #5, D5
            ROR.L       D2, D3
            ROR.L       D2, D3
            ASR.L       #4, D4
            ASL.L       D2, D4

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
