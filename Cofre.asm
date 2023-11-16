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

// 8251A USART 

#define ADR_USART_DATA   (IO7 + 00h)
//ONDE VOCE VAI MANDAR E RECEBER DADOS DO 8251

#define ADR_USART_CMD   (IO7 + 02h)
//É O LOCAL ONDE VOCE VAI ESCREVER PARA PROGRAMAR O 8251
//WRITE 0E02H

#define ADR_USART_STAT  (IO7 + 02h)
//RETORNA O STATUS SE UM CARACTER FOI DIGITADO NO TERMINAL
//RETORNA O STATUS SE POSSO TRANSMITIR CARACTER PARA O TERMINAL
//READ 0E02H 

unsigned char TABELA_TECLADO[] = {
'7','8','9','/',
'4','5','6','*',
'1','2','3','-',
'C','0','=','+'};

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

unsigned char RESPONSE_7_SEG[] = {
0b00111000, //L
0b00111110, //U
0b01111001, //E
0b01110001, //F
};

unsigned char ANIMATION_7_SEG[] = {
0b00000001,
0b00000010,
0b00000100,
0b00001000,
0b00010000,
0b00100000
};

void Print_MM(int MM);
void Print_SS(int SSS);
void Print_HH(int HH);
void Print_String(void);
void Print_MM_SS(void);

int MINUTOS = 0;
int SEGUNDOS = 0;
int HORAS = 0;

int GARBAGE_COLLECTOR;

char Tecla;

char ZERO[] =  "ZERO";
char UM[] =    "UM";
char DOIS[] =  "DOIS";
char TRES[] =  "TRES";
char QUATRO[]= "QUATRO";
char CINCO[] = "CINCO";
char SEIS[] =  "SEIS";
char SETE[] =  "SETE";
char OITO[] =  "OITO";
char NOVE[] =  "NOVE";

unsigned char Tab_Mens1[] = "Entre com a Tabuada de";
unsigned char Tab_Mens2[] = "A tabuada de ";
unsigned char Tab_Mens3[] = " * ";
unsigned char Tab_Mens4[] = " = ";

unsigned char Terminal_Mens[] = "Entre com uma senha de 4 digitos no teclado 4x4";
unsigned char Terminal_Mens2[] = "CHAME O TECNICO DO FABRICANTE DO COFRE PARA A LIBERAÇAO DO COFRE";

int erroCount = 0;
int locked = 0;
int reset = 0;

#define TAM_STRING 64

char Mensagem[TAM_STRING+1];

void MANDA_CARACTER(void);
void ATUALIZA_HORAS_MINUTOS(void);

void Le_Tecla(void);
void Print_MM(int MM);
void Print_SS(int SSS);
void RECEBER_CARACTER_INTERRUPT(void);
void PRINT_MM_SS(void);

void INICIALIZA_8259(void) {
   _asm {
		pushf
		push ax
		push dx
		mov dx, IO8 
		mov al, 13H
		out dx, al
		mov dx, IO8 + 2 
		mov al, 70h
		out dx, al
		mov al, 1bh
		out dx, al
		mov al, 00h
		out dx, al
		pop dx
		pop ax
		popf
    }
}

void _interrupt _far nmi_handler(void) {			
}

void _interrupt _far int0_handler(void) {
	asm call Print_MM_SS
	asm call ATUALIZA_HORAS_MINUTOS
}

void _interrupt _far int1_handler(void) {
	RECEBER_CARACTER_INTERRUPT();
}

void _interrupt _far int2_handler(void) {
	Le_Tecla();
}

void _interrupt _far int3_handler(void){
	asm mov al,'3'
	asm call MANDA_CARACTER
}

void _interrupt _far int4_handler(void) {
	asm mov al,'4'
	asm call MANDA_CARACTER
}

void _interrupt _far int5_handler(void) {
	asm mov al,'5'
	asm call MANDA_CARACTER
}

void _interrupt _far int6_handler(void){
	asm mov al,'6'
	asm call MANDA_CARACTER
}

void _interrupt _far int7_handler(void) {
	asm mov al,'7'
	asm call MANDA_CARACTER
}

