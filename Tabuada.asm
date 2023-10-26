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

#define ADR_USART_DATA   (IO9 + 00h)
//ONDE VOCE VAI MANDAR E RECEBER DADOS DO 8251 (WRITE 1200H  READ 1200H)

#define ADR_USART_CMD    (IO9 + 02h)
//ONDE VOCE VAI ESCREVER PARA PROGRAMAR O 8251 (WRITE 1202H)

#define ADR_USART_STAT   (IO9 + 02h)
//RETORNA O STATUS SE UM CARACTER FOI DIGITADO NO TERMINAL
//RETORNA O STATUS SE POSSO TRANSMITIR CARACTER PARA O TERMINAL (READ 1202H)

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

//TER CERTEZA QUE O CARACTER ESTEJA EM AL, POIS AL É A PASSAGEM DE PARAMETRO - (POR REGISTRADOR)
void MANDA_CARACTER(void) {
   _asm {
      PUSHF  ; SALVA FLAGS Z E C
      PUSH DX
      PUSH AX  ; SALVA AL   AX = AH/AL
      
BUSY:
      MOV DX, ADR_USART_STAT
      IN  AL,DX
      TEST AL,1 ; 0000000S
      JE BUSY
      MOV DX, ADR_USART_DATA
      POP AX  ; RESTAURA AL
      OUT DX,AL
      POP DX
      POPF ; RESTAURA FLAGS Z E C
   }  
}

//AO TERMINO DESTA ROTINA, TEREMOS EM AL O CODIGO ASCII DA TECLA DIGITADA
void RECEBE_CARACTER(void) {
   _asm {
      PUSHF
      PUSH DX
      
AGUARDA_CARACTER:
      MOV DX, ADR_USART_STAT
      IN  AL,DX
      TEST AL,2 ;000000S0
      JE AGUARDA_CARACTER
      MOV DX, ADR_USART_DATA
      IN AL,DX
      SHR AL,1 
      
NAO_RECEBIDO:
      POP DX
      POPF
   }
}

char Mensagem[] = {"HELLO WORLD"};

void PULA_LINHA(void) {
   asm {
      mov al, 13
      call MANDA_CARACTER
      mov al, 10
      call MANDA_CARACTER
   }
}

#define TAM 32
char ContadorCaracteres;
char MensagemTexto[TAM+1];

//antes de chamar esta funcao, si deve apontar para a Mensagem
void LE_STRING(void) {
   asm mov ContadorCaracteres,0
   asm mov byte ptr [si], 0 //caso voce digite direto o CR
   asm {
      
AGUARDA_CARACTER:
      call RECEBE_CARACTER
      cmp  al,8
      je   TRATA_BS
      cmp  al,13
      je   TRATA_CR
      cmp  ContadorCaracteres, TAM
      je   AGUARDA_CARACTER
      mov [si], al
      inc si
      mov byte ptr [si], 0 //null
      inc ContadorCaracteres
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
TRATA_BS:
      cmp ContadorCaracteres,0
      je  AGUARDA_CARACTER
      dec si
      dec ContadorCaracteres
      mov al, 8
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
TRATA_CR:
			
   }
}

//Retorna em Result o numero digitado
unsigned char Result;
unsigned char Temp[4];

void LE_BYTE(void) {
   asm mov si, offset Temp
   asm mov ContadorCaracteres,0
   asm mov byte ptr [si], 0 //caso voce digite direto o CR
   asm {
      
AGUARDA_CARACTER:
      call RECEBE_CARACTER
      cmp  al,8
      je   TRATA_BS
      cmp  al,13
      je   TRATA_CR
      cmp  ContadorCaracteres, 3
      je   AGUARDA_CARACTER
      cmp  al,'0'
      jl   AGUARDA_CARACTER
      cmp  al,'9'
      jg   AGUARDA_CARACTER
      mov [si], al
      inc si
      mov byte ptr [si], 0 //null
      inc ContadorCaracteres
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
TRATA_BS:
      cmp ContadorCaracteres,0
      je  AGUARDA_CARACTER
      dec si
      dec ContadorCaracteres
      mov al, 8
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
TRATA_CR:
      cmp ContadorCaracteres,1
      je  Trata_1_Digito
      cmp ContadorCaracteres,2
      je  Trata_2_Digitos
      cmp ContadorCaracteres,3
      je  Trata_3_Digitos

Trata_1_Digito:
      mov di, 0 //registrador somatoria
      mov dh, Temp[0]
      sub dh, '0'
      mov cl, 1
      mov al, dh
      mul cl //ax = al * 100
      add di, ax //somatoria			
      jmp SAIDA

Trata_2_Digitos:
      mov di, 0 //registrador somatoria
      mov dh, Temp[0]
      mov dl, Temp[1]
      sub dh, '0'
      sub dl, '0'
      mov cl, 10
      mov al, dh
      mul cl //ax = al * 10
      add di, ax //somatoria			
      
      mov cl, 1
      mov al, dl
      mul cl
      add di, ax //somatoria

      jmp SAIDA

Trata_3_Digitos:
      mov di, 0 //registrador somatoria
      mov dh, Temp[0]
      mov dl, Temp[1]
      mov ch, Temp[2]
      sub dh, '0'
      sub dl, '0'
      sub ch, '0'
      mov cl, 100
      mov al, dh
      mul cl //ax = al * 100
      add di, ax //somatoria			
      
      mov cl, 10
      mov al, dl
      mul cl
      add di, ax //somatoria

      mov cl, 1
      mov al, ch
      mul cl
      add di, ax //somatoria

SAIDA:
      cmp di, 255
      jg  AGUARDA_CARACTER
      mov ax, di		
      mov Result, al
   }
}

