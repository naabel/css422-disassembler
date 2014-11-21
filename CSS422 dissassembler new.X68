*-----------------------------------------------------------
* Title      :CSS422 Project
* Written by :Nicholas Abel and Julio Perez
* Date       :November 7, 2014
* Description:Disassembler
*-----------------------------------------------------------
STARTPT   EQU $AA     *starting point
ENDPT     EQU $55     *ending point
temp      EQU $400    *location to work at
stack     EQU $A000
example   EQU %0001001000010111    * I made up bits 0 to 11      
shift12   EQU 12                   * Shift 12 bits 
shift10   EQU 10                   * Shift 10 bits
shift13   EQU 13 


        ORG    $1000
START:                          
*        LEA     ASKSTART, A1    *message to ask user for input
*        MOVE.B  #13, D0         *rule 13 allows print without line feed and carriage return if neccesary
*        TRAP    #15             *Display A1 message
*        
*        MOVE.B  #4, D0          *input rule saves to D1
*        TRAP    #15             *initiate read from keyboard
*        
*        MOVE.B  D1, STARTPT        *save number to NUM1
*        
*        LEA     ASKEND, A1      *ask about ending memory location
*        MOVE.B  #13, D0         
*        TRAP    #15             *display A1
*        
*        MOVE.B  #4, D0          *
*        TRAP    #15
*        
*        MOVE.B  D1, ENDPT         *ending memory location stored

        LEA     stack,SP        *Load the SP

        LEA     jmp_table,A0    *Index into the table

        CLR.L   D0              *Zero it
        CLR.L   D1
 
*Get word size element

        MOVE.W  #example,D6     *variable put in place
        
        MOVE.W D6, D0

        MOVE.B  #shift12,D1       *Shift 12 bits to the right  

        LSR.W   D1,D0           *Move the bits

        MULU    #6,D0       *Form offset     

        JSR     0(A0,D0)    *Jump indirect with index
* check read pointer location against EnDPt if end done
* otherwise move back into read sub routine
                    

*----------------------------------------------------------------
*                       OpCode ID Table                         |
*----------------------------------------------------------------


jmp_table  

               JMP         code0000

               JMP         code0001

               JMP         code0010

               JMP         code0011

               JMP         code0100

               JMP         code0101

               JMP         code0110

               JMP         code0111

               JMP         code1000

               JMP         code1001

               JMP         code1010

               JMP         code1011

               JMP         code1100

               JMP         code1101

               JMP         code1110

               JMP         code1111

*subroutines from jump table


code0000       STOP        #$2700

code0001       BRA         MoveByte

code0010       STOP        #$2700

code0011       STOP        #$2700

code0100       STOP        #$2700

code0101       STOP        #$2700

code0110       STOP        #$2700

code0111       STOP        #$2700

code1000       STOP        #$2700

code1001       STOP        #$2700

code1010       STOP        #$2700
 
code1011       BRA        code1011

code1100       STOP        #$2700

code1101       STOP        #$2700

code1110       STOP        #$2700

code1111       STOP        #$2700

 

*----------------------------------------------------------------
*                OpCode Breakdown Methods                       |
*----------------------------------------------------------------

*--------------MOVE.B Decode-----------------------------

MoveByte JSR disMoveByte

*continue searching through the machine code for source then destination
*because of writing format
        CLR.L D0
        CLR.L D1
        MOVE.W D6, D0     *reallocate example to reconfigure for next step
        JSR RegModeXnDecode * src decode
        JSR DesMoveDecode   *destination decode 
        NOP
        RTS
        
DesMoveDecode   BRA DesModeDecode        
        
DesModeDecode   MOVE.B #%1, D7  *set flag for destination    
                MOVE.W  D6, D0
                MOVE.B #shift12, D1
                ROR.W D1, D0
                MOVE.B #shift10, D1
                
                LSR.W D1, D0
                *must isolate the mode
                ROR.W #3, D0
                MOVE.B #shift13, D1
                LSR.W  D1, D0       *mode isolated
                
                JSR ModeCompare
                *JSR DesXnDecode
                NOP
                RTS *done here


DesXnDecode     MOVE.W D6,D0
                MOVE.B #shift12, D1
                ROR.W D1, D0
                MOVE.B #shift13, D1
                
                LSR.W D1, D0    *isolates Xn
                
                JSR XnCompare
                RTS

*----------------------------------------------------------------
*                         Decode Methods                        |
*----------------------------------------------------------------

RegModeXnDecode      BRA ModeDecode

        
ModeDecode      MOVE.W D6, D0
                ROR.W #6, D0
                MOVE.B  #shift10,D1       *Shift 10 bits to the right  

                LSR.W   D1,D0           *Move the bits
                
                LSR.W #3, D0   *D2 now has the mode
                JSR ModeCompare
                RTS    

XnDecode        MOVE.W D6, D0
                ROR.W #3, D0       * last three bits to isolate Xn
                
                MOVE.B #shift13, D1
                LSR.W D1,D0        *format is good last three bits in least signifant location
                Bra XnCompare




*----------------------------------------------------------------
*                         Comparisons                           |
*----------------------------------------------------------------


*------------------Mode Comparisons -----------------------------------------

ModeCompare     CMPI.B #%000, D0 * last three are zeroes
                BEQ   disDnRegMode       *jump to subroutine for Data register Source
                BNE   ModeCompare1              *FIXME: needs to have not equal Branch here
                
