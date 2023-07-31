.8086
.model small
.stack 100h

.data
		mControles db "presiona 1 para jugar contra la pc",0dh,0ah 
                   db "presiona 2 pra jugar de a 2 jugadores ",0dh,0ah,24h
		instrucj1 db 'jugador1:Recargar (Z), Disparar (X), Defenderse (C)',0dh,0ah,'$'
		instrucj2 db 'jugador2:Recargar (J), Disparar (K), Defenderse (L)',0dh,0ah,'$'
		mYa db '!Ya!',0dh,0ah, 24h
		mjugador1 db "jugador 1 ha ganado",0dh,0ah,24h
		mjugador2 db "jugador 2 ha ganado",0dh,0ah,24h
        mIA db "La IA ha ganado",0dh,0ah,24h
		mContador1 db "!1!", 0dh,0ah,24h
		mContador2 db "!2!", 0dh,0ah,24h
		mContador3 db "!3!", 0dh,0ah,24h
		control db '!ESTO ES UN TEXTO DE CONTROL!', 0dh,0ah,24h
		mempate db "!!! EMPATE SIGUENTE RONDA !!!",0dh,0ah,24h
		teclaInvalida db "TECLA INGRESADA INCORRECTA. VUELVE A COMENZAR EL TURNO",0dh,0ah,24h
		disparoSinBalasJ1 db "jugador 1 disparo sin balas",0dh,0ah,24h
		disparoSinBalasJ2 db "jugador 2 disparo sin balas",0dh,0ah,24h
        disparoSinBalasIA db "La pc disparo sin balas",0dh,0ah,24h
        nroRandom db 255 dup(24h),24h
        opcionDeMaquinaR db "La pc eligio la opcion: Recargar",0dh,0ah,24h
        opcionDeMaquinaD db "La pc eligio la opcion: Disparar",0dh,0ah,24h
        opcionDeMaquinaC db "La pc eligio la opcion: Defenderse",0dh,0ah,24h
		rta db 225 dup(24h),24h
        archivo db 'duelo1.bmp',0
		empa db 'empa.bmp',0
		perdio db 'perdio.bmp',0
		archivoFinal db 'cowboy.bmp',0
        salto db 0dh,0ah,24h
