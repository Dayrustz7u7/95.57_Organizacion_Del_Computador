global	main
extern	printf
extern	gets
extern	sscanf
extern	puts

section .data
   msjconteoMatriz    db   "Define X matrices siendo  0 < X <= 5: ",0
   msjErrorMaxMatriz  db   "El numero que ingresaste no esta dentro del Rango, vuelva a intentarlo",0
   msjErrorCaso1_2    db   "Error, elegiste la Operacion Suma o Multiplicacion, debes ingresar dos valores! Vuelve a intentarlo",0
   msjErrorNumero     db   "El dato que ingresaste es incorrecto, vuelva a intentarlo",0
   msjErrorDim        db   "Error: Las dimensiones de las matrices no son compatibles, Vuelva intentarlo.",0
   msjIngFilCol		    db	 "Matriz %hi: Ingrese el tamanio de N (1 a 8) y M (1 a 8) separados por un espacio: ",0
   msjIngNumero		    db	 "Matriz %hi:=> Ingrese el numero (-99 a 99): ",0
   msjIngOpcion       db   "Ingrese una Opcion Valida de (1 a 6): ",0
   msjIngPosMatriz    db   "Matriz %li: Ingrese el i y j separados por un espacio: ",0
   msjIngSumarOtravez db   "Desea Seguir sumando  La Matriz Resultado con las Matrices disponibles?(S o N): ",0
   msjResultConsulta  db   "Este es el Numero de la Posicion que consultaste: %li ",10,0
   msjResulTrans      db   "Este es el Resultado de tu Matriz %li Transpuesta :) ",10,0
   msjResulSuma       db   "Este es el resultado de la Suma de la Matriz %li con la Matriz %li : ",10,0
   msjResulMulti      db   "Este es el resultado de la Multiplicacion de la Matriz %li con la Matriz %li : ",10,0
   msjResultSuma_Y    db   "Este es el resultado de la Matriz Suma con la Matriz %li : ",10,0
   msjFinPrograma     db   "Adios >:D ",0
   msjMatriz          db   "Tu Matriz elegida es ---> Matriz %li ",10,0
   
   msjMenu            db   "Menu de Operaciones, Elija un numero",0
   msjOperacion_1     db   " 1.- Sumar 2 o mas matrices.",0
   msjOperacion_2     db   " 2.- Producto de Solo 2 matrices",0
   msjOperacion_3     db   " 3.- Trasponer 1 matriz",0
   msjOperacion_4     db   " 4.- Modificar el Valor de un Elemento de una Matriz",0
   msjOperacion_5     db   " 5.- Consultar el Valor de un Elemento de una Matriz",0
   msjOperacion_6     db   " 6.- Cerrar el Programa",0

   msjMatricesDisponibles  db   "  %hi .- Matriz %hi ",10,0
   msjIngNumMatriz         db   " Ingrese una Opcion Valida de (1 a %hi) y de ser Suma o Multiplcacion, Escriba 2 opciones -> x y : ",0

   formatMaxMatriz    db   "%hi",0
   formatInputFilCol	db	 "%hi %hi",0
   formatInputNum     db   "%li",0
   formatInputX_Y     db   "%li %li",0
   
   ImprimirNumMatriz  db   " %li ",0 ;Con printf
   NewLine            db   "",0 ;CON PUTS
   
   Fila_A  dw 0
   Col_A   dw 0
   Fila_B  dw 0
   Col_B   dw 0
   Fila_C  dw 0
   Col_C   dw 0
   Fila_D  dw 0
   Col_D   dw 0
   Fila_E  dw 0
   Col_E   dw 0

   Matriz_A  times 64 dq 0
   Matriz_B  times 64 dq 0
   Matriz_C  times 64 dq 0
   Matriz_D  times 64 dq 0
   Matriz_E  times 64 dq 0

   Matriz_Trans times 64 dq 0
   Matriz_Suma  times 64 dq 0
   Matriz_Multi times 64 dq 0

   pos_i   dw 1
   pos_j   dw 1
   pos_i_x dw 1
   pos_j_x dw 1
   longElemento dw 8 ;8bytes debido a que adentro son 62 bits
   N_veces_impr  dw 0
   Contador dw 0
   SumaPivote dq 0

section .bss
   inputMaxMatriz    resb  100 ;Este es lo que ingresa el usuario
   inputFilCol       resb  50  ;Este es lo que ingresa el usuario
   inputNumero       resb  50  ;Este es lo que ingresa el usuario
   inputOpcion       resb  50  ;Este es lo que ingresa el usuario
   inputOpcionSum    resb  50  ;Este es lo que ingresa el usuario ;UN Error es cuando te ingresan una Frase comenzando con S o N
   
   inputValidoNum    resb  1 ;----> S o N
   inputValidoCont   resb  1 ;----> S o N
   inputValidoFilCol resb  1 ;----> S o N
   inputValidoOpcion resb  1 ;----> S o N
   inputValidoDimen  resb  1 ;----> S o N
   inputRecorr       resb  1 ;----> S o N
   inputMatrizTrans  resb  1 ;----> S o N
   inputMatrizSuma   resb  1 ;----> S o N
   inputMatrizMulti  resb  1 ;----> S o N
   inputImprimir     resb  1 ;----> S o N
   inputMultiplicar  resb  1 ;----> S o N
   
   TotalMatrices     resw  1 ;----> X matrices
   Fila			         resw	 1 ;PIVOTE FILA DE UNA MATRIZ
	 Columna			     resw	 1 ;PIVOTE COL  DE UNA MATRIZ

   FilaY             resw  1
   ColY              resw  1
   FilaX             resw  1
   ColX              resw  1

   VarAuxLoop2       resq  1 ;PIVOTE AUX para Fil o COL
   VarAuxLoop        resq  1 ;Pivote al Contador LOOP
   Numero            resq  1 ;PIVOTE AL NUMERO QUE SE CARGARA EN LA MATRIZ
   NumX              resq  1
   desplaz           resw  1 ;PIVOTE AL DESPLAZAMIENTO DE CADA MATRIZ
   Opcion            resq  1 ;PIVOTE A LA OPeracioN ELEGIDA
   OpcionMatriz      resq  1 ;PIVOTE A LA MATRIZ ELEGIDA
   elemento          resq  1 ;Pivote para ver cada elemento de la matriz "IMPRIMIR"
   Matriz_X          resq  1 ;PIVOTE A LA X ELEGIDA,Sirve para la suma o multiplicacion
   Matriz_Y          resq  1 ;PIVOTE A LA y ELEGIDA,Sirve para la sumo o multiplicacion


section .text

main:
   mov   rdi,msjconteoMatriz
   sub   rsp,8
   call  printf    ;Luego cambiarlo por printf
   add   rsp,8

   mov   rdi,inputMaxMatriz
   sub   rsp,8
   call  gets
   add   rsp,8

   sub	rsp,8
   call	ValidarMaxMatrices
   add	rsp,8
    
   cmp   byte[inputValidoCont],'S' 
   je    ValidoTotalMatrices

   mov   rdi,msjErrorMaxMatriz
   sub   rsp,8
   call  puts
   add   rsp,8
   jmp   main

 ValidoTotalMatrices:
   
   mov    rcx,[TotalMatrices]

 PedirValoresMatrices:
   sub    r12,r12
   mov    r12,rcx
   add    word[Contador],1

   sub    rsp,8
   call   PedirFilyCol
   add    rsp,8

   sub    rsp,8
   call   AsignacionFilCol_a_Matriz
   add    rsp,8
   
   sub    rsp,8
   call   LlenarDatos
   add    rsp,8

   mov    rcx,r12
   loop   PedirValoresMatrices
   
 ;Aqui terminamos de llenar todos los datos de las matrices, lo que falta ya es el menu de operaciones
 Menu_de_Opciones:
   sub    rsp,8
   call   PedirOpcion
   add    rsp,8
   
   sub    rsp,8
   call   OpcionElegida
   add    rsp,8

   ;AQUI TENGO QUE INICIALIZAR DENUEVO TODOS LOS RESULTADOS
   
   cmp    qword[Opcion],6
   jne    Menu_de_Opciones
