; Se dispone de una matriz de 12x12 que representa un edificio nuevo a estrenar, donde
; tiene 12 pisos con 12 departamentos en cada uno. Cada elemento de la matriz es un
; binario de 4 bytes, donde guarda el precio de venta en U$S de cada departamento. Se
; dispone de un archivo (PRECIOS.DAT) que contiene los precios de los departamentos,
; donde cada registro del archivo contiene los siguientes campos: 
;  Piso: Carácter de 2 bytes 
;  Departamento:  Binario de 1 byte  
;  Precio venta: Binario de 4 bytes
; Se pide realizar un programa en assembler Intel 80x86 que realice la carga de la matriz
; a través del archivo. Como la información del archivo puede ser incorrecta se deberá
; validar haciendo uso de una rutina interna (VALREG) que descartará los registros
; inválidos (la rutina deberá validar todos los campos del registro).
; Una vez finalizada la carga, se solicitará ingresar por teclado numero (x) y un precio de
; venta (no se requieren validar) y se deberá mostrar todos los departamentos/pisos cuyo
; precio de venta sea menor al ingresado.
; Para alumnos con padrón par, x será un numero de piso y se deberá mostrar por
; pantalla todos los nros de departamento cuyo precio sea inferior al ingresado en el piso
; ingresado.
; Para alumnos con padrón impar, x será un numero de departamento y se deberá
; mostrar por pantalla todos los nros de piso donde el departamento ingresado tenga
; precio inferior al ingresado.

global 	main
extern 	printf
extern	gets
extern 	sscanf
extern	fopen
extern	fread
extern	fclose
extern puts


section     .data

    archivo_nombre	    db	"PRECIOS.dat",0
    modo_apertura		db	"rb",0		; modo lectura del archivo binario
    msj_error_apertura	db  "Error en apertura de archivo",0

    registro        times 0     db ""
     piso           times 2     db " "
     departamento               db 0
     precio                     dd 0

    vec_pisos db "010203040506070809101112",0

                ;DEPARTAMENTOS
    matriz  dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0 ;PISOS
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0
            dd  0,0,0,0,0,0,0,0,0,0,0,0


    desplaz dq 0
    fila_piso dq 1

    registro_valido db 0
    dato_valido     db 0
    formato         db "%i",0 ;32 bits

    plusRsp db 0



    ;MENSAJES
    msj_ingreso_precio db "Ingrese precio del departamento: ",13,0
    msj_ingreso_departamento db "Ingrese numero de departamento: ",10,0
    msj_precio_bajo db "El departamento %li es baho ",0 


section     .bss

    puntero_archivo resb 1
    precio_ing_num resq 100
    depto_ing_num resq 100
    precio_ing     resb 100
    depto_ing        resb 100




section     .text
main:
    ;Abro archivo Beneficios
    mov		rdi,archivo_nombre
    mov     rsi,modo_apertura
	call	fopen

	cmp		rax,0
	jle		error_apertura
	mov     [puntero_archivo],rax

    leerRegistro:
    mov     rdi,registro
    mov     rsi,7      
    mov     rdx,1 ;lee de a un registro
	mov		rcx,[puntero_archivo] 
	call    fread

	cmp     rax,0   ;si no leyo nada del archivo, lo cerramos
    jle     cerrar	;aca termina la lectura y va al final de lo que pide la consigna

    ;Valido registro
	call	VALREG
    cmp		byte[registro_valido],0
    je		leerRegistro ;si el registro no es valido pasa al siguiente registro del archivo

    ;EN ESTE ESPACIO VA LA LLAMADA A LA RUTINA QUE AGARRA EL REGISTRO Y LO PROCESA 
    ;Luego se salta al siguiente registro
    call    actualizar_matriz

    jmp     leerRegistro


error_apertura:
    mov rdi,msj_error_apertura
    call puts
    jmp fin
cerrar:
    mov rdi,[puntero_archivo]
    call fclose
    call precio_menor
fin:
    ret



;*********************************************************** RUTINAS INTERNAS *******************************************************************


precio_menor:

    mov rdi,msj_ingreso_departamento
    call puts

    mov rdi,depto_ing
    call gets

    mov rdi,depto_ing
    mov rsi,formato
    mov rdx,depto_ing_num

    call checkAlign
    sub rsp,[plusRsp]
    call sscanf
    add rsp,[plusRsp]

    mov rdi,msj_ingreso_precio
    call puts

    mov rdi,precio_ing
    call gets

    mov rdi,precio_ing
    mov rsi,formato
    mov rdx,precio_ing_num

    call checkAlign
    sub rsp,[plusRsp]
    call sscanf
    add rsp,[plusRsp]

    ; [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ; longFila = longElemento * cantidad columnas
    mov r10,0 ;contador
sig_piso_:
    mov r11b,byte[depto_ing_num]
    dec  r11;columna -= 1
    imul r11,r11,4
    mov qword[desplaz],r11 

    

    mov rdx,qword[fila_piso]
    dec rdx
    imul rdx,rdx,48
    ;fijarte de resolver esto porque aca desplaz se va quedar con la anterior suma
    add qword[desplaz],rdx

    mov rbx,qword[desplaz]

    mov r9,[matriz + rbx]
    cmp r9,qword[precio_ing_num]
    jl  imprimir_piso

    inc r10
    add qword[fila_piso],1

    cmp r10,12
    jl  sig_piso_

ret

imprimir_piso:
    mov rdi,msj_precio_bajo
    mov rsi,qword[fila_piso]


ret

actualizar_matriz:
    ; [(fila-1)*longFila]  + [(columna-1)*longElemento]
    ; longFila = longElemento * cantidad columnas


    sub r8,1 ;fila -= 1
    imul r8,r8,48 ;12columns * 4 bytes
    mov qword[desplaz],r8

    sub rax,rax
    mov al,byte[departamento] ;columna -= 1
    sub rax,1
    imul rax,rax,4 
    add qword[desplaz],rax

    mov rbx,qword[desplaz] ;desplazamiento
    mov r12d,dword[precio]

    add dword[matriz + rbx],r12d

ret

VALREG:
    mov byte[registro_valido],0

    call val_piso
	cmp	byte[dato_valido],0
	je	fin_validar_registro

    call val_dpto
    cmp  byte[dato_valido],0
    je   fin_validar_registro


    mov byte[registro_valido],1

fin_validar_registro:
ret

val_dpto:
    mov byte[dato_valido],0
    
    cmp byte[departamento],1
    jl  fin_val_dpto

    cmp byte[dato_valido],12
    jg  fin_val_dpto

    mov byte[dato_valido],1

fin_val_dpto:
ret

val_piso:
    mov byte[dato_valido],0

    mov r8,0 ;contador
    mov rdx,0 ;indice_vector

sig_piso:

    mov rcx,2 ;cuantos bytes comparo
    mov rdi,[vec_pisos + rdx]
    mov rsi,piso

    repe cmpsb

    je  fin_val_piso

    add r8,1
    add rdx,2

    cmp r8,12
    jl sig_piso
    
    mov byte[dato_valido],1

fin_val_piso:

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