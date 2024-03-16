;****************************************************************************************************
;ENUNCIADO:
;El juego BOMBERMAN se desarrolla en un espacio dividido en sectores que pueden estar 
;afectados por ninguna, una o más bombas. Cada bomba afecta al sector en el que se encuentra 
;y también a aquellos que se encuentran arriba, abajo y en sus laterales, formando una cruz 
;con centro en la posición de la bomba. La potencia de la bomba determina cuántas celdas en 
;cada dirección se extiende su alcance.

;El espacio está determinado por una matriz de 50x50 donde cada posición 
;representa a un sector y contiene un BPFc/s de 16 bits que almacena la cantidad de bombas
;que lo afectan. Se dispone de un archivo llamado BOMBAS.;DAT que contiene la ubicación y la
;potencia de las bombas. Cada registro ;del archivo está formado por los siguientes campos: 

;·   Fila: 2 bytes en formato carácter 
;·   Columna: 2 bytes en formato carácter 
;·   Potencia: binario de punto fijo con signo de 16 bits

;Se pide realizar un programa Assembler Intel que resuelva lo siguiente:

;a) Leer el archivo BOMBAS.DAT y por cada registro leído actualizar las 
;celdas que son afectadas por cada bomba.

;b) Como los datos del archivo pueden ser incorrectos, se deberá hacer uso 
;de rutina interna (VALREG) que deberá validar Fila, Columna y Potencia. 
;Teniendo en cuenta que el alcance no caiga fuera de la matriz. Los 
;registros inválidos serán descartados.

;c) Padrón PAR: Pedir por teclado el ingreso de un nro de  fila y mostrar 
;por pantalla los nros de columna que no estén amenazadas en dicha fila

;****************************************************************************************************
global  main
extern  gets
extern  printf
extern  sscanf
extern  puts
extern  fopen
extern  fread
extern  fclose

section     .data
    fileName      db "BOMBAS.DAT",0 
    mode          db "r",0
    msjErrorOpen  db "Error en apertura de Archivo",10,0
    msjIngFila    db "Ingrese una fila (1 a 50 inclusive): ",0
    msjColumnaNoAlcanzada  db "La columna %i no se encuentra dentro del rango de alguna bomba",10,0
    formatFIla    db "%i",0           
    matriz        times 2500  dw 0

    dimensiones   db "01020304050607080910111213141516171819202122232425"
                  db "26272829303132333435363738394041424344454647484950"  

    registro      times 0 db ""
    fila          times 2 db " "
    columna       times 2 db " "
    potencia      times 2 db " "

section     .bss
    fileHandle  resq 1
    filaBin     resw 1
    columnaBin  resw 1
    contador    resq 1
    desplazCol  resq 1
    desplazFil  resq 1
    filaIngresada resw 1
    esValido    resb 10
    buffer      resb 50

section     .text
main:
    call   abrirArchivo

    cmp    qword[fileHandle],0
    jle    ErrorOpen

    call   leerArchivo

    call   pedirIngreso

finPrograma:
    ret

ErrorOpen:
    mov    rdi,msjErrorOpen
    call   puts
    jmp    finPrograma

abrirArchivo:
    mov    rdi,fileName
    mov    rsi,mode
    call   fopen

    mov    [fileHandle],rax

    ret

leerArch:

leerReg:
    mov    rdi,registro
    mov    rsi,6
    mov    rdx,1
    mov    rcx,[fileHandle]
    call   fread

    cmp    rax,0
    jle    eof

    call   VALREG
    cmp    byte[esValido],'S'
    jne    leerReg

    call   actualizarMatriz

    jmp    leerReg
eof:
    mov    rdi,[fileHandle]
    call   fclose

    ret

VALREG:  ;PARA VALIDAR LAS FILAS Y COLUMNAS HAGO UNA VALIDACION POR TABLA

validarFila:
    mov    rbx,0
    mov    rcx,50
    mov    rax,0 ;fila convertida en numeros

compFila:
    inc    rax ;incremento en 1 por cada fila que itero
    mov    qword[contador],rcx ;guardo en una variable, tambien podria usar la pila (usando push)

    mov    rcx,2 ;cada fila ocupa 2 bytes
    lea    rsi,[fila]
    lea    rdi,[dimensiones + rbx]
    repe   cmpsb
    mov    rcx,qword[contador] ;tomo el valor que guarde (si uso pila haria pop)

    je     validarColumna
    add    rbx,2

    loop   compFila

    jmp    Invalido

validarColumna:
    mov    [filaBin],ax  ;guardo ax en filaBin, tengo el numero de fila

    mov    rbx,0
    mov    rcx,50
    mov    rax,0 ;columna convertida en numeros

