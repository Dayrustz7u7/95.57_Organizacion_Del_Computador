extern puts
extern gets
extern printf
extern sscanf
extern fopen
extern fwrite
extern fread
extern fclose

section 	.data
    promedioMasGrande db 0

    sumatoriaDiagonales dw 0
    

    ; Uso estas para recorrer la diagonal
    filaPivote db 0
    colPivote db 0

    archivo  db "diagonales.dat",0
	modo     db "rb",0
	msjError db "Error al leer archivo", 0

    longElemento db 2
	longFila db 20

    desplaz dw 1 
	fila db 0
	columna db 0

section 	.bss
    handler resb 1

    registro times 0 resb 4
        regFilaVertSup resb 1
        regColVertSup resb 1
        regFilaVertInf resb 1
        regColVertInf resb 1

    filaVertSup resb 1
    colVertSup resb 1
    filaVertInf resb 1
    colVertInf resb 1

    matriz times 100 resw 1

    diagonalInvalida resb 1

section 	.text
main:
	mov rdi,archivo
	mov rsi,modo
	sub rsp,8
	call fopen
	add rsp,8

	cmp rax, 0 
	jle errorArchivo
	mov [handler], rax

leerProximaDiagonal:
    mov byte[sumatoriaDiagonales],0
leerRegistro:

	mov rdi, registro
	mov rsi, 4
	mov rdx, 1
	mov rcx, [handler]
	sub rsp, 8
	call fread
	add rsp, 8

	cmp rax, 0 
	jle finArchivo

    sub rsp,8
    call VALREG
    ;valida que diagonales esten alineadas
    ;calcula el tam de la diago y lo guarda

    add rsp,8
    cmp byte[diagonalInvalida],"S"
    je leerProximaDiagonal

    mov byte[filaVertSup],regFilaVertSup
    mov byte[colVertSup],regColVertSup
    mov byte[filaVertInf],regFilaVertInf
    mov byte[colVertSup],regColVertInf

    mov byte[filaPivote],filaVertSup
    mov byte[colPivote],colVertSup
    
    ;con los limites superiores (vert  y col superior)
    ;y el tam de la diago puedo calcular la suma mas facil
    call sumarDiago

    ; Esto me da el promedio
    mov R8D,word[sumatoriaDiagonales] ;R8D = SumatoriaDiagonal (2 bytes)

    ;como la cant de eles esta en un byte... 
    mov al,byte[cantElementosDiagonal] ; 1) muevo a un registro de 1 byte AL =cantElesDiago  
    cbw  ;2) Convierte el byte almacenado en AL a una word en AX. (2 bytes)
    
    mov bx,ax ;BX = cantElementosDiagonal
    ;necesito el ax para la division

    mov ax,ax ;dejo en 0 por las dudas    
    mov ax,r8d ;AX = SumatoriaDiagonal
    
    idiv bx ; DX:AX / BX SumatoriaDiagonal/cantElementosDiagonal -> promedio = cociente = AX

    cmp ax,word[promedioMasGrande]    ;comparamos con el promedio anterior
    ;si actual - anterior < 0, voy a sig diagonal porque es mas chico
    jle leerProximaDiagonal
    ;sino cambio el valor
    mov word[promedioMasGrande],ax ;promedioMasGrande =nuevo promedio

    jmp leerProximaDiagonal

    ret
    ;mov   word[promedioMasGrande],ax ;dejamos el promedio mas grande

    ; idiv sumatoriaDiagonales,cantElementosDiagonal
    ; cmp sumatoriaDiagonales,promedioMasGrande
     ; Si mi promedio leido es mayor al promedio mas grande que hay, lo actualizo
     ;jle avanzarAProxDiagonal
     ;jle leerProximaDiagonal
     ;mov sumatoriaDiagonales,promedioMasGrande
    ;avanzarAProxDiagonal:
    ;     sub rsp,8
    ;     call leerProximaDiagonal
;     add rsp,8
    ;jmp leerProximaDiagonal
	
ret


; **************** ;
; RUTINAS INTERNAS ;
; **************** ;
errorArchivo:
	mov rdi, msjError
	sub rsp, 8
	call puts
	add rsp, 8
ret

finArchivo:
    mov rdi,[handler]
    sub rsp, 8
	call fclose
	add rsp, 8

    sub rsp,8
	call imprimirMayorProm
	add rsp, 8

    ;HACER ALGO MAS (PONER PROMEDIO MAS GRANDE)
ret

VALREG:
    mov byte[diagonalInvalida],"S"

    ; Resto las coordenadas de las filas
    sub r8,r8
    sub r9,r9
    mov r8,filaVertSup
    mov r9,filaVertInf
    sub r9,filaVertSup

    ; Resto las coordenadas de las columnas
    sub r10,r10
    sub r11,r11
    mov r10,colVertSup
    mov r11,colVertInf
    sub r11,colVertSup

    ; Si las diferencias son iguales es porque los elementos están en diagonal
    cmp r11,r9
    jne leerRegistro

    ; Quiero saber cuantos elementos tiene la diagonal. Me fijo si esta resta dio
    ; un numero negativo, y en tal caso, lo hago positivo
    cmp r11,0
    jg cantidadElementosValida

    neg r11
    mov [cantElementosDiagonal],r11

cantidadElementosValida:
    
    ; La cantidad de elementos de la diagonal es la diferencia + 1
    inc byte[cantElementosDiagonal]
    mov byte[diagonalInvalida],"N"


ret


sumarDiago:
    mov rcx,cantElementosDiagonal

sumaElementosDiagonal:

    inc byte[filaPivote]
	inc byte[colPivote] 
    ;me muevo 1 en diagonal (i+1, j+1)

	sub rax,rax
	mov al,[filaPivote]
	dec rax     ;(fila -1)
	sub r8,r8  ;??
	imul rax,[longFila]  ;desplaz en filas
	
    sub rbx, rbx
    mov bl, [colPivote]
    dec rbx
	sub r9,r9 ;??
    imul rbx, [longElemento]    ;desplaz en cols

    add ax,bx    ;;desplaz final en ax
    mov [desplaz],ax        ;desplaz final

    mov ebx,word[desplaz]   ;ebx = desplaz 

    sub r9, r9 ;?
    ;mov r10w, [matriz + eax] 
    ;mov r10d, word[matriz + eax] ;#correccion
    mov r10d, word[matriz + ebx] ;#correccion
    ;R10D = ELE ACTUAL ;elementos de #de 2 byte

    ;cargo suma parcial
	sub r11, r11
	mov r11d,word[sumatoriaDiagonales]
    ;R11D = SUMA PARCIAL

    ;sumo suma parical + ele actual
	add r11, r10
    ;R11D = SUMA PARCIAL + nuevo ele

    ;guardo la nueva suma parcial
	mov word[sumatoriaDiagonales],r11d

    loop sumaElementosDiagonal

ret

imprimirMayorProm:
    