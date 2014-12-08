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
temp      EQU $400    *location to work at
stack     EQU $A000
example   EQU %0001000000111001 
exampleEA EQU %1111111111111111     * I made up bits 0 to 11      
shift12   EQU 12                   * Shift 12 bits 
shift10   EQU 10                   * Shift 10 bits
shift13   EQU 13 


        ORG    $1000
START:                          
        LEA     stack,SP        *Load the SP
        LEA     jmp_table,A0    *Index into the table
*        
        LEA     ASKSTART, A1    *message to ask user for input
        MOVE.B  #13, D0         *rule 13 allows print without line feed and carriage return if neccesary
        TRAP    #15             *Display A1 message
        
        LEA     STARTPT, A1
        MOVE.B  #2, D0          *input rule saves to D1
        TRAP    #15             *initiate read from keyboard
        
        JSR     setCharToHex    
        
        MOVE.L  D4, STARTPT
        
        CLR.L     D4
        CLR       D6
        
        LEA     ASKEND, A1      *ask about ending memory location
        MOVE.B  #13, D0         
        TRAP    #15             *display A1
        
        LEA     ENDPT, A1       
        MOVE.B  #2, D0
        TRAP    #15
        
        JSR     setCharToHex
        
        MOVE.L  D4, ENDPT
        
        CLR     D4
        CLR     D6
        


        CLR.L   D0              *Zero it
        CLR.L   D1
        MOVE.W  #0, lineNumber
        MOVE.L      STARTPT, A5
        
        CLR.B   NumDisplayed
        
MainLoop    *Get word  element
            JSR         CheckNumDisplayed
            CMPA.L      ENDPT, A5
            BEQ         DONE         
            ADDI.W      #1, lineNumber
            LEA         output, A6
            MOVE.L      A5, lineAddress
            JSR         displaySpace
            MOVE.B      #8, hexlength
            MOVE.L      lineAddress, D4
            CLR.B       counter
            JSR         hexDecode
            JSR         displaySpace
            MOVE.W      (A5)+,D6     *variable put in place
            MOVE.W      D6, fullOpcode
*            MOVE.W      #example, D6        
            MOVE.W      D6, D0
            MOVE.B      #shift12,D1         *Shift 12 bits to the right  
            LSR.W       D1,D0               *Move the bits
            MULU        #6,D0               *Form offset     

            JSR         0(A0,D0)            *Jump indirect with index
            
ContinueMain
            *JSR         display
            MOVE.B      #$00, (A6)+
            JSR         displayOutput
            ADD.B       #1,     NumDisplayed
            BRA         MainLoop
            
            * check read pointer location against EnDPt if end done
            * otherwise move back into read sub routine

CheckNumDisplayed
            CMP.B       #10,            NumDisplayed
            BLT         Continue
            LEA         AskToContinue,  A1
            MOVE.B      #13,            D0
            TRAP        #15
            MOVE.B      #5,             D0
            TRAP        #15
            CLR.B       NumDisplayed
Continue    RTS
            

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


code0000       JSR        GroupZero
               BRA        continueMain

code0001       JSR         MoveByte
               BRA        continueMain
code0010       JSR         MoveLong               
                BRA        continueMain

code0011       BRA         MoveWord
               BRA        continueMain

code0100       STOP        #$2700
               BRA        continueMain

code0101       STOP        #$2700
               BRA        continueMain

code0110       JSR        BranchGroup
               BRA        continueMain

code0111       STOP        #$2700
               BRA        continueMain

code1000       STOP        #$2700
               BRA        continueMain

code1001       STOP        #$2700
               BRA        continueMain

code1010       STOP        #$2700
               BRA        continueMain
 
code1011       BRA         code1011
               BRA        continueMain

code1100       STOP        #$2700
               BRA        continueMain


code1101       JSR        AddGroup
               BRA        continueMain

code1110       JSR        BitShiftGroup
               BRA        continueMain

code1111       STOP        #$2700
               BRA        continueMain

 

*----------------------------------------------------------------
*                OpCode Breakdown Methods                       |
*----------------------------------------------------------------

GroupZero       BRA        GroupZeroType

BranchGroup     BRA         BranchType

