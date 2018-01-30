TITLE FireCrossing.asm

; jogo Fire Crossing

INCLUDE Irvine32.inc

.CONST

; ******* constantes do jogo *******

prnc1 DB "    _     "  		, 0
prnc2 DB "  ;|_|; /"			, 0
prnc3 DB "   /@|_/ " 		, 0
prnc4 DB "   | |     "		, 0

limpa1 DB "           "  		, 0
limpa2 DB "           "			, 0
limpa3 DB "            " 		, 0
limpa4 DB "            "		, 0

fball1 DB " @@                            @@                      @@               "				, 0
fball2 DB "@@@@                          @@@@                    @@@@              "			, 0
fball3 DB " @@                            @@                      @@              "				, 0


.DATA

;******* aqui irão todas as variaveis *******

mapa00 BYTE "}~|                                                                      |~{", 0
mapa01 BYTE "}~|                                                                      |~{", 0
mapa02 BYTE "}~|                                                                      |~{", 0
mapa03 BYTE "}~|                                                                      |~{", 0
mapa04 BYTE "}~|                                                                      |~{", 0
mapa05 BYTE "}~|                                                                      |~{", 0
mapa06 BYTE "}~|                                                                      |~{", 0
mapa07 BYTE "}~|                                                                      |~{", 0
mapa08 BYTE "}~|                                                                      |~{", 0
mapa09 BYTE "}~|                                                                      |~{", 0                                                          
mapa10 BYTE "}~|                                                                      |~{", 0                                                 
mapa11 BYTE "}~|                                                                      |~{", 0                                                        
mapa12 BYTE "}~|                                                                      |~{", 0                                                     
mapa13 BYTE "}~|                                                                      |~{", 0                                                       
mapa14 BYTE "}~|                                                                      |~{", 0                                                       
mapa15 BYTE "}~|                                                                      |~{", 0                                                        
mapa16 BYTE "}~|                                                                      |~{", 0
mapa17 BYTE "}~|                                                                      |~{", 0                                                       
mapa18 BYTE "}~|                                                                      |~{", 0
mapa19 BYTE "}~|                                                                      |~{", 0
mapa20 BYTE "}~|                                                                      |~{", 0
mapa21 BYTE "}~|                                                                      |~{", 0
mapa22 BYTE "}~|                                                                      |~{", 0
mapa23 BYTE "}~|                                                                      |~{", 0
mapa24 BYTE "}~|                                                                      |~{", 0
mapa25 BYTE "}~|                                                                      |~{", 0
mapa26 BYTE "}~|                                                                      |~{", 0
mapa27 BYTE "}~|                                                                      |~{", 0
mapa28 BYTE "}~|                                                                      |~{", 0
mapa29 BYTE "}~|                                                                      |~{", 0
mapa30 BYTE "}~|                                                                      |~{", 0
mapa31 BYTE "}~|                                                                      |~{", 0
mapa32 BYTE "}~|                                                                      |~{", 0
mapa33 BYTE "}~|                                                                      |~{", 0
mapa34 BYTE "}~|                                                                      |~{", 0

;frameBuffer WORD 1920 DUP(0)		; framebuffer (50x80)

gameGrid BYTE 50*80 dup(020h)

pLin BYTE 50d						; linhas da princesa
pCol BYTE 40d						; colunas da princesa

mRight BYTE 'd'
mLeft BYTE 'a'
mUp BYTE 'w'
mDown BYTE 's'

varClock BYTE 50
clkFireball BYTE 0

posP BYTE 0
tempPos BYTE 0



tempLin BYTE 0						; variavel temporaria para guardar o index das linhas	
tempCol BYTE 0						; variavel temporaria para guardar o index das colunas

linB BYTE 0d						; index da linha acima da atual
linC BYTE 0d						; index da linha abaixo da atual
colE BYTE 0d						; index da coluna a esquerda da atual
colD BYTE 0d						; index da colunda a direita da atual

tempLinF BYTE 0
tempColF BYTE 0

colisaoP BYTE 0d					; flag para indicar o fim do jogo (colisao)

;posAtual BYTE 'w'							; variavel que guarda a posicao atual da princesa
;posNova BYTE 'w'							; variavel que guarda a proxima posicao indicada pelo input
delayFrame	DWORD 100				; delay entre os frames

