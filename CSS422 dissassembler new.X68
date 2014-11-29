*-----------------------------------------------------------
* Title      :CSS422 Project
* Written by :Nicholas Abel and Julio Perez
* Date       :November 7, 2014
* Description:Disassembler
*
*Nomenclature:   | OpCode |     Part       | Job
*                | OpCode | Part | SubPart | Job
*
*-----------------------------------------------------------
STARTPT   EQU $AA     *starting point
ENDPT     EQU $55     *ending point
temp      EQU $400    *location to work at
stack     EQU $A000
example   EQU %1110000000001111    * I made up bits 0 to 11      
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
            MOVE.W      #example,D6     *variable put in place        
            MOVE.W      D6, D0
            MOVE.B      #shift12,D1       *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MULU        #6,D0       *Form offset     

            JSR         0(A0,D0)    *Jump indirect with index
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


code0000       STOP        #2700

code0001       BRA         MoveByte

code0010       BRA         MoveLong

code0011       BRA         MoveWord

code0100       STOP        #$2700

code0101       STOP        #$2700

code0110       STOP        #$2700

code0111       STOP        #$2700

code1000       STOP        #$2700

code1001       STOP        #$2700

code1010       STOP        #$2700
 
code1011       BRA         code1011

code1100       STOP        #$2700

code1101       STOP        #$2700

code1110       BRA         BitShiftGroup

code1111       STOP        #$2700

 

*----------------------------------------------------------------
*                OpCode Breakdown Methods                       |
*----------------------------------------------------------------

*--------------MOVE.B Decode-----------------------------

MoveByte        JSR     disMoveByte

*continue searching through the machine code for source then destination
*because of writing format
                JSR     MoveSrcDecode * src decode
                JSR     displayComma
                JSR     displaySpace
                JSR     MoveDesDecode   *destination decode
                JSR     displayLine 
                NOP
                RTS
         

*--------------MOVE.W Decode-----------------------------

MoveWord        JSR     disMoveWord

                JSR     MoveSrcDecode * src decode
                JSR     displayComma
                JSR     displaySpace
                JSR     MoveDesDecode   *destination decode
                JSR     displayLine 
                NOP
                RTS
                
                
*--------------MOVE.L Decode-----------------------------

MoveLong        JSR     disMoveLong

                JSR     MoveSrcDecode * src decode
                JSR     displayComma
                JSR     displaySpace
                JSR     MoveDesDecode   *destination decode
                JSR     displayLine 
                NOP
                RTS

*----------------------------------------------------------------
*                  MOVE   Decode Methods                        |
*----------------------------------------------------------------

MoveSrcDecode   BRA MoveSrcXnDecode

MoveSrcXnDecode
                CLR     D0
                CLR     D1
                MOVE.W  D6, D0
                ROR.W   #3, D0       * last three bits to isolate Xn
                
                MOVE.B  #shift13, D1
                LSR.W   D1,D0        *format is good last three bits in least signifant location
                MOVE.W  D0, D3
                BRA     MoveSrcModeDecode
      
MoveSrcModeDecode
                CLR     D0
                CLR     D1
                MOVE.W  D6, D0
                ROR.W   #6, D0
                MOVE.B  #shift10,D1     *Prepare D1 for shifting 10

                LSR.W   D1,D0           *Shift D0 #10 bits to the right
                
                LSR.W   #3, D0   *D2 now has the mode
                MOVE.W  D0, D2
                JSR     ModeCompare
                RTS    




*------------
MoveDesDecode   BRA     MoveDesXnDecode        



MoveDesXnDecode
                MOVE.W  D6,D0
                MOVE.B  #shift12, D1
                ROR.W   D1, D0
                MOVE.B  #shift13, D1
                
                LSR.W   D1, D0    *isolates Xn
                MOVE.W  D0, D3
                
                BRA     MoveDesModeDecode
        
MoveDesModeDecode  
                MOVE.W  D6, D0
                MOVE.B  #shift12, D1
                ROR.W   D1, D0
                MOVE.B  #shift10, D1
                
                LSR.W   D1, D0
                *must isolate the mode
                ROR.W   #3, D0
                MOVE.B  #shift13, D1
                LSR.W   D1, D0       *mode isolated
                MOVE.W  D0, D2
                JSR     ModeCompare
                RTS






*--------------BitShiftingGroup Decode-----------------------------

bitShiftGroup            BRA bitShiftType

bitShiftType
                CLR         D0
                CLR         D1
                CLR         D2  *    
                CLR         D3  *
                CLR         D4  *will store direction of opcode
                CLR         D5  *size
                CLR         D7  *i/r
                
*------------       store direction bit               
                MOVE.W      D6, D4
                LSL.W       #7, D4
                MOVE.B      #15, D1
                LSR.W       D1, D4
