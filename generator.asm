SYS_EXIT  equ 1
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data

	endl db 0xA,0xD
	lend equ $ - endl

	sbuf db 0x0
	slen equ $ - sbuf

	rbuf db 0x0
	rlen equ $ - rbuf

segment .bss
	line resb 1000
	lptr resd 1
	lptr2 resd 1
	rule resd 1
	generation resd 1
	length  resd 1

segment .text
	global generator

generator:
    push ebp
    mov  ebp,esp

    mov  eax,[ebp+8]
    mov  [rule],eax		;		

    mov  eax,[ebp+12]
    mov  [lptr],eax		; lptr now points the adress of sequence

    mov  eax,line
    mov  [lptr2],eax 
    
    mov eax,[ebp+16]
    mov [length],eax    

    mov eax,[ebp+20]
    mov [generation],eax  	   

    mov  eax,SYS_WRITE      	; First input is printed
    mov  ebx,STDOUT
    mov  ecx,[lptr]
    mov  edx,[length]
    int  0x80

    mov  eax,SYS_WRITE
    mov  ebx,STDOUT
    mov  ecx,endl
    mov  edx,lend
    int  0x80

    call main_loop		;

    pop  ebp
    ret

display:
    push ecx
    push eax
    mov  eax,SYS_WRITE
    mov  ebx,STDOUT
    mov  ecx,[lptr2]
    mov  edx,[length]
    int  0x80

    mov  eax,SYS_WRITE
    mov  ebx,STDOUT
    mov  ecx,endl
    mov  edx,lend
    int  0x80


    pop eax
    pop ecx
    ret

generate_line:
    push ecx
    push eax

    mov  eax,[lptr]         ; lptr -> eax
    mov  ecx,[length]
    sub  ecx, 1
    mov  edx,[lptr2]
    mov  ebx,0
    dec  eax
loop_2:
    call get_seq
    call get_rule
    mov  ebx,[rbuf]
    mov  byte[edx],bl
    inc  edx
    inc  eax
    mov  ebx,-1
    loop loop_2

    mov  ebx,1
    call get_seq
    call get_rule
    mov  ebx,[rbuf]
    mov  byte[edx],bl

    pop eax
    pop ecx
    ret

get_seq:
    push eax			
    push ecx			
    push edx			

    mov  ecx,3
    cmp  ebx,0
    jne  normal
    mov  ecx,2         		;Counter for loop
    inc  eax			
normal:
    sub  dl,dl          	; Reset dl
loop_1:
    cmp  ebx,1
    jne  normal2
    dec  ecx
normal2:
    mov  bl,[eax]         ; Get item in array -> ebx
    inc  eax
    clc                   ; Clear carry
    cmp  bl,'0'           ; Compare ebx with '0'
    je   zero             ; If '0' then don't set carry
    stc                   ; Set carry if item is '1'
zero:
    rcl  dl,1             ; Rotate left with carry
    loop loop_1
    mov  [sbuf],dl        ; Sequence rule -> [sbuf] /////////////////////////
    pop  edx
    pop  ecx
    pop  eax
    ret

get_rule:
    push eax
    push ecx
    push edx
    mov  edx,[rule]       ; Rule number -> edx
    mov  cl,[sbuf]        ; Sequence rule -> cl
    inc  cl
    sub  eax,eax
    shr  edx,cl           ; Shift right until reach the result of rule
    rcl  eax,1            ; Carry -> al
    mov  [rbuf],al        ; Rule result -> [rbuf]
    add  byte[rbuf],'0'
    pop  edx
    pop  ecx
    pop  eax
    ret

main_loop:
    mov  ecx,[generation]		;ecx kadar loop edeceğiz bu yüzden ecx'e generation'ı attık
loop_main:
    call generate_line
    call display
    mov  eax,[lptr2]
    mov  edx,[lptr]
    mov  [lptr],eax
    mov  [lptr2],edx
    loop loop_main			;
	
    ret