//bx deve apontar para a memoria que guardara o Texto (0 a 255)
void LE_BYTE_REALTIME(void) {
   asm {
      mov bx, offset Temp
      mov ContadorCaracteres,0
      
AGUARDA_CARACTER:	
      call RECEBE_CARACTER
      cmp  al, 13 //enter
      je   PRESSIONOU_ENTER
      cmp  al, 8  //backspace
      je   PRESSIONOU_BACKSPACE		
      cmp ContadorCaracteres, 3
      je  AGUARDA_CARACTER
      cmp al, '0'
      jl  AGUARDA_CARACTER
      cmp al, '9'
      jg  AGUARDA_CARACTER

      mov [bx], al
      inc bx
      mov  byte ptr [bx], 0 //null
      inc ContadorCaracteres
      call MANDA_CARACTER
      JMP  VERIFICA_EM_TEMPO_REAL

PRESSIONOU_ENTER:
      CMP ContadorCaracteres,0
      JE AGUARDA_CARACTER
      //CMP QNT_CARACTERES_DIGITADOS,3
      //JNE AGUARDA_CARACTER
      JMP SAIDA_Le_String
      
PRESSIONOU_BACKSPACE:
      cmp ContadorCaracteres,0
      je  AGUARDA_CARACTER
      dec bx
      mov byte ptr[bx], 0
      dec ContadorCaracteres
      mov al, 8 //opcional
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
VERIFICA_EM_TEMPO_REAL:
      CMP ContadorCaracteres,1
      JE  MULT_UNIDADE
      CMP ContadorCaracteres,2
      JE  MULT_DEZ_UNID
      CMP ContadorCaracteres,3
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
      jmp AGUARDA_CARACTER
      
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
      jmp AGUARDA_CARACTER

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
      cmp di, 255
      jg APAGA_ULTIMO_CARACTER
      JMP AGUARDA_CARACTER
      
APAGA_ULTIMO_CARACTER:
       SUB DI, AX //ELIMINAR ULTIMA SOMA
       MOV AL,8
       CALL MANDA_CARACTER
       DEC BX
       MOV BYTE PTR [BX], 0
       DEC ContadorCaracteres
       JMP AGUARDA_CARACTER
       
SAIDA_Le_String:
      push di
      pop  ax //al tem o resultado do numero digitado (int)
      mov  Result, al
      }
}

