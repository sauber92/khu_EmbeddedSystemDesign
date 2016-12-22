#  ifndef atmega128
	#define atmega128
#  endif
#define FOSC 16000000// Clock Speed#define BAUD 19200
#define BAUD 19200
#define MYUBRR FOSC/16/BAUD-1

#include <avr/io.h>		      // Definition file for ATmega128
#include <avr/interrupt.h>
#include <stdio.h>

#include "cho_asm_io_def.h"   // I/O Port Definition for ATmega128
#include "GCC_c_asm_soft_delay_u_mSec.h"
#include "GCC_c_asm_uart.h"
#include "GCC_c_asm_lcd_hd44_4bit.h"
#include "GCC_get_keypad_multi.h"
#include "gnu_sciutil.h"

// SRAM Definitions
#define _SFR_OFFSET 0			// Needed to subtract 0x20 from I/O addresses

#define INPUT_FIRST_OPERAND 1
#define INPUT_SECOND_OPERAND 2
#define INIT_OPERATION 0

#define F_CPU 16000000					// Clock Speed
#define BAUD0 19200
#define BAUD1 115200

#define MYUBRR0 (F_CPU/16/BAUD0-1)
#define MYUBRR1 (F_CPU/8/BAUD1-1)		// Double the USART Transmission Speed

unsigned char operation_mode;	// Operation Mode

void Init_devices(void);
static int put_char(char c, FILE *stream);

volatile unsigned int cnt = 0;


static int put_char(char c, FILE *stream)
{
	UART_putchar(c);
	tx1_char(c);
	return 0; 
}

//call this routine to initialize all peripherals
void Init_devices(void)
{
	unsigned int ubrr = MYUBRR;		// baud rate
	asm volatile(" cli ");			//disable all interrupts
	UART_Init(ubrr);				// UART 0 √ ±‚»≠, Set baud rate(19200)
	keypad_init();			// I/O Port init
	asm volatile(" sei ");	//	Global Interrupt Enable
	LCD_init();
	fdevopen(put_char,0);   
	//all peripherals are now initialized
	operation_mode = INPUT_FIRST_OPERAND;
	keyCodeMode = KEY_CODE_TABLE_1;
}

void SCI_OutChar(char letter){ 
	UART_putchar(letter);
	tx1_char(letter);
}

unsigned char rx1_char(void)
{
	while ((UCSR1A&0x80) == 0);
	
	return UDR1;
}

void tx1_char(unsigned char data)
{
	
	while ((UCSR1A&0x20) == 0);
	
	UDR1 = data;
}

unsigned short SCI_InChar(){ 
  return (rx1_char());
}


unsigned short ASM_getchar(void){ 
  return (get_key());
}

int main (void)
{
	unsigned int num = 0;
	unsigned char ch;
	char input;

	Init_devices();

	UCSR1A = 0x00;
	UCSR1B = 0x98;
	UCSR1C = 0x06;
	UBRR1H = 0;
	UBRR1L = 103;

	LCD_SetCsr(1, 1);
	LCD_OutString("KHU EE Junyoung");
	LCD_SetCsr(2, 1);
	LCD_OutString("Avoid Balls!!!");
	

	// Infinite loop
	while(1){
		num = SCI_InUDec_OpCode(&input);
		input = get_key();
		SCI_OutChar(input);

		ch = SCI_InChar();
		

		
	}

	return 0;
}
