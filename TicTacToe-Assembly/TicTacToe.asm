; TicTacToe

include Irvine32.inc
    
.data
board BYTE " 1      |2      |3      ",10,13,
           "        |       |       ",10,13,
           "        |       |       ",10,13,
           " -------+-------+-------",10,13, 
           " 4      |5      |6      ",10,13,
           "        |       |       ",10,13,
           "        |       |       ",10,13,
           " -------+-------+-------",10,13,
           " 7      |8      |9      ",10,13, 
           "        |       |       ",10,13,
           "        |       |       ",10,13,0
playerX        BYTE 'X'
playerY        BYTE 'O'
currentPlayer  BYTE 'X'
choice         DWORD ?
sIntro         BYTE "Welcome to TicTacToessembly!",0
sTurn          BYTE "'s turn. Choose a square: ",0
sInvalidChoice BYTE "Invalid choice. Choose a square: ",0
sWins          BYTE " wins!",0

.code
printIntro       PROTO
printBoard       PROTO
chooseSquare     PROTO
switchPlayer     PROTO
checkWinner      PROTO
printOutro       PROTO

main PROC
     ; print intro
     call printIntro
     
     ; prompt for choices until game is won
Run:     
     push OFFSET board
     call printBoard

     mov al,currentPlayer
     push eax
     push OFFSET board
     call chooseSquare
     
     mov al,currentPlayer
     push eax
     call switchPlayer
     
     ; check if game over
     push OFFSET board
     call checkWinner
     cmp eax,0
     je Run

Finish:
     ; print outro
     call printOutro
     
     ; pause before closing window
     call WaitMsg
	
     exit
main ENDP

; Prints intro.
;    Receives: nothing
;    Returns:  nothing
printIntro PROC
     mov edx,OFFSET sIntro
     call WriteString
     call Crlf
     call Crlf
     ret
printIntro ENDP

; Prints board.
;    Receives: [ebp + 8] = address of board
;    Returns:  nothing
printBoard PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; print board
     mov edx,[ebp + 8]
     call WriteString

     ; clean up stack frame
     popad
     pop  ebp
     ret  4
printBoard ENDP

; Prompts player to choose a location on board to place an X. Validates input and
; will only accept a number between 1 and 9. Cells to place at are as follows:
; 1 = 30, 2 = 38, 3 = 46, 4 = 134, 5 = 142, 6 = 150, 7 = 238, 8 = 246, 9 = 254
;    Receives: [ebp +  8] = address of board
;              [ebp + 12] = currentPlayer
;    Returns:  nothing
chooseSquare PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; loop until choice entered
     mov  eax,[ebp + 12]
     call WriteChar
     mov edx,OFFSET sTurn
     call WriteString

Validate:
     call ReadDec
     mov  choice,eax
     cmp  choice,9
     ja   Invalid            ; value for terms too high, jump to Invalid
     cmp  choice,1
     jb   Invalid            ; value for terms too low, jump to Invalid
     jmp  Finish

Invalid:
     mov  edx,OFFSET sInvalidChoice
     call WriteString
     jmp  Validate

Finish:
     ; clean up stack frame
     popad
     pop  ebp
     ret 8
chooseSquare ENDP

; Checks to see if either player has won by looking for runs of 3 X's or O's. This is
; done by looking at particular cells in the board array. For example, a run in the
; first row would mean that cells 30, 38, and 46 would all be either X or O. If winner
;    Receives: [ebp + 8] = address of board  
;    Returns:  0 in EAX if no winner found, 1 in EAX if winner found
switchPlayer PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; procedure code here

     ; clean up stack frame
     popad
     pop  ebp
     ret
switchPlayer ENDP

; Checks to see if either player has won by looking for runs of 3 X's or O's. This is
; done by looking at particular cells in the board array. For example, a run in the
; first row would mean that cells 30, 38, and 46 would all be either X or O. If winner
;    Receives: [ebp + 8] = address of board  
;    Returns:  0 in EAX if no winner found, 1 in EAX if winner found
checkWinner PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; procedure code here

     ; clean up stack frame
     popad
     pop  ebp
     ret
checkWinner ENDP

; Prints outro.
;    Receives: nothing
;    Returns:  nothing
printOutro PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; procedure code here

     ; clean up stack frame
     popad
     pop  ebp
     ret
printOutro ENDP

END main