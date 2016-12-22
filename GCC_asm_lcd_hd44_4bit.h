//  ***************  LCD1602.H ******************************
//  LCD Display (HD44780) on PortA
//  ground = pin 1    Vss
//  power  = pin 2    Vdd   +5V
//  10Kpot = pin 3    Vlc   contrast adjust 0 to +5V
//  PIN_E     = pin 6    E     (enable)
//  PIN_RW    = pin 5    R/W   (1 for read, 0 for write)
//  PIN_RS    = pin 4    RS    (1 for data, 0 for control/status)
//  PIN_DATA0 - 7  = pins7-14 DB0-7
//  4Bit Interface : LCD_DATA_PORT -> PA4,PA5,PA6,PA7

#ifndef LCDHD44_H
#define LCDHD44_H

#define LCD_DATA_PORT ASM_PORTA
#define LCD_DATA_PORT_DDR ASM_DDRA
#define LCD_COLTROL_PORT ASM_PORTA
#define LCD_COLTROL_PORT_DDR ASM_DDRA

#define LCD_PORT_MASK 0xFE
#define LCD_DATA_PORT_MASK 0xF0
#define LCD_COLTROL_PORT_MASK 0x0E

// PA1 : RS, PA2 : R/W, PA3 : E
// Data Rg / Instruction Rg ¿Í Read / Write Operation ¼±ÅÃ Mask
#define LCD_INST_W 0x00
#define LCD_INST_R 0x04
#define LCD_DATA_W 0x02
#define LCD_DATA_R 0x06
// LCD Enable Control Bit Position
#define LCD_COLTROL_E 0x03

#define FIST_LINE_START_ADDRESS 0x80
#define SECOND_LINE_START_ADDRESS 0xC0


.extern LCD_init

// Output a single ASCII character to LCD
.extern LCD_OutChar

.extern  LCD_OutCommand

// Clear the LCD screen
.extern LCD_Clear

// Output String (NULL termination)
.extern LCD_OutString

// Set Cursor Position
.extern LCD_SetCsr

// Output a single ASCII character at row-colum position  
.extern LCD_LCD_OutChar_row_col

// change the LCD display mode
/* Entry Mode Set 0,0,0,0,0,1,I/D,S
     I/D=1 for increment cursor move direction
        =0 for decrement cursor move direction
     S  =1 for display shift
        =0 for no display shift
   Display On/Off Control 0,0,0,0,1,D,C,B
     D  =1 for display on
        =0 for display off
     C  =1 for cursor on
        =0 for cursor off
     B  =1 for blink of cursor position character
        =0 for no blink
   Cursor/Display Shift  0,0,0,1,S/C,R/L,*,*
     S/C=1 for display shift
        =0 for cursor movement
     R/L=1 for shift to left
        =0 for shift to right
   Function Set   0,0,1,DL,N,F,*,*
     DL=1 for 8 bit
       =0 for 4 bit
     N =1 for 2 lines
       =0 for 1 line
     F =1 for 5 by 10 dots
       =0 for 5 by 7 dots */
#endif  //#ifndef LCD1602_H  
