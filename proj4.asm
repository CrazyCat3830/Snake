IDEAL
MODEL small
STACK 100h
DATASEG
	Clock equ es:6Ch
	;-----score-----;
	score dw 0
	;-----colors-----;
	white dw 0Fh
	black dw 00h
	bright_green dw 10h
	green dw 2h
	red dw 04h
	;-----snake color-----;
	snake_color dw ?
	head_color dw ?
	headc_arr dw 3 dup (2, 1, 4)
	snakec_arr dw 3 dup (10, 9, 12)
	;-----snake-----;
	head_x dw 110
	head_y dw 105
	snake_x dw 300 dup (110);,110,110
	snake_y dw 300 dup (94);,83,72
	snake_cord dw 300 dup (?)
	tail_x dw ?
	tail_y dw ?
	tail2_x dw ?
	tail2_y dw ?
	snakelen dw 1
	dir db 'd'

	isValid db 1 
	isApple db 0

	e11 db 11
	e28 db 28

	ranxorkey dw 348
	;-----apple-----;
	apple_cord dw 245
	apple_x dw ?
	apple_y dw ?
	fruit_width dw 9
	;-----buffer-----;
	buffer db 0
	;-----apple skin-----;
	appleSprite dw  0Fh, 00h, 00h, 00h, 00h, 0Ah, 00h, 00h, 0Fh,00h, 00h, 00h, 00h, 0Ah, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 04h, 04h, 0Fh, 04h, 04h, 04h, 04h, 00h, 00h, 04h, 0Fh, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 0Fh, 00h, 04h, 04h, 00h, 04h, 04h, 00h, 0Fh
	;-----screens texts-----;
	o   db"		 _______  _        _______  _        _______  ",10, 13
		db"		(  ____ \( (    /|(  ___  )| \    /\(  ____ \ ",10, 13
		db"		| (    \/|  \  ( || (   ) ||  \  / /| (    \/ ",10, 13
		db"		| (_____ |   \ | || (___) ||  (_/ / | (__     ",10, 13
		db"		(_____  )| (\ \) ||  ___  ||   _ (  |  __)    ",10, 13
		db"		      ) || | \   || (   ) ||  ( \ \ | (       ",10, 13
		db"		/\____) || )  \  || )   ( ||  /  \ \| (____/\ ",10, 13
		db"		\_______)|/    )_)|/     \||_/    \/(_______/ ",10,13,'$'
	
	g   db"	  ______                              _____                   ",10, 13
		db"	 / _____)                            / ___ \                  ",10, 13
		db"	| /  ___  ____ ____   ____    ___   | |   | |_   _ ____  ____ ",10, 13
		db"	| | (___)/ _  |    \ / _  )  (___)  | |   | | | | / _  )/ ___)",10, 13
		db"	| \____/( ( | | | | ( (/ /          | |___| |\ V ( (/ /| |    ",10, 13
		db"	 \_____/ \_||_|_|_|_|\____)          \_____/  \_/ \____)_|    ",10, 13, '$'   
	
	starting_screen_text db "		[ Welcome to snake game! ]", 10,10, "		Your goal is to move the snake, eat", 10,  "		fruits and get 10 points.", 10, "		If you touch the walls or yourself,", 10, "		you'll lose the game!",10,10,10, "		- Press a key to continue -$"
	color_screen_text db "[choose the color of the snake!]", 10,10, "press a,s,d to change!", 10,10, "a-green,s-blue,d-red to change!",10,10,10, "-Aftet that, Press a key to continue -$"
	you_chose_text db 10,10,10,10, "you chose: $"
	score_text db "score: $"
	win_screen_text db "		[ You won! ]", 10,10, "You managed to get 10 points!  Good job!", 10,10,10, "- Press a key to exit -$"
	LOSE_screen_text db "		[ You lost! ]", 10,10, "Better luck next time...", 10,10,10, "- Press a key to exit -$"
	;-----melodys and sounds-----;
	win_melody dw 2711, 2415, 2031, 2711, 1612, 1,1, 1612, 1,1, 1809, 1,1,1,1, 2711, 2415, 2031, 2711, 1809, 1,1, 1809, 1,1, 2031, 1, 2152, 2415, 1,1, 2711, 2415, 2031, 2711, 2031, 1,1,1, 1809, 1, 2152, 1,1,1, 2711, 1,1, 2711, 1,1, 1809, 1,1, 2031, 0
	lose_melody dw 9663, 9121, 8126, 1, 12175, 1, 10847, 1, 13666, 1, 14478, 0
	score_melody dw 2415, 0
	eating_melody dw 2415, 0

