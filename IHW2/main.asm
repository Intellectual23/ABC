.data
inf: .asciz "infinity\n"
.text
.globl main
.include "macrolib.asm"
main:
	read_double(fa1) #считываем a, b, x1 и x2
	read_double(fa2)
	read_double(fa3)
	read_double(fa4)
	check:
		fmul.d ft0 fa3 fa4
		fge.d t0 ft1 ft0 #Если границы разных знаков, или одна из них 0, то произведение меньше либо равно 0
		beqz t0 normal_case
		li a7 4 #Проверка не пройдена
		la a0 inf
		ecall
		j exit
	normal_case: #Проверка пройдена
		jal integrate #вызываем подпрограмму интегрирования методом Симсона(парабол), переданы параметры a b x1 x2
		print_double(fa0) #результат в fa0 - печатаем его
	exit: #exit
		li a7 10 
		ecall