*-------------      store size bits
                MOVE.B      D6, D5
                LSR.B       #6, D5
*--------------     store i/r
                MOVE.B      D6, D7
                LSL.B       #2, D7
                LSR.B       #7, D7
*-------------
                
*-------------      store type
                MOVE.W      D6, D0             
                LSR.W       #3, D0
                MOVE.W      #14,D1
                LSL.W       D1, D0
                LSR.W       D1, D0
                BRA         BitShiftTypeCompare

                               
BitShiftTypeCompare
                CMPI.B      #%01, D0
                BEQ         LogShiftGroup
                CMPI.B      #%00, D0
                BEQ         AsyShiftGroup
                CMPI.B      #%11, D0
                BEQ         RotShiftGroup
                

LogShiftGroup
                JSR         disLogicShift    
                JSR         printDirection
                JSR         printSize
                JSR         ShiftGrpCount
                JSR         displayComma
                JSR         displaySpace
*               JSR         ShiftGrpDest
                

LogShiftRet            
                


AsyShiftGroup
                JSR         disAsymmShift
                
                CMPI.B      #0, D4
                BEQ         disRightDir
                BNE         disLeftDir
AsyShiftRet   

RotShiftGroup
                JSR         disRotateShift
                
                JSR         printDirection

RotShiftRet



ShiftGrpCount
                CMPI.B      #0, D7
                BEQ         printImmData
                BNE         printRegister    


printImmData    
                JSR         printHashTag
                JSR         printShiftRegNumber
                RTS
                                
printRegister
                JSR         disDnReg
                JSR         printShiftRegNumber
                RTS
                
printShiftRegNumber
                JSR         disDnReg
                
                CMPI.B      #0, D1
                BEQ         print8
                MOVE.W      D6, D1
                LSL.W       #4, D1
                MOVE.B      #13, D2
                LSR.W       D2, D1
                MOVE.B      #3, D0
                TRAP #15
                
                RTS
                
                


     
                                
                
                

printDirection
                CMPI.B      #0, D4
                BEQ         disRightDir
                BNE         disLeftDir
printDirRet
                RTS


printSize
                CMPI.B      #0, D5
                BEQ         disByteSize
                CMPI.B      #1, D5
                BEQ         disWordSize
                CMPI.B      #2, D5
                BEQ         disLongSize
                BNE         disError
printSizeRet
                RTS



*----------------------------------------------------------------
*                         Comparisons                           |
*----------------------------------------------------------------


*------------------Mode Comparisons -----------------------------------------

ModeCompare     CMPI.B  #%000, D2 * last three are zeroes
                BEQ     disDnRegMode       *jump to subroutine for Data register Source
                BNE     ModeCompare1              *FIXME: needs to have not equal Branch here
                
ModeCompare1    CMPI.B  #%001, D2
                BEQ     disAnRegMode
                BNE     ModeCompare2
                
ModeCompare2    CMPI.B  #%010, D2
                BEQ     disAnIndMode
                BNE     ModeCompare3
                
ModeCompare3    CMPI.B  #%011, D2
                BEQ    disAnPosMode
                BNE     ModeCompare4

ModeCompare4    CMPI.B  #%100, D2
                BEQ    disAnPreMode
                BNE     ModeCompare5
                
ModeCompare5    CMPI.B  #%111, D2
*                BEQ    disEAmode
                BNE     disError

             

*---------------------Register Compare---------------------                
XnCompare       CMPI.b  #%000, D3
                BEQ     Print0
                BNE     XnCompare1
                
XnCompare1      CMPI.b  #%001, D3
                BEQ     Print1
                BNE     XnCompare2

XnCompare2      CMPI.b  #%010, D3
                BEQ     Print2
                BNE     XnCompare3

XnCompare3      CMPI.b  #%011, D3
                BEQ     Print3
                BNE     XnCompare4

XnCompare4      CMPI.b  #%100, D3
                BEQ     Print4
                BNE     XnCompare5

XnCompare5      CMPI.b  #%101, D3
                BEQ     Print5
                BNE     XnCompare6

XnCompare6      CMPI.b  #%110, D3
                BEQ     Print6
                BNE     XnCompare7

XnCompare7      CMPI.b  #%111, D3
                BEQ     Print7
                BNE     disError
                * FIXME we may need to use this for a bad command BNE XnCompare1


*----------------------------------------------------------------
*                          DISPLAYS                             |
*----------------------------------------------------------------


          


*---------------------MODE Displays----------------------


*-------------------

disDnRegMode    JSR     disDnReg

                JSR     XnCompare
                
                CLR.L   D7
                RTS

*-------------------
                    
disAnRegMode    JSR     disAnReg

                JSR     XnCompare
                
                CLR.L   D7
                RTS