GroupZeroType   
                CLR.L         D0
                CLR.L         D1  *temp variables
                CLR.L         D2  *Mode    
                CLR.L         D3  *Number
                CLR.L         D4  *Memory increment save
                CLR.L         D5  *size
                CLR.L         D7  *
*----------- store size-------------------------------
                MOVE.W      D6, D5
                LSL.W       #8, D5
                MOVE.B      #14,D1
                LSR.W       D1, D5
                MOVE.W      D5, OpCodeSize
*-----------Src Mode--------------------------------------
                MOVE.W      D6, D2
                LSL.W       #4, D2
                MOVE.B      #13, D1
                LSR.W       D1, D2
                MOVE.W      D2, RegOrCount
*-----------Des Mode--------------------------------------
                MOVE.W      D6, D2
                MOVE.B      #10, D1
                LSL.W       D1, D2
                MOVE.B      #13, D1
                LSR.W       D1, D2
                MOVE.W      D2, Mode
*-----------Register Number-------------------
                MOVE.W      D6, D3
                MOVE.B      #13, D1
                LSL.W       D1,D3
                LSR.W       D1,D3
                MOVE.W      D3, Reg

*-------------Identifier set------------------                
                MOVE.W      D6, D0
                LSR.W       #8, D0
                BRA         GroupZeroCompare                
                
                
BranchType
                CLR.L         D0
                CLR.L         D1  *temp variables
                CLR.L         D2  *Mode    
                CLR.L         D3  *Number
                CLR.L         D4  *Memory increment save
                CLR.L         D5  *size
                CLR.L         D7  *

*-----------Get Condition

                CLR.B           OpCodeCondition
                MOVE.W          D6, D2
                LSL.W           #4, D2
                MOVE.B          #12,    D1
                LSR.W           D1,     D2
                MOVE.B          D2, OpCodeCondition
                
*-----------Get Displacement

                CLR.B           OpCodeDisplacement
                MOVE.W          D6, D3
                LSL.W           #8, D3
                LSR.W           #8, D3
                MOVE.B          D3, OpCodeDisplacement
                BRA             BranchCode

GroupZeroCompare
                CMPI.W      #%00000000, D0
                BEQ         ORIopCode
                CMPI.W      #%00001000, D0
                BEQ         BTSTopCode         
                CMPI.W      #%00001100, D0
                BEQ         CMPIopCode
                CMPI.W      #%00001010, D0
                BEQ         EORIopCode

*----------GroupZero Functions

ORIopCode
                JSR         outORI
                JSR         printSize
                JSR         getImmDataFromOpCodeSize
                JSR         displayComma
                JSR         displaySpace
                MOVE.W      Mode, D2
                MOVE.W      Reg, D3
                JSR         modeCompare
                RTS
       

BTSTopCode
                JSR         outBTST
                JSR         displaySpace
                JSR         checkImmOrReg                
                JSR         displayComma
                JSR         displaySpace
                MOVE.W      Mode, D2
                MOVE.W      Reg, D3
                JSR         ModeCompare
                RTS    

CMPIopCode
                JSR         outCMPI
                JSR         printSize
                JSR         getImmDataFromOpCodeSize
                JSR         displayComma
                JSR         displaySpace
                MOVE.W      Mode, D2
                MOVE.W      Reg, D3
                JSR         modeCompare
                RTS

EORIopCode
                JSR         outEORI
                JSR         printSize
                JSR         getImmDataFromOpCodeSize
                JSR         displayComma
                JSR         displaySpace
                MOVE.W      Mode, D2
                MOVE.W      Reg, D3
                JSR         modeCompare
                RTS
                
*----------GroupZero Helpers
                
checkImmOrReg
                MOVE.W      RegOrCount, D1
                CMPI.W      #4, D1
                BEQ         getImmDataFromOpCodeSize
                MOVE.W      RegOrCount, D3
                BNE         disDataReg

getImmDataFromOpCodeSize
                JSR         printHash
                MOVE.W      opCodeSize, D1
                CMPI.W      #0, D1
                BEQ         getByte
                CMPI.W      #1, D1
                BEQ         getWord
                CMPI.W      #2, D1
                BEQ         getLong
                RTS

*----------Branch Functions

