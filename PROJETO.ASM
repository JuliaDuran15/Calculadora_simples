TITLE Julia Duran, Thayná Aquino. RA_22009210, RA_22002057

.MODEL SMALL
.DATA 
    SB DB 10,'     SEJA BEM VINDO AO PROGRAMA!!!!!     ',10,'$'
    OP db 10,'  Escolha qual operacao desejada *,/,+,-: ','$'
    msg1 db 10,'  Entre com o primeiro num (entre 0 e 9): ','$'
    msg2 db 10,'  Entre com o segundo num (entre 0 e 9): ','$'
    resultado  db 10, '  O resultado: ','$'
    DESEJA DB 10,'  Deseja reiniciar o programa? (se sim digite s): ','$'
    IMP DB 10,'  Conta impossivel dividendo igual a ZERO!',10,'$'
    resultado_quoci db 10,'  O quociente eh: ','$'
    resultado_rest db 10,'  O resto eh: ','$'

.CODE
main proc
;Iniciando a data
    MOV AX,03
    INT 10H

    MOV AX,@DATA
    MOV DS,AX


    LEA DX,SB
    MOV AH,09
    INT 21H

INICIO:     ;caso deseje volta do inicio
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX

    MOV AH,02
    MOV DL,10
    INT 21H
    ;recebendo os numeros e imprimendo mesagem para o usuario
    LEA DX,msg1
    CALL COLLHE_INFO
    SUB AL,30H
    MOV BL,AL

    LEA DX,OP
    CALL COLLHE_INFO
    MOV CL,AL

;recebendo os numeros e imprimendo mesagem para o usuario
    LEA DX,msg2
    CALL COLLHE_INFO
    SUB AL,30H
; comparacoes para saber qual operacao fazer
    CMP CL,43
    JZ SOMA
    CMP CL,45
    JZ SUBT
    CMP CL,42
    JZ MULTI
    CMP CL,47
    JZ DIVI

SOMA: ADD BL,AL ;soma
    
    JMP IMPRIME1

SUBT:   
    NEG AL
    ADD BL,AL

    JNC IMPRIME2
    JC IMPRIME1

MULTI: CALL MULTIPLICA
       JMP IMPRIME1


DIVI:   CMP AL, 00H
        JZ IMPOSSIVEL
        CALL divis
        JMP IMPRIME3
        
IMPOSSIVEL: LEA DX,IMP
            MOV AH,09
            INT 21H
            JMP SAI

IMPRIME3: CALL IMPRIME_DV
            JMP SAI



IMPRIME1: CALL IMPRIME
            JMP SAI

IMPRIME2: CALL IMPRIME_NEG  
            JMP SAI
SAI:
    LEA DX,DESEJA   ;reiniciar o programa 
    CALL COLLHE_INFO
    CMP AL,'s'
    JNE FIM
    JMP INICIO
FIM:
    MOV AH,4CH
    INT 21H
MAIN ENDP

IMPRIME proc
;passa o num para al, zera o excesso, divide por 10,imprime separado cada digito
    LEA DX,resultado
    MOV AH,09H
    INT 21H

    MOV AL,BL
    XOR AH,AH
    MOV BL,10
    DIV BL

    MOV BX,AX
    MOV DL,BL
    OR DL,30H   ;transforma num em digito novamente
    MOV AH,02
    INT 21H

    MOV DL,BH
    OR DL,30H    
    INT 21H
    
    RET
IMPRIME ENDP

IMPRIME_NEG proc
;passa o num para al, zera o excesso, divide por 10,imprime separado
    LEA DX,resultado
    MOV AH,09H
    INT 21H
    mov dl,45   ;impressao do sinal de menos
    MOV AH,02
    INT 21H
    NEG BL  ;neg novamente o numero para impressao correa
    MOV AL,BL   ;
    XOR AH,AH
    MOV BL,10
    DIV BL
    MOV BX,AX
    MOV DL,BL
    OR DL,30H   ;transforma num em digito novamente
    MOV AH,02
    INT 21H
    MOV DL,BH
    OR DL,30H    
    INT 21H

    RET

IMPRIME_NEG ENDP

COLLHE_INFO proc
    MOV AH,09H
    INT 21H
    MOV AH,01H
    INT 21H

    RET
COLLHE_INFO ENDP

MULTIPLICA proc
    XOR CL,CL   ;zera cl para receber resultado
    VOLTA:
    TEST BL,01H ;verifica se o ultimo digito eh 1 ou 0
    JZ PULA
    ADD CL,AL
    PULA:
    SHL AL,1
    SHR BL,1
    JNZ VOLTA
    MOV BL,CL

    RET
MULTIPLICA ENDP

IMPRIME_DV proc
    LEA DX,resultado_quoci
    MOV AH,09H
    INT 21H
    MOV DL,CL
    OR DL,30H   ;transforma num em digito novamente
    MOV AH,02
    INT 21H
    LEA DX,resultado_rest
    MOV AH,09H
    INT 21H
    MOV DL,BL
    OR DL,30H   ;transforma num em digito novamente
    MOV AH,02
    INT 21H

    RET
IMPRIME_DV ENDP

divis proc

    MOV CH,4
    xor cl,cl
    SHl AL,4
    shr cl,4
VOLTAD:
    SUB BL,AL
    TEST BL,80H
    JNZ NEGATIVO
    OR CL,1
    JMP FIMD
NEGATIVO:
    OR CL,0
    ADD Bl,AL
FIMD:
    SHL BL,1
    SHL CL,1
    DEC CH
    CMP CH,0
    JNZ VOLTAD
    
    SHR BL,4
    RET

divis endp


END MAIN 
