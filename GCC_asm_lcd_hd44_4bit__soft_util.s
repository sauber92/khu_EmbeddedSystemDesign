// GCC_asm_lcd_hd44_4bit_util.s
//
// Author: chowk
// Lab: KHU
// Date: 2012. 10. 10

// Software Delay Routine을 사용 한 LCD 제어 프로그램

#include <avr/io.h>		      // Definition file for ATmega128
#include "cho_asm_io_def.h"   // I/O Port Definition for ATmega128
#include "GCC_asm_lcd_hd44_4bit.h"
#include "GCC_asm_soft_delay_u_mSec.h"
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

.global LCD_init,LCD_OutChar,LCD_OutCommand,LCD_Clear,LCD_Home
.global LCD_OutString,LCD_SetCsr,LCD_LCD_OutChar_row_col


.section .text


; C Function : void LCD_port_init(void);
LCD_port_init:
		push AC0
		push AC1

		in AC0, LCD_DATA_PORT
		ldi AC1, LCD_PORT_MASK
		com AC1
		and AC0, AC1
		out LCD_DATA_PORT, AC0				; LCD Port Init(PA1-PA7 <- 0)

		ldi AC0, LCD_PORT_MASK
		in AC1, LCD_DATA_PORT_DDR
		or AC0, AC1
		out LCD_DATA_PORT_DDR, AC0			; LCD Port <- Output Port(PA1-PA7 <- Output Port)
		
		pop AC1
		pop AC0
		ret
			
;Send data
; Calling Sequence
;  RG_ARG0_L <- Data(8 Bit)
;  RG_ARG0_H <- Clear
; rcall lcd_data
; C Function : void lcd_data(char );
LCD_OutChar:
		push RG_ARG0_L
		push AC0

		mov AC0, RG_ARG0_L					;
		; 상위 4 Bit를 LCD Port에 Output
		andi RG_ARG0_L, LCD_DATA_PORT_MASK	;
		ori RG_ARG0_L, LCD_DATA_W
		out LCD_DATA_PORT, RG_ARG0_L
		rcall LCD_E					; 
		
		; 하위 4 Bit를 LCD Port에 Output
		swap AC0                   
		andi AC0, LCD_DATA_PORT_MASK
		ori AC0, LCD_DATA_W
		out LCD_DATA_PORT, AC0
		rcall LCD_E 

		ldi  RG_ARG0_L,40			; Wait time > 10 usec
		rcall delay_1uSec

		pop AC0
		pop RG_ARG0_L
		ret
 
; Send command data
; Calling Sequence
;  RG_ARG0_L <- Command(8 Bit)
;  RG_ARG0_H <- Clear
; rcall lcd_command
; C Function : void lcd_command(char );
LCD_OutCommand:
		push RG_ARG0_L
		push AC0

		mov AC0, RG_ARG0_L					;
		; 상위 4 Bit를 LCD Port에 Output
		andi RG_ARG0_L, LCD_DATA_PORT_MASK	;
		ori RG_ARG0_L, LCD_INST_W
		out LCD_DATA_PORT, RG_ARG0_L
		rcall LCD_E					; 
		
		; 하위 4 Bit를 LCD Port에 Output
		swap AC0                   
		andi AC0, LCD_DATA_PORT_MASK
		ori AC0, LCD_INST_W
		out LCD_DATA_PORT, AC0
		rcall LCD_E 

		ldi  RG_ARG0_L,40			; Wait time > 10 usec
		rcall delay_1uSec

		pop AC0
		pop RG_ARG0_L
		ret
 
 ; Enable-Puls
 LCD_E:
		sbi LCD_DATA_PORT, LCD_COLTROL_E
		nop
		nop
		nop
		nop
		nop
		nop
		cbi LCD_DATA_PORT, LCD_COLTROL_E
		
		ret                  
 
