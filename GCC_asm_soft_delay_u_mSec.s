// GCC_asm_soft_delay_u_mSec.s

// Author: chowk
// Lab: KHU
// Date: 2012. 10. 10

// Software Time Delay Function

#include <avr/io.h>		      // Definition file for ATmega128
#include "cho_asm_io_def.h"   // I/O Port Definition for ATmega128

// Program Constants

// Program Variables Definitions
#define RG_TEMP r0	   // Temporary Register
#define RG_ZERO r1     // Zero
#define AC0 r16		   // Temporary Byte Rg 0
#define AC1 r17		   // Temporary Byte Rg 1
#define AC2 r18		   // Temporary Byte Rg 2
#define AC3 r19		   // Temporary Byte Rg 3
#define AC4 r20		   // Temporary Byte Rg 2
#define AC5 r21		   // Temporary Byte Rg 2
#define ACW0_L r2	   // Temporary Word Rg 0 Low
#define ACW0_H r3	   // Temporary Word Rg 0 High
#define ACW1_L r4	   // Temporary Word Rg 1 Low
#define ACW1_H r5	   // Temporary Word Rg 1 High
#define ACW2_L r6	   // Temporary Word Rg 2 Low
#define ACW2_H r7	   // Temporary Word Rg 2 High
#define ACW3_L r8	   // Temporary Word Rg 3 Low
#define ACW3_H r9	   // Temporary Word Rg 3 High
#define RG_ARG0_H r25  // Function Argument Word Rg 0 High
#define RG_ARG0_L r24  // Function Argument Word Rg 0 Low
#define RG_ARG1_H r23  // Function Argument Word Rg 1 High
#define RG_ARG1_L r22  // Function Argument Word Rg 1 Low
#define RG_ARG2_H r21  // Function Argument Word Rg 2 High
#define RG_ARG2_L r20  // Function Argument Word Rg 2 Low

.global delay_1uSec,delay_1mSec

.section .text

; mSec 단위의 Time  Delay를 갖는 함수
; 최대 Delay Time : 65536mSec
; RG_ARG0_L = time_ms
; Calling Sequence
;  RG_ARG0_L <- mSec
;  RG_ARG0_H <- Clear
; rcall delay_mSec
; C Function : void delay_mSec(char );

delay_1mSec:
; 1cycle = 1/16000000 -> 0.0625uSec
; one loop takes 1mSec 
		push AC0

		mov AC0, RG_ARG0_L
delay_1mSec1:
		ldi RG_ARG0_L, 250
		rcall delay_1uSec
		ldi RG_ARG0_L, 250
		rcall delay_1uSec
		ldi RG_ARG0_L, 250
		rcall delay_1uSec
		ldi RG_ARG0_L, 250
		rcall delay_1uSec
		dec AC0					; 1 cycle +
		brne delay_1mSec1		; 2 cycle = 16 cycle * 0.0625uSe=c  1uSec
		
		pop AC0
		ret

; uSec 단위의 Time  Delay를 갖는 함수
; 최대 Delay Time : 256uSec
; 1cycle = 1/16000000 -> 0.0625uSec
; RG_ARG0_L = time_us
; Calling Sequence
;  RG_ARG0_L <- uSec
;  RG_ARG0_H <- Clear
; rcall delay_uSec
; C Function : void delay_uSec(char );
delay_1uSec:
		push  RG_ARG0_L			; 2 cycle +
		
delay_1uSec1:
		push  RG_ARG0_L			; 2 cycle +
		pop   RG_ARG0_L			; 2 cycle +
		push  RG_ARG0_L			; 2 cycle +
		pop   RG_ARG0_L			; 2 cycle +
		push  RG_ARG0_L			; 2 cycle +
		pop   RG_ARG0_L			; 2 cycle +
		nop						; 1 cycle +
		dec RG_ARG0_L			; 1 cycle +
		brne delay_1uSec1		; 2 cycle = 16 cycle * 0.0625uSe=c  1uSec

		pop RG_ARG0_L			; 2 cycle +
		ret

.end