BranchCode
                JSR         bccCodeTypeDisplay
                JSR         displaySpace
                JSR         getDisplacementByField
                RTS
                
*----------Branch Helpers
                
bccCodeTypeDisplay
                CLR             D2
                MOVE.B          OpCodeCondition,    D2
                CMPI.B          #%0000, D2
                BEQ             outBRA
                CMPI.B          #%0010, D2
                BEQ             outBHI
                CMPI.B          #%0111, D2
                BEQ             outBEQ
                CMPI.B          #%1101, D2
                BEQ             outBLT
                RTS
                
getDisplacementByField
                CLR             D3
                MOVE.B          OpCodeDisplacement, D3
                CMPI.B          #$FF,   D3
                BEQ             getLongDisplacement
                CMPI.B          #$00,   D3
                BEQ             getWordDisplacement
                
*Otherwise getByteDisplacement
                JSR             GetByte
                BRA             doneDisplacement
                
getWordDisplacement
                JSR             GetWord
                BRA             doneDisplacement
                
getLongDisplacement
                JSR             GetLong
                BRA             doneDisplacement
                
doneDisplacement    RTS


*--------------MOVE.B Decode-----------------------------

MoveByte        
                JSR     disMoveByte
                MOVE.W  #1, opcodeSize
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
                MOVE.W  #3, opCodeSize
                JSR     MoveSrcDecode * src decode
                JSR     displayComma
                JSR     displaySpace
                JSR     MoveDesDecode   *destination decode
                JSR     displayLine 
                NOP
                RTS
                
                
*--------------MOVE.L Decode-----------------------------

MoveLong        JSR     disMoveLong
                MOVE.W  #2, opCodeSize
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
                MOVE.W  D3, Reg
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
                MOVE.W  D2, Mode
                MOVE.W  Mode, D2
                MOVE.W  Reg, D3
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
                MOVE.W  D3, Reg
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
                MOVE.W  D2, Mode
                MOVE.W  Mode, D2
                MOVE.W  Reg, D3
                JSR     ModeCompare
                RTS


*--------------Add Group Decode-----------------------------
AddGroup            BRA     addGroupType

addGroupType    
                CLR.L         D0
                CLR.L         D1
                CLR.L         D2  *    
                CLR.L         D3  *
                CLR.L         D4  *will store direction of opcode
                CLR.L         D5  *size
                CLR.L         D7  *i/r
                
*------------       Des Reg direction bit                       
                
                MOVE.W        D6, D0
                LSL.W         #4, D0
                MOVE.W        #13, D1
                LSR.W         D1, D0
                MOVE.W        D0, Reg
*------------      store Size bit
                MOVE.W        D6, D0
                LSL.W         #8, D0
                MOVE.W        #14, D1
                LSR.W         D1, D0
                MOVE.W        D0, opCodeSize
*------------      store Size bit in bit size variable for add A
                MOVE.W        D6, D0
                LSL.W         #7, D0
                MOVE.W        #15, D1
                LSR.W         D1, D0
                MOVE.W        D0, bitsOfSize                
          
                
*------------       Des Mode direction bit
                MOVE.W        D6, D0
                LSL.W         #7, D0
                MOVE.W        #13, D1
                LSR.W         D1, D0
                MOVE.W        D0, Mode

*------------       Des Reg direction bit 
                MOVE.W        D6, D0
                MOVE.W        #10, D1
                LSL.W         D1, D0
                MOVE.W        #13, D1
                LSR.W         D1, D0
                MOVE.W        D0, OpMode

*------------       Des Reg direction bit 
                MOVE.W        D6, D0
                MOVE.W        #13, D1
                LSL.W         D1, D0
                LSR.W         D1, D0
                MOVE.W        D0, RegOrCount
                JSR           checkAddType
                BRA           AddprintRest
           
*------------      analyzeType
checkAddType
                CMPI.W        #%11, opCodeSize
                BEQ           addAType
                BNE           addType

addAType
                JSR           outAddA
                MOVE.W        bitsOfSize, OpCodeSize       
                RTS

addType
                JSR           outAdd
                RTS

                