//ESTA ROTINA ALTERA O VETOR DE INTERRUPCAO INT_NO PARA QUE APONTE PARA SERVICE_PROC
void set_int(unsigned char int_no, void * service_proc) { 
	_asm { 
		push es
		xor ax, ax  //zera ax
		mov es, ax  // manda ES aponta para SEGMENTO 0
		mov al, int_no //pega no numero da interrupcao 2
		xor ah, ah     //zera ah //ax 0000000000000010
		shl ax, 1      //shift left rotaciona esquerda 0000000000000010													//0000000000000100                                               //0000000000001000       
		shl ax, 1      //shift left rotaciona esquerda
		mov si, ax  //manda si apontar para endereco 8
		mov ax, service_proc //pega o endereco da tratadora
		mov es:[si], ax //escreve na memoria a partir de 8 
		inc si //
		inc si //
		mov bx, cs //segmento onde esta a tua rotina tratadora, seg 0 (Code Segmento)
		mov es:[si], bx //escreve segmento
		pop es  //gravamos entao em 8,9,10,11 o endereco do tratador e o segmento onde ele se encontra
    }
}

//19200,8,N,1
void INICIALIZA_8251(void) {
	_asm {
		MOV AL,0
		MOV DX, ADR_USART_CMD
		OUT DX,AL
		OUT DX,AL
		OUT DX,AL
		MOV AL,40H
		OUT DX,AL
		MOV AL,4DH
		OUT DX,AL
		MOV AL,37H
		OUT DX,AL
    }
}

void MANDA_CARACTER(void) {
	_asm {
		PUSHF  ; SALVA FLAGS Z E C
		PUSH DX
		PUSH AX  ; SALVA AL   AX = AH/AL
		
BUSY:
		MOV DX, ADR_USART_STAT
		IN  AL,DX
		TEST AL,1 ; 0000000S
		JZ BUSY
		MOV DX, ADR_USART_DATA
		POP AX  ; RESTAURA AL
		OUT DX,AL
		POP DX
		POPF ; RESTAURA FLAGS Z E C
	}  
}

void RECEBER_CARACTER(void) {
	_asm {
		PUSHF
		PUSH DX
		
AGUARDA_CARACTER:
		MOV DX, ADR_USART_STAT
		IN  AL,DX
		TEST AL,2 ;000000S0
		JZ AGUARDA_CARACTER
		MOV DX, ADR_USART_DATA
		IN AL,DX
		SHR AL,1 
		
NAO_RECEBIDO:
		POP DX
		POPF
   }
}

//AO TERMINO DESTA ROTINA, TEREMOS EM AL
//O CODIGO ASCII DA TECLA DIGITADA

char Tecla;
char Ha_Tecla_Digitada = 0;

void RECEBER_CARACTER_INTERRUPT(void) {
	_asm {
		PUSHF
		PUSH DX
		MOV DX, ADR_USART_DATA
		IN AL,DX
		mov Tecla,al
		mov Ha_Tecla_Digitada,1
		POP DX
		POPF
	}
}

char *NUMEROS[] = {"ZERO", "UM", "DOIS"};

int KeyPressed = 0;

void Le_Tecla(void) {
	asm {
	
Aguarda_Tecla:
		mov dx, IO6
		in  al, dx
		mov ah, al
		and al, 0b10000000 //verica bit mais esquerda ligado
		cmp al, 0b10000000
		jne Aguarda_Tecla
		mov KeyPressed, 1
		mov al, ah
		and al, 0b00001111
		mov bl, al
		mov bh, 0
		mov al, TABELA_TECLADO[BX]
		mov Tecla, al
		
Aguarda_DA_IR_BAIXO:
		mov dx, IO6
		in  al, dx
		mov ah, al
		and al, 0b10000000 //verica bit mais esquerda ligado
		cmp al, 0b10000000
		je Aguarda_DA_IR_BAIXO
	}
}

void ATUALIZA_HORAS_MINUTOS(void){
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
	asm {
		mov dx, IO6
		in al, dx
		cmp al,0b00000001 //na entrada, detectei sinal high
		je  ESPERA_IR_LOW
		cmp al,0b00000000 //na entrada, detectei sinal low
		je  ESPERA_IR_HIGH
		
ESPERA_IR_LOW:
		in al, dx
		cmp al, 0b00000000
		je BREAK
		jmp ESPERA_IR_LOW
		
ESPERA_IR_HIGH:
	  in al, dx
	  cmp al, 0b00000001
	  je BREAK
	  jmp ESPERA_IR_HIGH
BREAK:
	}
}

char Digito_1;
char Digito_2;

