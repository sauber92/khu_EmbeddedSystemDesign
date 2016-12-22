// I/O Rg(I/O Mapped)를 Assembly Program에서 직접 사용 하기 위한 Header File
// GCC 에서는 Memory Map를 사용 하기 위하여 I/O Address + 0x20(_SFR_OFFSET) 값을 사용 함.

/* I/O registers */

/* Input Pins, Port F */
#define ASM_PINF      0x00

/* Input Pins, Port E */
#define ASM_PINE      0x01

/* Data Direction Register, Port E */
#define ASM_DDRE      0x02 

/* Data Register, Port E */
#define ASM_PORTE     0x03 

/* ADC Data Register */
#define ASM_ADCW      0x04  /* for backwards compatibility */
#ifndef __ASSEMBLER__
#define ASM_ADC       0x04 
#endif
#define ASM_ADCL      0x04 
#define ASM_ADCH      0x05 

/* ADC Control and status register */
#define ASM_ADCSR     0x06 
#define ASM_ADCSRA    0x06  /* new name in datasheet (2467E-AVR-05/02  */

/* ADC Multiplexer select */
#define ASM_ADMUX     0x07 

/* Analog Comparator Control and Status Register */
#define ASM_ACSR      0x08 

/* USART0 Baud Rate Register Low */
#define ASM_UBRR0L    0x09 

/* USART0 Control and Status Register B */
#define ASM_UCSR0B    0x0A 

/* USART0 Control and Status Register A */
#define ASM_UCSR0A    0x0B 

/* USART0 I/O Data Register */
#define ASM_UDR0      0x0C 

/* SPI Control Register */
#define ASM_SPCR      0x0D 

/* SPI Status Register */
#define ASM_SPSR      0x0E 

/* SPI I/O Data Register */
#define ASM_SPDR      0x0F 

/* Input Pins, Port D */
#define ASM_PIND      0x10 

/* Data Direction Register, Port D */
#define ASM_DDRD      0x11 

/* Data Register, Port D */
#define ASM_PORTD     0x12 

/* Input Pins, Port C */
#define ASM_PINC      0x13 

/* Data Direction Register, Port C */
#define ASM_DDRC      0x14 

/* Data Register, Port C */
#define ASM_PORTC     0x15 

/* Input Pins, Port B */
#define ASM_PINB      0x16 

/* Data Direction Register, Port B */
#define ASM_DDRB      0x17 

/* Data Register, Port B */
#define ASM_PORTB     0x18 

/* Input Pins, Port A */
#define ASM_PINA      0x19 

/* Data Direction Register, Port A */
#define ASM_DDRA      0x1A 

/* Data Register, Port A */
#define ASM_PORTA     0x1B 

/* EEPROM Control Register */
#define ASM_EECR      0x1C 

/* EEPROM Data Register */
#define ASM_EEDR      0x1D 

/* EEPROM Address Register */
#define ASM_EEAR      0x1E 
#define ASM_EEARL     0x1E 
#define ASM_EEARH     0x1F 

/* Special Function I/O Register */
#define ASM_SFIOR     0x20 

/* Watchdog Timer Control Register */
#define ASM_WDTCR     0x21 

/* On-chip Debug Register */
#define ASM_OCDR      0x22 

/* Timer2 Output Compare Register */
#define ASM_OCR2      0x23 

/* Timer/Counter 2 */
#define ASM_TCNT2     0x24 

/* Timer/Counter 2 Control register */
#define ASM_TCCR2     0x25 

/* T/C 1 Input Capture Register */
#define ASM_ICR1      0x26 
#define ASM_ICR1L     0x26 
#define ASM_ICR1H     0x27 

/* Timer/Counter1 Output Compare Register B */
#define ASM_OCR1B     0x28 
#define ASM_OCR1BL    0x28 
#define ASM_OCR1BH    0x29 

/* Timer/Counter1 Output Compare Register A */
#define ASM_OCR1A     0x2A 
#define ASM_OCR1AL    0x2A 
#define ASM_OCR1AH    0x2B 

/* Timer/Counter 1 */
#define ASM_TCNT1     0x2C 
#define ASM_TCNT1L    0x2C 
#define ASM_TCNT1H    0x2D 

/* Timer/Counter 1 Control and Status Register */
#define ASM_TCCR1B    0x2E 

/* Timer/Counter 1 Control Register */
#define ASM_TCCR1A    0x2F 

/* Timer/Counter 0 Asynchronous Control & Status Register */
#define ASM_ASSR      0x30 

/* Output Compare Register 0 */
#define ASM_OCR0      0x31 

/* Timer/Counter 0 */
#define ASM_TCNT0     0x32 

/* Timer/Counter 0 Control Register */
#define ASM_TCCR0     0x33 

/* MCU Status Register */
#define ASM_MCUSR     0x34 
#define ASM_MCUCSR    0x34  /* new name in datasheet (2467E-AVR-05/02  */

/* MCU general Control Register */
#define ASM_MCUCR     0x35 

/* Timer/Counter Interrupt Flag Register */
#define ASM_TIFR      0x36 

/* Timer/Counter Interrupt MaSK register */
#define ASM_TIMSK     0x37 

/* External Interrupt Flag Register */
#define ASM_EIFR      0x38 

/* External Interrupt MaSK register */
#define ASM_EIMSK     0x39 

/* External Interrupt Control Register B */
#define ASM_EICRB     0x3A 

/* RAM Page Z select register */
#define ASM_RAMPZ     0x3B 

/* XDIV Divide control register */
#define ASM_XDIV      0x3C 

#define ASM_SPL 	  0x3D

#define ASM_SPH 	  0x3E

#define ASM_SREG 	  0x3f

// lds, sts 명령을 사용 하여 Data space (Rg, I/O Port, Memory를 포함 한다)로 부터 
// 직접 Data를 Access 하는 방법으로 Register File를 Access 할 수 있도록 하기 위한 정의 임.
#define r0  0
#define r1  1
#define r2  2
#define r3  3
#define r4  4
#define r5  5
#define r6  6
#define r7  7
#define r8  8
#define r9  9
#define r10 10
#define r11 11
#define r12 12
#define r13 13
#define r14 14
#define r15 15
#define r16 16
#define r17 17
#define r18 18
#define r19 19
#define r20 20
#define r21 21
#define r22 22
#define r23 23
#define r24 24
#define r25 25
#define r26 26
#define r27 27
#define r28 28
#define r29 29
#define r30 30
#define r31 31
