.text
.globl main
.include "macrolib.asm"
main:
	read_double(fa1) #считываем a, b, x1 и x2
	read_double(fa2)
	read_double(fa3)
	read_double(fa4)
	jal integrate #вызываем подпрограмму интегрирования методом Симсона(парабол), переданы параметры a b x1 x2
	print_double(fa0) #результат в fa0 - печатаем его
	li a7 10 #exit
	ecall