char Mensagem_1[] = {"HELLO WORLD"};

void Pula_Linha(void) {
	asm {
		mov al, 13
		call MANDA_CARACTER
		mov al, 10
		call MANDA_CARACTER
	}
}

void Print_String(void) {
	asm {
	
PROCURA_NULL:
		mov al, [bx] //coloca em al "H"
		cmp al, 0 //null ?
		je  BREAK
		call MANDA_CARACTER
		inc bx
		jmp PROCURA_NULL
		
BREAK:
	}
}

unsigned char QNT_CARACTERES_DIGITADOS;

//bx deve apontar para a memoria que guardara o Texto
void Le_String(void) {
	asm {
		mov QNT_CARACTERES_DIGITADOS,0
		
AGUARDA_CARACTER:	
		call RECEBER_CARACTER
		cmp  al, 13 //enter
		je   PRESSIONOU_ENTER
		cmp  al, 8  //backspace
		je   PRESSIONOU_BACKSPACE		
		cmp QNT_CARACTERES_DIGITADOS, TAM_STRING
		je  AGUARDA_CARACTER
		mov [bx], al
		inc bx
		mov  byte ptr [bx], 0 //null
		inc QNT_CARACTERES_DIGITADOS
		call MANDA_CARACTER
		jmp AGUARDA_CARACTER
		
PRESSIONOU_ENTER:
		CMP QNT_CARACTERES_DIGITADOS,0
		JE AGUARDA_CARACTER
		JMP SAIDA_Le_String
		
PRESSIONOU_BACKSPACE:
		cmp QNT_CARACTERES_DIGITADOS,0
		je  AGUARDA_CARACTER
		dec bx
		mov byte ptr[bx], 0
		dec QNT_CARACTERES_DIGITADOS
		mov al, 8 //opcional
		call MANDA_CARACTER
		jmp AGUARDA_CARACTER
		
SAIDA_Le_String:
	}
}

//bx deve apontar para a memoria que guardara o Texto
void Le_Byte_Modo_I(void) {
	asm {
		mov QNT_CARACTERES_DIGITADOS,0
		
AGUARDA_CARACTER:	
		call RECEBER_CARACTER
		cmp  al, 13 //enter
		je   PRESSIONOU_ENTER
		cmp  al, 8  //backspace
		je   PRESSIONOU_BACKSPACE		
		cmp QNT_CARACTERES_DIGITADOS, 3
		je  AGUARDA_CARACTER
		cmp al, '0'
		jl  AGUARDA_CARACTER
		cmp al, '9'
		jg  AGUARDA_CARACTER
		mov [bx], al
		inc bx
		mov  byte ptr [bx], 0 //null
		inc QNT_CARACTERES_DIGITADOS
		call MANDA_CARACTER
		jmp AGUARDA_CARACTER
		
PRESSIONOU_ENTER:
		CMP QNT_CARACTERES_DIGITADOS,0
		JE AGUARDA_CARACTER
		CMP QNT_CARACTERES_DIGITADOS,3
		JNE AGUARDA_CARACTER
		JMP SAIDA_Le_String
		
PRESSIONOU_BACKSPACE:
		cmp QNT_CARACTERES_DIGITADOS,0
		je  AGUARDA_CARACTER
		dec bx
		mov byte ptr[bx], 0
		dec QNT_CARACTERES_DIGITADOS
		mov al, 8 //opcional
		call MANDA_CARACTER
		jmp AGUARDA_CARACTER
		
SAIDA_Le_String:
		mov ch, Mensagem[0] // '1' 49
		mov dh, Mensagem[1] // '2' 50
		mov dl, Mensagem[2] // '3' 51
		sub ch, '0' //1*100 
		sub dh, '0' //2*10
		sub dl, '0' //3*1
		// mul cl <==== ax = al * cl
		mov di, 0
		mov cl, 100
		mov al, ch
		mul cl
		add di, ax //soma parcial da multiplicacao
		mov cl, 10
		mov al, dh
		mul cl
		add di, ax
		mov cl, 1
		mov al, dl
		mul cl
		add di, ax //pronto, di = 1*100+2*10+3*1
		cmp di, 255
		jg AGUARDA_CARACTER 
	}
}

unsigned char Temp[3+1];
unsigned char Result;
unsigned int  Reg_Di;