.code
    extrn bmp:proc    
	
	main proc
	mov ax, @data
	mov ds, ax

	
	
	menu:
    ; Limpia pantalla 
    mov ax, 3
    int 10h

    lea bx,archivo
    push bx
    call bmp

    mov si, 0      ; Balas del jugador 1
    mov bx, 0      ; Balas del jugador 2

    mov ah, 9    ; Imprimir mensaje de modo de juego
    mov dx, offset mControles
    int 21h
	
    mov ah, 9    ; Imprimir salto
    mov dx, offset salto
    int 21h

	mov ah, 9   ; Imprimir mensaje de controles j1
    mov dx, offset instrucj1
    int 21h

	mov ah, 9   ; Imprimir mensaje de controles j2
    mov dx, offset instrucj2
    int 21h
    ; Esperar hasta que se presione la tedia "1" para comenzar el juego
    esperarInicio:
    mov ah, 1 ;  ah,8 serivicio 8 pido caracteres sin ECO
    int 21h		;para que no se vea la opcion elejida

    mov ah, 9    ; Imprimir salto
    mov dx, offset salto
    int 21h

    cmp al, '1'
	je opcionVsia
	
	 
	cmp al, '2'
	je comienza
    jne esperarInicio
	
	opcionVsia:
        jmp comienzaVsIA
	; puntero para las resputas
	
	
	comienza:
	call espera
	call espera
	call espera

	lea bx,empa
    push bx
    call bmp
    mov di, 0		;contador necesario
    mov ah, 9   ; Imprimir m de contador (3)
    mov dx, offset mContador3
    int 21h
	
	call espera  ;tiempo de espera
    mov ah, 9    ; Imprimir m de contador (2)
    mov dx, offset mContador2
    int 21h
	
	call espera
	
    mov ah, 9    ; Imprimir m de contador (1)
    mov dx, offset mContador1
    int 21h
	
	call espera
	

    mov ah, 9    ; Imprimir m de "Ya!"
    mov dx, offset mYa
    int 21h



    ; Logica del juego
 
  	
	mov ah, 8 ;  ah,8 serivicio 8 pido caracteres sin ECO   
    int 21h
	
	mov rta[di],al
	
	mov ah, 8  
    int 21h
	mov rta[di+1],al
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;por aca abria que reemplazar la logica para jugar contra la pc
	;con la funcion random, para que elejija entre j , k, l
	;todavia no hay control de error
	
	;ops j1. verifico quien presiono primero su opcion (y verifico si presiono una opcion correcta) 
	;y luego salto a verificar si el otro jugador presiono correctamente su opcion, para luego entrar a la logica del juego

	cmp rta[di],'z' ;opcion para que el jugador 1 recargue primero
	je j1PrimeroControl

	cmp rta[di],'x' ;opcion para que el jugador 1  dispare primero
	je j1PrimeroControl

	cmp rta[di],'c' ;opcion para que el jugador 1 se defienda primero
	je j1PrimeroControl

	;ops j2
	cmp rta[di],'j' ;opcion para que el jugador 2 recargue primero
	je j2PrimeroControl

	cmp rta[di],'k' ;opcion para que el jugador 2 dispare primero
	je j2PrimeroControl

	cmp rta[di],'l' ;opcion para que el jugador 2 se defienda primero
	je j2PrimeroControl	

	;Si la primera tecla presionada no pertenece a ningun jugador, se muestra un error y vuelve a empezar el turno

	mov ah, 9    ; Imprimir m de "Ya!"
    mov dx, offset teclaInvalida
    int 21h
	
	jmp comienza

	;Si  el jugador 1 presiono primero y correctamente, se verifica que el jugador 2 haya presionado correctamente su opcion
	j1PrimeroControl:
	cmp rta[di+1],'j' ;opcion para que el jugador 2 recargue segundo
	je jugador1p
	cmp rta[di+1],'k' ;opcion para que el jugador 2 dispare segundo
	je jugador1p
	cmp rta[di+1],'l' ;opcion para que el jugador 2 se defienda segundo
	je jugador1p

	;Si la primera tecla presionada corresponde al jugador 1 y la segunda no pertenece al jugador 2, se muestra un error y vuelve a empezar el turno

	mov ah, 9    ; Imprimir m de "Ya!"
    mov dx, offset teclaInvalida
    int 21h
	
	jmp comienza

	;Si el jugador 2 presiono primero y correctamente, se verifica que el jugador 1 haya presionado correctamente su opcion
	j2PrimeroControl:
	cmp rta[di+1],'z' ;opcion para que el jugador 1 recargue segundo
	je jugador2p
	cmp rta[di+1],'x' ;opcion para que el jugador 1 dispare segundo
	je jugador2p
	cmp rta[di+1],'c' ;opcion para que el jugador 1 se defienda segundo
	je jugador2p

	;Si la primera tecla presionada corresponde al jugador 2 y la segunda no pertenece al jugador 1, se muestra un error y vuelve a empezar el turno
	mov ah, 9    ; Imprimir m de "Ya!"
    mov dx, offset teclaInvalida
    int 21h
	jmp comienza

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	jugador2p:
		jmp jugador2pLogica ;tuve que agregar un salto intermedio porque si no me daba error "Relative jump out of range by (una cantidad dependiendo que tan lejos estaba) de bytes"
    
	;Recargar (Z), Disparar (X), Defenderse (C) j1
	;Recargar (J), Disparar (K), Defenderse (L) j2
	;mov si, 0      ; Balas del jugador 1
    ;mov bx, 0      ; Balas del jugador 2
	
	;salta a la logica correspondiente a si el j1 presiono su opcion primero

    jugador1p:
	cmp rta[di],'z'
	je logicarecarga 
	cmp rta[di],'x'
	je logicadisparo
	cmp rta[di],'c'
	je logicadefensa

logicarecarga:
	inc si   ;se le suma una bala al j1
	cmp rta[di+1],'j'	;compara par ver si el j2 esta recargando
	je balabx
	cmp rta[di+1],'k'	;compara par ver si el j2 esta disparando
	je chequeoBalasJ1recJ2disp ;evito error
	cmp rta[di+1],'l'	;compara par ver si el j2 se esta defendiendo
	jmp empate

	balabx:
		inc bx ;como los 2 recargan, a ambos se le suma una bala y empatan
		jmp empate
	
	chequeoBalasJ1recJ2disp: ;cheque primero si el j2 tiene balas cuando j1 recarga
		cmp bx, 0
		je nobalaj2
		jmp jugador2Gana; si bx es distinto de 0 gana el j2 porque el j1 esta recargando