compColumna:
    inc    rax ;incremento en 1 por cada columna que itero
    mov    qword[contador],rcx 

    mov    rcx,2 ;cada columna ocupa 2 bytes
    lea    rsi,[columna]
    lea    rdi,[dimensiones + rbx]
    repe   cmpsb
    mov    rcx,qword[contador] 

    je     validarPotencia
    add    rbx,2

    loop   compColumna

    jmp    Invalido

validarPotencia:
    mov    [columnaBin],ax  ;guardo el numero de columna en columnaBin
    
    cmp    word[potencia],0
    jl     Invalido
    mov    rax,0
    mov    ax,[filaBin]
    add    ax,[potencia]
    cmp    ax,50           ;si la potencia sumado a la fila supera 50 se va del rango de la matriz
    jg     Invalido
    mov    ax,[columnaBin]
    add    ax,[potencia]
    cmp    ax,50           ;idem con las filas para las columnas
    jg     Invalido

    mov    byte[esValido],'S'

finValidar:
    ret

Invalido:
    mov    byte[esValido],'N'
    jmp    finValidar


actualizarMatriz:
;actualizo primero en donde se encuentra la bomba
    mov    rax,0  
    mov    al,[columnaBin]
    dec    al     
    mov    bl,2           
    mul    bl             
    mov    [desplazCol],rax ;guardo el desp. Columna para luego moverme por las filas
        
    mov    ax,[filaBin]
    dec    ax
    mov    bl,100    
    mul    bl       
    
    mov    [desplazFil],rax
    add    rax,[desplazCol]  ;guardo el desp. Fila para luego moverme por las Columnas
    
    add    dword[matriz + rax],1

actualizoAlcance:

    mov    rcx,0
    mov    cx,[potencia] ;hago un loop para actualizar cada fila en base a la potencia
actualizoALcanceBombaFilas:
    ;actualizo las filas de 'arriba'
    mov    rax,0
    mov    ax,[filaBin]
    add    ax,cx
    dec    ax    
    mov    bl,100   
    mul    bl       
    add    rax,[desplazCol]  ;sumo ambos desplazamientos
    add    dword[matriz + rax],1

    ;actualizo las filas de 'abajo'
    mov    rax,0
    mov    ax,[filaBin]
    sub    ax,cx
    dec    ax    
    mov    bl,100   
    mul    bl       
    add    rax,[desplazCol]  ;sumo ambos desplazamientos
    add    dword[matriz + rax],1

    loop   actualizoALcanceBombaFilas

    mov    rcx,0
    mov    cx,[potencia] ;hago un loop para actualizar cada columna en base a la potencia
actualizoALcanceBombaColumnas:
    ;actualizo las columnas de la 'derecha'
    mov    rax,0
    mov    ax,[columnaBin]
    add    ax,cx
    dec    ax    
    mov    bl,2 
    mul    bl   
    add    rax,[desplazFil]  ;sumo ambos desplazamientos
    add    dword[matriz + rax],1

    ;actualizo las columnas de la 'izquierda'
    mov    rax,0
    mov    ax,[columnaBin]
    sub    ax,cx
    dec    ax    
    mov    bl,2    
    mul    bl      
    add    rax,[desplazFil]  ;sumo ambos desplazamientos
    add    dword[matriz + rax],1
    
    loop   actualizoALcanceBombaColumnas

    ret

pedirIngreso:
    mov    rdi,msjIngFila
    call   puts
    mov    rdi,buffer
    call   gets
    
    call   convertirFila

mostrarMatriz: ;calculo el desplazo de fila segun lo que ingreso el usuario
               ;asi guardo ese desplazo y lo utilizo para moverme en las columnas
    mov    rax,0
    mov    ax,[filaIngresada]
    dec    ax
    mov    bl,100    
    mul    bl       
    mov    [desplazFil],rax

muestroColumnasNoAfectadas:
    mov    rcx,0
    mov    cx,1
comparoAlcanceColumna:
    mov    rax,0
    mov    ax,cx
    dec    ax    
    mov    bl,2 
    mul    bl   

    add    rax,[desplazFil]  ;sumo ambos desplazamientos
    
    cmp    dword[matriz + rax],0
    je     mostrarColumna
    
seguirComparandoALcanceCol:
    inc    cx
    comp   cx,50
    jle    comparoAlcanceColumna

    ret

mostrarColumna:
    mov    rdi,msjColumnaNoAlcanzada
    mov    rsi,rcx
    mov    rax,0
    jmp    seguirComparandoALcanceCol

convertirFila:
    mov    rdi,buffer
    mov    rsi,formatFIla
    mov    rdx,filaIngresada

    call   checkAlign
    sub    rsp,[plusRsp]
    call   sscanf
    add    rsp,[plusRsp] 

    ret

;faltaria el checkAlign
