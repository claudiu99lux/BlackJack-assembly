.586
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern scanf: proc
extern printf: proc
extern system: proc
include deck_control.inc
include menu.inc
include display.inc


public start


.data
deck DB 52 DUP(0)
shDeck DB 52 DUP(0) ;shuffledDeck
modulo DW 0
contor DW 0
menuChoice DB 0
cardNumber DB 0
pozitie DD 0
playerScore DB 0
aiScore DB 0

cards DB 2,3,4,5,6,7,8,9,10,11,12,13,14
msjBlackJack DB "____BLACKJACK____",10,10,0
formatString DB "%s",0;
formatCaracter DB "%c",0
formatNumar DB "%d",0
formatCaracterString DB "%c %s",0
instructiuni DB 10,"Alegeti optiunea:",10,0
optiune1start DB "1. Incepe jocul",10,0
optiune2start DB "2. Iesire",10,0
optiune1 DB "1. Draw",10,0
optiune2 DB "2. Stand",10,0
playerMsg DB 10,10,"Player: ",0
dealerMsg DB 10,10,"Dealer: ",0
scorDealer DB 10,"Scor dealer: ",0
scorPlayer DB 10,"Scor player: ",0
inima DB " Inima ",0
romb DB " Romb ",0
trefla DB " Trefla ",0
frunza DB " Frunza ",0
bust DB  10,10,">>>>>BUST!<<<<<",0
blackjack DB 10, 10, ">>>>>BLACKJACK!<<<<<",0
dealer_bust DB 10, ">>>>>DEALER BUST!<<<<<", 0
playerWin DB 10,10,10, ">>>>>Player WINS!<<<<<", 0
aiWin DB 10,10,10, ">>>>>Dealer WINS!<<<<<",0
msgDraw DB 10, "DRAW!", 0
newLine DB 10,10,10,0
cls DB "cls",0

	
.code

;pickedCard (cardNumber, cards, score) >  ecx=offset-ul cartii alese, eax=scor
pickedCard PROC
	push ebx
	push edx
	push esi
	
	push ebp
	mov ebp, esp
	sub esp, 12
	
	;corpul procedurii
	mov eax, [ebp+28] ;stocam la adresa [esp] cardNumber
	mov [esp],eax

	mov eax, [ebp+24] ;stocam la [esp+4] offset-ul lui cards
	mov [esp+4], eax
	
	mov eax, [ebp+20] ;stocam la [esp+8] offset scor
	mov [esp+8], eax
	mov edx, 0
	mov ecx, 0
	mov cx, 4
	mov eax, [ebp+28]
	div cx ;ax=cardNumber/4, dx=cardNumber%4
	
	
	add [esp+4], eax 
	mov eax, [esp+4]
	mov [esp+12], eax ;[esp+12]=offset card + ax > offset-ul cartii alese
	
	pickedCard_value:
	mov ebx, [esp+12]
	mov ecx, [ebx]
	cmp cl, 11
	jl pickedCard_scorNormal
	cmp cl, 11
	jg pickedCard_scor10
	cmp cl, 11
	je pickedCard_scor11
	
	pickedCard_scorNormal:
	mov ebx, [esp+8]
	mov eax, [ebx]
	add eax, ecx
	jmp pickedCard_iesire
	
	pickedCard_scor10:
	mov ebx, [esp+8]
	mov eax, [ebx]
	add eax, 10
	jmp pickedCard_iesire
	
	pickedCard_scor11:
	mov ebx, [esp+8]
	mov eax, [ebx]
	add eax, 11
	
	
	pickedCard_iesire:
	mov ecx, [esp+12]
	
	mov esp, ebp
	pop ebp
	
	pop esi
	pop edx
	pop ebx
	ret 12
	
pickedCard ENDP


;cardLabel (cardNumber, pickedCard ) >  ecx=semn, eax=label
cardLabel PROC
	push ebx
	push edx
	push esi
	
	push ebp
	mov ebp, esp
	sub esp, 4
	
	;corpul procedurii
	mov eax, [ebp+24] ;stocam la adresa [esp] cardNumber
	mov [esp],eax
	mov eax, [ebp+20] ;stocam la adresa [esp+4] offset pickedCard
	mov [esp+4],eax
	
	mov edx, 0
	mov eax, [esp] ; calcul semn
	mov cx, 4
	div cx
	mov ecx, 0
	mov cx, dx
	
	cardLabel_label:
	mov ebx, [esp+4]
	mov eax, [ebx]
	mov ebx, eax
	cmp bl, 10
	jl cardLabel_normal
	cmp bl, 10
	je cardLabel_10
	cmp bl, 11
	je cardLabel_A 
	cmp bl, 12
	je cardLabel_J 
	cmp bl, 13
	je cardLabel_Q 
	cmp bl, 14
	je cardLabel_K  
	
	cardLabel_normal:
	mov eax, 48
	add eax, ebx
	jmp cardLabel_iesire
	
	cardLabel_10:
	mov eax, 10
	jmp cardLabel_iesire
	
	cardLabel_A:
	mov eax, 'A'
	jmp cardLabel_iesire
	
	cardLabel_J:
	mov eax, 'J'
	jmp cardLabel_iesire
	
	cardLabel_Q:
	mov eax, 'Q'
	jmp cardLabel_iesire
	
	cardLabel_K:
	mov eax, 'K'
	jmp cardLabel_iesire
	
	cardLabel_iesire:
	mov esp, ebp
	pop ebp
	
	pop esi
	pop edx
	pop ebx
	ret 8
	
