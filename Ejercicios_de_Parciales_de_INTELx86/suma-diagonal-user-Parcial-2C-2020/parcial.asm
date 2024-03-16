;   Ejercicio examen parcial primera oportunidad 2do cuatrimestre 2020
;Dada una matriz (M) de 15x15 cuyos elementos son binarios de punto fijo con signo de 16 bits, 
;se pide desarrollar un programa en assembler INTEL que pida el ingreso por teclado de un número de fila i, 
;que  deberá validarlo mediante el uso de una rutina interna, y muestre por pantalla la sumatoria 
;de los elementos de la diagonal que va desde (i,1) hasta (15,k) junto con los elementos de la diagonal 
;que va desde (15,k) hasta (r,15)

global main
extern printf
extern gets
extern puts
extern sscanf

section .data
    msjInicio   db  "Ingrese numero de fila: ",0
    msjInputInvalido    db  'Ingreso invalido',0
    msjInputValido      db  'Ingreso OK',0 
    filaFormat  db  '%hi' ;16 bits (lo minimo que puedo definir en windows)
    sumatoria   dd  0
    msjSumatoria        db  'La sumatoria es: %i',0
    matriz      dw  1,0,0,0,0,0,0,0,0,0,0,0,0,0,2
                dw  0,1,0,0,0,0,0,0,0,0,0,0,0,2,0
                dw  0,0,1,0,0,0,0,0,0,0,0,0,2,0,0
                dw  0,0,0,1,0,0,0,0,0,0,0,2,0,0,0
                dw  0,0,0,0,1,0,0,0,0,0,2,0,0,0,0
                dw  3,0,0,0,0,1,0,0,0,2,0,0,0,0,0
                dw  0,3,0,0,0,0,1,0,2,0,0,0,0,0,0
                dw  0,0,3,0,0,0,0,1,0,0,0,0,0,0,0
                dw  0,0,0,3,0,0,2,0,1,0,0,0,0,0,0
                dw  0,0,0,0,3,2,0,0,0,1,0,0,0,0,3
                dw  0,0,0,0,2,3,0,0,0,0,1,0,0,3,0
                dw  0,0,0,2,0,0,3,0,0,0,0,1,3,0,0
                dw  0,0,2,0,0,0,0,3,0,0,0,3,1,0,0
                dw  0,2,0,0,0,0,0,0,3,0,3,0,0,1,0
                dw  2,0,0,0,0,0,0,0,0,3,0,0,0,0,1


section .bss
    filaInput   resb    50
    filaValida  resb    1
    filaNum     resw    1   ;16 bits
    columna     resw    1
    sumarFila   resw    1
section .text
main:

;PIDO INGRESO POR TECLADO DE LA FILA
    mov     rcx,msjInicio
    sub     rsp,32      ;para todas las funciones de C en WINDOWS!!!
    call    printf
    add     rsp,32      ;para todas las funciones de C en WINDOWS!!!
    mov     rcx,filaInput
    sub     rsp,32
    call    gets
    add     rsp,32
;VALIDO LO INGRESADO
    call   validarInput 
    cmp     byte[filaValida],'N'
    je      inputInvalido
    
mov     rcx,msjInputValido
sub     rsp,32
call    puts
add     rsp,32 

    mov     word[sumarFila],1 ;lo que se va a sumar o restar a fila (1 o -1)
    mov     word[columna],1 ;fila arranca en 1 y siempre irá subiendo de a 1
addNextElem:
    call    calcDesplaMatriz
    mov     bx,[matriz+rax]
    add     [sumatoria],bx

    cmp     word[filaNum],15    ; veo si llegue a la ultima fila para empezar a restar 1
    jne     modifFilaCol
    mov     word[sumarFila],-1  ; pongo -1 para empezar a restar 1 a fila
modifFilaCol:
    mov     ax,[sumarFila]  
    add     [filaNum],ax        ;altero fila (sumo o resto 1 segun valor de sumarFila)
    inc     word[columna]       ;altero columan (siempre suma 1)

    cmp     word[columna],16    ;veo si llegue a la ulitma columna
    jl      addNextElem
;IMPRIMO LA SUMATORIA
    mov     rcx,msjSumatoria
    mov     rdx,[sumatoria]
    sub     rsp,32
    call    printf
    add     rsp,32

    jmp     endProg

inputInvalido:
    mov     rcx,msjInputInvalido
    sub     rsp,32
    call    puts
    add     rsp,32    
endProg:
ret

;-------------------------------------------------------------------
; RUTINAS INTERNAS          '1233',0
;-------------------------------------------------------------------
validarInput:
;-------------------------------------------------------------------
    mov     byte[filaValida],'N'

    mov     rsi,0
nextDig:
    cmp     byte[filaInput+rsi],0
    je      valFisOK

    cmp     byte[filaInput+rsi],'0'
    jl      finValidarInput
    cmp     byte[filaInput+rsi],'9'
    jg      finValidarInput
    inc     rsi
    jmp     nextDig
valFisOK:
	mov		rcx,filaInput        ;rcx
	mov		rdx,filaFormat      ;rdx
	mov		r8,filaNum         ;r8
	sub     rsp,32
    call	sscanf
	add     rsp,32

    cmp     word[filaNum],1
    jl      finValidarInput
    cmp     word[filaNum],15
    jg      finValidarInput

    mov     byte[filaValida],'S'
finValidarInput:
ret
;-------------------------------------------------------------------
calcDesplaMatriz:
;-------------------------------------------------------------------
    xor     rax,rax
    mov     ax,[filaNum]
    sub     ax,1
    imul    ax,30 ; longitud fila es 30 (15 * 2 bytes)

;    xor     rbx,rbx
    mov     bx,[columna]
    mov     bl,[columna]
    sub     bx,1
    imul    bx,2

    add     ax,bx
ret
;-------------------------------------------------------------------