;inputTerminal DWORD ?				; variavel que guarda o input pelo terminal
;numInput DWORD ?					; variavel que guarda o numero de bytes do buffer de input
;tipoInput BYTE 16 DUP(?)			; variavel que guarda dados do tipo INPUT_RECORD
;bRead DWORD ?						; não sei se vou usar ainda

; strings do menu

;menuString BYTE "1. Novo Jogo", 0Dh, 0Ah, "2. Como Jogar", 0Dh, 0Ah, "3. Sair", 0Dh, 0Ah, 0

menu01 BYTE	"            _        _      _      _    _     _     _    _             _        ", 0
menu02 BYTE	"           |_    |  |_|    |_     |    |_|   | |   |_   |_   |   |\ | |_      ", 0
menu03 BYTE	"           |     |  |  \   |_     |_   |  \  |_|    _|   _|  |   | \| |_|      ", 0
menu04 BYTE	"                                                                                              ",  0
menu05 BYTE	"                                    1. Novo Jogo                                    ",  0
menu06 BYTE	"                                    2. Como Jogar                                  ",  0
menu07 BYTE	"                                    3. Sair                                             ",  0


; string de nivel e game over

colisaoString BYTE "Game Over!", 0


instrString01 BYTE "      Movimente a princesa utilizando as teclas WASD do teclado e desvie das bolas de fogo na tela.", 0
instrString02 BYTE "      Voce precisa chegar ate o outro lado para passar de nivel.                                                     ",  0
instrString03 BYTE "      Selecione 1 para voltar ao menu principal.                                                                            ", 0

.CODE

main PROC

; ******* os procedimentos do main printam na tela o menu, e startam o jogo *******

	menu:
	CALL Randomize														; procedimento para randomizar as bolas de fogo
	CALL Clrscr																; limpa a tela
	CALL Crlf
	MOV edx, OFFSET menu01 										; ponteiro do menu para o edx
	CALL WriteString														; escreve o que está em edx na tela
	
	CALL Crlf
	MOV edx, OFFSET menu02
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET menu03
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET menu04
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET menu05
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET menu06
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET menu07
	CALL WriteString
	
	escolha1:												; loop que le a escolha do jogador
	CALL ReadChar										; coloca o caracter escolhido em al
	
	CMP al, '1'											; novo jogo selecionado
	JE startJ						
	
	
	CMP al, '2'											; como jogar selecionado
	JE inst
	
	CMP al, '3'											; volta ao loop de escolha caso nenhum caracter valido
	JNE escolha1											; for escolhido
																; caso contrario, fecha o programa
	EXIT
	
	
	inst: 													; mostra as instrucoes ao jogador
	CALL Clrscr
	CALL Crlf
	MOV edx, OFFSET instrString01					; coloca as instrucoes em edx
	CALL WriteString									; printa elas na tela	
	
	CALL Crlf
	MOV	edx, OFFSET instrString02
	CALL WriteString
	
	CALL Crlf
	MOV edx, OFFSET instrString03 			; oferece a opcao de voltar ao menu	
	CALL WriteString				
	
	escolha2:
	CALL ReadChar	
	
	CMP al, '1'								; selecionado 1, volta ao menu
	JE menu
	
	jmp escolha2							; escolha invalida, volta ao loop
	
	startJ:												; seta as flags necessarias e chama
															; o loop principal
	MOV eax, 0										; limpa o registrador
	MOV edx, 0
	
	CALL Clrscr
;	CALL initPrincesa						; coloca a princesa na posicao inicial
;	CALL genFireballs						; gera as bolas de fogo
	CALL startJogo							; chama o loop do jogo
	JMP menu									; volta ao menu
	

startJogo:

	CALL Clrscr
	CALL drawGame
	CALL genF1
	CALL initPrincesa

	
	gameLoop:
			
	CALL movP

	jmp gameLoop

	
	gameOver:

	
	

main ENDP

initPrincesa PROC USES edx

; ******* esse procedimento inicializa a princesa para a posicao padrao *******

	MOV dh, 29									; escolhe a linha de numero 1
	MOV dl, 38									; escolhe a coluna de numero 40
	MOV posP, 0
	CALL saveIndex
	CALL drawP									; desenha a princesa na posição

	
	RET

initPrincesa ENDP

;*******************************************************************
;
;									DESENHA PRINCESA 
;
;******************************************************************	


