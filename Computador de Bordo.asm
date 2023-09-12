#define IO0 	0x0000
#define IO1 	0x0200
#define IO2 	0x0400
#define IO3 	0x0600
#define IO4 	0x0800
#define IO5 	0x0A00
#define IO6 	0x0C00
#define IO7 	0x0E00
#define IO8 	0x1000
#define IO9 	0x1200
#define IO10 	0x1400
#define IO11 	0x1600
#define IO12 	0x1800
#define IO13 	0x1A00
#define IO14 	0x1C00
#define IO15 	0x1E00

void main(void) {
	while (1) {
		asm {
	    MOV DX, IO1
	    IN AL, DX
	    AND AL, 0b00001111
	    CMP AL, 0b0000
	    JE ESCREVE_0
	    CMP AL, 0b0001
	    JE ESCREVE_1
	    CMP AL, 0b0010
	    JE ESCREVE_2
	    CMP AL, 0b0011
	    JE ESCREVE_3
	    CMP AL, 0b0100
	    JE ESCREVE_4
	    CMP AL, 0b0101
	    JE ESCREVE_5
	    CMP AL, 0b0110
	    JE ESCREVE_6
	    CMP AL, 0b0111
	    JE ESCREVE_7
	    CMP AL, 0b1000
	    JE ESCREVE_8
	    CMP AL, 0b1001
	    JE ESCREVE_9
	    CMP AL, 0b1010
	    JE ESCREVE_A
	    CMP AL, 0b1011
	    JE ESCREVE_B
	    CMP AL, 0b1100
	    JE ESCREVE_C
	    CMP AL, 0b1101
	    JE ESCREVE_D
	    CMP AL, 0b1110
	    JE ESCREVE_E
	    CMP AL, 0b1111
	    JE ESCREVE_F
	      
ESCREVE_0:
	    MOV DX, IO0
	    MOV AL, 0b00111111
	    OUT DX, AL
	    JMP BREAK
	      
ESCREVE_1:
	    MOV DX, IO0
	    MOV AL, 0b000000110
	    OUT DX, AL
	    JMP BREAK

ESCREVE_2:
	    MOV DX, IO0
	    MOV AL, 0b01011011
	    OUT DX, AL
	    JMP BREAK
	      
ESCREVE_3:
	    MOV DX, IO0
	    MOV AL, 0b01001111
	    OUT DX, AL
	    JMP BREAK

ESCREVE_4:
	    MOV DX, IO0
	    MOV AL, 0b01100110
	    OUT DX, AL
	    JMP BREAK

ESCREVE_5:
	    MOV DX, IO0
	    MOV AL, 0b01101101
	    OUT DX, AL
	    JMP BREAK

ESCREVE_6:
	    MOV DX, IO0
	    MOV AL, 0b01111101
	    OUT DX, AL
	    JMP BREAK

ESCREVE_7:
	    MOV DX, IO0
	    MOV AL, 0b00000111
	    OUT DX, AL
	    JMP BREAK

ESCREVE_8:
	    MOV DX, IO0
	    MOV AL, 0b01111111
	    OUT DX, AL
	    JMP BREAK

ESCREVE_9:
	    MOV DX, IO0
	    MOV AL, 0b01101111
	    OUT DX, AL
	    JMP BREAK

ESCREVE_A:
	    MOV DX, IO0
	    MOV AL, 0b01110111
	    OUT DX, AL
	    JMP BREAK

ESCREVE_B:
	    MOV DX, IO0
	    MOV AL, 0b01111100
	    OUT DX, AL
	    JMP BREAK

ESCREVE_C:
	    MOV DX, IO0
	    MOV AL, 0b00111001
	    OUT DX, AL
	    JMP BREAK

ESCREVE_D:
	    MOV DX, IO0
	    MOV AL, 0b01011110
	    OUT DX, AL
	    JMP BREAK

ESCREVE_E:
	    MOV DX, IO0
	    MOV AL, 0b01111001
	    OUT DX, AL
	    JMP BREAK

ESCREVE_F:
	    MOV DX, IO0
	    MOV AL, 0b01110001
	    OUT DX, AL
	    JMP BREAK

BREAK:
		}
	}
}

// MOV DX, IO1 	// Endereco controladora de teclas
// IN AL, DX   	// Joga em AL o estado das teclas
// MOV DX, IO0 	// Endereco controladora de leds
// OUT DX, AL   // joga AL nos leds