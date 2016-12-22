// GCC_asm_uart.s

// Author: chowk
// Lab: KHU
// Date: 2012. 10. 10

// Uart Basic Function

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

.global UART_Init,UART_Transmit,UART_Receive, UART_getchar,UART_putchar

.section .text

; Calling Sequence
;  RG_ARG0_H <- UBRRH
;  RG_ARG0_L ,- UBRL
;  rcall USART_Init
; C Function : void USART_Init(unsigned int);
UART_Init:
		push AC0
		; Set baud rate
		sts UBRR0H, RG_ARG0_H
		out ASM_UBRR0L, RG_ARG0_L
		; Enable receiver and transmitter
		ldi AC0, (1<<RXEN)|(1<<TXEN)
		out ASM_UCSR0B,AC0
		; Set frame format: 8data, 1stop bit
		ldi AC0, (0<<USBS)|(3<<UCSZ0)
		sts UCSR0C,AC0
		pop AC0
		ret

; Calling Sequence
;  RG_ARG0_L <- Transmit Data
; C Function : void ASM_putchar(unsigned char);
UART_Transmit:
UART_putchar:
		; Wait for empty transmit Rg
		sbis ASM_UCSR0A,UDRE
		rjmp UART_Transmit
		; Put data (AC0) into transmit Rg
		out ASM_UDR0,RG_ARG0_L
		ret

; Return Value
;  RG_ARG0_L : Received Data
;  RG_ARG0_H : zero
; C Function : unsigned char ASM_getchar(void);
UART_Receive:
UART_getchar:
		; Wait for data to be received
		sbis ASM_UCSR0A, RXC
		rjmp UART_Receive
		; Get received data
		in RG_ARG0_L, ASM_UDR0
		ret

.end
