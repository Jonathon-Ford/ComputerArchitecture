; Jonathon Ford
; Professor: Brent Nowlin
;
;Project 0
;
; This program reads in two 6 integers (two pairs of feet and inches) from a user and calculates volume

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
Include irvine32.inc

.data

	lengthInch word 0
	widthInch word 0
	heightInch word 0

	volumeCubedJustInch dword 0

	lengthInputFeetText db 'Enter the length feet:', 13,10, 0
	lengthInputInchText db 'Enter the length inches:', 13,10, 0

	widthInputFeetText db 'Enter the width feet:', 13,10, 0
	widthInputInchText db 'Enter the width inches:', 13,10, 0

	heightInputFeetText db 'Enter the height feet:', 13, 10, 0
	heightInputInchText db 'Enter the height inches:', 13, 10, 0

	volumeOutIntro db 'Your volume is ', 0
	volumeOutCont1 db ' cu. ft. and ', 0
	volumeOutCont2 db ' cu. Inches, which is ', 0
	volumeOutro db ' cu. Inches', 0

.code
main PROC

	;Get input from user for length in form: feet inch

	MOV EDX, offset lengthInputFeetText
	CALL writestring
	CALL readint
	MOV CX, AX
	MOV EDX, offset lengthInputInchText
	CALL writestring
	CALL readint
	MOV BX, AX
	
	;Convert length feet to inches and add to existing inches
	
	MOV AX, 12
	MUL CX
	ADD AX, BX
	MOV lengthInch, AX

	;Do the same for width and height

	MOV EDX, offset widthInputFeetText
	CALL writestring
	CALL readint
	MOV CX, AX
	MOV EDX, offset widthInputInchText
	CALL writestring
	CALL readint
	MOV BX, AX

	MOV AX, 12
	MUL CX
	ADD AX, BX
	MOV widthInch, AX

	MOV EDX, offset heightInputFeetText
	CALL writestring
	CALL readint
	MOV CX, AX
	MOV EDX, offset heightInputInchText
	CALL writestring
	CALL readint
	MOV BX, AX

	MOV AX, 12
	MUL CX
	ADD AX, BX
	MOV heightInch, AX


	;Apply L * W * H = V

	MOV AX, lengthInch
	MUL widthInch
	MUL heightInch

	MOV volumeCubedJustInch, EAX
	XOR ECX, ECX
	MOV CX, 1728
	DIV CX
	XOR ECX, ECX
	MOV CX, DX

	;Display the volume in cubed feet and inches

	MOV EDX, offset volumeOutIntro
	CALL writestring
	CALL writedec
	MOV EDX, offset volumeOutCont1
	CALL writestring
	MOV EAX, ECX
	CALL writedec
	MOV EDX, offset volumeOutCont2
	CALL writestring
	MOV EAX, volumeCubedJustInch
	CALL writedec
	MOV EDX, offset volumeOutro
	CALL writestring


	INVOKE ExitProcess, 0

main ENDP
END main