CODESEG
;-----clears all variables before the game-----;
proc clear_all
	push bx
	push cx
	push si
	push bp
	
	mov [score], 0
	mov [buffer], 0
	mov [snakelen], 1
	mov [isValid], 1
	mov [dir], 'd'
	mov [isApple], 0
	mov [apple_cord], 245
	mov [head_x], 110
	mov [head_y], 105
	mov cx, [snakelen]
	mov bp, cx
	shl bp, 1
	mov bx, [head_y]
	
clear_allloop:
	mov si, cx
	shl si, 1
	neg si
	add si, bp
	sub bx, 11
	mov [snake_y+si], bx
	mov [snake_x+si], 110
	loop clear_allloop
	
	pop bp
	pop si
	pop cx
	pop bx
	ret
endp clear_all
;-----paints a pixel-----;
proc pixel
	push bp ;access the stack with bp
	mov bp, sp
	push cx ;save registers
	push dx
	push ax
	
	mov al, [bp+4] ;al color
	mov dx, [bp+6] ;dx is the y
	mov cx, [bp+8] ;cx is the x
	
	mov ah, 0ch ;print pixel to screen
	int 10h

	pop ax ;restore registers
	pop dx
	pop cx
	pop bp
	ret 6
endp pixel
;-----takes center x,y and color, and builds a square from x-5,y-5 to x+5,y+5 (11x11), with the given color-----;
proc snake_pixel
	push bp ;access the stack with bp
	mov bp, sp 
	push si ;save registers
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	mov al, [bp+4] ;al = color
	mov dx, [bp+6] ;dx = y center
	mov bx, [bp+8] ;bx = x center
	mov cx, 11 ;loop 11 times for 11 different x-values
pi11x:
	mov si, cx ;si = cx. si is 1 to 11
	sub si, 6 ;si is -5 to 5
	add si, bx ;si is the x-5 to x+5. meaning si have the x-values of the square
	push cx ;save cx for the y loop
	mov cx, 11 ;loop 11 times for 11 different y-values
pi11y: ;for each x value, we will print 11 diffferent pixels in 11 different y values
	push cx ;save cx. cx is 1 to 11
	sub cx, 6 ;cx is -5 to 5
	add cx, dx ;cx is the y-5 to y+5, meaning cx have the y-values of the square
	push si ;the x value
	push cx ;the y value
	push ax ;the color
	
	call pixel ;build pixel here
	pop cx ; restore cx for the next y loop iteration
	loop pi11y
	pop cx ;resotre cx for the next x loop iteration
	loop pi11x
	
	pop dx ;restore registers
	pop cx
	pop bx
	pop ax
	pop si
	pop bp
	ret 6
endp snake_pixel
;-----takes center x,y and color, and builds a square from x-4,y-4 to x+4,y+4 (9x9), with the given color-----;
proc pixel9
	push bp ;access the stack with bp
	mov bp, sp 
	push si ;save registers
	push ax
	push bx
	push cx
	push dx
	
	xor ax, ax
	mov al, [bp+4] ;al = color
	mov dx, [bp+6] ;dx = y center
	mov bx, [bp+8] ;bx = x center
	mov cx, 9 ;loop 9 times for 9 different x-values