ret

;FIN PROGRAMA PRINCIPAL
;*********************************
; RUTINAS INTERNAS
;*********************************
;===================================================================================================
ValidarMaxMatrices:
   mov    byte[inputValidoCont],'N'
   mov    rdi,inputMaxMatriz
   mov    rsi,formatMaxMatriz
   mov    rdx,TotalMatrices
   sub    rsp,8
   call   sscanf
   add    rsp,8

   cmp    rax,1
   jl     DatoIncorrecto
   
   cmp	 word[TotalMatrices],1  ;SI es menor a 1 es Dato Incorrecto
   jl	    DatoIncorrecto
   cmp	 word[TotalMatrices],5  ;Si es mayor a 5 es Dato incorrecto 
   jg	    DatoIncorrecto  

   mov    byte[inputValidoCont],'S'
 DatoIncorrecto:
ret
;===================================================================================================
PedirFilyCol:
   mov		rdi,msjIngFilCol
   mov      rsi,[Contador]
	sub		rsp,8
	call	   printf
	add		rsp,8
   
   mov	   rdi,inputFilCol	
	sub		rsp,8	
   call     gets    
	add		rsp,8
   
   sub		rsp,8
   call	   ValidarFilyCol
	add	   rsp,8 

   cmp	  byte[inputValidoFilCol],'S'
	je      Seguir
   
   mov     rdi,msjErrorMaxMatriz
   sub     rsp,8
   call    puts
   add     rsp,8
   jmp     PedirFilyCol

 Seguir:
ret
;===================================================================================================
ValidarFilyCol:
   mov	   byte[inputValidoFilCol],'N'
   mov      rdi,inputFilCol ;Por ej lo que ingresa el usuario es "1 2" <--Fila 1 Columna 2
   mov      rsi,formatInputFilCol
	mov		rdx,Fila
	mov		rcx,Columna
	sub		rsp,8
	call	   sscanf
	add		rsp,8

   cmp      rax,2
   jl       InvalidoFilCol

	cmp		word[Fila],1
	jl		   InvalidoFilCol
	cmp		word[Fila],8
	jg		   InvalidoFilCol    

   cmp		word[Columna],1
	jl		   InvalidoFilCol
	cmp		word[Columna],8
	jg		   InvalidoFilCol  

   mov		byte[inputValidoFilCol],'S'
 InvalidoFilCol:
ret
;===================================================================================================
AsignacionFilCol_a_Matriz:
   sub  r13,r13
   sub  r11,r11
   
   mov  r13w,[Fila]
   mov  r11w,[Columna]

   cmp  word[Contador],1
   je   MatrizA
   
   cmp  word[Contador],2
   je   MatrizB

   cmp  word[Contador],3
   je   MatrizC

   cmp  word[Contador],4
   je   MatrizD

   cmp  word[Contador],5
   je   MatrizE
   ;POSIBLE JMP FIN si da errores
 MatrizA:
   mov  word[Fila_A],r13w
   mov  word[Col_A],r11w
   jmp Fin
 MatrizB:
   mov  word[Fila_B],r13w
   mov  word[Col_B],r11w
   jmp Fin
 MatrizC:
   mov  word[Fila_C],r13w
   mov  word[Col_C],r11w
   jmp Fin
 MatrizD:
   mov  word[Fila_D],r13w
   mov  word[Col_D],r11w
   jmp Fin
 MatrizE:
   mov  word[Fila_E],r13w
   mov  word[Col_E],r11w
   jmp Fin
 Fin:       
ret
;===================================================================================================
LlenarDatos:
   imul   r13,r11   ; N (ACTUAL) X  M (ACTUAL) --> Actual de Numeros a poner en la matriz
   mov    rcx,r13   ;Servira para el Loop y cuantas veces pida el numero hasta llenar la matriz
 Ingresar_Num_a_Matriz:
   sub    r14,r14
   mov    r14,rcx
   
   sub    rsp,8
   call   PedirNumero
   add    rsp,8
   
   sub    rsp,8
   call   calcDesplaz
   add    rsp,8

   sub    rsp,8
   call   AsignacionNum_a_Matriz
   add    rsp,8

   mov    rcx,r14
   loop   Ingresar_Num_a_Matriz
   ;Cuando ya se completo el loop, es hora de volver a inicializar i,j y desplaz en 0 para la proxima matriz
   
   mov  word[pos_i],1
   mov  word[pos_j],1
   

ret
;===================================================================================================
PedirNumero:
  mov		rdi,msjIngNumero
  mov   rsi,[Contador]
	sub		rsp,8
	call	printf
	add		rsp,8

  mov		rdi,inputNumero
	sub		rsp,8
  call  gets   
	add		rsp,8	

  sub		rsp,8
  call  ValidarNumero   
	add		rsp,8	

  cmp	  byte[inputValidoNum],'S'
	je    Seguir1
   
  mov     rdi,msjErrorNumero
  sub     rsp,8
  call    puts
  add     rsp,8
  jmp     PedirNumero

 Seguir1:
ret
;===================================================================================================
ValidarNumero:
   mov	   byte[inputValidoNum],'N'
   mov      rdi,inputNumero 
   mov      rsi,formatInputNum
	mov		rdx,Numero
	sub		rsp,8
	call	   sscanf
	add		rsp,8
   
   cmp      rax,1
   jl       InvalidoNumero

   cmp      qword[Numero],-99
   jl       InvalidoNumero

   cmp      qword[Numero],99
   jg       InvalidoNumero

   mov	   byte[inputValidoNum],'S'

 InvalidoNumero:
ret
;===================================================================================================
calcDesplaz:
 Inicio:
	mov		bx,[pos_i]
	sub		bx,1

  cmp      bx,[Fila]
  je       FinDesplaz   ;Bifurco al Final cuando bx ya eS IGUAL A Fila 

	imul	   bx,8		;bx tengo el desplazamiento a la fila , Multiplico x8 debido a que son 8 columnas la matriz general
  imul     bx,word[longElemento]
   
  mov		[desplaz],bx

	mov		bx,[pos_j]
	dec		bx
	
  cmp      bx,[Columna]    ;Cuando J es igual a Columna -> J:Col, Vas a sumar I y reiniciar J
  je       Siguiente_Fila

  imul	   bx,word[longElemento]			; bx tengo el deplazamiento a la columna

  add		[desplaz],bx	; en desplaz tengo el desplazamiento final


   add      word[pos_j],1
   jmp      FinDesplaz 
 Siguiente_Fila:
   add      word[pos_i],1
   mov      word[pos_j],1
   jmp      Inicio         ; BIfurco Inicio para no perder 1 vez  en el loop principal 
 FinDesplaz: 
