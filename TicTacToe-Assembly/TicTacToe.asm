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

.code
main PROC
     push OFFSET board
     call showBoard

     ; pause before closing window
     call WaitMsg
	
     exit
main ENDP

; Prints board.
;    Receives: [ebp + 8] = address of board
;    Returns:  nothing
showBoard PROC
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
showBoard ENDP

END main