; Initialize the LCD to
; Increment address, No displayshift, Display on, 
; Cursor off, Blink off, Cursormove, Shift right
; 4 bit, 2 line, 5 by 7dots
; C Function : void lcd_init(void );
LCD_init:
		push AC0
		push RG_ARG0_L


		rcall LCD_port_init			; LCD Output Port Init: PORTA
		
		ldi  RG_ARG0_L,30			; Wait >15 msec after power(30mSec)
		rcall delay_1mSec
		
		; Command 0x30  No.1
		ldi AC0, 0x30
		out LCD_DATA_PORT, AC0
		rcall LCD_E
		ldi  RG_ARG0_L,2			;  Wait > 160usec(200uSec Delay)
		rcall delay_1mSec
		; Command 0x30  No.2
		rcall LCD_E
		ldi  RG_ARG0_L,2			;  Wait > 160usec(200uSec Delay)
		rcall delay_1mSec
		; Command 0x30  No.3
		rcall LCD_E
		ldi  RG_ARG0_L,2			;  Wait > 160usec(200uSec Delay)
		rcall delay_1mSec
		; DL=0 4-bit Interface
		ldi AC0, 0x20
		out LCD_DATA_PORT, AC0		; DL=0 4-bit Interface
		rcall LCD_E
		ldi  RG_ARG0_L,2			; Wait > 160usec(200uSec Delay)
		rcall delay_1mSec

		ldi RG_ARG0_L, 0x28			; DL=0 4-bit Interface, N=1 2-line mode
		rcall LCD_OutCommand
		ldi RG_ARG0_L, 0x0c			; D=1 Display on, C=0 Cursor, B=0 off, Blink off mode
		rcall LCD_OutCommand
		ldi RG_ARG0_L, 0x06			; I/D=1 Increment, SH=1 Entire shift off mode
		rcall LCD_OutCommand


		ldi  RG_ARG0_L,2			; Wait > 160usec(200uSec Delay)
		rcall delay_1mSec
		rcall LCD_Clear				; clear display

		pop RG_ARG0_L
		pop AC0
		ret
 
; Clear
; C Function : void lcd_clear(void );
LCD_Clear:
		push RG_ARG0_L

		ldi RG_ARG0_L, 0x01			; Clear Command
		rcall LCD_OutCommand
		ldi  RG_ARG0_L,2			; 1.6mSec Delay
		rcall delay_1mSec
		
		rcall LCD_Home

		pop RG_ARG0_L
		ret
 
; Cursor Home Position
; C Function : void lcd_home(void );
LCD_Home:
		push RG_ARG0_L

		ldi RG_ARG0_L, 0x02			; Cursor Home
		rcall LCD_OutCommand
		ldi  RG_ARG0_L,2			; 1.6mSec Delay
		rcall delay_1mSec

		pop RG_ARG0_L
		ret
           
; Calling Sequence
;  RG_ARG0_L <- String Pointer Low Byte
;  RG_ARG0_H <- String Pointer High Byte
; C Function : void LCD_OutString(char *);
LCD_OutString:
		push ZL
		push ZH

		mov ZL, RG_ARG0_L
		mov ZH, RG_ARG0_H

OutString1:
		ld RG_ARG0_L, Z+
		and RG_ARG0_L, RG_ARG0_L
		breq EndString
		rcall LCD_OutChar
		rjmp OutString1
EndString:
		pop ZH
		pop ZL
		ret

; Calling Sequence
;  RG_ARG0_L <- LCD row position
;  RG_ARG1_L <- LCD col position
; C Function : void LCD_SetCsr(char row, char col);
LCD_SetCsr:
		push AC0

		cpi RG_ARG0_L, 1
		brne LCD_SetCsr1
		ldi AC0, FIST_LINE_START_ADDRESS
		rjmp LCD_SetCsr2
LCD_SetCsr1:
		cpi RG_ARG0_L, 2
		brne LCD_SetCsr3
		ldi AC0, SECOND_LINE_START_ADDRESS
LCD_SetCsr2:
		add AC0, RG_ARG1_L
		dec AC0
		mov RG_ARG0_L, AC0
		rcall LCD_OutCommand
LCD_SetCsr3:

		pop AC0
		ret

; Calling Sequence
;  RG_ARG0_L <- LCD row position
;  RG_ARG1_L <- LCD col position
;  RG_ARG2_L <- Char
; C Function : void LCD_LCD_OutChar_row_col(char row, char col, char letter);
LCD_LCD_OutChar_row_col:
		push AC0

		cpi RG_ARG0_L, 1
		brne LCD_LCD_OutChar_row_col1
		ldi AC0, FIST_LINE_START_ADDRESS
		rjmp LCD_LCD_OutChar_row_col2
LCD_LCD_OutChar_row_col1:
		cpi RG_ARG0_L, 2
		brne LCD_LCD_OutChar_row_col3
		ldi AC0, SECOND_LINE_START_ADDRESS
LCD_LCD_OutChar_row_col2:
		add AC0, RG_ARG1_L
		dec AC0
		mov RG_ARG0_L, AC0
		rcall LCD_OutCommand

		mov RG_ARG0_L, RG_ARG2_L
		rcall LCD_OutChar
LCD_LCD_OutChar_row_col3:

		pop AC0
		ret
			
.end