pi9x:
	mov si, cx ;si = cx. si is 1 to 9
	sub si, 5 ;si is -4 to 4
	add si, bx ;si is the x-4 to x+4. meaning si have the x-values of the square
	push cx ;save cx for the y loop
	mov cx, 9 ;loop 9 times for 9 different y-values
pi9y: ;for each x value, we will print 9 diffferent pixels in 9 different y values
	push cx ;save cx. cx is 1 to 9
	sub cx, 5 ;cx is -4 to 4
	add cx, dx ;cx is the y-4 to y+4, meaning cx have the y-values of the square
	push si ;the x value
	push cx ;the y value
	push ax ;the color
	
	call pixel ;build pixel here
	pop cx ; restore cx for the next y loop iteration
	loop pi9y
	pop cx ;resotre cx for the next x loop iteration
	loop pi9x
	
	pop dx ;restore registers
	pop cx
	pop bx
	pop ax
	pop si
	pop bp
	ret 6
endp pixel9
;-----x-----;
proc appleHandle
	push ax
	push bx
	push cx
	push dx
	push si
	push bp
	
	mov bx, [head_x]
	mov ax, [head_y]
	mov cx, [snakelen]
	inc cx
	mov bp, cx
	shl bp, 1
cord:
	mov si, cx
	shl si, 1
	neg si
	add si, bp
	sub ax, 17
	sub bx, 11
	div [e11]
	mul [e28]
	mov dx, ax
	mov ax, bx
	div [e11]
	add dx, ax
	mov [snake_cord+si], dx
	mov ax, [snake_y+si]
	mov bx, [snake_x+si]
	loop cord

	mov ax, [Clock]
	and ax, 111111111b
	xor ax, [ranxorkey]
	mov cx, [snakelen]
	inc cx
checkapple:
	mov si, cx
	shl si, 1
	cmp ax, [snake_cord+si-1]
	jb contin
	inc ax
contin: 
	loop checkapple
	shr bp, 1
	neg bp
	add bp, 447
	cmp ax, bp
	mov [apple_cord], ax
	jbe validapp
	
	mov ax, [tail2_y]
	sub ax, 17
	div [e11]
	mul [e28]
	mov dx, ax
	mov ax, [tail2_x]
	sub ax, 11
	div [e11]
	add dx, ax
	mov [apple_cord], dx

validapp:
	call print_apple
	
	pop bp
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp appleHandle
;----------;
proc wait_tenth
    push ax
    push cx
    push dx
    
    mov ah, 86h
    mov cx, 0001h
    mov dx, 86A0h
    int 15h

    pop dx
    pop cx
    pop ax
    ret
endp
;----------;
proc play_beep ; divisor
    push bp
    mov bp, sp
    push ax

    in al, 61h ; Open speaker
    or al, 00000011b
    out 61h, al
    
    mov al, 0B6h ; Send control word to change frequency
    out 43h, al

    mov ax, [bp+4] ; Play divisor
    out 42h, al ; Sending lower byte
    mov al, ah
    out 42h, al ; Sending upper byte

    pop bp
    pop ax
    ret 2
endp
;----------;
proc stop_beep
    push ax

    in al, 61h
    and al, 11111100b
    out 61h, al

    pop ax
    ret
endp
;-----plays array melody-----;
proc play_melody ; ax = notes array offset, divisor[2]
    push ax
    push si

    mov si, ax
    play_melody_loop:
        mov ax, [si]
        cmp ax, 0
        je play_melody_end

        cmp ax, 1
        je play_melody_continue

        push ax
        call play_beep

        play_melody_continue:
        call wait_tenth
        call stop_beep
        add si, 2
        jmp play_melody_loop
    
    play_melody_end:
    call stop_beep
    pop si
    pop ax
    ret
endp
;-----opens graphic_mode-----;
proc graphic_mode
    push ax ;save ax

    mov ax, 13h ;graphic mode
    int 10h
    
    pop ax ;restore ax
    ret