AddprintRest
                MOVE.W           OpCodeSize, D5
                JSR              printSize
                MOVE.W           RegOrCount, D3
                MOVE.W           OpMode, D2
                JSR              ModeCompare
                JSR              displayComma
                JSR              displaySpace
                MOVE.W           Reg, D3
                MOVE.W           Mode, D2
                JSR              ModeCompare
                RTS   
                 
                



                


*--------------BitShiftingGroup Decode-----------------------------

bitShiftGroup            BRA bitShiftType

bitShiftType
                CLR.L         D0
                CLR.L         D1
                CLR.L         D2  *    
                CLR.L         D3  *
                CLR.L         D4  *will store direction of opcode
                CLR.L         D5  *size
                CLR.L         D7  *i/r
                
*------------       store direction bit               
                MOVE.W      D6, D4
                LSL.W       #7, D4
                MOVE.B      #15, D1
                LSR.W       D1, D4
                MOVE.W      D4, OpCodeDirection
*-------------      store size bits
                MOVE.B      D6, D5
                LSR.B       #6, D5
                MOVE.W      D5, opCodeSize
*--------------     store i/r
                MOVE.B      D6, D7
                LSL.B       #2, D7
                LSR.B       #7, D7
                MOVE.W      D7, ImmOrReg
*-------------      store sourceReg
                MOVE.W      D6, D2
                LSL.W       #4, D2
                MOVE.B      #13, D1
                LSR.W       D1, D2
                MOVE.W      D2, RegOrCount
*-------------      store DesMode
                MOVE.W      D6, D2
                MOVE.W      #10, D1
                LSL.W       D1, D2
                MOVE.W      #13, D1
                LSR.W       D1, D2
                MOVE.W      D2, Mode

*-------------      store DesXn
                MOVE.W      D6, D2
                MOVE.W      #13, D1
                LSL.W       D1, D2
                LSR.W       D1, D2
                MOVE.W      D2, Reg               
 
                
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
                MOVE.W      OpcodeDirection, D0    
                JSR         printDirection
                MOVE.W      OpcodeSize, D5
                JSR         printSize
                JSR         printShiftFront
                JSR         displayComma
                JSR         displaySpace
                JSR         printShiftBack
                RTS

AsyShiftGroup
                JSR         disAsymmShift    
                JSR         printDirection
                JSR         printSize
                JSR         printShiftFront
                JSR         displayComma
                JSR         displaySpace
                JSR         printShiftBack
                RTS


RotShiftGroup
                JSR         disRotateShift    
                JSR         printDirection
                JSR         printSize
                JSR         printShiftFront
                JSR         displayComma
                JSR         displaySpace
                JSR         printShiftBack
                RTS



*--------BIT SHifting helper functions---------   
printShiftFront
                CLR.L       D1
                MOVE.W      RegOrCount, D1
                MOVE.B      #1, D2
                CMP.W       ImmOrReg, D2
                BEQ         printShiftRegister
                BNE         printShiftImm
                RTS

printShiftBack
                CLR.L       D1
                MOVE.W      Reg, D1
                MOVE.B      #3, D2
                CMP.W       OpCodeSize, D2
                BEQ         ShiftCheckEA
                BNE         printShiftRegister
                RTS
                
ShiftCheckEA
                CLR.L       D1         
                MOVE.W      #1, D1
                CMP.W       RegOrCount, D1
                BEQ         printShiftMode
                MOVE.W      Reg, D1
                BNE         printShiftRegister
printShiftImm 
                CLR.L       D1
                JSR         printHash
                JSR         printDollar
                MOVE.W      RegOrCount, D1
                JSR         printShiftXn
                RTS
                                
printShiftRegister
                JSR         disDataReg
                JSR         printShiftXn
                RTS

                
printShiftXn *analyzes D1
                MOVE.W      D1, D3
                ROR.L       #4, D1
                MOVE.B      #0, D2
                CMP.W       ImmOrReg, D2
                BEQ         printShiftXnCompare
                MOVE.L      D1, D4
                CLR.B       Counter
                MOVE.B      #1, HexLength
                JSR         HexDecode
                RTS



printShiftXnCompare                
                CMPI.W      #0, D3
                BEQ         out8   *special case
                MOVE.B      #1, ImmDataSize
                MOVE.L      D1, ImmData
                JSR         outImmData   
                RTS
                
