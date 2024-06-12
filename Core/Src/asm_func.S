.text

.syntax unified
.thumb

.global asm_potencia
.global asm_potencia_DSP
.global asm_medDif
.global asm_medDif_DSP
.global asm_eco
.global asm_eco_DSP


// **************************************************************************
// Ejercicio 1
// **************************************************************************
// Prototipo en .h
// uint32_t asm_potencia(int16_t *vecIn, uint32_t longitud);

// Parámetros:
//  r0: dirección de vectorIn
//  r1: longitud
//  r2: auxiliar1
//  r3: acumulador
//	r4: longitud N
// **************************************************************************

.thumb_func
	asm_potencia:
		PUSH {r4}		// guarda r4 en la pila
		MOV	 r4, r1		// almacena longitud en r4
		MOV	 r3, #0		// inicializa acumulador
		CBZ  r0, _exit	// vecIn == NULL => salir
		CBZ  r1, _exit  // longitud = 0  => salir

		_loop:
			SUB   r1, #1 				// decrementa longitud
			LDRSH r2, [r0, r1, LSL #1]	// Cargar x[n] con signo
			MULS  r2, r2, r2			// x[n]^2
			ADD   r3, r2				// Acumular suma de cuadrados
			//cbnz  r1, _loop 			// Si r1 no es cero, repetir
    		CBZ   r1, _end_loop 		// Si r1 es cero, salir del bucle
    		B     _loop         		// Volver al inicio del bucle

		_end_loop:
    		UDIV  r3, r3, r4    // Dividir suma de cuadrados por longitud

		_exit:
			MOV r0, r3					// mover resultado a r0
			POP {r4}					// restaura r4
			BX lr               		// Volver de la función
// ************************************************************************
// Prototipo en .h
// uint32_t asm_potencia_DSP(int16_t *vecIn, uint32_t longitud);

// Parámetros:
//  r0: dirección de vectorIn
//  r1: longitud
//  r2: auxiliar1
//  r3: acumulador
//	r4: longitud N

// Condiciones especiales:
// l = 1		// caso particula impar
// l % 2 = 1	// impar

.thumb_func
	asm_potencia_DSP:
		PUSH {r4, r5}	// guarda r4 y r5 en la pila
		MOV	 r4, r1		// almacena longitud en r4
		MOV	 r3, #0		// inicializa acumulador
		CBZ  r0, _exit	// vecIn == NULL => salir
		CBZ  r1, _exit  // longitud = 0  => salir

		ANDS    r5, r4, #1  // longitud es impar?
		ITT     ne			// si l es impar
		MOVSNE r3, [r0,

		_loop:
			SUB   r1, #2 				// decrementa longitud
			LDRS  r2, [r0, r1, LSL #2]	// Cargar x[n] con signo
			SMLAD r3, r2, r2, r3	  	// r3 = x[n]^2 + r3
			//condición de borde si l%2 = 1
    		CBZ   r1, _end_loop 		// Si r1 es cero, salir del bucle
   		    B     _loop         		// Volver al inicio del bucle

		_end_loop:
    		UDIV  r3, r3, r4    // Dividir suma de cuadrados por longitud

		_exit:
			MOV r0, r3					// mover resultado a r0
		    POP {r4}					// restaura r4
			BX lr               		// Volver de la función
// ************************************************************************



// ************************************************************************
// Ejercicio 2
// ************************************************************************

.thumb_func
	asm_medDif:
		bx lr               		// Volver de la función
// ************************************************************************
.thumb_func
	asm_medDif_DSP:
		bx lr               		// Volver de la función
// ************************************************************************



// ************************************************************************
// Ejercicio 3
// ************************************************************************

.thumb_func
	asm_eco:
		bx lr               		// Volver de la función
// ************************************************************************
.thumb_func
	asm_eco_DSP:
		bx lr               		// Volver de la función
// ************************************************************************