endp graphic_mode
;-----gets keyboard key (not used much)-----;
proc get_key ; returns ah=scancode al=ascii
    mov ah, 00h
    int 16h
    ret
endp
;-----shows the opening screen-----;
proc OPENING

	mov ax, 02h
	int 10h
	MOV AH, 9
    mov dx, offset o
	INT 21H
	
    mov ah, 09h
    mov dx, offset starting_screen_text
    int 21h

    mov ah, 00h
    int 16h

    ret
endp
;-----show the screen where you can choose the color of the snake-----;
proc CHOOSE_screen
	push ax
	push bx
	xor ax, ax
	xor bx, bx
	mov ah, 09h
    mov dx, offset color_screen_text
    int 21h
	mov ah, 09h
    mov dx, offset you_chose_text
    int 21h
	
choosing1:

	call get_key
	cmp al, 'a';a
	je chosen1
	cmp al, 's';s
	je chosen2
	cmp al, 'd';d
	je chosen3
	jne choosing1
	
	chosen1:
		mov [head_color], 2
		mov [snake_color], 10
		call print_snake
		jmp chosen_ready
	chosen2:
		mov [head_color], 1
		mov [snake_color], 9
		call print_snake
		jmp chosen_ready
	chosen3:
		mov [head_color], 4
		mov [snake_color], 12
		call print_snake
		jmp chosen_ready
	
chosen_ready:	
    mov ah, 00h
    int 16h

    call wait_tenth
	
	pop bx
	pop ax
	ret
endp
;-----shows the winning screen-----;
proc WIN_screen
	
    mov ah, 09h
    mov dx, offset win_screen_text
    int 21h

    mov ax, offset win_melody
    call play_melody

    mov ah, 00h
    int 16h

    call wait_tenth

    ret
endp
;-----shows the loosing sceen-----;
proc LOSE_screen
    mov ax, 02h
	int 10h
	MOV AH, 9
    mov dx, offset g
	INT 21H
	
    mov ah, 09h
    mov dx, offset LOSE_screen_text
    int 21h

    mov ax, offset lose_melody
    call play_melody

    mov ah, 00h
    int 16h

    call wait_tenth

    ret
endp
;-----shows the main screen of the game-----;
proc main_screen
	push ax
	push cx
	push si
	mov ax, 2h ;hide mouse
	int 33h

	call clear_all
	call CHOOSE_screen
	call graphic_mode
	mov ah, 9h ;print string
	mov dx, offset score_text
	int 21h
	call show_score
	call print_snake
	
	mov cx, 310
upper_bord:
	mov si, 4
	add si, cx
	push si
	push 11
	push 15
	call pixel
	loop upper_bord
	
	mov cx, 310
lower_bord:
	mov si, 4
	add si, cx
	push si
	push 188
	push 15
	call pixel
	loop lower_bord
	
	mov cx, 178
left_bord:
	mov si, 10
	add si, cx
	push 5
	push si
	push 15
	call pixel
	loop left_bord

	mov cx, 178
right_bord:
	mov si, 10
	add si, cx
	push 314
	push si
	push 15
	call pixel
	loop right_bord
	
	pop si
	pop cx
	pop ax
	ret
endp main_screen
;-----prints the score on the screen-----;
proc show_score
	push ax
	push bx
	push cx
	push dx
	mov ax, [score] ;xyz
	mov cx, 3
	mov bl, 100
printloop:
	div bl
	mov dh, ah
	mov dl, al
	mov al, bl
	mov bh, 10
	xor ah,ah
	div bh
	mov bl, al
	mov ah, 2 ;print dl
	add dl, '0' ;add dl 0
	int 21h
	mov al, dh
	xor ah,ah
	loop printloop
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp show_score
;-----prints the snake on the screen-----;
proc print_snake
	push [head_x]
	push [head_y]
	push [head_color]
	call snake_pixel
	
	mov cx, [snakelen]
