*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ORG    $10000
    
START:                  ; first instruction of program

    LEA     $1000,      A1

    MOVE.W  #$AA,       (A1)
    MOVE.W  #$BBBB,     D3
    MOVE.L  #$CCCCCCCC, D4

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
