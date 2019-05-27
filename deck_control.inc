initDeck MACRO deckVar    ;initializam pachetul
	LOCAL initializare
	push esi
	push eax
	mov esi, 0
	
	initializare:
		mov eax, esi
		mov deckVar[esi], al
		inc esi
		cmp esi, 52
		jl initializare
	pop eax
	pop esi
ENDM

shuffleDeck MACRO ;amestecam pachetul
	LOCAL shuffle
	push eax
	push edx
	push ebx
	push ecx
	push esi
	mov esi, 0
	mov cx, 51
	mov contor, cx ;parcurgem pachetul
	
	shuffle:
		rdtsc
		inc contor
		mov edx, 0
		div contor
		dec contor
		mov modulo, dx ;modulo=random%(contor+1)
		mov edx, 0
		mov si, contor
		mov cl, shDeck[esi] ;interschimbam valorile dintre shDeck[modulo] si shDeck[contor]
		mov si, modulo
		mov dl, shDeck[esi]
		mov si, contor
		mov shDeck[esi], dl
		mov si, modulo
		mov shDeck[esi], cl
		dec contor
		cmp contor, 0
		jg shuffle
	
	pop esi
	pop ecx
	pop ebx
	pop edx
	pop eax
ENDM
	
drawCard MACRO pozitie
	push eax
	push edx
	push ebx
	push ecx
	

	mov eax, 0
	;mov esi, pozitie
	mov al, shDeck[esi]
	mov cardNumber, al
	inc esi
	;mov pozitie, esi
	
	
	pop ecx
	pop ebx
	pop edx
	pop eax
ENDM