//-------------------------------------------------------- CÓPIA --------------------------------------------------------
void LE_BYTE_REALTIME(void) {
   asm {
      mov bx, offset Temp
      mov ContadorCaracteres,0
      
AGUARDA_CARACTER:	
      call RECEBE_CARACTER
      cmp  al, 13 //enter
      je   PRESSIONOU_ENTER
      cmp  al, 8  //backspace
      je   PRESSIONOU_BACKSPACE		
      cmp ContadorCaracteres, 3
      je  AGUARDA_CARACTER
      cmp al, '0'
      jl  AGUARDA_CARACTER
      cmp al, '9'
      jg  AGUARDA_CARACTER

      mov [bx], al
      inc bx
      mov  byte ptr [bx], 0 //null
      inc ContadorCaracteres
      call MANDA_CARACTER
      JMP  VERIFICA_EM_TEMPO_REAL

PRESSIONOU_ENTER:
      CMP ContadorCaracteres,0
      JE AGUARDA_CARACTER
      //CMP QNT_CARACTERES_DIGITADOS,3
      //JNE AGUARDA_CARACTER
      JMP SAIDA_Le_String
      
PRESSIONOU_BACKSPACE:
      cmp ContadorCaracteres,0
      je  AGUARDA_CARACTER
      dec bx
      mov byte ptr[bx], 0
      dec ContadorCaracteres
      mov al, 8 //opcional
      call MANDA_CARACTER
      jmp AGUARDA_CARACTER
      
VERIFICA_EM_TEMPO_REAL:
      CMP ContadorCaracteres,1
      JE  MULT_UNIDADE
      CMP ContadorCaracteres,2
      JE  MULT_DEZ_UNID
      CMP ContadorCaracteres,3
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
      jmp AGUARDA_CARACTER
      
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
      jmp AGUARDA_CARACTER

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
      cmp di, 255
      jg APAGA_ULTIMO_CARACTER
      JMP AGUARDA_CARACTER
      
APAGA_ULTIMO_CARACTER:
       SUB DI, AX //ELIMINAR ULTIMA SOMA
       MOV AL,8
       CALL MANDA_CARACTER
       DEC BX
       MOV BYTE PTR [BX], 0
       DEC ContadorCaracteres
       JMP AGUARDA_CARACTER
       
SAIDA_Le_String:
      push di
      pop  ax //al tem o resultado do numero digitado (int)
      mov  Result, al
      }
}
//-------------------------------------------------------- CÓPIA --------------------------------------------------------

//AL DEVE CONTER O BYTE A SER IMPRESSO
unsigned Contador_Pilha;
void PRINT_BYTE(void) {
   asm mov Contador_Pilha,0
   asm
   {
	   
PROXIMA_DIVISAO_10:
      MOV AH,0 //ZERA PQ A ULTIMA DIVISAO POE RESTO NELE
      MOV CL,10
      DIV CL  //      AX/10--> AH = RESTO, AL = QUOCIENTE
      PUSH AX //SALVA NA PILHA O RESTO (AH)
      inc Contador_Pilha
      cmp al, 0//verifica se quociente = 0
      jne PROXIMA_DIVISAO_10
DESEMPILHA_PROXIMO:
       POP AX //AH TEM O RESTO QUE FOI EMPILHADO
       MOV AL,AH //MOVE AH PARA AL, POIS MANDA_CARACTER
	 //AGUARDA PARAMETRO EM AL
       ADD AL,'0' //INT PARA CHAR
       CALL MANDA_CARACTER
       dec Contador_Pilha
       cmp Contador_Pilha,0
       jne DESEMPILHA_PROXIMO
   }
}

//SI DEVE CONTER O ENDERECO ONDE ESTA A MENSAGEM
void MANDA_STRING(void) {
   asm {
	   
PROCURA_NULL:
      mov al, [SI]
      cmp al, 0 //null
      je  BREAK
      call MANDA_CARACTER
      inc SI
      jmp PROCURA_NULL
      
BREAK:
   }
}

unsigned char TABELA_ASCII[] = {
'7','8','9','/',
'4','5','6','*',
'1','2','3','-',
'C','0','=','+'
};

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
      je ZERAR_MINUTOS
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
      mov dx, IO1
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

char Tecla;

void Le_Tecla(void) {
   asm {
Aguarda_Tecla:
      mov dx, IO8
      in  al, dx 
      //al D000CCCC
      and al, 0b10000000
      cmp al, 0b10000000
      jne Aguarda_Tecla
      in  al, dx //leia para al pq voce destruiu
      and al, 0b01111111 //apaga DA

      mov bl, al
      mov bh, 0
      mov al, TABELA_ASCII[BX]

      mov Tecla, al //salva em Tecla

Aguarda_DA_Ir_Para_0:
      in  al, dx
      and al, 0b10000000
      cmp al, 0b10000000 //compara se DA = 1
      je  Aguarda_DA_Ir_Para_0
   }
}

char Digito_1;
char Digito_2;

char Mensagem_ZERO[]   = {"ZERO"};
char Mensagem_UM[]     = {"UM"};
char Mensagem_DOIS[]   = {"DOIS"};
char Mensagem_TRES[]   = {"TRES"};
char Mensagem_QUATRO[] = {"QUATRO"};
char Mensagem_CINCO[]  = {"CINCO"};
char Mensagem_SEIS[]   = {"SEIS"};
char Mensagem_SETE[]   = {"SETE"};
char Mensagem_OITO[]   = {"OITO"};
char Mensagem_NOVE[]   = {"NOVE"};

