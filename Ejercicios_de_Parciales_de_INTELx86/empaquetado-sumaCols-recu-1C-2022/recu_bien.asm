;Se pide realizar un programa en assembler Intel que realice un ciclo donde pida por teclado la configuración hexadecimal de un número empaquetado 
;y los valores i j correspondientes a una coordenada de una matriz (M).  El fin del ingreso por teclado se produce cuando el usuario ingresa ‘*’ en lugar 
;del número empaquetado

;La dimensión de M es 15x15 y sus elementos son números en formato binario de punto fijo con signo de 16 bits.  
;El programa deberá descartar ingresos inválidos.  Para ello hará  uso de una rutina interna llamada VALING que 
;validará los valores de i y j, el
;formato del empaquetado y que el número que representa entre en el formato destino.
;Los elementos de M que no fueron ocupados por un número ingresado por el usuario deberán ser 0.

;Por último el programa deberá mostrar por pantalla la siguiente información:

;Alumnos con padrón par: el valor promedio (entero) por cada columna de M.
;Alumnos con padrón impar: el valor promedio (entero) por cada fila de M.


;ACLARACION: cuando te dice que los tenees que guardar en la matriz, lo que tenes que hacer es guardar el numero en  base decimal, porque
;            cuando se guarde va a estar en bpf c/s (ya que es el formato en que se guardan los valores numericos). Lo que tenes que hacer
;            es lograr obtener ese numero que esta almacenado en el empaquetado que se ingresa

global 	main
extern 	printf
extern	gets
extern 	sscanf
extern puts



section     .data

    matriz times 225 dw 0 ;matriz de 15 x 15
    desplaz dq 0
    plusRsp db 0
    sumatoria dq 0
    coordenada_fila_num      dq 0 
    coordenada_columna_num   dq 0
    numero_1 dq 1
    aux dq 0
    
    vector_signo db "bdcafe",0

    formato db "%hi",0

    ;mensajes:
    msj_pedir_coordendadaX db "Ingrese la coordenada fila: ",0
    msj_pedir_coordendadaY db "Ingrese la coordenada columna: ",0
    msj_pedir_empaquetado db "Ingrese un numero en empaquetado hexadecimal: ",0
    msj_informe db "El numero ingresado fue: %hi",10,0
    msj_log db "Entre a validar empaquetado",0
    msj_log2 db "La letra es: %c",10,0
    msj_log3 db "pude validar letra",0
    msj_log4 db "el contador de digitos llego hasta: %li",0
    msj_log5 db "la letra del vector es: %c",0
    msj_log6 db "siguiente letra",0
    msj_log7 db "multiplique por -1",0
    msj_log8 db "entre al no_negativo",0
    ;validadores:
    coordenada_valida db 0
    empaquetado_valido db 0
    valores_validos db 0
    numero db "",0


section     .bss

    empaquetado          resb 100
    coordenada_fila      resb 100
    coordenada_columna   resb 100
    letra                resb 10
    numero_num           resb 100


section     .text
main:

coordenadas:
    mov byte[numero],""
    mov byte[numero + 1],""
    mov byte[numero + 2],""
    ;PEDIR COORDENADAS
    mov rdi, msj_pedir_coordendadaX
    sub rax,rax
    call printf

    mov rdi,coordenada_fila
    call gets

    mov rdi,coordenada_fila
    mov rsi,formato
    mov rdx,coordenada_fila_num

    call checkAlign
    sub rsp,[plusRsp]
    call sscanf
    add rsp,[plusRsp]

    cmp rax,1
    jl  coordenadas

    mov rdi,msj_pedir_coordendadaY
    sub rax,rax
    call printf

    mov rdi,coordenada_columna
    call gets

    mov rdi,coordenada_columna
    mov rsi,formato
    mov rdx,coordenada_columna_num

    call checkAlign
    sub rsp,[plusRsp]
    call sscanf
    add rsp,[plusRsp]

    cmp rax,1
    jl  coordenadas

    
pedir_empaquetado:

    ;PEDIR EMPAQUETADO
    mov rdi,msj_pedir_empaquetado
    sub rax,rax
    call printf

    mov rdi,empaquetado
    call gets

    cmp byte[empaquetado],"*"
    je  informe

    call VALING
    ;si los valores no son validos volves a pedir todo
    cmp  byte[valores_validos],0
    je coordenadas

    call informe
    ;call actualizar_matriz

    jmp coordenadas

ret

;*********************************************************** RUTINAS INTERNAS *******************************************************************