logicadisparo:
	cmp rta[di+1],'j' ;condicion de victoria j1 dispara, j2 recargando
	je	chequeoBalasJ1dispJ2rec
	cmp rta[di+1],'k' ;ambos disparan
	je	chequeoBalasJ1dispJ2disp
	cmp rta[di+1],'l' ;j2 se defiende
	je	J1dispJ2def
	

	chequeoBalasJ1dispJ2rec:
		cmp si, 0
		je nobalaj1 ;salta a emitir mensaje y luego a empate
		dec si
		jmp jugador1Gana ;gana jugador 1 porque el j2 esta recargando
	
	chequeoBalasJ1dispJ2disp:
		cmp si, 0
		je nobalaj1ChequeoJ2; si no tiene balas j1 chequeo si j2 tiene balas
		jmp jugador1Gana ;si el j1 tiene balas, gana el j1 porque disparo primero

		nobalaj1ChequeoJ2:
			cmp bx,0
			je sinbalaslos2
			jmp jugador2Gana ;si j2 tiene al menos 1 bala gana porque el j1 no tenia balas al disparar
		sinbalaslos2:
			mov ah, 9    ; Imprimir que el j1 no tenia balas al disparar y luego salta a empate, porque el j2 tampoco tenia balas
			mov dx, offset disparoSinBalasJ1
			int 21h

			mov ah, 9    ; Imprimir que el j2 no tenia balas al disparar y luego salta a empate, porque el j1 tampoco tenia balas
			mov dx, offset disparoSinBalasJ2
			int 21h

			jmp empate
	J1dispJ2def: 		;j2 se defiende, si j1 no tiene balas no pasa nada(empate) y si j1 tiene balas se le resta 1 y empatan
		cmp si, 0
		je nobalaj1
		dec si
		jmp empate

	nobalaj1:
			mov ah, 9    ; Imprimir que el j1 no tenia balas al disparar y luego salta a empate
			mov dx, offset disparoSinBalasJ1
			int 21h

			jmp empate
	nobalaj2:
			mov ah, 9    ; Imprimir que el j2 no tenia balas al disparar y luego salta a empate, porque el j1 recargo o se defendio
			mov dx, offset disparoSinBalasJ2
			int 21h
			jmp empate
logicadefensa:
	cmp rta[di+1],'j' ;j1 se defiende y j2 recarga
	je sumbx
	
	cmp rta[di+1],'k'
	je J1defiendeBala
	
	cmp rta[di+1],'l'
	jmp empate
	
	sumbx:  ;j1 se defiende y j2 recarga, luego empatan
		inc bx
		jmp empate
	
	J1defiendeBala:
		cmp bx,0 ;veo si j2 tiene balas
		je nobalaj2
		dec bx
		jmp empate


	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Recargar (Z), Disparar (X), Defenderse (C) j1
	;Recargar (J), Disparar (K), Defenderse (L) j2
	;mov si, 0      ; Balas del jugador 1
    ;mov bx, 0      ; Balas del jugador 2
   jugador2pLogica:
	cmp rta[di],'j' ;veo si el j2 recarga primero
	je logicarecarga2
	cmp rta[di],'k'	;veo si el j2 dispara primero
	je logicadisparo2
	cmp rta[di],'l'	;veo si el j2 se defiende primero
	je logicadefensa2

logicarecarga2:
	inc bx
	cmp rta[di+1],'z'	
	je balasi
	cmp rta[di+1],'x' ; chequeo si el j1 tiene balas para disparar al j2 que esta recargando 
	je chequeoBalasJ2recJ1rec
	cmp rta[di+1],'c'
	jmp empate
	balasi:  ;ambos recargan y empatan
		inc si
		jmp empate
	chequeoBalasJ2recJ1rec:
		cmp si, 0
		je nobalaj1
		jmp jugador1Gana; si SI es distinto de 0 gana el j1 porque el j2 esta recargando
	
