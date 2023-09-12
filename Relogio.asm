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

//PARA APARECER NO VISOR
unsigned char TABELA_7_SEG[] = {
0b00111111, // 0
0b00000110, // 1
0b01011011, // 2
0b01001111, // 3
0b01100110, // 4
0b01101101, // 5
0b01111101, // 6
0b00000111, // 7
0b01111111, // 8
0b01101111, // 9
0b01110111, // A
0b01111100, // B
0b00111001, // C
0b01011110, // D
0b01111001, // E
0b01110001  // F
};

	void Print_MM(int MM);
	void Print_SS(int SSS);
	void Print_HH(int HH);

	int MINUTOS = 0;
	int SEGUNDOS = 0;
	int HORAS = 0;

	int GARBAGE_COLLECTOR;

	void ATUALIZA_HORAS_MINUTOS(void) {
		asm {
			add SEGUNDOS, 1 // inc SEGUNDOS
			cmp SEGUNDOS, 60
			je  ZERAR_SEGUNDOS
			jmp BREAK
			ZERAR_SEGUNDOS:
			mov SEGUNDOS, 0
			add MINUTOS, 1
			cmp MINUTOS, 60
			je 	ZERAR_MINUTOS
			jmp BREAK
			ZERAR_MINUTOS:
			mov MINUTOS, 0
			add HORAS,1
			cmp HORAS, 24
			je  ZERA_HORAS
			jmp BREAK
			ZERA_HORAS:
			mov HORAS,0
			BREAK:
		}
    }

    void Pausa(void) {
		asm{
			mov dx,IO1
			in al,dx
			cmp al,0b00000001 //NA ENTRADA DETECTAR SINAL HIGH
			je ESPERA_IR_LOW
			cmp al,0b00000000 //NA ENTRADA DETECTAR SINAL LOW
			je ESPERA_IR_HIGH
      
			ESPERA_IR_LOW:
			in al, dx
			cmp al,0b00000000
			je BREAK
			jmp ESPERA_IR_LOW
			ESPERA_IR_HIGH:
			in al, dx
			cmp al,0b00000001
			je BREAK
			jmp ESPERA_IR_HIGH
			BREAK:
        }
    }
      
	void main(void) {
		while (1) {
			asm {
				push HORAS
				call near ptr Print_HH
				pop GARBAGE_COLLECTOR
				push MINUTOS
				call near ptr Print_MM
				pop GARBAGE_COLLECTOR
				push SEGUNDOS
				call near ptr Print_SS
				pop GARBAGE_COLLECTOR
				call ATUALIZA_HORAS_MINUTOS
				mov dx, IO1
				in  al, dx
				mov dx, IO0
				mov bl, al
				mov bh, 0
				mov al, TABELA_7_SEG[BX]
				out dx, al
				call near ptr Pausa
			}
		}
	}
   
	//IMPLEMENTANDO MINUTOS
	void Print_MM(int MM){
		asm {
			mov ax, MM //17
			mov bl, 10
			div bl
			//ah = 7 = resto //al = 1 = quociente
			mov bl,al  //jogar al para...
			mov bh,0 // ...bx
			mov al, TABELA_7_SEG[bx]
			mov dx, IO4  //DEZ MM
			out dx, al
			mov al, ah //move resto para al...
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO5 //UNID MM
			out dx, al
		}
	}
   
	//IMPLEMENTANDO SEGUNDOS
	void Print_SS(int SSS) {
		asm {
			mov ax, SSS //17
			mov bl, 10
			div bl
			//ah = 7 = resto //al = 1 = quociente
			mov bl,al  //jogar al para...
			mov bh,0 // ...bx
			mov al, TABELA_7_SEG[bx]
			mov dx, IO6  //DEZ SS
			out dx, al
			mov al, ah //move resto para al...
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO7 //UNID SS
			out dx, al
		}
	}
   
	//IMPLEMENTANDO HORAS
	void Print_HH(int HH) {
		asm {
			mov ax, HH //17
			mov bl, 10
			div bl
			//ah = 7 = resto //al = 1 = quociente
			mov bl,al  //jogar al para...
			mov bh,0 // ...bx
			mov al, TABELA_7_SEG[bx]
			mov dx, IO2  //DEZ HH
			out dx, al
			mov al, ah //move resto para al...
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO3 //UNID HH
			out dx, al
		}
  	}
