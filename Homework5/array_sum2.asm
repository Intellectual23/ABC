.include "macros.asm"
.data
sep: .asciz "\n"
sep2: .asciz "-------\n"
.align 2
array:  .space 40 #арендуем память для массива из максимум 10 чисел
arrend:
.text
main:
	check_n (a1)#вызываем макрос на проверку длины массива, в нее уже включен ввод
	la a0 array
	fill (a0 a1)#вызываем макрос для ввода, в а1 уже передана длина, а в а0 адрес массива
	li a7 4
	la a0 sep2
	ecall
	la a0 array
	sum(a0 a1) #вызываем макрос для суммирования
	li a7 1 #вывод
	ecall
	li a7 4
	la a0 sep
	ecall
	li a7 1
	mv a0 a1
	ecall
	li a7 10 #конец
	ecall