ModeCompare1    CMPI.B  #%001, D0
                BEQ disAnRegMode
                BNE ModeCompare2
                
ModeCompare2    CMPI.B  #%010, D0
                BEQ disAnIndMode
                BNE ModeCompare3
                
ModeCompare3    CMPI.B  #%011, D0
                *BEQ disAnIndPostMode
                BNE ModeCompare4

ModeCompare4    CMPI.B  #%100, D0
                *BEQ disAnIndPreMode
                BNE ModeCompare5
                
ModeCompare5    CMPI.B  #%111, D0
                *BEQ disEAmode
                BNE disError

             

*---------------------Register Compare---------------------                
XnCompare       CMPI.b #%000, D0
                BEQ XnIs0
                BNE XnCompare1
                
XnCompare1      CMPI.b #%001, D0
                BEQ XnIs1
                BNE XnCompare2

XnCompare2      CMPI.b #%010, D0
                BEQ XnIs2
                BNE XnCompare3

XnCompare3      CMPI.b #%011, D0
                BEQ XnIs3
                BNE XnCompare4

XnCompare4      CMPI.b #%100, D0
                BEQ XnIs4
                BNE XnCompare5

XnCompare5      CMPI.b #%101, D0
                BEQ XnIs5
                BNE XnCompare6

XnCompare6      CMPI.b #%110, D0
                BEQ XnIs6
                BNE XnCompare7

XnCompare7      CMPI.b #%111, D0
                BEQ XnIs7
                BNE disError
                * FIXME we may need to use this for a bad command BNE XnCompare1


*----------------------------------------------------------------
*                          DISPLAYS                             |
*----------------------------------------------------------------




*---------------------MODE Displays----------------------

SrcDisXn        JSR XnDecode
                RTS
        
DesDisXn        JSR DesXnDecode
                RTS

*create seperate right paren loop




disDnRegMode    LEA DnReg, A1
                MOVE.B #14, D0
                TRAP #15
                CMPI.B #%1, D7
                BEQ     DesDisXn
                BNE     SrcDisXn
                CLR.L D7
                RTS
                    
disAnRegMode    LEA AnReg, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

disAnIndMode    LEA LeftParen, A1
                MOVE.B  #14, D0
                TRAP    #15
                LEA AnReg,      A1
                MOVE.B  #14,     D0
                TRAP    #15
                CMPI.B #%1, D7
                BEQ     DesDisXn
                BNE     SrcDisXn
                CLR.L D7
                LEA     RightParen, A1
                MOVE.B  #14,    D0
                TRAP    #15
                RTS


disAnPosMode    LEA LeftParen, A1
                MOVE.B  #14, D0
                TRAP    #15
                LEA AnReg,      A1
                MOVE.B  #14,     D0
                TRAP    #15
                CMPI.B #%1, D7
                BEQ     DesDisXn
                BNE     SrcDisXn
                CLR.L D7
                LEA     RightParen, A1
                MOVE.B  #14,    D0
                TRAP    #15
                LEA disPlus, A1
                MOVE.B  #14,    D0
                TRAP    #15
                RTS

disAnPreMode    LEA disMinus, A1
                MOVE.B  #14,    D0
                TRAP    #15
                LEA LeftParen, A1
                MOVE.B  #14, D0
                TRAP    #15
                LEA AnReg,      A1
                MOVE.B  #14,     D0
                TRAP    #15
                CMPI.B #%1, D7
                BEQ     DesDisXn
                BNE     SrcDisXn
                CLR.L D7
                LEA     RightParen, A1
                MOVE.B  #14,    D0
                TRAP    #15
                RTS



      
                      
*----------------------Register Displays---------------------- 

*-----------Numbers------------               
XnIs0           LEA disZero, A1
                MOVE.B #14, D0
                TRAP #15
                RTS
                
XnIs1           LEA disOne, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs2           LEA disTwo, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs3           LEA disThree, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs4           LEA disFour, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs5           LEA disFive, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs6           LEA disSix, A1
                MOVE.B #14, D0
                TRAP #15
                RTS

XnIs7           LEA disSeven, A1
                MOVE.B #14, D0
                TRAP #15
                RTS


                
              
*----------OpCode-----------------                
disMoveByte     LEA MOVEByteDis, A1
                MOVE.B #14, D0
                TRAP #15
                RTS                






*-----------Error------------------         
disError        LEA Error, A1
                Move.B #14, D0
                Trap #15
                RTS          
         
*----------------------------------------------------------------
*                         String constants                      |
*----------------------------------------------------------------

* Put variables and constants here
Error DC.B  'error', 0

MOVEByteDis    DC.B   'MOVE.B ', 0
MOVEWordDis    DC.B   'MOVE.W ', 0   
MOVELongDis    DC.B   'MOVE.L ', 0
DnReg       DC.B   'D', 0
AnReg       DC.B   'A', 0
LeftParen   DC.B    '(', 0
RightParen  DC.B    ')', 0
disPlus     DC.B    '+', 0
disMinus    DC.B    '-', 0
ASKSTART    DC.B   'Identify the starting memory location: ', 0
ASKEND      DC.B   'Identify the ending memory location: ', 0

*numbers
disZero     DC.B    '0', 0
disOne      DC.B    '1', 0
disTwo      DC.B    '2', 0
disThree    DC.B    '3', 0
disFour     DC.B    '4', 0
disFive     DC.B    '5', 0
disSix      DC.B    '6', 0
disSeven    DC.B    '7', 0



    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
