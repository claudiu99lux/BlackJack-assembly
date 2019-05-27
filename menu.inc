showMenu MACRO 
	push offset instructiuni
	push offset formatString
	call printf
	add esp,8
	
	push offset optiune1start
	push offset formatString
	call printf
	add esp,8
	
	push offset optiune2start
	push offset formatString
	call printf
	add esp,8
ENDM

showBlackJack MACRO
	push offset msjBlackJack
	push offset formatString
	call printf
	add esp,8
ENDM

getMenuChoice MACRO
	push offset menuChoice
	push offset formatNumar
	call scanf
	add esp, 8
	
	mov eax, 0
	mov al, menuChoice
	
	cmp al, 1
	je start_game
	jmp iesire
ENDM

showChoiceMenu MACRO
	push offset instructiuni
	push offset formatString
	call printf
	add esp,8
	
	push offset optiune1
	push offset formatString
	call printf
	add esp,8
	
	push offset optiune2
	push offset formatString
	call printf
	add esp,8
ENDM

getControlChoice MACRO
	push offset menuChoice
	push offset formatNumar
	call scanf
	add esp, 8
	
	mov eax, 0
	mov al, menuChoice
	
	cmp al, 1
	je player_drawCard
	jmp player_stand
ENDM