ret
;===================================================================================================
AsignacionNum_a_Matriz:
   sub  r11,r11
   sub  r10,r10                       ;NOTAR QUE NO FUNCIONA EN LA RUTINA CONS_MOD matriz
   mov  r11,[Numero]
   mov  r10w,[desplaz]

   cmp  word[Contador],1
   je   Matriz_1
   cmp  word[Contador],2
   je   Matriz_2
   cmp  word[Contador],3
   je   Matriz_3
   cmp  word[Contador],4
   je   Matriz_4
   cmp  word[Contador],5
   je   Matriz_5
   ;POSIBLE JMP FIN si da errores
 Matriz_1:
   mov qword[Matriz_A + r10],r11
   jmp FinAsignacionNum
 Matriz_2:
   mov qword[Matriz_B + r10],r11
   jmp FinAsignacionNum
 Matriz_3:
   mov qword[Matriz_C + r10],r11
   jmp FinAsignacionNum
 Matriz_4:
   mov qword[Matriz_D + r10],r11
   jmp FinAsignacionNum
 Matriz_5:
   mov qword[Matriz_E + r10],r11
   jmp FinAsignacionNum
 FinAsignacionNum:
ret
;===================================================================================================
PedirOpcion:
   sub    rsp,8
   call   ImprimirMenuOpciones
   add    rsp,8

   mov   rdi,inputOpcion
   sub   rsp,8
   call  gets
   add   rsp,8

   sub   rsp,8
   call  ValidarOpcion
   add   rsp,8

   cmp	  byte[inputValidoOpcion],'S'
	je      Valido_Opcion
   
   mov     rdi,msjErrorMaxMatriz
   sub     rsp,8
   call    puts
   add     rsp,8
   jmp     PedirOpcion
 Valido_Opcion:
ret
;===================================================================================================
ImprimirMenuOpciones:
   mov  rdi,msjMenu
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_1
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_2
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_3
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_4
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_5
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjOperacion_6
   sub  rsp,8
   call puts
   add  rsp,8

   mov  rdi,msjIngOpcion
   sub  rsp,8
   call printf
   add  rsp,8
ret
;===================================================================================================
ValidarOpcion:
   mov	   byte[inputValidoOpcion],'N'
   mov      rdi,inputOpcion ;Por ej lo que ingresa el usuario es "1 2" <--Fila 1 Columna 2
   mov      rsi,formatInputNum
	 mov		   rdx,Opcion
	 sub		rsp,8
	 call	   sscanf
	 add		rsp,8

   cmp      rax,1
   jl       InvalidoOpcion

	cmp		word[Opcion],1
	jl		   InvalidoOpcion
	cmp		word[Opcion],6
	jg		InvalidoOpcion    

   mov		byte[inputValidoOpcion],'S'
 InvalidoOpcion:
ret
;===================================================================================================
OpcionElegida:
  sub  r13,r13
  mov  r13,[Opcion]
  mov    byte[inputOpcionSum],'N'
  mov    byte[inputImprimir],'N'
   
  cmp  qword[Opcion],6
  je   Opcion6

  sub rsp,8
  call Matrices_Disponibles
  add rsp,8
  
  sub  rsp,8
  call AsignarFil_Col_Aux  ;ESTO ESTA ADENTRO DE TRANPONER MATRIZ PERO PUEDE ESTAR AFUERA DEBAJO DE MATRICES DISPONIBLES
  add  rsp,8

   cmp  qword[Opcion],1
   je   Opcion1
   cmp  qword[Opcion],2
   je   Opcion2
   cmp  qword[Opcion],3
   je   Opcion3
   cmp  qword[Opcion],4
   je   Opcion4y5
   cmp  qword[Opcion],5
   je   Opcion4y5


 Opcion1:
   ;mov  byte[inputOpcionSum],'N'
   sub  rsp,8
   call SumarMatrices
   add  rsp,8

   jmp FinOpcion
 Opcion2:
   sub  rsp,8
   call MultiplicarMatrices
   add  rsp,8
   
   jmp FinOpcion
 Opcion3:

   sub  rsp,8
   call TransponerMatriz
   add  rsp,8
  ;-------------------------------------------------------------------------
  jmp FinOpcion
 Opcion4y5:
   sub  rsp,8
   call Modificar_Consultar_Matriz
   add  rsp,8         

   jmp FinOpcion
 Opcion6:
   mov  rdi,msjFinPrograma
   sub  rsp,8
   call puts
   add  rsp,8
 FinOpcion:
  mov		  rdi,NewLine
  sub		  rsp,8
  call	  puts
  add		  rsp,8
ret
;===================================================================================================
Matrices_Disponibles:
   sub r12,r12
   mov r12w,[TotalMatrices]
   mov word[Contador],1    ;Inicializo otra vez el Contador para hacerle saber al usuario que solo puede N matrices

 N_Matrices:
  mov  rdi,msjMatricesDisponibles
  mov  rsi,[Contador]
  mov  rdx,[Contador]
  sub  rsp,8
  call printf                 ;NOTA : Aqui probe con un loop y no entiendo porque se me iba al infinito los printf
  add  rsp,8
   
  add word[Contador],1
  cmp [Contador],r12w
  jle  N_Matrices

 PedirOpcionMatriz:

  mov  rdi,msjIngNumMatriz
  mov  rsi,[TotalMatrices]
  sub  rsp,8
  call printf
  add  rsp,8

  mov   rdi,inputOpcion
  sub   rsp,8
  call  gets
  add   rsp,8
  
  cmp   r13w,3  ;Me fijo si la opcion de Operacion es 1 o 2 para que valide de otra manera
  jl    Caso_1_2
   ;Aqui puede haber una validacion y en un registro evaluar en que opcion esta y bifurcar en cada validacion 
  sub	rsp,8
  call	ValidarOpcion_Matriz
  add	rsp,8

  cmp	  byte[inputValidoOpcion],'S'
	je      Valido_Opcion_Matriz
   
  mov     rdi,msjErrorMaxMatriz
  sub     rsp,8
  call    puts
  add     rsp,8
  jmp     PedirOpcionMatriz
 Caso_1_2:

  sub	rsp,8
  call	ValidarOpcion_Caso1_2
  add	rsp,8

  cmp	  byte[inputValidoOpcion],'S'
	je      Valido_Opcion_Matriz

  mov     rdi,msjErrorCaso1_2
  sub     rsp,8
  call    puts
  add     rsp,8
  jmp     PedirOpcionMatriz

 Valido_Opcion_Matriz:
ret
;===================================================================================================
ValidarOpcion_Matriz:
  mov	   byte[inputValidoOpcion],'N'
  mov    rdi,inputOpcion ;Por ej lo que ingresa el usuario es "1 2" <--Fila 1 Columna 2
  mov    rsi,formatInputNum
	mov		 rdx,OpcionMatriz     ;Opcion tamano resq
	sub		 rsp,8
	call	 sscanf
	add	   rsp,8

  cmp    rax,1
  jl     InvalidoOpcion_Matriz

	cmp		 qword[OpcionMatriz],1
	jl		 InvalidoOpcion_Matriz
	cmp		 word[OpcionMatriz],r12w
	jg		 InvalidoOpcion_Matriz    

  mov		byte[inputValidoOpcion],'S'
 InvalidoOpcion_Matriz:
