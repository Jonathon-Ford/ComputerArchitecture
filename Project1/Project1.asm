


Include Irvine32.inc

.data
	intro db 'Enter a string:', 13,10,0
	askFunction db 13,10, 'Enter a number corresponding to these functions:', 13,10,0
	function1 db '1: Outputs the location of the first occourance of a specified character.', 13,10,0
	function2 db '2: Outputs the number of occurrences of a certain letter in a string.', 13,10,0
	function3 db '3: Outputs the length of the input string including spaces.', 13,10,0
	function4 db '4: Outputs the number of alphanumeric characters.', 13,10,0
	function5 db '5: Replace every occurrence of a certain letter with another symbol (Case sensitive).', 13,10,0
	function6 db '6: Capitalize all letters in the string.', 13,10,0
	function7 db '7: Make each letter lower case in the string.', 13,10,0
	function8 db '8: Toggle the case of each letter', 13,10,0
	function9 db '9: Undo the last function', 13,10,0
	function10 db '10: Input a new string', 13,10,0
	function0 db '0: Output menu again', 13,10,0
	function999 db '999: Exit', 13,10,0

	reverts db 13,10, 'Reverts to: ', 0

	stringArr db 51 dup(0)
	stringArrOnePrev db 51 dup(0)
	byteCount dword ?

.code
main PROC
	
Get_String:     ;Recieve string input
	
	mov edx, offset intro
	call writestring
	mov edx, offset stringArr
	mov ecx, sizeof stringArr
	call readstring
	mov byteCount, eax


Ask_Next_Func:     ;Ask next function and print options
	mov edx, offset askFunction
	call writestring
	mov edx, offset function1
	call writestring
	mov edx, offset function2
	call writestring
	mov edx, offset function3
	call writestring
	mov edx, offset function4
	call writestring
	mov edx, offset function5
	call writestring
	mov edx, offset function6
	call writestring
	mov edx, offset function7
	call writestring
	mov edx, offset function8
	call writestring
	mov edx, offset function9
	call writestring
	mov edx, offset function10
	call writestring
	mov edx, offset function0
	call writestring
	mov edx, offset function999
	call writestring

	call readint
	jz Ask_Next_Func

	mov esi, offset stringArr
	mov ecx, sizeof stringArr

	cmp eax, 1
	jne Test_For_Two
	call FindFirstOcc
	jmp Ask_Next_Func

Test_For_Two:

	cmp eax, 2
	jne Test_For_Three
	call FindNumOcc
	jmp Ask_Next_Func

Test_For_Three:
	
	cmp eax, 3
	jne Test_For_Four
	call FindStringLength
	jmp Ask_Next_Func

Test_For_Four:

	cmp eax, 4
	jne Test_For_Nine
	call FindStringAlNumLength
	jmp Ask_Next_Func

Test_For_Nine:
	
	cmp eax, 9
	jne Test_For_999
	mov edx, esi
	call writestring
	mov ebx, offset stringArrOnePrev

Loop_Thru_The_Origional_Array:
	
	mov al, [ebx]
	mov [esi], al
	dec ecx
	jcxz Show_Old_As_Curr
	add esi, type byte
	add ebx, type byte
	jmp Show_Old_As_Curr

Show_Old_As_Curr:
	
	mov edx, offset reverts
	call writestring
	mov edx, offset stringArr
	call writestring
	jmp Ask_Next_Func

Test_For_999:

	cmp eax, 999
	jne Test_For_Six
	jmp Quitter

Test_For_Six:

	mov ebx, offset stringArrOnePrev
	push eax

Loop_Thru_Saved_Array:
	
	mov al, [esi]
	mov [ebx], al
	dec ecx
	jcxz Done_Thru_Saved_Array
	add esi, type byte
	add ebx, type byte

Done_Thru_Saved_Array:

	pop eax
	cmp eax, 6
	jne Test_For_Seven


Test_For_Seven:

Quitter:

	INVOKE ExitProcess, 0

main ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------
;FindFirstOcc
;Receives: 
;ESI = the array offset
;ECX = size of array
;Prints the location of the first occurance of an inputed char
;----------------------------------------------------------------------------------------------------------------------------------------------

FindFirstOcc PROC

.data

	firstOccAskMsg db 'Enter a char to find first occurance of:',13,10, 0
	firstOccOutMsg1 db 'The character ', 0
	firstOccOutMsg2 db ' first occurs at position ',0
	firstOccOutMsg3 db ', in the string: ',0
	firstOccFailedMsg1 db 'The character ',0
	firstOccFailedMsg2 db ' does not appear in the string: ',0

.code

PUBLIC FindFirstOcc

	push esi
	push ecx
	push eax
	push edx
	push ebx
	xor ebx, ebx
	push esi

	mov edx, offset firstOccAskMsg
	call writestring
	call readchar

Loopin_Thru_The_Array:
	
	dec ecx
	inc ebx
	cmp [esi], al
	je Found_It
	jcxz Not_Found
	add esi, type byte
	jmp Loopin_Thru_The_Array

