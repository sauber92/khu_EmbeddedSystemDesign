###############################################################################
# Makefile for the project GCC_c_asm_keypad_LCD_arithmetic
###############################################################################

## General Flags
PROJECT = GCC_c_asm_keypad_LCD_arithmetic
MCU = atmega128
TARGET = Junyoung.elf
CC = avr-gcc

CPP = avr-g++

## Options common to compile, link and assembly rules
COMMON = -mmcu=$(MCU)

## Compile options common for all C compilation units.
CFLAGS = $(COMMON)
CFLAGS += -Wall -gdwarf-2 -std=gnu99   -DF_CPU=16000000UL -Os -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -MD -MP -MT $(*F).o -MF dep/$(@F).d 

## Assembly specific flags
ASMFLAGS = $(COMMON)
ASMFLAGS += $(CFLAGS)
ASMFLAGS += -x assembler-with-cpp -Wa,-gdwarf2

## Linker flags
LDFLAGS = $(COMMON)
LDFLAGS +=  -Wl,-Map=Junyoung.map


## Intel Hex file production flags
HEX_FLASH_FLAGS = -R .eeprom -R .fuse -R .lock -R .signature

HEX_EEPROM_FLAGS = -j .eeprom
HEX_EEPROM_FLAGS += --set-section-flags=.eeprom="alloc,load"
HEX_EEPROM_FLAGS += --change-section-lma .eeprom=0 --no-change-warnings


## Objects that must be built in order to link
OBJECTS = GCC_asm_get_keypad_multi_code.o Junyoung.o GCC_asm_uart.o GCC_asm_lcd_hd44_4bit__soft_util.o GCC_asm_soft_delay_u_mSec.o gnu_avr_sciutil.o 

## Objects explicitly added by the user
LINKONLYOBJECTS = 

## Build
all: $(TARGET) Junyoung.hex Junyoung.eep Junyoung.lss size

## Compile
GCC_asm_get_keypad_multi_code.o: ../GCC_asm_get_keypad_multi_code.s
	$(CC) $(INCLUDES) $(ASMFLAGS) -c  $<

Junyoung.o: ../Junyoung.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

GCC_asm_uart.o: ../GCC_asm_uart.s
	$(CC) $(INCLUDES) $(ASMFLAGS) -c  $<

GCC_asm_lcd_hd44_4bit__soft_util.o: ../GCC_asm_lcd_hd44_4bit__soft_util.s
	$(CC) $(INCLUDES) $(ASMFLAGS) -c  $<

GCC_asm_soft_delay_u_mSec.o: ../GCC_asm_soft_delay_u_mSec.s
	$(CC) $(INCLUDES) $(ASMFLAGS) -c  $<

gnu_avr_sciutil.o: ../gnu_avr_sciutil.c
	$(CC) $(INCLUDES) $(CFLAGS) -c  $<

##Link
$(TARGET): $(OBJECTS)
	 $(CC) $(LDFLAGS) $(OBJECTS) $(LINKONLYOBJECTS) $(LIBDIRS) $(LIBS) -o $(TARGET)

%.hex: $(TARGET)
	avr-objcopy -O ihex $(HEX_FLASH_FLAGS)  $< $@

%.eep: $(TARGET)
	-avr-objcopy $(HEX_EEPROM_FLAGS) -O ihex $< $@ || exit 0

%.lss: $(TARGET)
	avr-objdump -h -S $< > $@

size: ${TARGET}
	@echo
	@avr-size -C --mcu=${MCU} ${TARGET}

## Clean target
.PHONY: clean
clean:
	-rm -rf $(OBJECTS) Junyoung.elf dep/* Junyoung.hex Junyoung.eep Junyoung.lss Junyoung.map


## Other dependencies
-include $(shell mkdir dep 2>NUL) $(wildcard dep/*)