printShiftMode  *can only be an effective address
                MOVE.W        Mode, D2
                MOVE.W        Reg, D3  
                JSR           EACompare
                RTS  
                                  

                     

*-------------Helper Functions-----------     


*----------------------------------------------------------------
*                         Comparisons                           |
*----------------------------------------------------------------


*------------------Mode Comparisons -----------------------------------------

ModeCompare     
                CMPI.B  #%000, D2 * last three are zeroes
                BEQ     disDataRegMode       *jump to subroutine for Data register Source
                BNE     ModeCompare1              *FIXME: needs to have not equal Branch here
                
ModeCompare1    CMPI.B  #%001, D2
                BEQ     disAddressRegMode
                BNE     ModeCompare2
                
ModeCompare2    CMPI.B  #%010, D2
                BEQ     disAnIndMode
                BNE     ModeCompare3
                
ModeCompare3    CMPI.B  #%011, D2
                BEQ     disAnPosMode
                BNE     ModeCompare4

ModeCompare4    CMPI.B  #%100, D2
                BEQ     disAnPreMode
                BNE     ModeCompare5
                
ModeCompare5    CMPI.B  #%111, D2
                BEQ     EACompare
                BNE     disError

             

*---------------------Register Compare---------------------                

                * FIXME we may need to use this for a bad command BNE XnCompare1

**--<EA> Mode Register
*
EACompare       
                CMPI.B  #%000,  D3
                BEQ     GetWord
                BNE     EACompare1
                
EACompare1      
                CMPI.B  #%001,  D3
                BEQ     GetLong
                BNE     EACompareData
                
EACompareData   
                CMPI.B  #%100,  D3
                BEQ     ImmDataScan
                BNE     disError
                
**--<EA> After Mode

GetByte
                JSR     printDollar
                MOVE.W  (A5)+,  D4
                MOVE.B  #2,     hexLength   *iterations of nibbles to take
                CLR.B     counter           *before you call hex decode zero conter
                MOVE.B  #24, D2
                LSL.L   D2, D4
                JSR     HexDecode
                RTS

GetWord         
                JSR     printDollar
                MOVE.W  (A5)+,  D4
                MOVE.B  #4,     hexLength
                CLR.B     counter ***
                MOVE.B  #16, D2
                LSL.L   D2, D4
                JSR     HexDecode
                RTS
                
GetLong         
                JSR     printDollar
                MOVE.L  (A5)+,  D4
                MOVE.B  #8,     hexLength
                CLR.B     counter
                JSR     HexDecode
                RTS

*----------------------------------------------
printDirection
                CMPI.B      #0, D4
                BEQ         outDirectionR
                BNE         outDirectionL


printSize
                CMPI.B      #0, D5
                BEQ         outSizeByte
                CMPI.B      #1, D5
                BEQ         outSizeWord
                CMPI.B      #2, D5
                BEQ         outSizeLong
                BNE         disError
                
                RTS


                
*----------------------------------------------

ImmDataScan *find Immediate data type and store --- USE bitsOfSize
                JSR     printHash
                CMPI.B  #4, opCodeNib *takes care of MOVE group
                BLT     ImmDataTypeMove
                CMPI.B  #1, bitsOfSize *number of bits of the Size for this particular machine code
                BEQ     ImmDataType1Bit
                CMPI.B  #2, bitsOfSize
                BEQ     ImmDataType2Bit
                BRA     disError

ImmDataTypeMove 
                MOVE.W  opCodeSize, D5
                CMPI.B  #%01,   D5
                BEQ     GetByte
                CMPI.B  #%11,   D5
                BEQ     GetWord
                CMPI.B  #%10,   D5
                BEQ     GetLong
                BRA     disError
                
ImmDataType1Bit 
                MOVE.W  opCodeSize, D5
                CMPI.B  #%0,   D5
                BEQ     GetWord
                CMPI.B  #%1,   D5
                BEQ     GetLong
                BRA     disError
                
ImmDataType2Bit 
                MOVE.W  opCodeSize, D5
                CMPI.B  #%00,   D5
                BEQ     GetByte
                CMPI.B  #%10,   D5
                BEQ     GetWord
                CMPI.B  #%11,   D5
                BEQ     GetLong
                BRA     disError                
               