logicadisparo2:
	cmp rta[di+1],'z' ;condicion de victoria j2 dispara, j1 recarga
	je	J2dispJ1rec
	cmp rta[di+1],'x' ;j2 dispara y j1 tambien, chequeo si tienen balas
	je	ambosdisparan
	cmp rta[di+1],'c' ;j1 se defiende mientras j2 dispara,chequeo si tiene balas
	je	j2DispJ1Def
	
	J2dispJ1rec:
		cmp bx,0 ;si no tiene balas para disparar j2 salta a dar un mensaje y luego empatan
		je sinBalaj2
		jmp jugador2Gana
	ambosdisparan:
		cmp bx, 0
		je nobalaj2ChequeoJ1; si no tiene balas j1 chequeo si j2 tiene balas
		jmp jugador2Gana ;si el j2 tiene balas, gana el j2 porque disparo primero

		nobalaj2ChequeoJ1: ;chequeo si j1 tiene balas, j2 ya se que no tiene
			cmp si,0
			je sinBalas      ; si no tiene salta a mostrar un mensaje y a empatar
			jmp jugador1Gana ;si j1 tiene al menos 1 bala gana porque el j2 no tenia balas al disparar
		
		sinBalas:
			mov ah, 9    ; Imprimir que el j1 no tenia balas al disparar y luego salta a empate, porque el j2 tampoco tenia balas
			mov dx, offset disparoSinBalasJ1
			int 21h

			mov ah, 9    ; Imprimir que el j2 no tenia balas al disparar y luego salta a empate, porque el j1 tampoco tenia balas
			mov dx, offset disparoSinBalasJ2
			int 21h

			jmp empate
	j2DispJ1Def:
		cmp bx,0
		je sinBalaj2
		dec bx
		jmp empate ;empate porque j2 dispara j1 se defiende	


;vaAempate:	;no se porque me tiraba el error "Relative jump out of range by 0020h bytes" asi que tuve que poner un salto auxiliar
	;jmp empate	


