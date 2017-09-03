; TicTacToe
; by Alex Johnson
; September 2, 2017

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
currentPlayer  BYTE 'X'
choice         DWORD ?
winner         DWORD 0
playerXwins    DWORD 0
playerOwins    DWORD 0
catsCount      DWORD 0
playAgainIn    BYTE 2 DUP (?)
sIntro         BYTE "Welcome to TicTacToessembly!",0
sPlayAgain     BYTE "Play again (y/n)? ",0
sOutro         BYTE "Thanks for playing!",0
sTurn          BYTE "'s turn. Choose a square: ",0
sInvalidChoice BYTE "Invalid choice. Choose a square: ",0
sCats          BYTE "Cats!",0
sWins          BYTE " wins!",0
sWinCount      BYTE " wins: ",0
sCatsCount     Byte "Cats: ",0

.code
printIntro     PROTO
clearBoard     PROTO
printBoard     PROTO
chooseSquare   PROTO
checkWinner    PROTO
processWinner  PROTO
processCats    PROTO
switchPlayer   PROTO
printOutro     PROTO

main PROC
     ; print intro
     call printIntro

Play:  
     ; clear board
     push OFFSET board
     call clearBoard
     
     ; print starting board
     push OFFSET board
     call printBoard

     ; prompt for choices until game is won
L1:   
     ; prompt player to choose square
     mov al,currentPlayer          ; move currentPlayer (X or O) into al
     push eax                      ; push currentPlayer (in al) to stack
     push OFFSET board             ; push address of board to stack
     call chooseSquare
     
     ; print board after move
     push OFFSET board
     call printBoard

     ; check if game over    
     push OFFSET winner            ; push address of winner to stack
     mov al,currentPlayer          ; move currentPlayer (X or O) into al
     push eax                      ; push currentPlayer (in al) to stack
     push OFFSET board             ; push address of board to stack
     call checkWinner
     mov eax,winner
     cmp eax,1                     ; if winner/eax is 1, game is over
     je Win
     cmp eax,2
     je Cats

     ; switch to other player
     push OFFSET currentPlayer     ; push address of currentPlayer to stack
     call switchPlayer
     jmp L1

Win:
     push OFFSET catsCount
     push OFFSET playerOwins
     push OFFSET playerXwins
     mov al,currentPlayer          ; move currentPlayer (X or O) into al
     push eax                      ; push currentPlayer (in al) to stack
     call processWinner
     jmp PlayAgain

Cats:
     push OFFSET catsCount
     push OFFSET playerOwins
     push OFFSET playerXwins
     call processCats
     jmp PlayAgain
     
PlayAgain:
     ; prompt for another game
     mov edx,OFFSET sPlayAgain
     call WriteString
     mov edx,OFFSET playAgainIn
     mov ecx,2
     call ReadString
     mov al,playAgainIn
     cmp al,'y'
     je Play
     cmp al,'n'
     je Finish
     
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

; Clears board.
;    Receives: [ebp + 8] = address of board
;    Returns:  nothing
clearBoard PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; clear board squares
     mov esi,[ebp + 8]        ; move address of board into esi
     mov bl,' '
     mov [esi + 30],bl
     mov [esi + 38],bl
     mov [esi + 46],bl
     mov [esi + 134],bl
     mov [esi + 142],bl
     mov [esi + 150],bl
     mov [esi + 238],bl
     mov [esi + 246],bl
     mov [esi + 254],bl

     ; clean up stack frame
     popad
     pop  ebp
     ret  4
clearBoard ENDP

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
     ja   Invalid             ; value for terms too high, jump to Invalid
     cmp  choice,1
     jb   Invalid             ; value for terms too low, jump to Invalid
     cmp choice,1                         
     je Place1                ; place at cell 1
     cmp choice,2                         
     je Place2                ; place at cell 2
     cmp choice,3                         
     je Place3                ; place at cell 3
     cmp choice,4                         
     je Place4                ; place at cell 4
     cmp choice,5                         
     je Place5                ; place at cell 5
     cmp choice,6                         
     je Place6                ; place at cell 6
     cmp choice,7                         
     je Place7                ; place at cell 7
     cmp choice,8                         
     je Place8                ; place at cell 8
     cmp choice,9                         
     je Place9                ; place at cell 9
     jmp  Finish

