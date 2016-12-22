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
// ��ġ Ư���� ���� ���ڸ� ����� �ϴ� �⺻ �Լ�
// (���ڸ� ����� �ϴ� �⺻ �Լ�(SCI_OutChar, SCI_InChar))��
// �ٽ� �ۼ� �ϸ� �Ʒ��� ���� �� ���ڸ� ����� �ϴ� �Լ��� 
// ��� ����� �� �ִ�.

//------------ SCI_OutChar �� ------------------

void SCI_OutChar(letter){ 
USART_Write(AT91C_BASE_US0, letter);
}

//------------ SCI_InChar �� --------------------

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