drawP PROC USES eax edx 

	MOV eax, yellow
	CALL SetTextColor
	
	CMP posP, 0
	JE draw
	
	CMP posP, 1
	JE p1
	
	CMP posP, 2
	JE p2
	
	CMP posP, 3
	JE p3
	
	CMP posP, 4
	JE p4
	
	CMP posP, 5
	JE p5
	
	CMP posP, 6
	JE p6
	
	CMP posP, 7
	JE p7
	
	CMP posP, 8
	JE p8
	
	CMP posP, 9
	JE p9
	
	CMP posP, 10
	JE p10
	
	CMP posP, 11
	JE p11
	
	CMP posP, 12
	JE p12
	
	CMP posP, 13
	JE p13
	
	CMP posP, 14
	JE p14
	
	CMP posP, 15
	JE p15
	
	CMP posP, 16
	JE p16
	
	
	
	p1:
	
	MOV dh, 23
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p2:
	
	MOV dh, 23
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p3:
	
	MOV dh, 23
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p4:
	
	MOV dh, 23
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p5:
	
	MOV dh, 17
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p6:
	
	MOV dh, 17
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p7:
	
	MOV dh, 17
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p8:
	
	MOV dh, 17
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p9:
	
	MOV dh, 11
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p10:
	
	MOV dh, 11
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p11:
	
	MOV dh, 11
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p12:
	
	MOV dh, 11
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p13:
	
	MOV dh, 5
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p14:
	
	MOV dh, 5
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p15:
	
	MOV dh, 5
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p16:
	
	MOV dh, 5
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	draw:
	
	CALL Gotoxy
	MOV edx, OFFSET prnc1
	CALL WriteString	
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET prnc2
	CALL WriteString	
	CALL getIndex
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET prnc3
	CALL WriteString	
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET prnc4
	CALL WriteString
	
	
	ret
	
drawP ENDP

;*******************************************************************
;
;									MOVE PRINCESA 
;
;******************************************************************	
	
movP PROC USES ebx 

	
	procuraKey:
		
		MOV eax, 50
		CALL Delay
		CALL ReadKey
		JZ procuraKey
		
	
	CMP al, 'a'
	JE esq
	
	CMP al, 'd'
	JE dir
	
	CMP al, 's'
	JE down
	
	CMP al, 'w'
	JNE procuraKey
	
	up:
		CMP posP, 0
		JE inicial
		CALL getIndex
		CMP posP, 13
		JE endKey
		
		CMP posP, 14
		JE endKey	
		
		CMP posP, 16
		JE endKey
		
		MOV bl, posP
		MOV tempPos, bl
		ADD posP, 4
		CALL limpaP
		CALL drawP
		JMP endKey
		
	esq:
		CMP posP, 0
		JE endKey
		
		CALL getIndex
		CMP dl, 6
		JE endKey
		
		MOV bl, posP
		MOV tempPos, bl
		DEC posP
		CALL limpaP
		CALL drawP
		JMP endKey
		
	dir:
		CMP posP, 0
		JE endKey
		
		CALL getIndex
		CMP dl, 54
		JE endKey
		
		MOV bl, posP
		MOV tempPos, bl
		INC posP
		CALL limpaP
		CALL drawP
		JMP endKey
		
	inicial:
	
		MOV posP, 3
		MOV tempPos, 0
		CALL limpaP
		CALL drawP
		JMP endKey
		
	down:
		CMP posP, 0
		JE endKey
		
		CALL getIndex
		
		CMP posP, 1
		JE endKey
		
		CMP posP, 2
		JE endKey	
		
		CMP posP, 3
		JE endKey
		
		CMP posP, 4
		JE endKey
		
		MOV bl, posP
		MOV tempPos, bl
		SUB posP, 4
		CALL limpaP
		CALL drawP

		
	endKey:
		ret
		
		
		
	
movP ENDP

saveIndex PROC

; ******************************************************************
;
;										SALVA O INDEX DA POSICAO 
;
; *******************************************************************
	MOV tempLin, dh
	MOV tempCol, dl
	
	ret

saveIndex ENDP 

saveIndexF PROC

	MOV tempLinF, dh
	MOV tempColF, dl
	
	RET

saveIndexF ENDP

getIndex PROC
; ******************************************************************
;
;										RETORNA O INDEX DA POSICAO 
;
; *******************************************************************
	
	MOV dh, tempLin
	MOV dl, tempCol
	
	RET

