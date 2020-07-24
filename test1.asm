         ;代码清单5-1
         ;文件名：c05_mbr.asm
         ;文件说明：硬盘主引导扇区代码
         ;创建日期：2020-7-24 21:21

         mov ax,0xb800                 ;指向文本模式的显示缓冲区
         mov es,ax

         ;以下显示字符串"Label offset:"
         mov byte [es:0x00],'H'
         mov byte [es:0x01],0x07
         mov byte [es:0x02],'e'
         mov byte [es:0x03],0x07
         mov byte [es:0x04],'l'
         mov byte [es:0x05],0x07
         mov byte [es:0x06],'l'
         mov byte [es:0x07],0x07
         mov byte [es:0x08],'o'
         mov byte [es:0x09],0x07
         mov byte [es:0x0a],' '
         mov byte [es:0x0b],0x07
         mov byte [es:0x0c],","
         mov byte [es:0x0d],0x07
         mov byte [es:0x0e],'w'
         mov byte [es:0x0f],0x07
         mov byte [es:0x10],'o'
         mov byte [es:0x11],0x07
         mov byte [es:0x12],'r'
         mov byte [es:0x13],0x07
         mov byte [es:0x14],'d'
         mov byte [es:0x15],0x07
         mov byte [es:0x16],' '
         mov byte [es:0x17],0x07
         mov byte [es:0x18],':'
         mov byte [es:0x19],0x07

         mov ax,number                 ;取得标号number的偏移地址,是一个地址
         mov bx,10           ;10是作为除数送到bx中

         ;设置数据段的基地址
         mov cx,cs           ;cs是代码寄存器，cx是
         mov ds,cx
         ;目的是访问访问number指向的内存单元
         ;求个位上的数字
         mov dx,0         ;被除数的高16位为0
         div bx   ;将Dx:AX的数除以bx的数，商在AX中，余数在Dx中
         ;为什么在dl取，因为10较小，可以取低字节就行
         mov [0x7c00+number+0x00],dl   ;保存个位上的数字  number是地址
         ;这个0x7c00从哪里来的呢   0x7c00表示的是主引导扇区的 位置
         ;number    源程序编译阶段确定的
         ;求十位上的数字
         ;ax是商，dx是高字节(之前存了余数)应该清零再算
         xor dx,dx      ;自己异或自己，清零数据
         div bx
         mov [0x7c00+number+0x01],dl   ;保存十位上的数字

         ;求百位上的数字
         xor dx,dx
         div bx
         mov [0x7c00+number+0x02],dl   ;保存百位上的数字

         ;求千位上的数字
         xor dx,dx
         div bx
         mov [0x7c00+number+0x03],dl   ;保存千位上的数字

         ;求万位上的数字
         xor dx,dx
         div bx
         mov [0x7c00+number+0x04],dl   ;保存万位上的数字

         ;以下用十进制显示标号的偏移地址
         mov al,[0x7c00+number+0x04]
         add al,0x30        ;得到于该数字对应的ASCII码
         mov [es:0x1a],al    ;为什么是这个位置呢，因为之前显示的offset最后是0x19
         mov byte [es:0x1b],0x04    ;黑底红色，无闪烁，无加亮

         mov al,[0x7c00+number+0x03]
         add al,0x30
         mov [es:0x1c],al
         mov byte [es:0x1d],0x04

         mov al,[0x7c00+number+0x02]
         add al,0x30
         mov [es:0x1e],al
         mov byte [es:0x1f],0x04

         mov al,[0x7c00+number+0x01]
         add al,0x30
         mov [es:0x20],al
         mov byte [es:0x21],0x04

         mov al,[0x7c00+number+0x00]
         add al,0x30
         mov [es:0x22],al
         mov byte [es:0x23],0x04

         mov byte [es:0x24],'D'   ;表示是十进制
         mov byte [es:0x25],0x07

   infi: jmp near infi                 ;无限循环

  number db 0,0,0,0,0          ;db表示声明 5个字节数据  ，是一种伪指令，供编译器使用

  times 203 db 0
            db 0x55,0xaa          ;主引导扇区的最后两个字节 规定：  0x55 0xaa