*-------------------

disAnIndMode    JSR     disLeftParen
                JSR     disAnReg
                
                JSR     XnCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                
                RTS
                
*-------------------

disAnPosMode    JSR     disLeftParen
                JSR     disAnReg
                
                JSR     XnCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                JSR     displayPlus
                
                RTS

*-------------------

disAnPreMode    JSR     displayMinus
                JSR     disLeftParen
                JSR     disAnReg
                
                JSR     XnCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                
                CLR.L   D7
                RTS
                
*-------------------


      
                      
*----------------------Register Displays---------------------- 


*------------------Characters--------------------------------

disDnReg        LEA     DnReg, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS


disAnReg        LEA     AnReg, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

disLeftParen    LEA     LeftParen, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
disRightParen   LEA     RightParen, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
              
displayPlus     LEA     disPlus, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
displayMinus    LEA     disMinus, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

displayComma    LEA     disComma, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
displaySpace    LEA     disSpace, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
displayLine     LEA     disNewLine, A1
                MOVE.B  #0, D0
                TRAP    #15
                RTS
                
                
*-----------Numbers------------               
print0          LEA     disZero, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
print1          LEA     disOne, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print2          LEA     disTwo, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print3          LEA     disThree, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print4          LEA     disFour, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print5          LEA     disFive, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print6          LEA     disSix, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print7          LEA     disSeven, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print8          LEA     disEight, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
print9          LEA     disNine, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printA          LEA     disA, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printB          LEA     disB, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printC          LEA     disC, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printD          LEA     disD, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printE          LEA     disE, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

printF          LEA     disF, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

print#          LEA     hashTag,A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

*----------OpCode-----------------                
disMoveByte     LEA     MOVEByteDis, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS                


disMoveWord     LEA     MOVEWordDis, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

disMoveLong     LEA     MOVELongDis, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
                
disAsymmShift
                LEA     AsymmShift, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS
disLogicShift
                LEA     logicShift, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS

disRotateShift                
                LEA     rotateShift, A1
                MOVE.B  #14, D0
                TRAP    #15
                RTS                
                
                
                

*-----------Sizes------------------  
disByteSize     LEA     byteSize, A1
                Move.B  #14, D0
                Trap    #15
                RTS

disWordSize     LEA     wordSize, A1
                Move.B  #14, D0
                Trap    #15
                RTS

disLongSize     LEA     longSize, A1
                Move.B  #14, D0
                Trap    #15
                RTS


*-----------Directions------------------         
disLeftDir      LEA     leftDir, A1
                Move.B  #14, D0
                Trap    #15
                BRA     printDirRet

disRightDir     LEA     rightDir, A1
                Move.B  #14, D0
                Trap    #15
                BRA     printDirRet


*-----------Error------------------         
disError        LEA     Error, A1
                Move.B  #14, D0
                Trap    #15
                RTS          
         
*----------------------------------------------------------------
*                         String constants                      |
*----------------------------------------------------------------

* Put variables and constants here
Error DC.B  'error', 0

MOVEByteDis     DC.B    'MOVE.B ', 0
MOVEWordDis     DC.B    'MOVE.W ', 0   
MOVELongDis     DC.B    'MOVE.L ', 0

AsymmShift      DC.B    'AS', 0

logicShift      DC.B    'LS', 0

rotateShift     DC.B    'RO', 0



byteSize        DC.B    '.B ', 0
wordSize        DC.B    '.W ', 0
longSize        DC.B    '.L ', 0

leftDir         DC.B    'L', 0
rightDir        DC.B    'R', 0

hashtag         DC.B    '#', 0

DnReg           DC.B    'D', 0
AnReg           DC.B    'A', 0
LeftParen       DC.B    '(', 0
RightParen      DC.B    ')', 0
disPlus         DC.B    '+', 0
disMinus        DC.B    '-', 0
disComma        DC.B    ',', 0
disSpace        DC.B    ' ', 0
ASKSTART        DC.B    'Identify the starting memory location: ', 0
ASKEND          DC.B    'Identify the ending memory location: ', 0

*numbers
disZero         DC.B    '0', 0
disOne          DC.B    '1', 0
disTwo          DC.B    '2', 0
disThree        DC.B    '3', 0
disFour         DC.B    '4', 0
disFive         DC.B    '5', 0
disSix          DC.B    '6', 0
disSeven        DC.B    '7', 0
disEight        DC.B    '8', 0
disNine         DC.B    '9', 0

disA            DC.B    'A', 0
disB            DC.B    'B', 0
disC            DC.B    'C', 0
disD            DC.B    'D', 0
disE            DC.B    'E', 0
disF            DC.B    'F', 0

disNewLine      DC.B    '', 0
 
    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