ret
;===================================================================================================
ValidarOpcion_Caso1_2:
   mov	   byte[inputValidoOpcion],'N'
   mov      rdi,inputOpcion 
   mov      rsi,formatInputX_Y
	mov		rdx,Matriz_X
   mov      rcx,Matriz_Y     
	sub		rsp,8
	call	   sscanf
	add		rsp,8

   cmp      rax,2
   jl       Invalido_X_Y_Matriz

   cmp		qword[Matriz_X],1
	jl		   Invalido_X_Y_Matriz
	cmp		word[Matriz_X],r12w
	jg		   Invalido_X_Y_Matriz 

   cmp		qword[Matriz_Y],1
	jl		   Invalido_X_Y_Matriz
	cmp		word[Matriz_Y],r12w
	jg		   Invalido_X_Y_Matriz  

   mov		byte[inputValidoOpcion],'S'
 Invalido_X_Y_Matriz:
ret
;===================================================================================================
MultiplicarMatrices:;#########################################################################################
  sub   r11,r11
  sub   r12,r12
  mov   byte[inputMultiplicar],'S'
  sub   rsp,8
  call  ValidarDimensionesMatriz
  add   rsp,8

  sub    rsp,8
  call   ImprimirXeY
  add    rsp,8
  
  cmp     byte[inputValidoDimen],'N'
  je      Matrices_NoCompatibles

  sub    rsp,8
  call   MultiplicarXeY
  add    rsp,8

  ;----------------------------------------------------------------
  mov    rdi,msjResulMulti
  mov    rsi,[Matriz_X]
  mov    rdx,[Matriz_Y]
  sub		 rsp,8                             
	call	 printf       
	add		 rsp,8

  mov    r14w,[FilaX]
  mov    word[Fila],r14w
  mov    r14w,[ColY]
  mov    word[Columna],r14w
  mov    byte[inputMatrizMulti],'S'
  sub		 rsp,8                             
	call	 Imprimir_Matrices               ;Sirve para imprimir la matriz resultado
	add		 rsp,8
  mov    byte[inputMatrizMulti],'N'
 ;----------------------------------------------------------------
  
  jmp     FinMultiplicar
 Matrices_NoCompatibles:
  mov    rdi,msjErrorDim
  sub		 rsp,8                             
	call	 puts
	add		 rsp,8
 FinMultiplicar:
ret
MultiplicarXeY:
  ;matrizX : 3x4 / matrizY: 4x2 = matrizZ:3x2
 sub  rcx,rcx
 mov  word[pos_i_x],1
 mov  word[pos_j_x],1
 mov  byte[inputRecorr],'S'  ;Aqui Activo el Recorrido Vertical
 mov  cx,[FilaX]
 ;------------------------------------------------------------------------------------------------------------------------------------
 N_veces_MatrizX: ;Loop de Columnas de 3 de Fil X
  mov  [VarAuxLoop],rcx
  mov   r12w,[pos_i_x]
  sub   r11,r11
  mov   r11w,[FilaY]
  imul  r11w,[ColY]
  mov   rcx,r11
  mov   word[pos_i],1
  mov   word[pos_j],1
  ;===============================================================================================================================
  N_veces_MatrizY:
  mov      [VarAuxLoop2],rcx
  mov      r13w,[pos_j_x]            ;mueve j_x debido a que siempre sera el mismo recorrido para esas partes,EJMP EXCEL
  mov      r12w,[pos_i_x]            ;mueve lo que tiene guardado para las iteraciones en la MATRIZ X
  
  sub      rsp,8                  
  call     Calc_Dezplaz_Multiplicar  ;Calculo el desplaz de la Matriz X con r12w = FilX y r13w = ColX
  add      rsp,8
                                     ;Luego de esto tengo el desplaz
  sub      r13,r13 
  mov      r13w,[desplaz]
  mov      r10,[Matriz_X]            ;Sirve para actualizar y obtener el Numero de la matriz es X
  mov      [OpcionMatriz],r10
  
  sub      rsp,8                  
  call     ObtenerNumero_Matriz       ;en r12 tengo el numero
  add      rsp,8
  
  mov      [NumX],r12
  add      word[pos_j_x],1            ;1,2\1,3\1,4 \\ 2-1                                             ;ESTA PARTE ES PARA MATRIZ X^
  ;--------------------------------------------------------------------------------------------------------------------------------
                                   
  sub      rsp,8                  ;Aqui TENES EL DESPLAZ DE LA MATRIZ  M X N y el Recorrido es Vertical
  call     RecorrerMatriz         ;Puedo usar este recorrido debido a que FIl y COl GENERAL esta la informacion de FIL Y - Col Y   
  add      rsp,8                  ;Debido a a que llamamos antes IMPRIMIR X e Y
  
  sub      r13,r13 
  mov      r13w,[desplaz]            ;Sirve para obtener NUmero ya que usa el r13 
  mov      r10,[Matriz_Y]            ;Sirve para actualizar y obtener el Numero de la matriz es Y
  mov      [OpcionMatriz],r10

  sub      rsp,8                  
  call     ObtenerNumero_Matriz       ;en r12 tengo el numero
  add      rsp,8                                                                                       ;ESTA PARTE ES PARA MATRIZ Y^
  ;---------------------------------------------------------------------------------------------------------------------------------
  imul     r12,[NumX]                 ;Multiplico el numero de X con el numero de Y
  add      [SumaPivote],r12           ;Voy sumando las multiplicaciones

  mov      r10w,[pos_i]           
  cmp      r10w,[FilaY]               ;Cuando i_y es mayor a FIL_Y , estamos en el caso 5,1 por ende tenemos que preguntar   
  jg       InsertarResultMatriz 
  jmp      ContinuarSinInsertar          
  
  InsertarResultMatriz:
  mov      r12w,[pos_i_x]             ;Tomar encuenta que la matriz resultado en este caso es FilX con ColY
  mov      r13w,[pos_j]
  
  sub      rsp,8                  
  call     Calc_Dezplaz_Multiplicar  ;Calculo el desplaz de la Matriz Mulit con r12w = FilX y r13w = ColY || EJMP EXCEL
  add      rsp,8
  
  sub      r13,r13
  mov      r13w,[desplaz]
  mov      r14,[SumaPivote]
  mov      [Matriz_Multi + r13],r14
  mov      qword[SumaPivote],0        ;Inicializo
  mov      word[pos_j_x],1      
  ContinuarSinInsertar:
  mov      rcx,[VarAuxLoop2]
  dec      rcx
  jnz      N_veces_MatrizY
  ;===============================================================================================================================
 add   word[pos_i_x],1           ;Luego del Loop de la Cant DE NUMEROS MATRIZ Y , Se le suma 1 EN FIL X,
 mov   rcx,[VarAuxLoop]          ;Debido a que pasara a la siguiente FIla para continuar su
 dec   rcx                       ;Cambie el loop por dec y jnz debido a que habia mucho contenido dentro del loop
 jnz   N_veces_MatrizX
 ;------------------------------------------------------------------------------------------------------------------------------------ 
 mov  byte[inputRecorr],'N'      ;Aqui Desactivo el Recorrido Vertical
ret
;===================================================================================================
Calc_Dezplaz_Multiplicar:
	mov		bx,r12w ;FIL I
	sub		bx,1
	imul	bx,8		;8 por cantida de columnas
  imul  bx,word[longElemento]
  mov		[desplaz],bx  ;bx tengo el desplazamiento a la fila
	mov		bx,r13w ;Col J
	dec		bx
	imul	bx,word[longElemento]		; bx tengo el deplazamiento a la columna
  add		[desplaz],bx	; en desplaz tengo el desplazamiento final  
