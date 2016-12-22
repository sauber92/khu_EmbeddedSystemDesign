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
// 하나의 문자를 입출력 하는 함수(SCI_OutChar, SCI_InChar)로 장치
// ( 예: Debug, LCD 등)의 특성에 따라 이 함수를 다시 작성 하면 아래의
// 문자 및 숫자를 입출력 하는 함수를 모두 사용할 수 있다.

extern void SCI_OutChar(char );
extern unsigned short SCI_InChar(void)

//-------------------------SCI_OutChar to USART------------------------

void SCI_OutChar(letter){ 
	tx0_char(letter);
}

//-------------------------SCI_InChar from USART------------------------

unsigned short SCI_InChar(){ 
  return (rx0_char());
}
*/

//-------------------------SCI_OutString------------------------
// Output String (NULL termination)

void SCI_OutString(char *pt){ char letter;
  while((letter=*pt++)){
    SCI_OutChar(letter);
  }
}

//--------------------SCI_UpCase-------------------------------
// converts lowercase to uppercase
// char by subtracting	$20 from lowercase ASCII to	make uppercase ASCII

char SCI_UpCase(char character){	
  return ((character>='a') && (character<='z'))?character-0x20:character;}

//----------------------SCI_InUDec-------------------------------
// InUDec accepts ASCII input in unsigned decimal format
//     and converts to a 16 bit unsigned number
//     with a maximum value of 65535
// If you enter a number above 65535, it will truncate without reporting the error
// Backspace will remove last digit typed

unsigned short SCI_InUDec(void){	
unsigned short number=0, length=0;
unsigned char character;	

  character=SCI_InChar();
// The next line checks that the input is a digit, 0-9.
// If the character is not 0-9, it is ignored and not echoed
  while(((character>='0') && (character<='9'))){ 
      number = 10*number+(character-'0');   // this line overflows if above 65535
      length++;
      SCI_OutChar(character);
      character=SCI_InChar();
  }
  return number;
}

//----------------------SCI_InUDec-------------------------------
// InUDec accepts ASCII input in unsigned decimal format
//     and converts to a 16 bit unsigned number
//     with a maximum value of 65535
// If you enter a number above 65535, it will truncate without reporting the error
// Backspace will remove last digit typed

unsigned short SCI_InUDec_OpCode(char * op_code){	
unsigned short number=0, length=0;
unsigned char character;	

  character=SCI_InChar();
// The next line checks that the input is a digit, 0-9.
// If the character is not 0-9, it is ignored and not echoed
  while(((character>='0') && (character<='9'))){ 
      number = 10*number+(character-'0');   // this line overflows if above 65535
      length++;
      SCI_OutChar(character);
      character=SCI_InChar();
  }
  *op_code = character;

  return number;
}

//----------------------------SCI_InSDec-----------------------------
// InSDec accepts ASCII input in signed decimal format
//    and converts to a signed 16 bit number 
//    with an absolute value up to 32767
// If you enter a number above 32767 or below -32767, 
//    it will truncate without reporting the error
// Backspace will remove last digit typed

short SCI_InSDec(void){	
short number=0, sign=1;	// sign flag 1=positive 0=negative
unsigned int length=0;
unsigned char character;

  character=SCI_InChar();
  if(character=='-'){
    sign = -1;
    length++;
    SCI_OutChar('-');	// if - inputted, sign is negative
    }
  else if(character=='+'){
    length++;
    SCI_OutChar('+');	//if + inputted, sign is positive
  }

  if((character=='-') || (character=='+'))character=SCI_InChar();
  
// The next line checks that the input is a digit, 0-9.
// If the character is not 0-9, it is ignored and not echoed
  while(((character>='0') && (character<='9'))){ 
      number = 10*number+(character-'0');   // this line overflows if above 65535
      length++;
      SCI_OutChar(character);
      character=SCI_InChar();
  }
  
  return sign*number;
}

//----------------------------SCI_InSDec-----------------------------
// InSDec accepts ASCII input in signed decimal format
//    and converts to a signed 16 bit number 
//    with an absolute value up to 32767
// If you enter a number above 32767 or below -32767, 
//    it will truncate without reporting the error
// Backspace will remove last digit typed

