.eqv     BUF_SIZE 10
.macro strlen(%str)
    li      t0 0        # Счетчик
loop:
    lb      t1 (%str)   # Загрузка символа для сравнения
    beqz    t1 end
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    %str %str 1		# Берется следующий символ
    b       loop
end:
    mv      a0 t0
.end_macro

.macro print_str(%buf)
	la a0 %buf
	li a7 4
	ecall
.end_macro

.macro input_str(%buf)
la      a0 %buf
li a1 BUF_SIZE
li      a7 8
ecall
.end_macro

#Сохранение целого числа на верхушку стека
.macro push_int(%x)
 addi sp, sp, -4
 sw  %x, (sp)
.end_macro 

#Удаление целого числа из верхушки стека
.macro pop_int(%x)
 lw  %x, (sp)
 addi sp, sp, 4
.end_macro 