void Verifica_Tempo_Real(void) {
	asm {
		CMP QNT_CARACTERES_DIGITADOS,1
		JE  MULT_UNIDADE
		CMP QNT_CARACTERES_DIGITADOS,2
		JE  MULT_DEZ_UNID
		CMP QNT_CARACTERES_DIGITADOS,3
		JE  MULT_CENT_DEZ_UNID
		
MULT_UNIDADE:
		mov di, 0
		mov ch, Temp[0] // '1' 49
		sub ch, '0' //ascii para int
		mov al, ch
		mov ah, 0
		mov cl, 1		
		mul cl
		add di, ax //pronto, di = 1*100+2*10+3*1		
		jmp SAI_ROTINA_TEMPO_REAL
		
MULT_DEZ_UNID:
		mov ch, Temp[0] // '1' 49
		mov dh, Temp[1] // '2' 50
		sub ch, '0' //*10
		sub dh, '0' //*1
		// mul cl <==== ax = al * cl
		mov di, 0
		mov cl, 10
		mov al, ch
		mul cl
		add di, ax //soma parcial da multiplicacao
		mov cl, 1
		mov al, dh
		mul cl
		add di, ax
		jmp SAI_ROTINA_TEMPO_REAL

MULT_CENT_DEZ_UNID:
		mov ch, Temp[0] // '1' 49
		mov dh, Temp[1] // '2' 50
		mov dl, Temp[2] // '3' 51
		sub ch, '0' //1*100 
		sub dh, '0' //2*10
		sub dl, '0' //3*1
		// mul cl <==== ax = al * cl
		mov di, 0
		mov cl, 100
		mov al, ch
		mul cl
		add di, ax //soma parcial da multiplicacao
		mov cl, 10
		mov al, dh
		mul cl
		add di, ax
		mov cl, 1
		mov al, dl
		mul cl
		add di, ax //pronto, di = 1*100+2*10+3*1
		
SAI_ROTINA_TEMPO_REAL:
		mov Reg_Di,di
	}
}

//bx deve apontar para a memoria que guardara o Texto
void Le_Byte_Modo_II(void) {
	asm {
		mov bx, offset Temp
		mov QNT_CARACTERES_DIGITADOS,0
		
AGUARDA_CARACTER:	
		call RECEBER_CARACTER
		cmp  al, 13 //enter
		je   PRESSIONOU_ENTER
		cmp  al, 8  //backspace
		je   PRESSIONOU_BACKSPACE		
		cmp QNT_CARACTERES_DIGITADOS, 3
		je  AGUARDA_CARACTER
		cmp al, '0'
		jl  AGUARDA_CARACTER
		cmp al, '9'
		jg  AGUARDA_CARACTER

		mov [bx], al
		inc bx
		mov  byte ptr [bx], 0 //null
		inc QNT_CARACTERES_DIGITADOS
		call MANDA_CARACTER
		JMP  VERIFICA_EM_TEMPO_REAL

PRESSIONOU_ENTER:
		CMP QNT_CARACTERES_DIGITADOS,0
		JE AGUARDA_CARACTER
		//CMP QNT_CARACTERES_DIGITADOS,3
		//JNE AGUARDA_CARACTER
		JMP SAIDA_Le_String
		
PRESSIONOU_BACKSPACE:
		cmp QNT_CARACTERES_DIGITADOS,0
		je  AGUARDA_CARACTER
		dec bx
		mov byte ptr[bx], 0
		dec QNT_CARACTERES_DIGITADOS
		mov al, 8 //opcional
		call MANDA_CARACTER
		jmp AGUARDA_CARACTER
		
VERIFICA_EM_TEMPO_REAL:
		CALL Verifica_Tempo_Real
		cmp Reg_Di, 255
		jg APAGA_ULTIMO_CARACTER
		JMP AGUARDA_CARACTER
		
APAGA_ULTIMO_CARACTER:
		MOV AL,8
		CALL MANDA_CARACTER
		DEC BX
		MOV BYTE PTR [BX], 0
		DEC QNT_CARACTERES_DIGITADOS
		JMP AGUARDA_CARACTER
		
SAIDA_Le_String:
		CALL Verifica_Tempo_Real
		push Reg_Di
		pop  ax //al tem o resultado do numero digitado (int)
		mov  Result, al
	}
}

//mov al,254
//call Print_Int
//al deve conter o numero a ser impresso!