Place1:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,30               ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place2:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,38               ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place3:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,46               ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place4:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,134              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place5:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,142              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place6:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,150              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place7:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,238              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place8:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,246              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

Place9:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,254              ; increment esi to correct cell
     mov bl,' '
     cmp [esi],bl             ; check if cell is empty
     jne Invalid              ; jump if cell is not empty
     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov [esi],bl             ; move bl into address pointed to by esi
     jmp Finish

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

; Checks to see if either player has won by looking for runs of 3 X's or O's, depending
; on whether the most recent move was made by X or O. This is done by looking at 
; particular cell in the board array. For example, a run in the first row would mean
; that cell 30, 38, and 46 would all be either X or O.
;    Receives: [ebp +  8] = address of board  
;              [ebp + 12] = currentPlayer
;              [ebp + 16] = winner
;    Returns:  0 in winner if no winner found, 1 if winner found, 2 if cats
checkWinner PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     mov bl,[ebp + 12]        ; move currentPlayer into bl
     mov edi,[ebp + 16]       ; store address of winner in edi

CheckRow1:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,30               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow2            ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow2            ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow2            ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckRow2:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,134              ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow3            ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow3            ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckRow3            ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckRow3:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,238              ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn1         ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn1         ; no winner here, so check next row, column, or diagonal
     add esi,8                ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn1         ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckColumn1:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,30               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn2         ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn2         ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn2         ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckColumn2:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,38               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn3         ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn3         ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckColumn3         ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckColumn3:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,46               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal1       ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal1       ; no winner here, so check next row, column, or diagonal
     add esi,104              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal1       ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckDiagonal1:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,30               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal2       ; no winner here, so check next row, column, or diagonal
     add esi,112              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal2       ; no winner here, so check next row, column, or diagonal
     add esi,112              ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckDiagonal2       ; no winner here, so check next row, column, or diagonal
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckDiagonal2:
     mov esi,[ebp + 8]        ; move address of board into esi
     add esi,46               ; increment esi to correct cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckCats            ; no winner here, so no winner at all
     add esi,96               ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckCats            ; no winner here, so no winner at all
     add esi,96               ; increment esi to next cell
     cmp [esi],bl             ; check if cell is the same as currentPlayer
     jne CheckCats            ; no winner here, so no winner at all
     jmp WinnerFound          ; if we've made it this far then we have a winner

CheckCats:
     mov esi,[ebp + 8]        ; move address of board into esi
     mov bl,' '
     cmp [esi + 30],bl        ; check if cell is empty
     je NoWinnerFound         ; cell is empty, so can't be cats
     cmp [esi + 38],bl
     je NoWinnerFound
     cmp [esi + 46],bl
     je NoWinnerFound
     cmp [esi + 134],bl
     je NoWinnerFound
     cmp [esi + 142],bl
     je NoWinnerFound
     cmp [esi + 150],bl
     je NoWinnerFound
     cmp [esi + 238],bl
     je NoWinnerFound
     cmp [esi + 246],bl
     je NoWinnerFound
     cmp [esi + 254],bl
     je NoWinnerFound
     jmp CatsFound

NoWinnerFound:
     mov edx,0
     mov [edi],edx
     jmp Finish

WinnerFound:
     mov edx,1
     mov [edi],edx
     jmp Finish

CatsFound:
     mov edx,2
     mov [edi],edx
     jmp Finish

Finish:
     ; clean up stack frame
     popad
     pop  ebp
     ret 12
checkWinner ENDP