ret
;===================================================================================================
SumarMatrices: ;##############################################################################################
  sub   r11,r11
  sub   r12,r12
  mov   byte[inputMultiplicar],'N' ; Para que no entre al caso de Multiplicacion en La rutina ValidarDImensiones 

  sub   rsp,8
  call  ValidarDimensionesMatriz
  add   rsp,8

 ImprimirLasMatrices:
  sub    rsp,8
  call   ImprimirXeY
  add    rsp,8
  
  cmp     byte[inputValidoDimen],'N'
  je      Matrices_Incompatibles
   
  ;LLAMO A SUMAR FUNCION 
  
  cmp     byte[inputOpcionSum],'N'
  jne     PrintMatrizYconRes

  mov    rdi,msjResulSuma
  mov    rsi,[Matriz_X]
  mov    rdx,[Matriz_Y]
  sub		 rsp,8                             
	call	 printf       
	add		 rsp,8

 ;----------------------------------------------------------------
 Sumar:
  sub    rsp,8
  call   SumarXeY
  add    rsp,8
 ;----------------------------------------------------------------
  mov    byte[inputMatrizSuma],'S'
  sub		 rsp,8                             
	call	 Imprimir_Matrices               ;Sirve para imprimir la matriz resultado
	add		 rsp,8
  mov    byte[inputMatrizSuma],'N'
 ;----------------------------------------------------------------
  sub		 rsp,8                             
	call	 ElegirSumarOtravez       
	add		 rsp,8
  
  cmp    byte[inputOpcionSum],'S'
  je     ImprimirLasMatrices

  ;Y pregunto si quiere sumar otra matriz, reemplazando la opcion 
  jmp     FinSuma
 Matrices_Incompatibles:
  mov    rdi,msjErrorDim
  sub		 rsp,8                             
	call	 puts
	add		 rsp,8
  jmp    FinSuma
 PrintMatrizYconRes:
  mov    rdi,msjResultSuma_Y
  mov    rdx,[Matriz_Y]
  sub		 rsp,8                             
	call	 printf       
	add		 rsp,8
  jmp    Sumar
 FinSuma:
ret
;===================================================================================================
SumarXeY:
   sub      r11,r11
   mov      r11w,[Fila]
   imul     r11w,[Columna] ;-----------Total De numeros Segund la matriz elegida
   mov      rcx,r11        ;Aqui inicializo el loop
   mov      word[pos_i],1
   mov      word[pos_j],1
 Sumando_Numeros:
   sub      r14,r14
   mov      [VarAuxLoop],rcx

   mov      byte[inputRecorr],'N'
   sub      rsp,8
   call     RecorrerMatriz ;Aqui TENES EL DESPLAZ DE LA MATRIZ  N X M y el Recorrido es Horizontal
   add      rsp,8

   sub      r13,r13        ;Limpio para evitar errores.
   mov      r13w,[desplaz]
   ;---------------------------------------------------------------------------------------------------------------------   
   cmp      byte[inputOpcionSum],'N' ;Si es una nueva suma, la matriz x PASA HACER EL RESULTADO de la suma anterior
   jne      ActivMatrizResulSuma

   mov      r10,[Matriz_X]       ;Sirve para actualizar y obtener de que matriz es X
   mov      [OpcionMatriz],r10
   jmp      ObtenerNumX
  ActivMatrizResulSuma: 
   mov      byte[inputMatrizSuma],'S'
  
  ObtenerNumX:
   sub      rsp,8
   call     ObtenerNumero_Matriz ; EN r12 tengo el numero de la matriz Y LO ALMACENO EN NUMERO
   add      rsp,8

   add      [SumaPivote],r12                                                                      
                                                                                     ;OBTENER Y SUMAR EL DATO DE MATRIZ X
   ;----------------------------------------------------------------------------------------------------------------------
   mov      r10,[Matriz_Y]        ;Sirve para actualizar y obtener de que matriz es Y
   mov      [OpcionMatriz],r10
   
   mov      byte[inputMatrizSuma],'N' ;Para que no obtenga el numero de la matriz suma
   sub      rsp,8
   call     ObtenerNumero_Matriz ; EN r12 tengo el numero de la matriz Y LO ALMACENO EN NUMERO
   add      rsp,8

   add      [SumaPivote],r12
                                                                                     ;OBTENER Y SUMAR EL DATO DE MATRIZ Y
   ;----------------------------------------------------------------------------------------------------------------------
   mov      r14,[SumaPivote]
   mov      [Matriz_Suma + r13],r14           ;Agrego la suma de x1 + y1 a la matriz Suma
   mov      qword[SumaPivote],0          ;Lo vuelvo a inicializar para que sume x2 + y2 
   
   mov      rcx,[VarAuxLoop]
   dec      rcx                       ;Cambie el loop por dec y jnz debido a que habia mucho contenido dentro del loop
   jnz      Sumando_Numeros
  
ret
;===================================================================================================
ValidarDimensionesMatriz:
  sub    r11,r11
  sub    r12,r12
  sub    r10,r10

  mov    byte[inputValidoDimen],'N'
  mov    r10,[Matriz_Y]
  mov    [OpcionMatriz],r10

  sub    rsp,8
  call   AsignarFil_Col_Aux    ; Aqui tenes Fil y COl llenos,
  add    rsp,8

  mov    r11w,[Fila]            
  mov    r12w,[Columna]        ;Me guardo la fil y col de matrizY
  mov    [FilaY],r11w
  mov    [ColY],r12w           

  mov    r10,[Matriz_X]        ;Paso la opcionMatriz a MatrizX
  mov    [OpcionMatriz],r10
  
  sub    rsp,8
  call   AsignarFil_Col_Aux    ; Aqui tenes Fil y COl llenos pero de la MatrizY,
  add    rsp,8

  cmp    byte[inputMultiplicar],'N'  ; Me fijo si es una COmparacion Respecto a la suma o Multiplicacion
  jne    Caso_Multiplicar
  
  cmp    r11w,[Fila]           ; Aqui comparo la FILA Y CON LA FILA X (En ese orden)
  jne    InvalidoDimension
 
  cmp    r12w,[Columna]         ; Aqui comparo la Col Y  -  CON LA COl X (En ese orden)
  jne    InvalidoDimension
  
  jmp    ValidoDimension
 Caso_Multiplicar:

  cmp    r11w,[Columna]           ; Aqui comparo la FILA Y - CON LA Columna X (En ese orden)
  jne    InvalidoDimension
  mov    r11w,[Fila]
  mov    r12w,[Columna]           ; Guardo FIL X y COL X
  mov    [FilaX],r11w
  mov    [ColX],r12w
 ValidoDimension:
  mov    byte[inputValidoDimen],'S'
 InvalidoDimension:
ret
;===================================================================================================
ImprimirXeY:
  cmp     byte[inputOpcionSum],'N'
  jne     printMatrizY

  mov		 rdi,msjMatriz
	mov		 rsi,[Matriz_X]
	sub		 rsp,8                             
	call	 printf
	add		 rsp,8 

  sub		  rsp,8                     ;Aqui no hago un cambio debido a que dentro de validarDimension ya deja listo para matriz X
	call	  Imprimir_Matrices
	add		  rsp,8
 
 printMatrizY:
  mov		 rdi,msjMatriz
	mov		 rsi,[Matriz_Y]
	sub		 rsp,8                             
	call	 printf
	add		 rsp,8 
  
  mov    r11w,[FilaY]
  mov    r12w,[ColY]  
  mov    [Fila],r11w
  mov    [Columna],r12w       ;Cambio las Filas, Columnam y Opcion para que pueda imprimir la matriz Y elegida
  mov    r10,[Matriz_Y]
  mov    [OpcionMatriz],r10
  
  mov    byte[inputMatrizSuma],'N'
  sub		  rsp,8                             
	call	  Imprimir_Matrices
	add		  rsp,8

