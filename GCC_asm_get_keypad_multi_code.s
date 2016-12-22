// GCC_asm_keypad_soft_timer2_delay_basic.s
//
// Author: chowk
// Lab: KHU
// Date: 2012. 10. 20

// Keypad 제어 프로그램
//   이 프로그램은 Software getkey 함수와
//   Time2 over flow delay routine을 사용한 Keypad 제어 프로그램으로
//   2개의 Key Code Table를 사용 하여 Multi Code Keypad를  구현 하였다.
//
//   실험 방법
//		Keypad, LCD Display, 터미널 프로그램(OC Console 등)을 사용 한다.
//		프로그램을 실행 하면 LCD Display, 터미널 프로그램에 "Keypad Test" 메세지가 표시 된다.
//		Keypad 를 두드리면 LCD Display, 터미널 프로그램에 Keypad 문자가 출력 된다.
//      # Key 가 입력 되면 2개의 Key Code Table이 Toggle 되어 하나의 Keypad가 
//      2개의 Code 표를 갖는 Keypad로 동작 한다.

#  ifndef atmega128
	#define atmega128
#  endif
#define FOSC 16000000// Clock Speed

#include <avr/io.h>		      // Definition file for ATmega128
#include "cho_asm_io_def.h"   // I/O Port Definition for ATmega128
#include "GCC_asm_soft_delay_u_mSec.h"

// SRAM Definitions
#define _SFR_OFFSET 0			// Needed to subtract 0x20 from I/O addresses

// [Add all hardware information here]

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

#define ROW_PORT ASM_PORTC		// Output Port
#define ROW_PORT_DDR ASM_DDRC
#define COL_PORT ASM_PORTE		// Input Port
#define COL_PORT_DDR ASM_DDRE
#define COL_PORT_PIN ASM_PINE		// Input Port

#define ROW_MASK 0xf0
#define COL_MASK 0x70
#define NUM_ROWS 4
#define NUM_COLS 3
#define COL_TEST 0x40  // NUM_COLS = 3 : 0x40, NUM_COLS =4 : 0x80

#define DEBOUNCE_TIME 16			; 16mSec

#define TRUE 0xff
#define FALSE 0x00

.section .data
.global keyCodeMode
keyPressed:	.byte FALSE				; Key 상태(Pressed or Release)을 저장하기 위한 변수
keyCodeMode: .byte FALSE			; key_code_table1를 기본 Code Table로 한다.

key_code_table1:
		.byte 0x10,'3','2','1'
		.byte 0x20,'6','5','4'
		.byte 0x40,'9','8','7'
		.byte 0x80,'=','0','*'
		.byte 0,0,0,0


.section .text

.global keypad_init,get_key

; C Function : void keypad_port_init(void);
keypad_port_init:
		push AC0

		; ROW_PORT &= (~ROW_MASK)
		; Key Scan Output Port Enable <- 0
		in AC0, ROW_PORT
		andi AC0, ~ROW_MASK
		out ROW_PORT, AC0				; Row Port Init(PC7-PC4 <- 0)

		; ROW_PORT_DDR  |= ROW_MASK
		; Key Scan Output Port : PC4-PC7
		in AC0, ROW_PORT_DDR
		ori AC0, ROW_MASK
		out ROW_PORT_DDR, AC0
		
		; PORTE |= COL_MASK
		; External SW PullUp
		in AC0, COL_PORT				; Input Port Pull Up
		ori AC0, COL_MASK
		out COL_PORT, AC0				; Col Port Init(PE6-PE4 <- 1)

		; COL_PORT_DDR  &= (~COL_MASK)
		in AC0, COL_PORT_DDR
		andi AC0, ~COL_MASK
		out COL_PORT_DDR, AC0			; Col Port <- Input Port(PE6-PE4 <- Input Port)

		pop AC0
		ret

keypad_init:
		rcall keypad_port_init
		sts keyPressed, RG_ZERO				; keyPressed의 초기 상태를 FALSE 로 설정
		ret

#define rowScanCode r18
#define colData r19
#define rowScanCounter r20
#define colScanCounter r21
#define pressedKeyNum r25
#define keyCode r24