logicadefensa2:
	cmp rta[di+1],'z' ;j2 se defiende y j1 recarga
	je  sumJ1
	cmp rta[di+1],'x'
	je  j2DefJ1Disp
	cmp rta[di+1],'c' ;ambos se defienden
	jmp empate

	sumJ1: ;j2 se defiende y j1 recarga, luego empatan
		inc si
		jmp empate

	j2DefJ1Disp: ;jugador 2 defiende y j1 dispara
		cmp si,0 ;veo si j1 tiene para disparar
		je sinBalaj2	
	sinBalaj2:
			mov ah, 9    ; Imprimir que el j2 no tenia balas al disparar y luego salta a empate, porque el j1 se defendio o recargo
			mov dx, offset disparoSinBalasJ2
			int 21h
			jmp empate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Jugador vs ia;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comienzaVsIA:
	call espera
	call espera
	call espera

	lea bx,empa
    push bx
    call bmp
            mov di, 0		;contador necesario
            mov ah, 9   ; Imprimir m de contador (3)
            mov dx, offset mContador3
            int 21h

			call espera
            mov ah, 9    ; Imprimir m de contador (2)
            mov dx, offset mContador2
            int 21h

			call espera
            mov ah, 9    ; Imprimir m de contador (1)
            mov dx, offset mContador1
            int 21h

			call espera
            mov ah, 9    ; Imprimir m de "Ya!"
            mov dx, offset mYa
            int 21h

            ;Recargar (Z), Disparar (X), Defenderse (C) j1
            ;; mov si,0 balas de j1
            ;; mov bx,0 balas de ia	

            mov ah, 8 ;  ah,8 serivicio 8 pido caracteres sin ECO   
            int 21h
            
            mov rta[di],al ;guardo la opcion elegida por el j1
  
        opcionRandom: 
            call random
            mov nroRandom[di],al
            cmp si,0 ;si el jugador 1  tiene 0 balas salta a recargar la ia
            je RandomElijeRecarga
        ;el random elije un numero aleatorio del 0 al 9 y para se equitativo, si el random es 0,1,2="Recarga" , si es 3,4,5="Dispara" y si es 6,7,8="Defensa"
        ;si toca el "9" en la funcion random vuelve a usar la funcion, asi cada opcion tiene las mismas chances de tocar
            cmp nroRandom[di],0h
            je RandomElijeRecarga
            cmp nroRandom[di],1h
            je RandomElijeRecarga
            cmp nroRandom[di],2h
            je RandomElijeRecarga

            cmp nroRandom[di],3h
            je RandomElijeDisparar
            cmp nroRandom[di],4h
            je RandomElijeDisparar
            cmp nroRandom[di],5h
            je RandomElijeDisparar

            cmp nroRandom[di],6h
            je RandomElijeDefensa
            cmp nroRandom[di],7h
            je RandomElijeDefensa
            cmp nroRandom[di],8h
            je RandomElijeDefensa

            cmp nroRandom[di],9h
            je opcionRandom


            RandomElijeRecarga: ; si el nro random es 0,1,2 se le asigna la letra j y por lo tanto va a recargar
                mov rta[di+1],'j'
                
                mov ah, 9
                mov dx, offset opcionDeMaquinaR ; le muestra por pantalla al jugador 1, que opcion eligio la pc
                int 21h
                jmp controlJ1
            RandomElijeDisparar: ; si el nro random es 0,1,2 se le asigna la letra k y por lo tanto va a disparar
                mov rta[di+1],'k'

                mov ah, 9
                mov dx, offset opcionDeMaquinaD ; le muestra por pantalla al jugador 1, que opcion eligio la pc
                int 21h  
                jmp controlJ1  
            RandomElijeDefensa: ; si el nro random es 0,1,2 se le asigna la letra l y por lo tanto va a a defenderse
                mov rta[di+1],'l' 

                mov ah, 9
                mov dx, offset opcionDeMaquinaC ; le muestra por pantalla al jugador 1, que opcion eligio la pc
                int 21h 
                jmp controlJ1  
           
            ;controlo que la opcion elegida por el jugador 1 sea valida
            controlJ1:
            cmp rta[di],'z' ;opcion para que el jugador 1 recargue 
	        je logicaRecarga3

            cmp rta[di],'x' ;opcion para que el jugador 1  dispare 
            je logicaDisparo3

            cmp rta[di],'c' ;opcion para que el jugador 1 se defienda 
            je outrange2
            outrange2:
            jmp logicaDefensa3
            jmp comienzaVsIA ; si el jugador 1 no ingreseo 'z','x' o 'c' vuelve a empezar el turno


            logicaRecarga3:
                inc si          ; como recarga el j1 , se le suma 1 bala

                cmp rta[di+1],'j'	
                je  J1Rec1     ;el j1 recarga y la computadora tambien

                cmp rta[di+1],'k' 
                je  J1Rec2          ; chequeo si la computadora tiene balas para disparar al j1 que esta recargando 

                cmp rta[di+1],'l' ;como la computadora se cubre y el j1 ya recargo salta directamente a empate
                jmp empatevsIA

                J1Rec1: ;j1 recarga y la pc tambien recarga
                    inc bx ;le sumo una bala a la pc
                    jmp empatevsIA
                J1Rec2: ;j1 recarga y la pc intenta de disparar(contemplo el caso de que dispare sin balas)
                    cmp bx,0
                    je NoBalasIa    
                    jmp IAGana ; si tiene al menos una bala gana la ia
                    
                   
                    NoBalasIa:
                        mov ah, 9    ; Imprimir que la pc no tenia balas al disparar y luego salta a empate, porque el j1 se defendio o recargo
                        mov dx, offset disparoSinBalasIA
                        int 21h
                        jmp empatevsIA
            
            logicaDisparo3:
                cmp rta[di+1],'j'	
                je  J1Disp1     ;el j1 dispara y la computadora recarga (compruebo si el j1 tiene balas)
                cmp rta[di+1],'k'	
                je  J1Disp2     ;el j1 dispara y la computadora dispara (compruebo si ambos tienen balas)     
                cmp rta[di+1],'l'	
                je  J1Disp3     ;el j1 dispara y la computadora se defiende (si j1 tiene balas se le resta 1, sino tiene va directo a empate)

                J1Disp1: ;chequeo si tiene balas el j1 y la pc recarga
                    inc bx ;la pc carga una bala
                    cmp si,0 ;chequeo las balas del j1
                    je NoBalasJ1vsIA
                    jmp jugador1Gana
                    
                NoBalasJ1vsIA:
                    mov ah, 9    ; Imprimir que elj1 no tenia balas al disparar y luego salta a empate, porque la pc se defendio o recargo
                    mov dx, offset disparoSinBalasJ1
                    int 21h
                    jmp empatevsIA

                J1Disp2: ;disparan los 2, chequeo las balas de cada uno para ver que pasa
                    cmp si,0 ;veo si elj1 tiene 0 balas
                    je ChequeoBalas2
                   ; jmp jugador1Gana ; como j1 tiene balas y dispara mas rapido que la pc gana 
                   cmp bx,0 ;veo si la ia tiene 0 balas
                   ja outrange
                   jmp jugador1Gana
                   outrange:
                   dec si
                   dec bx
                   jmp empatevsIA 
                        ChequeoBalas2: ; se que el j1 no tiene balas, si la pc tiene balas, gana y sino es un empate
                            cmp bx,0
                            je sinbalaslos2IA
                            ;si la pc tiene balas, gana
                            jmp IAGana
                        sinbalaslos2IA:
                            mov ah, 9    ; Imprimir que elj1 no tenia balas al disparar y luego salta a empate, porque la pc se defendio o recargo
                            mov dx, offset disparoSinBalasJ1
                            int 21h

                            mov ah, 9    ; Imprimir que la pc no tenia balas al disparar y luego salta a empate, porque el j1 se defendio o recargo
                            mov dx, offset disparoSinBalasIA
                            int 21h
                            
                            jmp empatevsIA
                J1Disp3:;j1 intenta de disparar a la pc que se defiende, veo si tiene balas para disparar
                    cmp si,0
                    je NoBalasJ1vsIA;
                    dec si ; si cumple la condicion de que tenga balas, se le resta una (porque la pc se defiende) y luego salta a empate
                    jmp empatevsIA
            
            logicaDefensa3:
                cmp rta[di+1],'j' ;j1 se defiende y la pc recarga
                je j1Defe1
                cmp rta[di+1],'k' ;j1 se defiende y la pc dispara (tengo que chequear las balas de la pc para ver que pasa)
                je j1Defe2
                cmp rta[di+1],'l' ;j1 se defiende y la pc se defiende, por lo tanto empatan
                jmp empatevsIA

                j1Defe1:
                    inc bx
                    jmp empatevsIA
                j1Defe2:
                    ;veo si la pc tiene balas, si tiene balas gasta 1 y luego empatan, sino empatan directamente
                    cmp bx,0
                    je outrange3
                    outrange3:
                    jmp NoBalasIa
                    dec bx
                    jmp empatevsIA

