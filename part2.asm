SYS_EXIT  equ 1
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

segment .data

endl db 0xA,0xD
lend equ $ - endl

sbuf db 0x0         ; Symbol buffer

rbuf db 0x0         ; Rule buffer

segment .bss

rule resd 1                 ; Pointer for rule array

buff resb 1000       ;

line resd 1
clmn resd 1

arr1 resd 1
arr2 resd 1
loc  resd 1
buf  resd 1

segment .text
global generator

generator:
    push ebp
    mov  ebp,esp

    mov  eax,[ebp+8]
    mov  [rule],eax

    mov  eax,[ebp+12]
    mov  [arr1],eax

    mov  eax,buff
    mov  [arr2],eax

    mov  eax,[ebp+16]
    mov  [line],eax

    mov  eax,[ebp+20]
    mov  [clmn],eax

    call print
    call generate
    mov eax,[arr1]
    mov edx,[arr2]
    mov [arr2],eax
    mov [arr1],edx
    ;call print

    pop  ebp
    ret

print:
    mov  ecx,[line]
    mov edi,[clmn]
    mov  eax,[arr1]
    mov [buf],eax
    sub  [buf],edi
    ploop_1:
    add  [buf],edi
    push ecx

    mov  eax,SYS_WRITE
    mov  ebx,STDOUT
    mov  ecx,[buf]
    mov  edx,[clmn]
    int  0x80

    mov  eax,SYS_WRITE
    mov  ebx,STDOUT
    mov  ecx,endl
    mov  edx,lend
    int  0x80

    pop  ecx
    loop ploop_1

    ret

generate:
    mov eax,[arr1]
    mov [loc],eax       ; arr1 = loc
    mov eax,[line]
    mul word[clmn]      ; linexcolumn > eax
    mov ecx,eax         ; 25 times loop
    mov eax,1           ; current line < 1
    mov ebx,1           ; current column < 1
    gloop_1:
    push ecx
    mov ecx,0
    cmp eax,1           ; NESW > these compares for sides
    je swest
    cmp eax,[line]
    je seast
    second:
    cmp ebx,1
    je snorth
    cmp eax,[clmn]
    je ssouth

    continue:
    push eax
    push ebx
    call get_sym
    call get_rule
    pop ebx
    pop eax
    mov eax,[loc]
    sub eax,[arr1]
    add eax,[arr2]
    mov ebx,[rbuf]
    mov [eax],bl
    inc byte[loc]
    cmp ebx,[clmn]
    je reset
    inc ebx
    continue2:
    pop ecx
    loop gloop_1
    ret

    snorth:
    add ecx,8
    jmp second
    seast:
    add ecx,4
    jmp second
    ssouth:
    add ecx,2
    jmp continue
    swest:
    add ecx,1
    jmp continue

    reset:
    mov ebx,1
    inc eax
    jmp continue2

get_sym:            ; Get Symbol (i.e. CNESW=10110)
    sub  edx,edx
    mov  eax,loc
    mov  bl,[eax]
    call shift      ; Center
    sub  eax,5
    mov  bl,[eax]
    cmp  ecx,8
    jge  north
    add  ecx,8
    mov  bl,'0'
    north:
    sub  ecx,8
    call shift      ; North
    add  eax,6
    mov  bl,[eax]
    cmp  ecx,4
    jge  north
    add  ecx,4
    mov  bl,'0'
    east:
    sub  ecx,4
    call shift      ; East
    add  eax,4
    mov  bl,[eax]
    cmp  ecx,2
    jge  north
    add  ecx,2
    mov  bl,'0'
    south:
    sub  ecx,2
    call shift      ; South
    sub  eax,6
    mov  bl,[eax]
    cmp  ecx,1
    jge  north
    add  ecx,1
    mov  bl,'0'
    west:
    sub  ecx,1
    call shift      ; West
    mov  [sbuf],dl
    ret

shift:
    clc
    cmp  bl,'0'
    je   zero
    stc
    zero:
    rcl  dl,1
    ret

get_rule:
    mov  edx,[rule]
    mov  cl,[sbuf]
    sub  edx,31
    add  edx,edx
    mov  al,[edx]
    mov  [rbuf],al
    add  byte[rbuf],'0'
    ret
