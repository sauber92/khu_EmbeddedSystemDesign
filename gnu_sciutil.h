// filename *************** SCIutil.C ********
// Serial port I/O routines, utilities

#ifndef CR
	#define CR   0x0d
#endif
#ifndef LF
	#define LF   0x0a
#endif
#ifndef BS
	#define BS   0x08
#endif
#ifndef SPACE
	#define SPACE   0x20
#endif

extern void SCI_OutChar(char );
extern unsigned short SCI_InChar(void);

/* 
// 장치 특성에 따라 문자를 입출력 하는 기본 함수
// (문자를 입출력 하는 기본 함수(SCI_OutChar, SCI_InChar))를
// 다시 작성 하면 아래의 문자 및 숫자를 입출력 하는 함수를 
// 모두 사용할 수 있다.

//------------ SCI_OutChar 예 ------------------

void SCI_OutChar(letter){ 
USART_Write(AT91C_BASE_US0, letter);
}

//------------ SCI_InChar 예 --------------------

unsigned short SCI_InChar(){ 
  return (USART_Read(AT91C_BASE_US0));
}
*/

void SCI_OutString(char *pt);
char SCI_UpCase(char character);
unsigned short SCI_InUDec(void);
unsigned short SCI_InUDec_OpCode(char *);
short SCI_InSDec(void);
short SCI_InSDec_OpCode(char *);
void SCI_OutUDec(unsigned short n);
unsigned short SCI_InUHex(void);
void SCI_OutUHex(unsigned short number);
void SCI_OutSDec(short number);
void SCI_InString(char *string, unsigned int max);
void SCI_upCaseString(char *inString);