getIndex ENDP


getIndexF PROC

	MOV dh, tempLinF
	MOV dl, tempColF
	 
	RET
	
getIndexF ENDP

drawGame PROC

; ******************************************************************
;
;										DESENHA O MAPA
;
; *******************************************************************

	XOR ecx, ecx
	CALL Clrscr
	
	MOV eax, gray
	CALL SetTextColor
	
	MOV edx, OFFSET mapa01
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa02
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa03
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa04
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa05
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa06
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa07
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa08
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa09
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa10
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa11
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa12
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa13
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa14
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa15
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa16
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa17
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa18
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa19
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa20
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa21
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa22
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa23
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa24
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa25
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa25
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa26
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa27
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa28
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa29
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa30
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa31
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa32
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa33
	CALL WriteString
	CALL Crlf
	
	MOV edx, OFFSET mapa34
	CALL WriteString
	CALL Crlf
	
	ret

drawGame ENDP

limpaP PROC

; ******************************************************************
;
;										LIMPA A TELA DA POSICAO 
;
; *******************************************************************
	
	MOV dh, 29									
	MOV dl, 38
	CALL saveIndex
	CMP tempPos, 0
	JE draw
	
	CMP tempPos, 1
	JE p1
	
	CMP tempPos, 2
	JE p2
	
	CMP tempPos, 3
	JE p3
	
	CMP tempPos, 4
	JE p4
	
	CMP tempPos, 5
	JE p5
	
	CMP tempPos, 6
	JE p6
	
	CMP tempPos, 7
	JE p7
	
	CMP tempPos, 8
	JE p8
	
	CMP tempPos, 9
	JE p9
	
	CMP tempPos, 10
	JE p10
	
	CMP tempPos, 11
	JE p11
	
	CMP tempPos, 12
	JE p12
	
	CMP tempPos, 13
	JE p13
	
	CMP tempPos, 14
	JE p14
	
	CMP tempPos, 15
	JE p15
	
	CMP tempPos, 16
	JE p16
	
	
	
	p1:
	
	MOV dh, 23
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p2:
	
	MOV dh, 23
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p3:
	
	MOV dh, 23
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p4:
	
	MOV dh, 23
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p5:
	
	MOV dh, 17
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p6:
	
	MOV dh, 17
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p7:
	
	MOV dh, 17
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p8:
	
	MOV dh, 17
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p9:
	
	MOV dh, 11
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p10:
	
	MOV dh, 11
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p11:
	
	MOV dh, 11
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p12:
	
	MOV dh, 11
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	p13:
	
	MOV dh, 5
	MOV dl, 6
	CALL saveIndex
	JMP draw
	
	p14:
	
	MOV dh, 5
	MOV dl, 22
	CALL saveIndex
	JMP draw
	
	p15:
	
	MOV dh, 5
	MOV dl, 38
	CALL saveIndex
	JMP draw
	
	p16:
	
	MOV dh, 5
	MOV dl, 54
	CALL saveIndex
	JMP draw
	
	draw:
	
	CALL Gotoxy
	MOV edx, OFFSET limpa1
	CALL WriteString	
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET limpa2
	CALL WriteString	
	CALL getIndex
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET limpa3
	CALL WriteString	
	CALL getIndex
	INC dh
	CALL saveIndex
	CALL Gotoxy
	
	MOV edx, OFFSET limpa4
	CALL WriteString
	
	
	ret

limpaP ENDP

genF1 PROC

	MOV dh, 23
	MOV dl, 4
	CALL saveIndexF
	CALL drawFireball 

	RET
		
genF1 ENDP 

drawFireball PROC


	MOV eax, red
	CALL SetTextColor

	CALL getIndexF
	CALL Gotoxy
	CALL saveIndexF
	MOV edx, OFFSET fball1
	
	CALL WriteString	
	CALL getIndexF
	INC dh
	CALL saveIndexF
	CALL Gotoxy
	
	MOV edx, OFFSET fball2
	CALL WriteString	
	CALL getIndexF
	CALL getIndexF
	INC dh
	CALL saveIndexF
	CALL Gotoxy
	
	MOV edx, OFFSET fball3
	CALL WriteString	
	CALL getIndexF
	INC dh
	CALL saveIndexF
	CALL Gotoxy
	
drawFireball ENDP


END main