snakeloop:
	mov si, cx
	shl si, 1
	push [snake_x+si-2]
	push [snake_y+si-2]
	push [snake_color]
	call snake_pixel
	loop snakeloop
	ret
endp print_snake
;-----prints the apple on the screen-----;
proc print_apple
	push ax
	push bx
	mov ax,[apple_cord]
	div [e28]
	mov bl, al
	shr ax, 8
	mul [e11]
	add ax, 11
	push ax
	push ax
	pop [apple_x]
	mov al, bl
	mul [e11]
	add ax, 17
	push ax
	mov [apple_y], ax
	push 4
	call pixel9
	pop bx
	pop ax
	ret
endp print_apple
;-----draws the fruit using the array-----;
proc draw_fruit; 
	push si
    push bp
    mov bp, sp
    mov si, [bp + 6]
    push ax
    push bx
    push cx
    push dx

    mov cx, [apple_x] ;xpos
    mov dx, [apple_y] ;ypos
    mov ax, cx
    add ax, [fruit_width]
    mov bx, dx
    add bx, [fruit_width]
    drawAppleSpriteLoop:
        cmp dx, bx
        jge drawAppleSpriteEnd
        mov cx, ax
        sub cx, [fruit_width]
        drawAppleSpriteLoopY:
            cmp cx, ax
            jge drawAppleSpriteIncY
            cmp [si], ch ;because ch is always 0
            je drawAppleSpriteIncX
            push [si]
            push dx
            push cx
            call pixel
            drawAppleSpriteIncX:
            inc cx
            add si, 2
            jmp drawAppleSpriteLoopY
        drawAppleSpriteIncY:
            inc dx
            jmp drawAppleSpriteLoop
    drawAppleSpriteEnd:
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        pop si
        ret 2
endp
;-----gets an input from the keyboard-----;
proc keyboard_input
	push ax
	push bx
	mov ah, 01h
	int 16h
	jz noKeyPress
	mov ah, 00h
	int 16h
	cmp ah, 50h
	je updatebuff
	cmp ah, 4Bh
	je updatebuff
	cmp ah, 48h
	je updatebuff
	cmp ah, 4Dh
	jne nokeypress
updatebuff:
	mov [buffer], ah
noKeyPress:
	pop bx
	pop ax
	ret
endp keyboard_input
;-----x-----;
proc game_input
	push ax
	push bx
	mov ah, [buffer]
	cmp ah, 50h
	jne notDown
	cmp [dir],'u'
	je noKey
	mov [dir],'d'
	jmp noKey
notDown:
	cmp ah, 4Bh
	jne notLeft
	cmp [dir], 'r'
	je nokey
	mov [dir], 'l'
	jmp noKey
notLeft:
	cmp ah, 4Dh
	jne notRight
	cmp [dir], 'l'
	je nokey
	mov [dir], 'r'
	jmp nokey
notRight:
	cmp ah, 48h
	jne noKey
;up:
	cmp [dir],'d'
	je nokey
	mov [dir], 'u'
noKey:
	pop bx
	pop ax
	ret
endp game_input
;-----x-----;
proc waitmic
	push bp
	mov bp, sp
	push ax
	push cx
	push dx
	mov cx, [bp+6]
	mov dx, [bp+4]
	mov ah, 86h
	int 15h
	ret 4
endp waitmic
;-----updates snakes head and body-----;
proc updateSnake
	push ax
	push bx
	push cx
	push dx
	push bp
	push si
	
	cmp [dir], 'l' ;check if dir is left
	je Left
	cmp [dir],'r'
	jne noX
	push [head_x] ;push head_x to save as first snake_x
	add [head_x], 11 ;mov snake head right
	jmp validx
Left:
	push [head_x] ;push head_x to save as first snake_x
	sub [head_x],11 ;mov snake head left
	jmp validx