unsigned Contador_Pilha;
void Print_Int(void) {   

Contador_Pilha = 0; // mov Contador_Pilha,0
	
	asm {
	
Decomposicao:
		mov cl, 10
		mov ah,0
		div cl 
		push ax //pois ax tem ah
		inc Contador_Pilha
		cmp al, 0
		jne Decomposicao
		
Desempilha:
		pop ax
		mov al, ah //move resto para al
		add al, '0'
		call MANDA_CARACTER
		dec Contador_Pilha
		cmp Contador_Pilha,0
		jne Desempilha
	}
}

void Print_MM_SS(void) {
	Print_MM(MINUTOS);
    Print_SS(SEGUNDOS);
}

unsigned char animationPosition = 0;
void DisplayAnimation(void){
    asm{
		mov bl, animationPosition
		mov al, ANIMATION_7_SEG[bx]
		mov dx, IO0
		out dx, al
		inc animationPosition
		cmp animationPosition, 5
		jg RESETCOUNT
		jmp BREAK
		RESETCOUNT:
		mov animationPosition, 0
	BREAK:
	}
}

unsigned char SenhaDigitada[4]; //1234 ou 4321
unsigned char SenhaTecnico[6]; //Libera
int TecnicoSenhaPosition = 0;
int SenhaPosition = 0;
int WaitOutput = 0;
int TempSegundos = 0;
int Lock = 0;
int Unlock = 0;
int Erro = 0;
int TotalErro = 0;

