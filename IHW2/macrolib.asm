.data
sep: .asciz "\n"
.text

#Сохранение числа c плавающей точкой на верхушку стека
.macro push_double(%x)
 addi sp, sp, -8
 fsd  %x, (sp)
.end_macro 

#Удаление числа с плавающей точкой на верхушку стека
.macro pop_double(%x)
 fld  %x, (sp)
 addi sp, sp, 8
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

# Ввод числа с плавающей точкой
.macro read_double(%x)
	li a7, 7
    	ecall
	fmv.d %x, fa0 
.end_macro

# Вывод числа с плавающей точкой
.macro print_double(%x)
	fmv.d fa0, %x
	li a7, 3
    	ecall
    	la a0 sep
    	li a7 4
    	ecall
.end_macro

#Функция f(x) = a + bx^(-2) в виде макроса для удобства
.macro func(%a %b %x) # Входные параметры a b и аргумент x
	push_int(ra) # Cохраняю на стек входные параметры и регистр-адреса
	push_double(%a)
	push_double(%b)
	push_double(%x)
	push_double(fs1) # а так же локальный регистр
	fmv.d fa0 %a
	li t0 1
	fcvt.d.w fs1, t0
	fmul.d %x %x %x
	fdiv.d fs1 fs1 %x
	fmul.d fs1 fs1 %b
	fadd.d fa0 fa0 fs1
	pop_double(fs1) #восстанавливаю регистры из стека
	pop_double(%x)
	pop_double(%b)
	pop_double(%a)
	pop_int(ra)
.end_macro