outImmData
                MOVE.L  ImmData, D4 *this is the temp copy for the Hex decode
                MOVE.B  ImmDataSize, HexLength
                CLR.B   counter *reset Counter before every Hex Decode
                JSR     HexDecode
                RTS


RTSCommand
                RTS

*----------------------------------------------------------------
*                          DISPLAYS                             |
*----------------------------------------------------------------




*---------------------MODE Displays Methods----------------------


*-----------Data Register--------------------

disDataRegMode    
                JSR     disDataReg
                JSR     hexCompare
                
                CLR.L   D7
                RTS

*--------Address Register---------------------
                    
disAddressRegMode    
                JSR     disAddressReg
                JSR     HexCompare
                
                CLR.L   D7
                RTS

*-------Indirect Address Register----------------

disAnIndMode    JSR     disLeftParen
                JSR     disAddressReg
                
                JSR     HexCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                
                RTS
                
*----Indirect Address Register Post Increment----

disAnPosMode    JSR     disLeftParen
                JSR     disAddressReg
                
                JSR     HexCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                JSR     displayPlus
                
                RTS

*----Indirect Address Register Pre Decrement-----------

disAnPreMode    JSR     displayMinus
                JSR     disLeftParen
                JSR     disAddressReg
                
                JSR     HexCompare
                
                CLR.L   D7
                
                JSR     disRightParen
                
                CLR.L   D7
                RTS
                
*-----------Effective Address Long Size------------
disEALong
                JSR     printDollar
*                JSR     outEAword
                RTS
*-----------Effective Address Word Size------------                
disEAWord
                JSR     printDollar
*                JSR     outEAlong
                RTS
*------------Immediate Data-----------------------                
disImmData
                JSR     printHash
                JSR     printDollar
                JSR     outImmData
                RTS
                      
*----------------------Displays---------------------- 


*------------------Characters--------------------------------

disDataReg      
                MOVE.B  #$44, (A6)+
                RTS


disAddressReg        
                MOVE.B  #$41, (A6)+
                RTS

disLeftParen    MOVE.B  #$28, (A6)+
        
                RTS
                
disRightParen   MOVE.B  #$29, (A6)+
                RTS
                
              
displayPlus     MOVE.B  #$2B, (A6)+
                RTS
                
displayMinus    MOVE.B  #$2D, (A6)+
                RTS

displayComma    MOVE.B  #$2C, (A6)+
                RTS
                
displaySpace    MOVE.B  #$20, (A6)+
                RTS
                
displayLine     ;MOVE.B  #$A, (A6)+
                RTS
                
                
*-----------Numbers------------               

printHash       MOVE.B  #$23, (A6)+
                RTS

printDollar     MOVE.B  #$24, (A6)+
                RTS

*----------OpCode-----------------                
disMoveByte     JSR   outMove
                JSR   outSizeByte
                RTS                


disMoveWord     JSR   outMove
                JSR   outSizeWord
                RTS

disMoveLong     JSR   outMove
                JSR   outSizeLong
                RTS
                
disAsymmShift   
                JSR   outAsymm
                RTS
disLogicShift
                JSR   outLogical
                RTS

disRotateShift                
                JSR   outRotate
                RTS                
                
                
                





         

*----------OPCode IDs--------------

outMove
                MOVE.B      #$4D, (A6)+
                MOVE.B      #$4F, (A6)+
                MOVE.B      #$56, (A6)+
                MOVE.B      #$45, (A6)+
                JSR         CheckMoveA
                RTS

CheckMoveA      
                MOVE.W      fullOpcode, D1
                LSL.W       #7, D1
                MOVE.B      #13, D0
                LSR.W       D0, D1
                CMPI.W      #%001, D1
                BNE         RTSCommand
                MOVE.B      #$41, (A6)+
                RTS
                
outMoveM    
                JSR         outMove
                MOVE.B      #$4D, (A6)+
                RTS

outAdd          
                MOVE.B      #$41, (A6)+
                MOVE.B      #$44, (A6)+
                MOVE.B      #$44, (A6)+
                RTS
                
outAddA
                JSR         outAdd
                MOVE.B      #$41, (A6)+
                RTS


