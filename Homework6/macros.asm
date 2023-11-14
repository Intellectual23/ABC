.eqv     BUF_SIZE 100
.macro strncpy(%dest, %src, %len) #обернули подпограму в макрос, потом его можно добавить в библиотеку макросов cstring!
la a1 %dest
la a2 %src
mv a3 %len
jal strncpy
la a0 %dest
.end_macro

.macro strlen(%str) # strlen из семинара
	push(%str)
    li      t0 0        # Счетчик
loop:
    lb      t1 (%str)   # Загрузка символа для сравнения
    beqz    t1 end
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    %str %str 1		# Берется следующий символ
    b       loop
end:
    pop(%str)
    mv      a0 t0
.end_macro

.macro print_str(%buf) #печать строки
	push(a0)
	la a0 %buf
	li a7 4
	ecall
	pop(a0)
.end_macro

.macro print_int(%x) #печать целого числа
li a7 1
mv a0 %x
ecall
.end_macro

.macro read_str(%buf)#читаем целое число
la      a0 %buf
li a1 BUF_SIZE
li      a7 8
ecall
.end_macro

#Сохранение целого числа на верхушку стека
.macro push(%x)
 addi sp, sp, -4
 sw  %x, (sp)
.end_macro 

#Удаление целого числа из верхушки стека
.macro pop(%x)
 lw  %x, (sp)
 addi sp, sp, 4
.end_macro 


