DATA SEGMENT

;频率表

MUS DW 2 DUP(262,294,330,262),2 DUP(330,349,392)

    DW 2 DUP(392,440,392,349,330,262)

    DW 2 DUP(294,196,262),-1

;节拍表

TIME DW 10 DUP(2),4,2 DUP(2),4

     DW 4 DUP(1),2 DUP(2)

    DW 4 DUP(1),4 DUP(2),4

    DW 2 DUP(2),4

DATA ENDS

CODE SEGMENT

   ASSUME CS:CODE,DS:DATA

START: MOV AX,DATA

       MOV DS , AX

       LEA SI , MUS

      LEA BP, TIME

   L1:  MOV DI , [SI]

      CMP DI , -1

      JE EXIT

      MOV BX , DS:[BP]

      CALL SOUND

       ADD SI, 2

       ADD BP, 2

      JMP L1

 EXIT: MOV AX , 4C00H

     INT 21H

SOUND PROC

    PUSH AX

    PUSH BX

    PUSH CX

    PUSH DX

;利用PC机中的8253通道2实现发音见图

; PC机中8253控制口地址为43H，通道2口地址为42H）

   MOV AL, 0B6H

   OUT 43H, AL ;8253通道2方式3，二进制计数

   MOV DX , 12H

   MOV AX , 34DEH

   DIV DI  ;求计数初值=1234DEH/输出频率

 ;8253通道2送计数初值

   OUT 42H , AL

   MOV AL , AH

   OUT 42H , AL

 ;系统中已经将****8255B****口初始化为方式****0****输出**

       IN AL , 61H;****61H****为系统中****8255B****口的地址** 

       MOV AH , AL

       OR AL , 3

       OUT 61H , AL;** **将****PB0****和****PB1****设置为****1****，打开喇叭**

       WAIT1: CALL DELAY

      DEC BX

       JNZ WAIT1;** **；根据节拍进行延时**
       MOV AL , AH 

      OUT 61H , AL;** **；关闭喇叭**

       POP DX

      POP CX

      POP BX

     POP AX

      RET

SOUND ENDP

DELAY PROC

      PUSH AX

       PUSH BX

       PUSH CX

       PUSH DX

       MOV AH , 0

       INT 1AH

       ADD DX , 4

       MOV BX , DX

REP1:  MOV AH , 0

       INT 1AH

       CMP AL , 0

       JE REP2

       SUB BX , 0B0H

REP2:  CMP DX, BX

     JNE REP1

      POP DX

      POP CX

      POP BX

      POP AX

      RET

DELAY ENDP

CODE ENDS

   END START