; Prints winner and increments that player's score.
;    Receives: [ebp +  8] = currentPlayer
;              [ebp + 12] = address of playerXwins
;              [ebp + 16] = address of playerOwins
;              [ebp + 20] = address of catsCount
;    Returns:  nothing
processWinner PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; process arguments
     mov eax,[ebp + 8]
     mov esi,[ebp + 12]            ; move address of playerXwins into esi
     mov edi,[ebp + 16]            ; move address of playerOwins into edi

     ; print winner
     call WriteChar
     mov edx,OFFSET sWins
     call WriteString
     call Crlf

     ; increment wins
     cmp al,'X'
     je IncrementXwins
     cmp al,'O'
     je IncrementOwins

IncrementXwins:
     mov ebx,[esi]
     inc ebx
     mov [esi],ebx
     jmp PrintScores

IncrementOwins:
     mov ebx,[edi]
     inc ebx
     mov [edi],ebx
     jmp PrintScores

     ; print scores
PrintScores:
     mov esi,[ebp + 12]             ; move address of playerXwins into esi
     mov al,'X'
     call WriteChar
     mov edx,OFFSET sWinCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     mov esi,[ebp + 16]            ; move address of playerOwins into esi
     mov al,'O'
     call WriteChar
     mov edx,OFFSET sWinCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     mov esi,[ebp + 20]            ; move address of catsCount into esi
     mov edx,OFFSET sCatsCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     ; clean up stack frame
     popad
     pop  ebp
     ret 16
processWinner ENDP

; Prints cats and increments catsCount.
;    Receives: [ebp +  8] = address of playerXwins
;              [ebp + 12] = address of playerOwins
;              [ebp + 16] = address of catsCount
;    Returns:  nothing
processCats PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; print cats!
     mov edx,OFFSET sCats
     call WriteString
     call Crlf

     ; increment cats
IncrementCats:
     mov esi,[ebp + 16]            ; move address of catsCount into esi
     mov ebx,[esi]
     inc ebx
     mov [esi],ebx
     jmp PrintScores

     ; print scores
PrintScores:
     mov esi,[ebp + 8]             ; move address of playerXwins into esi
     mov al,'X'
     call WriteChar
     mov edx,OFFSET sWinCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     mov esi,[ebp + 12]            ; move address of playerOwins into esi
     mov al,'O'
     call WriteChar
     mov edx,OFFSET sWinCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     mov esi,[ebp + 16]            ; move address of catsCount into esi
     mov edx,OFFSET sCatsCount
     call WriteString
     mov eax,[esi]
     call WriteDec
     call Crlf

     ; clean up stack frame
     popad
     pop  ebp
     ret 12
processCats ENDP

; Checks to see if either player has won by looking for runs of 3 X's or O's. This is
; done by looking at particular cells in the board array. For example, a run in the
; first row would mean that cells 30, 38, and 46 would all be either X or O. If winner
;    Receives: [ebp + 8] = address of currentPlayer  
;    Returns:  0 in EAX if no winner found, 1 in EAX if winner found
switchPlayer PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; get currentPlayer char
     mov esi,[ebp + 8]        ; move address of currentPlayer into esi
     mov ebx,[esi]            ; move character pointed to by eax to ebx

     ; prepare registers for comparison
     mov ecx,'X'
     mov edx,'O'

     ; compare 
     cmp bl,cl                ; currentPlayer is X so switch to O
     je XtoO
     cmp bl,dl                ; currentPlayer is O so switch to X
     je OtoX

     ; swap currentPlayer
XtoO:
     mov bl,dl
     jmp Finish
OtoX:
     mov bl,cl
     jmp Finish
     
Finish:
     ; move back into currentPlayer via address in esi
     mov [esi],bl

     ; clean up stack frame
     popad
     pop  ebp
     ret 4
switchPlayer ENDP

; Prints outro.
;    Receives: nothing
;    Returns:  nothing
printOutro PROC
    ; prepare stack frame
     push ebp
     mov  ebp,esp
     pushad

     ; procedure code here
     mov edx,OFFSET sOutro
     call WriteString
     call Crlf

     ; clean up stack frame
     popad
     pop  ebp
     ret
printOutro ENDP

END main