showDrawnCard MACRO carte, semn
	LOCAL showDrawnCard_normal, showDrawnCard_continue, print_inima, print_romb, print_frunza, print_trefla, print_final
	cmp ax, 10
	jne showDrawnCard_normal
	
	push semn
	push carte
	push offset formatNumar
	call printf
	add esp, 8
	pop semn
	jmp showDrawnCard_continue
	
	
	showDrawnCard_normal:
	push semn
	push carte
	push offset formatCaracter
	call printf
	add esp, 8
	pop semn
	
	showDrawnCard_continue:
	mov eax, semn
	cmp eax, 0
	je print_inima
	cmp eax, 1
	je print_romb
	cmp eax, 2
	je print_trefla
	cmp eax, 3
	je print_frunza
	
	print_inima:
	push offset inima
	push offset formatString
	call printf
	add esp, 8
	jmp print_final
	
	print_romb:
	push offset romb
	push offset formatString
	call printf
	add esp, 8
	jmp print_final
	
	print_trefla:
	push offset trefla
	push offset formatString
	call printf
	add esp, 8
	jmp print_final
	
	print_frunza:
	push offset frunza
	push offset formatString
	call printf
	add esp, 8
	jmp print_final
	
	
	
	print_final:
	
ENDM

showScore MACRO scor
	
	
	push eax
	mov eax, 0
	mov al, scor
	push eax
	push offset formatNumar
	call printf
	add esp,8
	pop eax
ENDM