;;;;;;;;;;;;;;;;;;CONDICIONES FINALES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

jugador1Gana:
	; Limpia pantalla 
    mov ax, 3
    int 10h
	;imprimo imagen final
	lea bx,archivoFinal
    push bx
    call bmp

	mov ah, 9
	mov dx, offset mjugador1
	int 21h
	jmp finjuego
jugador2Gana:
	; Limpia pantalla 
    mov ax, 3
    int 10h
	;imprimo imagen final
	lea bx,perdio
    push bx
    call bmp

	mov ah, 9
	mov dx, offset mjugador2
	int 21h
	jmp finjuego
empate:
	
	mov ah, 9
	mov dx, offset mempate
	int 21h
	jmp comienza
    mov ah, 9    ; Imprimir salto
    mov dx, offset salto
    int 21h
IAGana:
	; Limpia pantalla 
    mov ax, 3
    int 10h
	;imprimo imagen final
	lea bx,perdio
    push bx
   	call bmp

	mov ah, 9
	mov dx, offset mIA
	int 21h
	jmp finjuego    
empatevsIA:
    mov ah, 9
	mov dx, offset mempate
	int 21h
	;imprimo imagen de EMPATE
    mov ah, 9    ; Imprimir salto
    mov dx, offset salto
    int 21h
	jmp comienzaVsIA 
finjuego:
	mov ax, 4c00h
	int 21h
	main endp

random proc ;funcion que devuelve un valor de 0 a 9 con el reloj del sistema
        push cx
        push dx
        mov ah, 2ch
        int 21h
        xor ax, ax
        mov al, dl
        mov cl, 0ah
        div cl
        xor ah, ah
        pop dx
        pop cx
        ret
    random endp    
	
espera proc 
	push cx
    push dx
	push ax

	mov al, 0 	;regitro que requiere esta vacio
	mov ah, 86h
	mov cx, 8	;tiempo de espera
	mov dx, 10
	int 15h
	
	pop ax
	pop dx
    pop cx
    ret
espera endp    

	
end