ret
;===================================================================================================
ElegirSumarOtravez:
  mov    rdi,msjIngSumarOtravez
  sub		 rsp,8                             
	call	 printf       
	add		 rsp,8

  mov    rdi,inputOpcionSum
  sub		 rsp,8                             
	call	 gets       
	add		 rsp,8
  
  cmp    byte[inputOpcionSum],'S'
  je     SeguirSumando
  
  cmp    byte[inputOpcionSum],'N'
  je     NoSeguirSumando
  
  mov    rdi,msjErrorNumero
  sub		 rsp,8                             
	call	 puts  
	add		 rsp,8
  jmp    ElegirSumarOtravez
 
 SeguirSumando:
  mov    r13,3   ;----> OBLIGO al programa a que tenga 3 debido a que llamare Matrices disponibles, Asi No Cae en el Caso 1 y 2
  
  sub		 rsp,8                             
	call	 Matrices_Disponibles ;Aqui tengo Lleno La opcionMatriz del usuario 
	add		 rsp,8

  mov    r13,[OpcionMatriz]
  mov    [Matriz_Y],r13

  sub   rsp,8
  call  ValidarDimensionesMatriz
  add   rsp,8
 
 NoSeguirSumando:
ret
;===================================================================================================
Modificar_Consultar_Matriz:;##################################################################################
  mov		 rdi,msjMatriz
	mov		 rsi,[OpcionMatriz]
	sub		 rsp,8                             
	call	 printf
	add		 rsp,8 
 
  sub		 rsp,8                             
	call	 Imprimir_Matrices
	add		 rsp,8

  sub    rsp,8
  call   PedirPosDeMatriz
  add    rsp,8

  sub    rsp,8
  call   CalcFijo_Dezplaz_Matriz
  add    rsp,8

  sub    rsp,8
  call   Cosl_Mod_Matriz
  add    rsp,8   
ret
;===================================================================================================------------
PedirPosDeMatriz:
  mov		rdi,msjIngPosMatriz
  mov   rsi,[OpcionMatriz]
	sub		rsp,8
	call	printf
	add		rsp,8
   
  mov	  rdi,inputFilCol	
	sub		rsp,8	
  call  gets    
	add		rsp,8
   
  sub		rsp,8
  call	ValidarPosMatriz
	add	  rsp,8 

  cmp	  byte[inputValidoFilCol],'S'
	je    ValidoPos

  mov   rdi,msjErrorMaxMatriz
  sub   rsp,8
  call  puts
  add   rsp,8
  jmp   PedirPosDeMatriz
 ValidoPos:
ret
;===================================================================================================-----------^
ValidarPosMatriz:
  mov	   byte[inputValidoFilCol],'N'
  mov      rdi,inputFilCol
  mov      rsi,formatInputFilCol
	mov		rdx,Fila
	mov		rcx,Columna
	sub		rsp,8
	call	   sscanf
	add		rsp,8

  cmp      rax,2
  jl       InvalidoPosMatriz
   
  cmp		word[Fila],1
	jl		   InvalidoPosMatriz
	cmp		word[Columna],1
	jl		   InvalidoPosMatriz
  
  sub      rsp,8
  call     ValidarFyC_de_cadaMatriz
  add      rsp,8
   
 InvalidoPosMatriz:
ret
;===================================================================================================-----------^
ValidarFyC_de_cadaMatriz:
  sub     r10,r10
  sub     r14,r14
  mov     r10w,[Fila]
  mov     r14w,[Columna]
  cmp     qword[OpcionMatriz],1
  je      ValidarFilAColA
  cmp     qword[OpcionMatriz],2
  je      ValidarFilBColB
  cmp     qword[OpcionMatriz],3
  je      ValidarFilCColC
  cmp     qword[OpcionMatriz],4
  je      ValidarFilDColD
  cmp     qword[OpcionMatriz],5
  je      ValidarFilEColE
 ValidarFilAColA:
  cmp		  r10w,[Fila_A]
	jg		  InvalidoColFilMatriz 
  cmp		  r14w,[Col_A]
	jg		  InvalidoColFilMatriz
  jmp     ValidoFilCol
 ValidarFilBColB:
  cmp		  r10w,[Fila_B]
	jg		  InvalidoColFilMatriz 
  cmp		  r14w,[Col_B]
	jg		  InvalidoColFilMatriz 
  jmp     ValidoFilCol
 ValidarFilCColC:
  cmp		  r10w,[Fila_C]
	jg		  InvalidoColFilMatriz 
  cmp		  r14w,[Col_C]
	jg		  InvalidoColFilMatriz  
  jmp    ValidoFilCol
 ValidarFilDColD:
  cmp		  r10w,[Fila_D]
	jg		  InvalidoColFilMatriz 
  cmp		  r14w,[Col_D]
	jg		  InvalidoColFilMatriz  
  jmp     ValidoFilCol
 ValidarFilEColE:
  cmp		  r10w,[Fila_E]
	jg		  InvalidoColFilMatriz 
  cmp		  r14w,[Col_E]
	jg		  InvalidoColFilMatriz
  jmp     ValidoFilCol
 ValidoFilCol:
   mov		byte[inputValidoFilCol],'S'
 InvalidoColFilMatriz:
ret
;===================================================================================================-----------
CalcFijo_Dezplaz_Matriz:
	mov		bx,[Fila]
	sub		bx,1
	imul	bx,8		;8 por cantida de columnas
  imul  bx,word[longElemento]
  mov		[desplaz],bx  ;bx tengo el desplazamiento a la fila
	mov		bx,[Columna]
	dec		bx
	imul	bx,word[longElemento]		; bx tengo el deplazamiento a la columna
  add		[desplaz],bx	; en desplaz tengo el desplazamiento final  