Not_Found:
	
	mov edx, offset firstOccFailedMsg1
	call writestring
	call writechar
	mov edx, offset firstOccFailedMsg2
	call writestring
	pop edx
	call writestring
	jmp End_It

Found_It:

	mov ecx, edx
	mov edx, offset firstOccOutMsg1
	call writestring
	call writechar
	mov edx, offset firstOccOutMsg2
	call writestring
	mov eax, ebx
	call writedec
	mov edx, offset firstOccOutMsg3
	call writestring
	pop edx
	call writestring

	jmp End_It

End_It:
	
	pop ebx
	pop edx
	pop eax
	pop ecx
	pop esi
	ret

FindFirstOcc ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------
;FindNumOcc
;Recives:
;ESI = The array offset
;ECX = The size of the array
;Prints the number of occurances of a specified char
;----------------------------------------------------------------------------------------------------------------------------------------------

FindNumOcc PROC

.data
	
	FindNumOccAskMsg db 'Enter a character to determine the number of occurrences: ',13,10, 0
	FindNumOccMsg1 db 'The character ', 0
	FindNumOccMsg2 db ' appears ', 0
	FindNumOccMsg3 db ' times in the string: ', 0

.code

	push esi
	push ecx
	push eax
	push edx
	push ebx
	xor ebx, ebx
	push esi

	mov edx, offset findNumOccAskMsg
	call writestring
	call readchar

Loopin_Thru_The_Array:
	
	dec ecx
	cmp [esi], al
	je Inc_The_Counter
	jcxz All_Done
Go_Back:
	add esi, type byte
	jmp Loopin_Thru_The_Array

Inc_The_Counter:

	inc ebx
	jmp Go_Back

All_Done:
	
	mov edx, offset FindNumOccMsg1
	call writestring
	call writechar
	mov edx, offset FindNumOccMsg2
	call writestring
	mov eax, ebx
	call writedec
	mov edx, offset FindNumOccMsg3
	call writestring
	pop edx
	call writestring

	pop ebx
	pop edx
	pop eax
	pop ecx
	pop esi
	ret

FindNumOcc ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------
;FindStringLength
;Recives:
;ESI = The array offset
;ECX = The size of the array
;Prints the number size of the string
;----------------------------------------------------------------------------------------------------------------------------------------------

FindStringLength PROC

.data

	FindStringLengthMsg1 db 'There are ',0
	FindStringLengthMsg2 db ' total characters in the string: ',0

.code

	push esi
	push ecx
	push eax
	push edx
	push ebx
	xor ebx, ebx
	xor edx, edx
	push esi

Looping_Thru_The_Array:

	dec ecx
	jcxz All_Done
	cmp [esi], dl
	je All_Done
	inc ebx
	add esi, type byte
	jmp Looping_Thru_The_Array

All_Done:

	mov edx, offset FindStringLengthMsg1
	call writestring
	mov eax, ebx
	call writedec
	mov edx, offset FindStringLengthMsg2
	call writestring
	pop edx
	call writestring

	pop ebx
	pop edx
	pop eax
	pop ecx
	pop esi
	ret

FindStringLength ENDP

;----------------------------------------------------------------------------------------------------------------------------------------------
;FindStringAlNumLength
;Recives:
;ESI = The array offset
;ECX = The size of the array
;Prints the number size of alfanumaric characters in a string
;----------------------------------------------------------------------------------------------------------------------------------------------

FindStringAlNumLength PROC

.data

	FindStringAlNumLengthMsg1 db 'There are ',0
	FindStringAlNumLengthMsg2 db ' total alphanumeric characters in the string: ',0

.code

	push esi
	push ecx
	push eax
	push edx
	push ebx
	xor ebx, ebx
	push esi

Loopin_Thru_The_Array:

	dec ecx
	jcxz All_Done
	mov dl, 030h
	cmp [esi], dl
	jge Possible_Num

Continue:

	add esi, type byte
	jmp Loopin_Thru_The_Array

Possible_Num:

	mov dl,039h
	cmp [esi], dl
	jg Upper_Letter_Maybe
	inc ebx
	jmp Continue

Upper_Letter_Maybe:

	mov dl, 040h
	cmp [esi], dl
	jl Continue
	mov dl, 05Ah
	cmp [esi], dl
	jg Lower_Letter_Maybe
	inc ebx
	jmp Continue

Lower_Letter_Maybe:

	mov dl, 061h
	cmp [esi], dl
	jl Continue
	mov dl, 07Ah
	cmp [esi], dl
	jg Continue
	inc ebx
	jmp Continue

All_Done:

	mov edx, offset FindStringAlNumLengthMsg1
	call writestring
	mov eax, ebx
	call writedec
	mov edx, offset FindStringAlNumLengthMsg2
	call writestring
	pop edx
	call writestring

	pop ebx
	pop edx
	pop eax
	pop ecx
	pop esi
	ret

FindStringAlNumLength ENDP

END main