outSub 
                MOVE.B      #$53, (A6)+
                MOVE.B      #$55, (A6)+
                MOVE.B      #$42, (A6)+
                RTS

outSubA         JSR         outSub
                MOVE.B      #$41, (A6)+
                RTS

outSubI         JSR         outSub
                MOVE.B      #$49, (A6)+
                RTS


outMulS         
                MOVE.B      #$4D, (A6)+
                MOVE.B      #$55, (A6)+
                MOVE.B      #$4C, (A6)+
                MOVE.B      #$53, (A6)+
                RTS

outDivs                             
                MOVE.B      #$44, (A6)+
                MOVE.B      #$49, (A6)+
                MOVE.B      #$56, (A6)+
                MOVE.B      #$53, (A6)+
                RTS

outLEA          
                MOVE.B      #$4C, (A6)+
                MOVE.B      #$45, (A6)+
                MOVE.B      #$41, (A6)+
                RTS
                
outAnd
                MOVE.B      #$41, (A6)+
                MOVE.B      #$4E, (A6)+
                MOVE.B      #$44, (A6)+
                RTS

outOri
                MOVE.B      #$4F, (A6)+
                MOVE.B      #$52, (A6)+
                MOVE.B      #$49, (A6)+
                RTS
                
outNeg
                MOVE.B      #$4E, (A6)+
                MOVE.B      #$45, (A6)+
                MOVE.B      #$47, (A6)+
                RTS

outEOR
                MOVE.B      #$45, (A6)+
                MOVE.B      #$4F, (A6)+
                MOVE.B      #$52, (A6)+
                RTS
                
outEORI
                JSR         outEOR
                MOVE.B      #$49, (A6)+
                RTS
                
outNot
                MOVE.B      #$4E, (A6)+
                MOVE.B      #$4F, (A6)+
                MOVE.B      #$54, (A6)+
                RTS                
                
outAsymm
                MOVE.B      #$41, (A6)+
                MOVE.B      #$53, (A6)+
                RTS        
                
outRotate
                MOVE.B      #$52, (A6)+
                MOVE.B      #$4F, (A6)+
                RTS

outLogical     
                MOVE.B      #$4C, (A6)+
                MOVE.B      #$53, (A6)+
                RTS
                
outBTST
                MOVE.B      #$42, (A6)+
                MOVE.B      #$54, (A6)+
                MOVE.B      #$53, (A6)+
                MOVE.B      #$54, (A6)+
                RTS
                
outCMP
                MOVE.B      #$43, (A6)+
                MOVE.B      #$4D, (A6)+
                MOVE.B      #$50, (A6)+
                RTS

outCMPI
                JSR         outCMP
                MOVE.B      #$49 ,(A6)+
                RTS

outCMPA
                JSR         outCMP
                MOVE.B      #$41, (A6)+
                RTS
                
outBEQ
                MOVE.B      #$42, (A6)+
                MOVE.B      #$45, (A6)+
                MOVE.B      #$51, (A6)+
                RTS
                
outBNE
                MOVE.B      #$42, (A6)+
                MOVE.B      #$4E, (A6)+
                MOVE.B      #$45, (A6)+
                RTS
                
outBLT
                MOVE.B      #$42, (A6)+
                MOVE.B      #$4C, (A6)+
                MOVE.B      #$54, (A6)+
                RTS
                
outBHI
                MOVE.B      #$42, (A6)+
                MOVE.B      #$48, (A6)+
                MOVE.B      #$49, (A6)+
                RTS
                
outBRA
                MOVE.B      #$42, (A6)+
                MOVE.B      #$52, (A6)+
                MOVE.B      #$41, (A6)+
                RTS
                
outJSR
                MOVE.B      #$42, (A6)+
                MOVE.B      #$53, (A6)+
                MOVE.B      #$52, (A6)+
                RTS
                
outRTS
                MOVE.B      #$52, (A6)+
                MOVE.B      #$54, (A6)+
                MOVE.B      #$53, (A6)+
                RTS

out8            
                MOVE.B      #$38, (A6)+
                RTS                                


*----------------opCode Helpers----------
*---------------Direction----------------
outDirectionL
                MOVE.B      #$4C, (A6)+
                RTS

outDirectionR
                MOVE.B      #$52, (A6)+
                RTS