noX:
	cmp [dir], 'u'
	je Up
Down:
	push [head_y] ;push head_y to save as first snake_y
	add [head_y],11 ;mov snake head down
	jmp validy
Up:
	push [head_y] ;push head_y to save as first snake_y
	sub [head_y],11 ;mov snake head up
validy:
	pop bx
	mov ax, [head_x]
	jmp updateloop
validx:
	pop ax ;ax=head_x for the first snake_x
	mov bx, [head_y] ;bx=head_y for the first snake_y
updateloop:
	mov cx, [snakelen] ;for every square in snake tail
	mov bp, [snakelen]
	shl bp, 1
sna_upd:
	mov si, cx
	shl si, 1
	neg si
	add si, bp
	push cx
	mov cx, [snake_x+si]
	mov dx, [snake_y+si]
	mov [snake_x+si], ax
	mov [snake_y+si], bx
	mov ax, cx
	mov bx, dx
	pop cx
	cmp cx, 1
	jne notlast
	push ax
	mov ax, [tail_x]
	mov [tail2_x], ax
	mov ax, [tail_y]
	mov [tail2_y], ax
	pop ax
	mov [tail_x], ax
	mov [tail_y], bx
notlast:
	loop sna_upd
	call checkhead ;check if head is valid
	cmp [isValid], 1 ;if valid, update and continue snake
	jne noValid
	push [tail_x]
	push [tail_y]
	push 0
	call snake_pixel
	call print_snake
noValid:
	
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp updateSnake

proc checkhead
	push ax
	push bx
	push cx
	push si
	cmp [head_x],10
	jb notValid
	cmp [head_x],309
	ja notValid
	cmp [head_y],16
	jb notValid
	cmp [head_y], 183
	ja notValid

	mov ax, [head_x]
	mov bx, [head_y]
	mov cx, [snakelen]
check:
	mov si, cx
	shl si,1
	cmp ax,[snake_x+si-2]
	jne valx
	cmp bx, [snake_y+si-2]
	je notValid
valx:
	loop check
	cmp ax, [apple_x]
	jne valid
	cmp bx, [apple_y]
	jne valid
	mov [isApple], 1
	jmp valid
notValid:
	mov [isValid],0
valid:
	pop si
	pop cx
	pop bx
	pop ax
	ret
endp checkhead
;----------;
start:
	mov ax, @data
	mov ds, ax
	mov ax, 40h
	mov es, ax
	
	call graphic_mode
	call OPENING
startgame:
	call graphic_mode
	call main_screen
	call print_apple
	mov ah, 0
	int 16h	
main_loop:
	

FirstTick:
	mov cx, 3
DelayLoop:
	mov ax, [Clock]
Tick:
	call keyboard_input
	cmp ax, [Clock]
	je TICK
	loop DELAYLOOP
	call game_input
	call updatesnake
	cmp [isValid], 1
	jne noval
	cmp [isapple], 1
	jne noApp
	push ax
	push bx
	push cx
	push dx
	mov bx, [snakelen]
	shl bx, 1
	mov cx, [tail_x]
	mov [snake_x+bx], cx
	mov cx, [tail_y]
	mov [snake_y+bx], cx
	inc [snakelen]
	call print_snake
	inc [score]
	mov ah, 9h ;print string
	mov dx, offset score_text
	int 21h
	call show_score
	call applehandle
	cmp [score], 10
	je win_exit
	pop dx
	pop cx
	pop bx
	pop ax
	mov [isapple], 0
noApp:
	jmp main_loop
noval:
	jmp lose_exit
;-----if the player won-----;	
win_exit:
    call stop_beep
    call GRAPHIC_MODE
    call WIN_screen
    jmp exit
;-----if the player lost-----;
lose_exit:
    call stop_beep
    call GRAPHIC_MODE
    call LOSE_screen
    jmp exit
;----------;
exit:
	mov ax, 4c00h
	int 21h
END start