char Mens1[] = {"TABUADA DE QUAL VALOR? (0 - 25)"};
char Mens2[] = {"TABUADA DE "};
char Mens3[] = {" * "};
char Mens4[] = {" = "};

void main(void) {
   asm call INICIALIZA_8251
   while(1) {
      asm {
NOVA_TABUADA:
	 //chamando a entrada do usuário
	 mov si, offset Mens1 //offset apenas quando a variavel for string
	 call MANDA_STRING
	 call PULA_LINHA
	 call LE_BYTE_REALTIME // GUARDA NA VAR RESULT
	 call PULA_LINHA
	 cmp Result, 25
	 jg NOVA_TABUADA
      }
      for(char tab = 1; tab <= 10; tab++) {
	 asm {
	    //chamando as mesnagens
	    mov si, offset Mens2
	    call MANDA_STRING
	    mov al, Result
	    call PRINT_BYTE
	    mov si, offset Mens3
	    call MANDA_STRING
	    mov al, tab
	    call PRINT_BYTE 
	    mov si, offset Mens4
	    call MANDA_STRING

	    //calculando o resultado
	    mov al, Result
	    mov cl, tab
	    mul cl
	    call PRINT_BYTE
	    call PULA_LINHA
      }
   }
}
while(1);
while(1) {
   asm {
ENTRE_NUMERO:
      CALL RECEBE_CARACTER
      cmp al,'0'
      jl ENTRE_NUMERO
      cmp al,'9'
      jg ENTRE_NUMERO
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

IMPRIMIR_ZERO:
      mov si, offset Mensagem_ZERO
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_UM:
      mov si, offset Mensagem_UM
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_DOIS:
      mov si, offset Mensagem_DOIS
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_TRES:
      mov si, offset Mensagem_TRES
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_QUATRO:
      mov si, offset Mensagem_QUATRO
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_CINCO:
      mov si, offset Mensagem_CINCO
      call MANDA_STRING
      jmp BREAK;
      
IMPRIMIR_SEIS:
      mov si, offset Mensagem_SEIS
      call MANDA_STRING
      jmp BREAK;

IMPRIMIR_SETE:
      mov si, offset Mensagem_SETE
      call MANDA_STRING
      jmp BREAK;

IMPRIMIR_OITO:
      mov si, offset Mensagem_OITO
      call MANDA_STRING
      jmp BREAK;

IMPRIMIR_NOVE:
      mov si, offset Mensagem_NOVE
      call MANDA_STRING
      jmp BREAK;

BREAK:

CALL PULA_LINHA
   }
}
asm jmp $ //loop infinito

while (1) {
   asm {
      
Aguarda_Digito_1:
      //ler primeiro digito
      call Le_Tecla
      cmp  Tecla, '0'
      jl   Aguarda_Digito_1
      cmp  Tecla, '9'
      jg   Aguarda_Digito_1
      mov  al, Tecla
      mov  Digito_1, al
      sub  al, '0' //converte ascii para int				
      mov bl, al
      mov bh, 0
      mov al, TABELA_7_SEG[BX]
      //ESCREVE NO DISPLAY
      mov dx, IO0
      out dx, al	
      //Le operacao
      
LE_OPERACAO:
      call Le_Tecla
      cmp  Tecla,'+'
      je	 SOMA
      cmp  Tecla,'-'
      je	 SUBTRACAO
      cmp  Tecla,'*'
      je   PRODUTO
      cmp  Tecla,'/'
      je   DIVISAO
      jmp  LE_OPERACAO


SOMA:
      call Le_Tecla //Digito_2
      cmp  Tecla, '0'
      jl	 SOMA
      cmp  Tecla, '9'
      jg   SOMA
      mov  al, Tecla
      mov  Digito_2, al

      sub al, '0'
      mov bl, al
      mov bh, 0
      mov al, TABELA_7_SEG[BX]

      mov dx, IO0
      out dx, al

AGUARDA_IGUAL:			
      call Le_Tecla //aguarda =
      cmp  Tecla, '='
      jne  AGUARDA_IGUAL

      sub Digito_1,'0'
      sub Digito_2,'0'

      mov al, Digito_1
      add al, Digito_2

      mov bl, al
      mov bh, 0
      mov al, TABELA_7_SEG[BX]

      mov dx, IO0
      out dx, al

SUBTRACAO:
PRODUTO:
DIVISAO:
   }
}
while(1);
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

void Print_MM(int MM) {
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
      out dx, al
   }
}
]