ret
;===================================================================================================-----------^
Cosl_Mod_Matriz:;Aqui se puedellamar a obtener NUmero
   sub  r11,r11
   sub  r13,r13  ;cambie el r10 por r13 porque salta error con r10 , no entiendo el porque
   mov  r13w,[desplaz]
   cmp  qword[Opcion],4
   jne  NoPidasNumero
   
   sub    rsp,8
   call   PedirNumero
   add    rsp,8
   
   mov   r11,[Numero]
 NoPidasNumero:
   cmp  qword[OpcionMatriz],1
   je   Cons_ModMatriz1
   cmp  qword[OpcionMatriz],2
   je   Cons_ModMatriz2
   cmp  qword[OpcionMatriz],3
   je   Cons_ModMatriz3
   cmp  qword[OpcionMatriz],4
   je   Cons_ModMatriz4
   cmp  qword[OpcionMatriz],5
   je   Cons_ModMatriz5
 ;----------------------------------------------------
 Cons_ModMatriz1:
   cmp   qword[Opcion],4
   jne   ConsultarMatrizA
   
   mov   qword[Matriz_A + r13],r11
   jmp   FinConsMod
 ConsultarMatrizA:
   mov   r11,[Matriz_A + r13]
   jmp   ImprimirNumero
 ;----------------------------------------------------
 Cons_ModMatriz2:
   cmp   qword[Opcion],4
   jne   ConsultarMatrizB
   
   mov   qword[Matriz_B + r13],r11
   jmp   FinConsMod
 ConsultarMatrizB:
   mov   r11,[Matriz_B + r13]
   jmp   ImprimirNumero
 ;----------------------------------------------------
 Cons_ModMatriz3:
   cmp   qword[Opcion],4
   jne   ConsultarMatrizC
   
   mov   qword[Matriz_C + r13],r11
   jmp   FinConsMod
 ConsultarMatrizC:
   mov   r11,[Matriz_C + r13]
   jmp   ImprimirNumero
 ;----------------------------------------------------
 Cons_ModMatriz4:
   cmp   qword[Opcion],4
   jne   ConsultarMatrizD
   
   mov   qword[Matriz_D + r13],r11
   jmp   FinConsMod
 ConsultarMatrizD:
   mov   r11,[Matriz_D + r13]
   jmp   ImprimirNumero
 ;----------------------------------------------------
 Cons_ModMatriz5:
   cmp   qword[Opcion],4
   jne   ConsultarMatrizE
   
   mov   qword[Matriz_E + r13],r11
   jmp   FinConsMod
 ConsultarMatrizE:
   mov   r11,[Matriz_E + r13]
   jmp   ImprimirNumero
 ;----------------------------------------------------
 ImprimirNumero:
  mov   qword[Numero],r11
  mov		rdi,msjResultConsulta
	mov		rsi,[Numero]
	sub		rsp,8
	call	printf
	add		rsp,8
 FinConsMod:
ret
;===================================================================================================
TransponerMatriz:;#############################################################################################
  mov		  rdi,msjMatriz
	mov		  rsi,[OpcionMatriz]
	sub		  rsp,8                             
	call	  printf
	add		  rsp,8 

  sub		  rsp,8                             
	call	  Imprimir_Matrices
	add		  rsp,8

  mov		  rdi,msjResulTrans
	mov		  rsi,[OpcionMatriz]
	sub		  rsp,8                             
	call	  printf
	add		  rsp,8 
  
  sub		  rsp,8                             
	call	  Transposicion
	add		  rsp,8

  mov     r13w,[Fila]
  mov     r14w,[Columna]    ;Intercambio la Fil y Col debido a que estoy imprimiendo el transpuesto N x M ahora es M x N
  mov     [Fila],r14w
  mov     [Columna],r13w
  
  mov      byte[inputMatrizTrans],'S'
  
  sub		  rsp,8                             
	call	  Imprimir_Matrices
	add		  rsp,8

  mov      byte[inputMatrizTrans],'N'


ret
;===================================================================================================
Transposicion:
   mov      byte[inputMatrizTrans],'N' ; Para que no entre en obtener Matriz que tiene a otro, Esto puede estar en opcionElegdida
   mov      byte[inputMatrizSuma],'N'
   sub      r11,r11
   
   sub      rsp,8
   call     AsignarFil_Col_Aux
   add      rsp,8
   
   mov      r11w,[Fila]
   imul     r11w,[Columna] ;-----------Total De numeros Segund la matriz elegida
   mov      rcx,r11        ;Aqui inicializo el loop
   mov      word[pos_i],1
   mov      word[pos_j],1
 Trasladando_Numeros:  ;Se repetira N x M = Cantidad de Numeros
   sub      r14,r14
   mov      r14,rcx
   mov      [VarAuxLoop],r14
   
   mov      byte[inputRecorr],'N'
   sub      rsp,8
   call     RecorrerMatriz ;Aqui TENES EL DESPLAZ DE LA MATRIZ  N X M y el Recorrido es Horizontal
   add      rsp,8
                                                                                 ;EJMP = En la primera pasada te queda i=1 j=2 
   sub      r13,r13        ;Limpio para evitar errores.
   mov      r13w,[desplaz]
   sub      rsp,8
   call     ObtenerNumero_Matriz ; EN r12 tengo el numero de la matriz Y LO ALMACENO EN NUMERO
   add      rsp,8
 ;----------------------------------------------------------------------------------------------------------------------------
   mov      r11w,[Fila]
   mov      r10w,[Columna]   ;Aqui cambio las col por Fila debido a que es necesario para el recorrido vertical
   mov      [Columna],r11w
   mov      [Fila],r10w
                              ; Aplico la formula para i y j y no genere conflico con el recorrido Vertical
                              ;EJMP , i=1 j=3 -> 1ero Guardoe en el pivote i, Luego a j le resto uno y lo reemplazo a i = 2, 
                              ;por ultimo reemplazo el pivote en j -> j = 1                
   mov      r12w,[pos_i]     
   sub      word[pos_j],1
   mov      r14w,[pos_j]
   mov      [pos_i],r14w
   mov      [pos_j],r12w
                                                                                ;;Aqui preparo las cosas para recorrer Vertical
 ;----------------------------------------------------------------------------------------------------------------------------
   mov      byte[inputRecorr],'S'
   sub      rsp,8
   call     RecorrerMatriz ;Aqui TENES EL DESPLAZ DE LA MATRIZ  M X N y el Recorrido es Vertical
   add      rsp,8

   sub      r13,r13  ;Limpio para evitar errores.
   mov      r13w,[desplaz]
   
   mov      r12,[Numero]
   mov     qword[Matriz_Trans + r13],r12 ;Pongo el numero de la matriz original a la Matriz Transpuesta
 ;----------------------------------------------------------------------------------------------------------------------------
   mov     [Fila],r11w
   mov     [Columna],r10w    ;Vuelvo a asu posicion la Fila Y Col de la matriz orginal Para preparar el recorrido normal de arriba
   
   sub     r12,r12
   mov     r12w,[pos_i]
   mov     r14w,[pos_j]
   mov     [pos_i],r14w
   mov     [pos_j],r12w
                                                                                ;;Aqui preparo las cosas para recorrer Horizontal
 ;----------------------------------------------------------------------------------------------------------------------------
   mov      r14,[VarAuxLoop]
   mov      rcx,r14
   dec      rcx                       ;Cambie el loop por dec y jnz debido a que habia mucho contenido dentro del loop
   jnz Trasladando_Numeros

ret
;===================================================================================================
AsignarFil_Col_Aux:
   sub  r10,r10    ;Limpiando Registros por las dudas

   mov  word[Fila],0
   mov  word[Columna],0   ;Limpiando Variables por las dudas

   cmp  qword[OpcionMatriz],1
   je   AsignarFilyCol_Aux1
   cmp  qword[OpcionMatriz],2
   je   AsignarFilyCol_Aux2
   cmp  qword[OpcionMatriz],3
   je   AsignarFilyCol_Aux3
   cmp  qword[OpcionMatriz],4
   je   AsignarFilyCol_Aux4
   cmp  qword[OpcionMatriz],5
   je   AsignarFilyCol_Aux5

 AsignarFilyCol_Aux1:
   mov  r10w,[Fila_A]
   mov  [Fila],r10w
   mov  r10w,[Col_A]
   mov  [Columna],r10w

   jmp  FinAsignacionFilCol
 AsignarFilyCol_Aux2:
   mov  r10w,[Fila_B]
   mov  [Fila],r10w
   mov  r10w,[Col_B]
   mov  [Columna],r10w
    
   jmp  FinAsignacionFilCol
 AsignarFilyCol_Aux3:
   mov  r10w,[Fila_C]
   mov  [Fila],r10w
   mov  r10w,[Col_C]
   mov  [Columna],r10w

   jmp  FinAsignacionFilCol
 AsignarFilyCol_Aux4:
   mov  r10w,[Fila_D]
   mov  [Fila],r10w
   mov  r10w,[Col_D]
   mov  [Columna],r10w

   jmp  FinAsignacionFilCol
 AsignarFilyCol_Aux5:
   mov  r10w,[Fila_E]
   mov  [Fila],r10w
   mov  r10w,[Col_E]
   mov  [Columna],r10
 FinAsignacionFilCol:
ret
;===================================================================================================-----------^
RecorrerMatriz:
 ;Este Recorrido solo me servira para sumar y transponer una Matriz,
 Inicio_1:
  ;-------------------------------------------------------------------------------------------------------------------------------------------
   mov		bx,[pos_i]
	 sub		bx,1

   cmp      byte[inputRecorr],'N' ;Porque hago esto? --> Es debido a que las verficaciones en FIL depende de que recorrido este haciendo
   jne      CasoFil_Recorr_Vertical

   cmp      bx,[Fila]
   je       FinRecorrido     ;Esto es exclusivamente para moverse horizontalmente
   jmp      Calc_i            ;Caso Recorrido Horizontal

 CasoFil_Recorr_Vertical:
   cmp      bx,[Fila]               ;Esta rutina sirve para que cuando la fila llege a su tope, cambie de fila mas no termine el programa
   je       Siguiente_Col           ;Caso Recorrido Vertical
 
 Calc_i:
	imul	   bx,8	
  imul     bx,word[longElemento]
   
  mov		[desplaz],bx                                                                                           ;TODA ESTA PARTE ES CALC I
 ;---------------------------------------------------------------------------------------------------------------------------------------------
	mov		bx,[pos_j]
	dec		bx
 
  cmp      byte[inputRecorr],'N'  ;Porque hago esto? --> Es debido a que las verficaciones en COL depende de que recorrido este haciendo
  jne      CasoCol_Recorr_Vertical

  cmp      bx,[Columna]    
  je       Siguiente_Fil
  jmp      calc_j

 CasoCol_Recorr_Vertical:
  cmp      bx,[Columna]
  je       FinRecorrido
 
 calc_j:
  imul	    bx,word[longElemento]			
  add		    [desplaz],bx	       ;Aqui ya tenes el dezplazamiento Final Segun el recorrido
                                                                                                                     ;TODA ESTA PARTE ES CALC J
  ;---------------------------------------------------------------------------------------------------------------------------------------------
   cmp      byte[inputRecorr],'N'  ;Porque hago esto? --> Es debido a que se incrementa de manera diferente segun el recorrido
   jne      CasoRecorrVertical

   add      word[pos_j],1                 ;Aqui se mueve el j HORIZONTALMENTE, manteniendo a i FIJO
   jmp      FinRecorrido 

 CasoRecorrVertical:
   add      word[pos_i],1                 ;Aqui se mueve el i VERTICALMENTE, manteniendo a j FIJO
   jmp      FinRecorrido 
                                                                                                                     ;TODA ESTA PARTE SUMA I O J
  ;---------------------------------------------------------------------------------------------------------------------------------------------                                         
 Siguiente_Fil:
   add      word[pos_i],1
   mov      word[pos_j],1

   cmp      byte[inputImprimir],'S'
   je       ImprimirSaltoDelinea      ;SOlo sirve para cuando Imprima una matriz
   jmp      ContinuarRecorrido
 ImprimirSaltoDelinea:
   mov		rdi,NewLine
	 sub		rsp,8
	 call	  puts
	 add		rsp,8
 ContinuarRecorrido:
   jmp      Inicio_1
 Siguiente_Col:
   add      word[pos_j],1
   mov      word[pos_i],1
   jmp      Inicio_1  
 FinRecorrido:
ret
;===================================================================================================-----------^
ObtenerNumero_Matriz:  
   mov  qword[Numero],0    ;Inicializo el en 0 por las dudas
   
   cmp  byte[inputMatrizTrans],'S'
   je   ObtenerNum_MatrizTrans
   cmp  byte[inputMatrizSuma],'S'
   je   ObtenerNum_MatrizSuma
   cmp  byte[inputMatrizMulti],'S'
   je   ObtenerNum_MatrizMulti
   ;Puedo a;adirle mas para el resultado de la suma y el resultado de la multiplicacion

   cmp  qword[OpcionMatriz],1
   je   ObtenerNum_Matriz1
   cmp  qword[OpcionMatriz],2
   je   ObtenerNum_Matriz2
   cmp  qword[OpcionMatriz],3
   je   ObtenerNum_Matriz3
   cmp  qword[OpcionMatriz],4
   je   ObtenerNum_Matriz4
   cmp  qword[OpcionMatriz],5
   je   ObtenerNum_Matriz5
 ObtenerNum_Matriz1:
   mov  r12,[Matriz_A + r13]
   jmp FinObtencion
 ObtenerNum_Matriz2:
   mov  r12,[Matriz_B+ r13]
   jmp FinObtencion
 ObtenerNum_Matriz3:
   mov  r12,[Matriz_C+ r13]
   jmp FinObtencion
 ObtenerNum_Matriz4:
   mov  r12,[Matriz_D + r13]
   jmp FinObtencion
 ObtenerNum_Matriz5:
   mov  r12,[Matriz_E + r13]
   jmp FinObtencion
 ObtenerNum_MatrizTrans:
   mov  r12,[Matriz_Trans + r13]
   jmp FinObtencion
 ObtenerNum_MatrizSuma:
   mov  r12,[Matriz_Suma + r13]
   jmp  FinObtencion
 ObtenerNum_MatrizMulti:
   mov  r12,[Matriz_Multi + r13]
 FinObtencion:
   mov [Numero],r12
ret
;===================================================================================================
Imprimir_Matrices:
  ;-------------------------------------------------------------------------
   sub  r13,r13
   mov  r13w,[Fila]
   imul r13w,[Columna]
   mov  rcx,r13
   mov  word[pos_i],1
   mov  word[pos_j],1
   mov  byte[inputImprimir],'S'
  SiguienteImpresion1:
   mov      word[N_veces_impr],cx
    
   mov      byte[inputRecorr],'N'
   sub      rsp,8
   call     RecorrerMatriz ;Aqui TENES EL DESPLAZ DE LA MATRIZ  N X M y el Recorrido es Horizontal
   add      rsp,8

   sub      r13,r13        ;Limpio para evitar errores.
   mov      r13w,[desplaz]
  
   sub      rsp,8
   call     ObtenerNumero_Matriz ; EN r12 tengo el numero de la matriz Y LO ALMACENO EN NUMERO
   add      rsp,8
    
   mov		  rdi,ImprimirNumMatriz
	 mov		  rsi,[Numero]
	 sub		  rsp,8                             
	 call	    printf
	 add		  rsp,8   

   sub      rcx,rcx
   mov      cx,word[N_veces_impr]
   loop     SiguienteImpresion1
  
   mov		  rdi,NewLine
   sub		  rsp,8
   call	    puts
   add		  rsp,8

   mov    byte[inputImprimir],'N'
  ;-------------------------------------------------------------------------
ret
;===================================================================================================
