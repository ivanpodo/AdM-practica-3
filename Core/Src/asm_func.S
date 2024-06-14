// **************************************************************************
// Guía Práctica 3 (CESE22 - AdM)
//
// Autores:
// Ing. Marco Rolón Radcenco
// Ing. Pablo Giménez
// Ing. Iván Podoroska
// **************************************************************************
.text
.syntax unified
.thumb

// **************************************************************************
// Ejercicio 1A
//
// Implementar una función que calcule la potencia de una señal discreta x[n]
// con datos signados de 16 bits.
//
// uint32_t asm_potencia (int16_t * vecIn, uint32_t longitud)
//
// r0: *vecIn
// r1: longitud
// r2: indice de vecIn
// r3: valor actual
// r4: acumulador
// **************************************************************************
.global asm_potencia
.thumb_func
	asm_potencia:
		push {r4}
		mov r4, #0

		cbz r0, potencia_end		// Checkear si *vecIn es NULL
		cbz r1, potencia_end		// Checkear si longitud es cero

		mov r2, r1					// Guardo longitud en indice

	potencia_loop:
		sub r2, #1     				// Decrementar en 1 indice de vecIn

		ldrsh r3, [r0, r2, LSL #1]	// Cargar siguiente elemento de vecIn
		muls  r3, r3, r3

		add r4, r3, r4				// Acumular

		cbz r2, potencia_end		// Si indice de vectorIn no es 0, repetir el loop
		b potencia_loop

		sdiv r4, r4, r1 			// Divido por la cantidad de elementos

	potencia_end:
		mov r0, r4
		pop {r4}
		bx lr               		// Volver de la función

// **************************************************************************
// Ejercicio 1B
//
// Implementar una función que calcule la potencia de una señal discreta x[n]
// con datos signados de 16 bits.
//
// uint32_t asm_potencia_DSP (int16_t * vecIn, uint32_t longitud)
//
// r0: *vecIn
// r1: longitud / indice de vecIn
// r2: indice de vecIn
// r3: valor actual
// r4: acumulador
// **************************************************************************
.global asm_potencia_DSP 
.thumb_func 
	asm_potencia_DSP: 
		push {r4}
		mov r4, #0					// Limpio acumulador
		
		cbz r0, potencia_end_dsp	// Checkear si *vecIn es NULL
		cbz r1, potencia_end_dsp	// Checkear si longitud es cero
		
		mov r2, r1					// Guardo longitud en indice	
		
	potencia_loop_dsp:
		sub   r2, #2     			// Decrementar en 2 indice de vecIn

		ldr   r3, [r0, r2, LSL #1]	// Cargar siguiente elemento de vecIn
		smlad r4, r3, r3, r4		// Elevar al cuadrado y acumular			

		cbz r2, potencia_end_dsp	// Si indice de vecIn no es 0, repetir el loop
		b potencia_loop_dsp
		
		udiv r4, r4, r1 			// Divido por la cantidad de elementos
		
	potencia_end_dsp:
		mov r0, r4
		pop {r4}
		bx lr               		// Volver de la función

// **************************************************************************
// Ejercicio 2A
//
// Implementar una función que calcule el vector de diferencia media entre
// dos señales discretas x[n] e y[n] con datos // signados de 8 bits y de
// igual cantidad de elementos.
//
// void asm_medDif(int8_t * e, int8_t *x, int8_t *y, uint16_t longitud)
//
// r0: *e
// r1: *x
// r2: *y
// r3: longitud / indice n
// r4: x[n]
// r5: y[n]
// r6: e[n]
// **************************************************************************
.global asm_medDif
.thumb_func
	asm_medDif:
		push {r4-r6}

		cbz r0, medDif_end			// Checkear si *e es NULL
		cbz r1, medDif_end			// Checkear si *x es NULL
		cbz r2, medDif_end			// Checkear si *y es NULL
		cbz r3, medDif_end			// Checkear si longitud es cero

	medDif_loop:
		sub r3, #1     				// Decrementar en 1 indice n

		ldrsb r4, [r1, r3]			// Cargar siguiente elemento de x
		ldrsb r5, [r2, r3]			// Cargar siguiente elemento de y

		sub r6, r4, r5				// Resta x[n]-y[n]
		asr r6, r6, #1				// Divir entre 2

		strb r6, [r0, r3]			// Cargar siguiente elemento de e

		cbz r3, medDif_end			// Si indice n no es 0, repetir el loop
		b medDif_loop

	medDif_end:
		pop {r4-r6}
		bx lr               		// Volver de la función


// **************************************************************************
// Ejercicio 2B
//
// Implementar una función que calcule el vector de diferencia media entre
// dos señales discretas x[n] e y[n] con datos // signados de 8 bits y de
// igual cantidad de elementos.
//
// void asm_medDif_DSP(int8_t * e, int8_t *x, int8_t *y, uint16_t longitud)
//
// r0: *e
// r1: *x
// r2: *y
// r3: longitud / indice de x e y
// r4: x[n]
// r5: y[n]
// r6: e[n]
// **************************************************************************
.global asm_medDif_DSP
.thumb_func
	asm_medDif_DSP:
		push {r4-r6}

		cbz r0, medDif_end_dsp		// Checkear si *e es NULL
		cbz r1, medDif_end_dsp		// Checkear si *x es NULL
		cbz r2, medDif_end_dsp		// Checkear si *y es NULL
		cbz r3, medDif_end_dsp		// Checkear si longitud es cero

	medDif_loop_dsp:
		sub r3, #4     				// Decrementar en 4 indice n

		ldr r4, [r1, r3]			// Cargar siguiente elemento de x
		ldr r5, [r2, r3]			// Cargar siguiente elemento de y

		shsub8 r6, r4, r5			// (x[n]-y[n])/2

		str r6, [r0, r3]			// Cargar siguiente elemento de e

		cbz r3, medDif_end_dsp		// Si indice n no es 0, repetir el loop
		b medDif_loop_dsp

	medDif_end_dsp:
		pop {r4-r6}
		bx lr               		// Volver de la función

// **************************************************************************
// Ejercicio 3A
//
// Realizar una función que recibe un vector de 4096 valores de 16 bits
// signados, que corresponden a muestras de audio tomadas a una tasa de
// muestreo de 44.100 muestras/s. La función debe introducir un “eco” que
// consiste en adicionar a la señal original, la propia señal original
// dividida por dos y atrasada en 20 ms.
//
// void void asm_eco (int16_t * signal, int16_t *eco, uint32_t longitud)
//
// r0: *signal
// r1: *eco
// r2: longitud / indice de signal
// r3: contiene el retraso de 20 ms en muestras: 882
// r4: valor actual de signal
// r5: valor defasado de signal
// r6: valor actual de eco
// r7: indice defasado de signal
// **************************************************************************
.global asm_eco
.thumb_func
	asm_eco:
		push {r4-r7}

		cbz r0, eco_end				// Checkear si *e es NULL
		cbz r1, eco_end				// Checkear si *x es NULL
		cbz r2, eco_end				// Checkear si longitud es cero
		mov r3, #882				// Retardo

	eco_loop:
		sub r2, #1     				// Decrementar en 1 indice n

		ldrsh r4, [r0, r2, lsl #1]	// Cargar valor actual de signal[]
		mov   r6, r4				// Copiar a salida

		cmp   r2, r3				// Comparar índice < 882
		blt   eco_save

		// Con eco
		sub   r7, r2, r3
		ldrsh r5, [r0, r7, lsl #1] 	// Cargar valor defasado de signal[]
		asr   r5, r5, #1			// Dividir valor desfasado entre 2
		add   r6, r4, r5			// Aplicar eco

	eco_save:
		strh  r6, [r1, r2, lsl #1]	// Guardar el resultado en eco[]

		cbz   r2, eco_end			// Si indice no es 0, repetir el loop
		b     eco_loop

	eco_end:
		pop {r4-r7}
		bx lr               		// Volver de la función

// -------------------------------
//    e[n]    = s[n] + s[n-882]/2
//
//    e[0]    = s[0]
//     ...
//    e[881]  = s[881]
//    e[882]  = s[882] + s[0]/2
//     ...
//    e[4095] = s[4095 + 882]/2
// -------------------------------

// **************************************************************************
// Ejercicio 3B
//
// Realizar una función que recibe un vector de 4096 valores de 16 bits
// signados, que corresponden a muestras de audio tomadas a una tasa de
// muestreo de 44.100 muestras/s. La función debe introducir un “eco” que
// consiste en adicionar a la señal original, la propia señal original
// dividida por dos y atrasada en 20 ms.
//
// void asm_eco_DSP (int16_t * signal, int16_t *eco, uint32_t longitud)
//
// r0: *signal
// r1: *eco
// r2: longitud / indice de signal
// r3: contiene el retraso de 20 ms en muestras: 882
// r4: valor actual de signal
// r5: valor defasado de signal
// r6: valor actual de eco
// r7: indice defasado de signal
// r8: auxiliar eco (= 0)
// **************************************************************************
.global asm_eco_DSP
.thumb_func
	asm_eco_DSP:
		push {r4-r8}

		cbz r0, eco_end_dsp			// Checkear si *signal es NULL
		cbz r1, eco_end_dsp			// Checkear si *eco es NULL
		cbz r2, eco_end_dsp			// Checkear si longitud es cero
		
		mov r3, #882				// Inicializar retardo
		mov r8, #0					// Inicializa variable auxiliar

	eco_loop_dsp:
		sub r2, #2     				// Decrementar en 2 indice n

		ldr   r4, [r0, r2, LSL#1]	// Cargar valor actual de signal[]
		mov   r6, r4				// Copiar a salida

		cmp   r2, r3				// Comparar índice < 882
		blt   eco_save_dsp

		// Con eco
		sub   r7, r2, r3
		ldr   r5, [r0, r7, LSL#1] 	// Cargar valor defasado de signal[]
		shsub16 r5, r5, r8			// r5 = (r5 - 0) / 2 = r5 / 2
		sadd16  r6, r4, r5			// Aplicar eco

	eco_save_dsp:
		str  r6, [r1, r2, LSL#1]	// Guardar el resultado en eco[]

		cbz   r2, eco_end_dsp		// Si indice no es 0, repetir el loop
		b     eco_loop_dsp

	eco_end_dsp:
		pop {r4-r8}
		bx lr               		// Volver de la función