void main(void) {
	
	asm call INICIALIZA_8251
	asm call INICIALIZA_8259

	//NMI
    set_int(0x02, (void *)&nmi_handler); 
    set_int(0x70, (void *)&int0_handler); 
    set_int(0x71, (void *)&int1_handler); 
    set_int(0x72, (void *)&int2_handler); 
    set_int(0x73, (void *)&int3_handler); 
    set_int(0x74, (void *)&int4_handler); 
    set_int(0x75, (void *)&int5_handler); 
    set_int(0x76, (void *)&int6_handler); 
    set_int(0x77, (void *)&int7_handler); 

	asm STI
    
    //PROGRAMA DA SENHA
    while(1){
		asm mov bx, offset Terminal_Mens
		asm call Print_String
		asm call Pula_Linha
      
    while(reset == 0) {
		if(TempSegundos != SEGUNDOS){
			if(WaitOutput != 1) {
			   asm call DisplayAnimation
			}
			TempSegundos = SEGUNDOS;
			WaitOutput = 0;
		} else if(KeyPressed == 1) {
			if(SenhaPosition < 4) {
				asm{
					mov al, Tecla
					mov bx, SenhaPosition
					mov SenhaDigitada[bx], al
					sub al, '0'
					mov bl, al
					mov bh, 0
					mov al, TABELA_7_SEG[BX]
					call DisplayAnimation
					mov dx, IO0
					out dx, al
					mov KeyPressed, 0
					mov WaitOutput, 1
					inc SenhaPosition
				}
			}
		} else if(SenhaPosition >= 4) {
			asm {
				mov bx, 0
				cmp SenhaDigitada[bx], '1'
				jne NOTLOCK
				mov bx, 1
				cmp SenhaDigitada[bx], '2'
				jne NOTLOCK
				mov bx, 2
				cmp SenhaDigitada[bx], '3'
				jne NOTLOCK
				mov bx, 3
				cmp SenhaDigitada[bx], '4'
				jne NOTLOCK
				je ISLOCK
				NOTLOCK:
				inc Erro
				mov bx, 0
				cmp SenhaDigitada[bx], '4'
				jne NOTUNLOCK
				mov bx, 1
				cmp SenhaDigitada[bx], '3'
				jne NOTUNLOCK
				mov bx, 2
				cmp SenhaDigitada[bx], '2'
				jne NOTUNLOCK
				mov bx, 3
				cmp SenhaDigitada[bx], '1'
				jne NOTUNLOCK
				je ISUNLOCK
				NOTUNLOCK:
				inc Erro
				jmp ENDCHECKING
				ISLOCK:
				inc Lock
				jmp ENDCHECKING
				ISUNLOCK:
				inc Unlock
				jmp ENDCHECKING
				ENDCHECKING:
			}
			if(Erro == 2){
				asm{
					mov bx, 2
					mov al, RESPONSE_7_SEG[bx]
					mov dx, IO0
					out dx, al
					inc TotalErro
					mov Erro, 0
				}
			} else if(Lock == 1){
				asm{
					mov bx, 0
					mov al, RESPONSE_7_SEG[bx]
					mov dx, IO0
					out dx, al
					mov Lock, 0
					mov Erro, 0
				}
			} else if(Unlock == 1){
				asm{
					mov bx, 1
					mov al, RESPONSE_7_SEG[bx]
					mov dx, IO0
					out dx, al
					mov Unlock, 0
					mov Erro, 0
				}
			}
			
			asm mov WaitOutput, 1
			asm mov SenhaPosition, 0
		}
		
		if(TotalErro >= 3){
			asm{
				mov bx, 3
				mov al, RESPONSE_7_SEG[bx]
				mov dx, IO0
				out dx, al
				mov bx, offset Terminal_Mens2
				call Print_String
				call Pula_Linha
				LOCKSYSTEM:
				cmp Ha_Tecla_Digitada,1
				jne DONTPRINT
				mov al, Tecla
				mov bx, TecnicoSenhaPosition
				mov SenhaTecnico[bx], al
				call MANDA_CARACTER
				mov Ha_Tecla_Digitada,0
				inc TecnicoSenhaPosition
				cmp TecnicoSenhaPosition, 6
				je CHECKPASSWORD
				jmp LOCKSYSTEM

DONTPRINT:
				jmp LOCKSYSTEM
			 
CHECKPASSWORD:
				mov bx, 0
				cmp SenhaTecnico[bx], 'L'
				jne NOTPASSWORD
				mov bx, 1
				cmp SenhaTecnico[bx], 'I'
				jne NOTPASSWORD
				mov bx, 2
				cmp SenhaTecnico[bx], 'B'
				jne NOTPASSWORD
				mov bx, 3
				cmp SenhaTecnico[bx], 'E'
				jne NOTPASSWORD
				mov bx, 4
				cmp SenhaTecnico[bx], 'R'
				jne NOTPASSWORD
				mov bx, 5
				cmp SenhaTecnico[bx], 'A'
				jne NOTPASSWORD
				je UNLOCKSYSTEM
			 
NOTPASSWORD:
				mov TecnicoSenhaPosition, 0
				call Pula_Linha
				jmp LOCKSYSTEM
		  
UNLOCKSYSTEM:
				mov TecnicoSenhaPosition, 0
				mov TotalErro, 0
				call Pula_Linha
				mov Lock, 0
				mov Unlock, 0
				mov Erro, 0
				mov bx, 0
			}
		}
    }
}
      
while(1) {
	asm {
		cmp Ha_Tecla_Digitada,1
		jne Nao_Imprime
		mov al, Tecla
		call MANDA_CARACTER
		mov Ha_Tecla_Digitada,0
		
Nao_Imprime:

	}
}
	
while(1) {
	Entrada:	
		asm mov bx, offset Tab_Mens1
		asm call Print_String
		asm call Pula_Linha
		asm call Le_Byte_Modo_II
		asm call Pula_Linha
		asm cmp Result, 25
		asm jg Entrada	
		
		for(unsigned char i = 1; i <= 10; i++) {
			asm {
				mov bx, offset Tab_Mens2
				call Print_String
				mov  al, Result
				call Print_Int
				mov bx, offset Tab_Mens3
				call Print_String
				mov al, i
				call Print_Int
				mov bx, offset Tab_Mens4
				call Print_String
				mov cl, i //pega multiplicador
				mov al, Result
				mul cl
				call Print_Int
				call Pula_Linha
			}
		}
	}

	while(1) {
		asm {
		
LEITURA_0_9:
			CALL RECEBER_CARACTER
			cmp al, '0'
			jl LEITURA_0_9
			cmp al, '9'
			jg LEITURA_0_9
			cmp al, '0'
			je  IMPRIMIR_ZERO
			cmp al, '1'
			je  IMPRIMIR_UM
			cmp al, '2'
			je  IMPRIMIR_DOIS
			cmp al, '3'
			je  IMPRIMIR_TRES
			cmp al, '4'
			je  IMPRIMIR_QUATRO
			cmp al, '5'
			je  IMPRIMIR_CINCO
			cmp al, '6'
			je  IMPRIMIR_SEIS
			cmp al, '7'
			je  IMPRIMIR_SETE
			cmp al, '8'
			je  IMPRIMIR_OITO
			cmp al, '9'
			je  IMPRIMIR_NOVE
			jmp LEITURA_0_9
			
IMPRIMIR_ZERO:
			MOV BX, OFFSET ZERO
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_UM:
			MOV BX, OFFSET UM
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_DOIS:
			MOV BX, OFFSET DOIS
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_TRES:
			MOV BX, OFFSET TRES
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_QUATRO:
			MOV BX, OFFSET QUATRO
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_CINCO:
			MOV BX, OFFSET CINCO
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_SEIS:
			MOV BX, OFFSET SEIS
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_SETE:
			MOV BX, OFFSET SETE
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_OITO:
			MOV BX, OFFSET OITO
			call Print_String
			call Pula_Linha
			jmp BREAKS
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
IMPRIMIR_NOVE:
			MOV BX, OFFSET NOVE
			call Print_String
			call Pula_Linha
			jmp BREAKS
			
BREAKS:
		}
	}


	while (1) {
		asm {
			call Le_Tecla 
			mov al, Tecla
			mov Digito_1, al
			sub al, '0'
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			
OPERACAO:
			call Le_Tecla
			mov al, Tecla
			cmp al, '+'
			je SOMA
			cmp al, '/'
			je DIVISAO
			cmp al, '*'
			je MULTIPLICACAO
			cmp al, '-'
			je SUBTRACAO 
			jmp OPERACAO
				
SOMA:
			call Le_Tecla
			mov  al, Tecla
			mov  Digito_2,al
			sub al,'0'
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			//Digito_1 + Digito_2
			
AGUARDA_IGUAL:
			call Le_Tecla
			mov al, Tecla
			cmp al, '='
			jne AGUARDA_IGUAL
			sub Digito_1, '0' //converte de ASCII
			sub Digito_2, '0' //para byte
			mov al, Digito_1
			add al, Digito_2
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			jmp BREAK
					
MULTIPLICACAO:
SUBTRACAO:
			call Le_Tecla
			mov  al, Tecla
			mov  Digito_2,al
			sub al, '0'
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al

AGUARDA_IGUAL_SUB:
			call Le_Tecla
			mov al, Tecla
			cmp al, '='
			jne AGUARDA_IGUAL_SUB
			sub Digito_1, '0' //converte de ASCII
			sub Digito_2, '0' //para byte
			mov al, Digito_1
			sub al, Digito_2
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			jmp BREAK
DIVISAO:
			call Le_Tecla
			mov  al, Tecla
			mov  Digito_2,al
			sub al, '0'
			mov bl, al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			//Digito_1 + Digito_2
AGUARDA_IGUAL_DIV:
			call Le_Tecla
			mov al, Tecla
			cmp al, '='
			jne AGUARDA_IGUAL_DIV
			sub Digito_1, '0' //converte de ASCII
			sub Digito_2, '0' //para byte
			mov al, Digito_1 //ax = Digito_1
			mov ah, 0
			mov cl, Digito_2
			div cl
			mov bl, al  //bx = al
			mov bh, 0
			mov al, TABELA_7_SEG[BX]
			mov dx, IO0
			out dx, al
			jmp BREAK
BREAK:		
		}
	}
}

void Print_MM(int MM) {
	asm {
		mov ax, MM //17
		mov bl, 10
		div bl
		//ah = 7 = resto //al = 1 = quociente
		mov bl,al  //jogar al para...
		mov bh,0 // ...bx
		mov al, TABELA_7_SEG[bx]
		mov dx, IO2  //DEZ MM
		out dx, al
		mov al, ah //move resto para al...
		mov bl, al
		mov bh, 0
		mov al, TABELA_7_SEG[BX]
		mov dx, IO3 //UNID MM
		out dx, al
	}
}
 
void Print_SS(int SSS) {
	asm {
		mov ax, SSS //17
		mov bl, 10
		div bl
		//ah = 7 = resto //al = 1 = quociente
		mov bl,al  //jogar al para...
		mov bh,0 // ...bx
		mov al, TABELA_7_SEG[bx]
		mov dx, IO4  //DEZ SS
		out dx, al
		mov al, ah //move resto para al...
		mov bl, al
		mov bh, 0
		mov al, TABELA_7_SEG[BX]
		mov dx, IO5 //UNID SS
		out dx, al
	}
}

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
		out dx, al
	}
}