VALING:
    ;el fin_rutina sirve para cuando la validacion detecta que el input esta mal y tiene que ir al fin para que se ejecute la ret y vuelva

    mov byte[valores_validos],0
    
    call val_coordenadax
    cmp  byte[coordenada_valida],1
    jl  fin_valing

    call val_coordenaday
    cmp byte[coordenada_valida],1
    jl fin_valing

    call val_empaquetado
    cmp byte[empaquetado_valido],1
    jl fin_valing

    mov byte[valores_validos],1

fin_valing:
ret


val_coordenadax:

    mov byte[coordenada_valida],0

    cmp qword[coordenada_fila_num],1
    jl  fin_val_coordenadax

    cmp qword[coordenada_fila_num],15
    jg  fin_val_coordenadax

    mov byte[coordenada_valida],1

fin_val_coordenadax:
ret

val_coordenaday:

    mov byte[coordenada_valida],0

    cmp qword[coordenada_columna_num],1
    jl  fin_val_coordenaday

    cmp qword[coordenada_columna_num],15
    jg  fin_val_coordenaday

    mov byte[coordenada_valida],1

fin_val_coordenaday:
ret

val_empaquetado:

    mov rdi,msj_log
    call puts

    mov byte[empaquetado_valido],0
    ;Lo que tenemos que validar es que:
    ;-los primeros numeros esten en base decimal (entre 0 y 9) y el ultimo sea una de las letras validas (CAFEBD)
    ;-el numero en decimales tendria que poder guardarse en 16 bits

    mov rbx,0 ;contador
sig_digito:
    

    cmp byte[empaquetado + rbx],"0"
    jl valida_letra

    cmp byte[empaquetado + rbx],"9"
    jg valida_letra

    cmp byte[empaquetado + rbx],0
    je fin_val_empaquetado
    
    mov r9b,byte[empaquetado + rbx]
    mov byte[numero + rbx],r9b

    inc rbx
    jmp sig_digito

valida_letra:
    

    ;valida que, si es un digito que no esta en base 10, tendria que ser el ultimo (la letra)
    cmp byte[empaquetado + rbx + 1],0
    jne fin_val_empaquetado

    mov r10,-1 ;contador, que va a tener la posicion de la letra en el vector
sig_letra:
    
    
    add r10,1
    cmp r10,5
    jg fin_val_empaquetado
    mov rdi,msj_log6
    call puts

    sub rdi,rdi
    sub rsi,rsi
    mov rcx,1 ;bytes a comparar
    lea rdi,[vector_signo + r10]
    lea rsi,[empaquetado + rbx]

    

    repe cmpsb
    jne sig_letra

    

    mov rdi,msj_log3
    call puts

    mov qword[aux],r10


    mov rdi,numero
    mov rsi,formato
    mov rdx,numero_num
    call checkAlign
    sub rsp,[plusRsp]
    call sscanf
    add rsp,[plusRsp]


    mov r10,qword[aux]
    cmp r10,2
    jge  no_negativo
    ;no se porque salta siempre al no_negativo
    mov rdi,msj_log7
    call puts
    ;si la letra es B o D, el numero es negativo
    mov r12w,word[numero_num]

    
    imul r12,-1
    mov word[numero_num],r12w
no_negativo:
    mov rdi,msj_log8
    call puts
    cmp word[numero_num],32767 ;si es menor al mayor numero representable en bpf c/s de 16 bits
    jg fin_val_empaquetado

    cmp word[numero_num],-32768
    jl fin_val_empaquetado

    mov byte[empaquetado_valido],1 ;si llego hasta aca es porque el ultimo digito era una letra valida


fin_val_empaquetado:
ret




informe:
    sub rdx,rdx
    mov rdi,msj_informe
    mov rsi,[numero_num]
    sub rax,rax
    call printf


ret




;----------------------------------------
;----------------------------------------
; ****	checkAlign ****
;----------------------------------------
;----------------------------------------
checkAlign:
	push rax
	push rbx
;	push rcx
	push rdx
	push rdi

	mov   qword[plusRsp],0
	mov		rdx,0

	mov		rax,rsp		
	add     rax,8		;para sumar lo q restó la CALL 
	add		rax,32	;para sumar lo que restaron las PUSH
	
	mov		rbx,16
	idiv	rbx			;rdx:rax / 16   resto queda en RDX

	cmp     rdx,0		;Resto = 0?
	je		finCheckAlign
	mov   qword[plusRsp],8
finCheckAlign:
	pop rdi
	pop rdx
;	pop rcx
	pop rbx
	pop rax
	ret