short SCI_InSDec_OpCode(char * op_code){	
short number=0, sign=1;	// sign flag 1=positive 0=negative
unsigned int length=0;
unsigned char character;

  character=SCI_InChar();
  if(character=='-'){
    sign = -1;
    length++;
    SCI_OutChar('-');	// if - inputted, sign is negative
    }
  else if(character=='+'){
    length++;
    SCI_OutChar('+');	//if + inputted, sign is positive
  }

  if((character=='-') || (character=='+'))character=SCI_InChar();
  
// The next line checks that the input is a digit, 0-9.
// If the character is not 0-9, it is ignored and not echoed
  while(((character>='0') && (character<='9'))){ 
      number = 10*number+(character-'0');   // this line overflows if above 65535
      length++;
      SCI_OutChar(character);
      character=SCI_InChar();
  }
  
  *op_code = character;
  return sign*number;
}

//-----------------------SCI_OutUDec-----------------------
// Output a 16 bit number in unsigned decimal format
// Variable format 1-5 digits with no space before or after
// This function uses recursion to convert decimal number
//   of unspecified length as an ASCII string 

void SCI_OutUDec(unsigned short n){
  if(n >= 10){
    SCI_OutUDec(n/10); // Recursive Operation
    n=n%10;
  }
  SCI_OutChar(n+'0'); /* n is between 0 and 9 */
}

//----------------------SCI_OutSDec---------------------------------------
// Output a 16 bit number in signed decimal format
// Variable format (optional sign)1 to 5 digits with no space before or after
// This function checks if the input parameter is negative,  
// If the number is negative, then 
//    1) it outputs a "-", 
//    2) negates the number and 
//    3) outputs it with OutUDec.
// Otherwise, it just calls OutUDec (i.e., no "+" sign)

void SCI_OutSDec(short number){
  if(number<0){	
    number = -number;
    SCI_OutChar('-');
  }
  SCI_OutUDec(number);
}

//---------------------SCI_InUHex----------------------------------------
// InUHex accepts ASCII input in unsigned hexadecimal (base 16) format
// No '$' or '0x' need be entered, just the 1 to 4 hex digits
// It will convert lower case a-f to uppercase A-F
//     and converts to a 16 bit unsigned number
//     with a maximum value of FFFF
// If you enter a number above FFFF, it will truncate without reporting the error
// Backspace will remove last digit typed

unsigned short SCI_InUHex(void){	
unsigned short number=0, digit, length=0;
unsigned char character;

  while((character=SCI_UpCase(SCI_InChar()))!=CR){	
    digit = 0x10; // assume bad
    if((character>='0') && (character<='9')){
      digit = character-'0';
    }
    else if((character>='A') && (character<='F')){ 
      digit = (character-'A')+0xA;
    }

// If the character is not 0-9 or A-F, it is ignored and not echoed
    if(digit<=0xF ){	
      number = number*0x10+digit;
      length++;
      SCI_OutChar(character);
    }

// Backspace outputted and return value changed if a backspace is inputted
    else if(character==BS && length){
      number /=0x10;
      length--;
      SCI_OutChar(character);
    }
  }
  return number;
}

//--------------------------SCI_OutUHex----------------------------
// Output a 16 bit number in unsigned hexadecimal format
// Variable format 1 to 4 digits with no space before or after
// This function uses recursion to convert the number of 
//   unspecified length as an ASCII string

void SCI_OutUHex(unsigned short number){
  if(number>=0x10)	{
    SCI_OutUHex(number/0x10);
    SCI_OutUHex(number%0x10);
  }
  else if(number<0xA){
    SCI_OutChar(number+'0');
  }
  else{
    SCI_OutChar((number-0x0A)+'A');
  }
}

//------------------------SCI_InString------------------------
// This function accepts ASCII characters from the serial port
//    and adds them to a string until a carriage return is inputted 
//    or until max length of the string is reached.  
// It echoes each character as it is inputted.  
// If a backspace is inputted, the string is modified 
//    and the backspace is echoed
// InString terminates the string with a null character
// -- Modified by Agustinus Darmawan + Mingjie Qiu --

void SCI_InString(char *string, unsigned int max) {	
unsigned int length=0;
unsigned char character;

  while((character=SCI_InChar())!=CR){
    if(character==BS){
      if(length){
        string--;
        length--;
        SCI_OutChar(BS);
      }
    }
    else if(length<max){
      *string++=character;
      length++; 
      SCI_OutChar(character);
    }
  }
  *string = 0;   // 문자열의 끝에 Null code 삽입함.
}

//------------------------SCI_upCaseString------------------------
// converts a NULL terminated string to uppercase

void SCI_upCaseString(char *inString){
  char *pt = inString;

// 'a' = 0x61 and 'A' = 0x41, so their difference is 0x20 
  while(*pt){  //  NULL => done 
    if((*pt >= 'a') && (*pt <= 'z'))
      *pt -= 0x20;
    pt++;
  }
}