cardLabel ENDP

start:
	;mesaj BlackJack initial
	showBlackJack
	;meniu
	showMenu
	;Preluare comanda + executie
	getMenuChoice
	
	start_game:
	push offset cls
	call system
	;initializam pachetul
	initDeck deck
	initDeck shDeck
	shuffleDeck
	mov esi, 0
	
    ;;;;;;;;;;;;;;;;;FIRST PICKS DEALER;;;;;;;;;;;;;;;;;;;
	;tragem prima carte dealer
	drawCard pozitie
	push offset dealerMsg
	push offset formatString
	call printf
	add esp,8
	
	;calcul carte si scor ai
	mov eax,0
	mov al, cardNumber
	push eax
	push offset cards
	push offset aiScore
	call pickedCard
	mov aiScore, al
	
	mov eax,0
	mov al, cardNumber
	push eax
	push ecx
	call cardLabel
	
	;afisare carte
	mov bx, ax
	mov eax, 0
	mov ax, bx
	showDrawnCard eax, ecx
	;afisare scor
	push offset scorDealer
	push offset formatString
	call printf 
	add esp, 8
	showScore aiScore
	
	;tragem a doua carte dealer
	drawCard pozitie
	push offset dealerMsg
	push offset formatString
	call printf
	add esp,8
	
	;calcul carte si scor ai
	mov eax,0
	mov al, cardNumber
	push eax
	push offset cards
	push offset aiScore
	call pickedCard
	mov aiScore, al
	
	mov eax,0
	mov al, cardNumber
	push eax
	push ecx
	call cardLabel
	
	;afisare carte
	mov bx, ax
	mov eax, 0
	mov ax, bx
	showDrawnCard eax, ecx
	;afisare scor
	push offset scorDealer
	push offset formatString
	call printf 
	add esp, 8
	showScore aiScore
	
	;;;;;;;;;;;;;;;;;;;;;;;PLAYER;;;;;;;;;;;;;;;;;;;;;
	;draw card player
	player_drawCard:
	drawCard pozitie
	push offset playerMsg
	push offset formatString
	call printf
	add esp,8
	
	;calcul carte si scor 
	mov eax,0
	mov al, cardNumber
	push eax
	push offset cards
	push offset playerScore
	call pickedCard
	mov playerScore, al
	
	
	mov eax,0
	mov al, cardNumber
	push eax
	push ecx
	call cardLabel
	
	mov bx, ax
	mov eax, 0
	mov ax, bx
	showDrawnCard eax, ecx
	
	push offset scorPlayer
	push offset formatString
	call printf 
	add esp, 8
	showScore playerScore
	
	mov al, playerScore
	cmp al, 21
	jg player_bust
	cmp al, 21
	je player_Blackjack
	
	;Intreaba daca player doreste draw sau stand
	showChoiceMenu
	getControlChoice
	
	player_stand:
	mov al, 21
	cmp playerScore, al
	jg player_bust
	cmp playerScore, al
	je player_Blackjack
	cmp playerScore, al
	jl player_continueDealer
	
	player_bust:
	push offset bust
	push offset formatString
	call printf
	add esp, 8
	jmp iesire
	
	player_Blackjack:
	push offset blackjack
	push offset formatString
	call printf
	add esp, 8
	jmp iesire
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;DECIZII DEALER DUPA CE PLAYER A ALES STAND;;;;;;;;;;;;;;;;;;;;;;;
	player_continueDealer:
	push eax
	mov eax, 17
	cmp aiScore, al
	jge compare_scores
	jmp dealer_draw
	pop eax
	
	dealer_draw:
	drawCard pozitie
	push offset dealerMsg
	push offset formatString
	call printf
	add esp,8
	
	mov eax,0
	mov al, cardNumber
	push eax
	push offset cards
	push offset aiScore
	call pickedCard
	mov aiScore, al
	
	mov eax,0
	mov al, cardNumber
	push eax
	push ecx
	call cardLabel
	
	mov bx, ax
	mov eax, 0
	mov ax, bx
	showDrawnCard eax, ecx
	
	push offset scorDealer
	push offset formatString
	call printf 
	add esp, 8
	showScore aiScore
	mov al, 21
	cmp aiScore, al
	jg dealerBust
	jmp player_continueDealer
	
	dealerBust:
	push offset dealer_bust
	push offset formatString
	call printf 
	add esp, 8
	
	;;;;;;;;;;;;;;;;;;;;;;;;;DACA NICI PLAYER NICI DEALER NU AU TRECUT DE 21;;;;;;;;;;;;;;;;;;;;;;;
	compare_scores:
	mov al, aiScore
	cmp playerScore, al
	jg result_playerWin
	cmp playerScore, al
	je result_Draw
	cmp playerScore, al
	jl result_dealerWin
	
	result_playerWin:
	push offset playerWin
	push offset formatString
	call printf 
	add esp, 8
	jmp iesire
	
	result_dealerWin:
	push offset aiWin
	push offset formatString
	call printf 
	add esp, 8
	jmp iesire
	
	result_Draw:
	push offset msgDraw
	push offset formatString
	call printf 
	add esp, 8
	
	
	
	;apel functie exit
	iesire:
	push 0
	call exit
end start