*---------------Size----------------------                
outSizeByte
                MOVE.B  #$2E, (A6)+
                MOVE.B  #$42, (A6)+
                MOVE.B  #$20, (A6)+
                RTS
outSizeWord
                MOVE.B  #$2E, (A6)+
                MOVE.B  #$57, (A6)+
                MOVE.B  #$20, (A6)+  
                RTS
outSizeLong
                MOVE.B  #$2E, (A6)+
                MOVE.B  #$4C, (A6)+
                MOVE.B  #$20, (A6)+
                RTS        
*----------------------------------------------------------------
*                         ASCII to HEX Decode                   |
*----------------------------------------------------------------

setCharToHex
        ADD.B   #%1, D6     *counter
        CMP.W   D1, D6
        BGT     doneLoadASCII
        MOVE.B  (A1)+, D2 *move one character
        CMPI.B  #$40, D2     *if greater than thirty
        BLT     charIsNum       *number
        CMPI.B  #$41, D2
        BGT     isLetterChkType

charIsNum
        SUBI.B      #$30, D2
        BRA         moveToLong
        
isLetterChkType
        CMPI.B      #$61, D2
        BGE         charIsLow
        BRA         charIsBig

charIsLow
        SUBI.B      #55, D2
        BRA         moveToLong
        
charIsBig        
        SUBI.B      #87, D2
        BRA         moveToLong
        
moveToLong
        LSL.B       #4, D2
        LSR.B       #4, D2
        LSL.L       #4, D4  *making space for new byte into remake
        ADD.B       D2, D4  *make hex value most significant bits (4-8)
        BRA         setCharToHex
        
doneLoadASCII     
        RTS
        
*----------------------------------------------------------------
*                         HEX to ASCII Decode                   |
*---------------------------------------------------------------- 

HexDecode
        ADDI.B  #1, counter 
        ROL.L   #4, D4  
        MOVE.B  D4, D3
*        MOVE.B  #28,D2
        LSL.B   #4, D3
        LSR.B   #4, D3
        JSR     HexCompare
        MOVE.B  HexLength, D0
        CMP.B   counter, D0
        BNE     HexDecode
        RTS
        
          
hexcompare
        CMPI.B  #%1010, D3
        BGE     loadHexLetter
        BLT     loadHexNumber

             
loadHexNumber        
        ADDI.B  #$30, D3
        MOVE.B  D3, (A6)+
        RTS
loadHexLetter
        ADDI.B  #$37, D3
        MOVE.B  D3, (A6)+
        RTS


*-----------Error------------------         
disError        
                LEA     Error, A1
                Move.B  #14, D0
                Trap    #15
                RTS 

displayOutput
                CLR.L   D1
                MOVE.W  lineNumber, D1
                MOVE.B  #3, D0
                TRAP    #15
               
                LEA     output, A1
                MOVE.B  #13, D0
                TRAP    #15
                RTS
    
DONE
*        BRA         START

    

         
*----------------------------------------------------------------
*                         String constants                      |
*----------------------------------------------------------------

* Put variables and constants here
Error           DC.B    'error', 0
ASKStart        DC.B    'Starting Location: ',0
ASKEnd          DC.B    'Ending Location: ',0
AskToContinue   DC.B    'Hit any key to continue',0

counter         DS.B    1
hexlength       DS.B    1

lineAddress     DS.L    1
lineNumber      DS.W    1

fullOpcode      DS.W    1
OpCodeNib       DS.W    1
OpCodeDir       DS.W    1

OpCodeCondition DS.B    1
OpCodeDisplacement  DS.B    1

OpCodeSize      DS.W    1
bitsOfSize      DS.B    1

OpCodeDirection DS.W    1


Mode            DS.W    1 *no need to duplicate only focus on source or destination at one time, not both.
Reg             DS.W    1 ************
RegOrCount      DS.W    1
OpMode          DS.W    1


EAword          DS.W    1
EAlong          DS.L    1


ImmOrReg        DS.W    1
ImmDataSize     DS.B    1
ImmData         DS.L    1

STARTPT         DS.L    1
ENDPT           DS.L    1

Output          DS.L    10

NumDisplayed    DS.B    1
 
    END START          
       ; last line of source


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