; Key Scan
; Return Value
;  RG_ARG0_L <- Char Code Data(8 Bit)
;  RG_ARG0_H <- Pressed Key Number
; rcall key_scan
; C Function : unsigned char key_scan( void ) ; keyCode 만 Return 하는 경우
; C Function : unsigned int key_scan( void ) ; keyCode를 LSB 1 Byte, 
;    Key 가 눌린 회수를 MSB 1 Byte에 저장 하여 Return 한다.
key_scan:
		push AC0
		push AC1
		push ZL
		push ZH
		push colData
		push colScanCounter

		; pressedKeyNum 초기화
		clr pressedKeyNum
		clr keyCode					; 모든 Key가 Release 된 경우 zero를 Return

		ldi ZL,lo8(key_code_table1) 	;
		ldi ZH,hi8(key_code_table1) 	; Z points to key_code_table 1
		lds AC0, keyCodeMode
		tst AC0
		breq multi_scan1
		
		; Row Scan Disable, Scan Port를 초기화 한다.
multi_scan1:
		in AC0, ROW_PORT
		ori AC0, ROW_MASK
		out ROW_PORT, AC0

key_scan1:
		ld AC1, Z+
		cp AC1, RG_ZERO
		breq key_scan4

		; Row Scan Code Output
		in AC0, ROW_PORT
		com AC1
		and AC0, AC1
		out ROW_PORT, AC0

		NOP
		; Get Colum Data
		in colData, COL_PORT_PIN
		andi colData, COL_MASK
		
		; Row Scan Disable
		in AC0, ROW_PORT
		ori AC0, ROW_MASK
		out ROW_PORT, AC0

		; colData bit testing
		ldi colScanCounter, NUM_COLS
key_scan2:
		mov AC0, colData

		andi AC0, COL_TEST
		brne key_scan3					; 현재 Col Key 가 Press Test 
		ld keyCode, Z					; 현재 Col Key 가 Pressed 된 경우 get key code
		ldi AC0, '#'
		cp AC0, keyCode					; # Code 가 입력 되면 
		brne multi_scan2
		lds AC0, keyCodeMode
		com AC0							; keyCodeMode를 변경 한다.
		sts keyCodeMode, AC0
				
multi_scan2:	
		inc pressedKeyNum
key_scan3:
		ld AC0, Z+						; Z+ , AC0 값은 사용 하지 않는다.

		lsl colData

		dec colScanCounter
		brne key_scan2

		rjmp key_scan1

key_scan4:
		pop colScanCounter
		pop	colData
		pop ZH
		pop ZL
		pop AC1
		pop AC0
		ret

; Return Value
;  RG_ARG0_L <- Char Code Data(8 Bit)
;  RG_ARG0_H <- Pressed Key Number
; C Function : unsigned char get_key( void ) ; keyCode 만 Return 하는 경우
; C Function : unsigned int get_key( void ) ; keyCode를 LSB 1 Byte, 
;              Key 가 눌린 회수를 MSB 1 Byte에 저장 하여 Return 한다.
get_key:
		push AC0

get_key1:
		; Row Scan Enable
		in AC0, ROW_PORT
		andi AC0, ~ROW_MASK
		out ROW_PORT, AC0
		nop

get_key2:
		; Get Colum Data
		in colData, COL_PORT_PIN
		andi colData, COL_MASK
		cpi colData, COL_MASK
		brne get_key3					; Key pressed -> get_key2
; Key 가 Release 된 상태 임

		lds AC0, keyPressed
		cpi AC0, TRUE					; 
		brne get_key2					; Release 상태가 계속 되고 있다. -> get_key1
; 이제 막 Key 가 Release 됨
		sts keyPressed, RG_ZERO			;  Key 가 Release 상태로 변경 된 것을 keyPressed 변수에 저장 한다.

		ldi RG_ARG0_L, DEBOUNCE_TIME	; 16mSec Delay
		rcall delay_1mSec
		rjmp get_key2

; Key 가 Pressed 된 상태 임
get_key3:
		lds AC0, keyPressed
		cpi AC0, TRUE					; 
		breq get_key2					; Pressed 된 상태가 계속 되고 있음 -> getkey1

; 새 Key가 이제 막 Pressed 됨
get_key4:
		ldi RG_ARG0_L, DEBOUNCE_TIME	; 16mSec Delay
		rcall delay_1mSec

		rcall key_scan
		tst RG_ARG0_L					; Buncing 등의 문제로 zero 가 Return 되는 경우 다시 get_key를 실행 한다.
		breq get_key1

		ldi AC0, TRUE					; Key 가 Pressed 상태로 변경 된 것을 keyPressed 변수에 저장 한다.
		sts keyPressed, AC0

		pop AC0
		ret
				
.end
