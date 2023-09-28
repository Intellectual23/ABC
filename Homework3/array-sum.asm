.data
ex: .asciz "out of int \n"
s: .asciz "sum: "
ev: .asciz "even: "
od: .asciz "odd: "
endl: .asciz "\n"
.align  2  
array: .space 40 #выделяем на 10 целых чисел
arrend:
.text
la t0  array
la s1 arrend #указатель на конец массива
li a7 5
ecall
mv t1,a0 # в t1 хранится количество чисел в массиве
li t2, 10
if_greater_10: # ставим предел - 10 чисел
	ble t1 t2 fill
	li t1,10
fill: #заполняем массив числами 
	bge t3 t1 end_fill
	li a7 5
	ecall
	mv t2, a0
	sw t2 (t0) #запаковка числа в массив
	addi t3 t3 1
	addi t0 t0 4 # между соседними ячейками расстояние 4 байта
	j fill
	end_fill:
li t3 0
la t0 array # указатель возвращаем обратно на начало массива
li t2 2 # для определения четности
ev_odd: # цикл, в котором считаем кол-во четных и нечетных чисел, в регистрах s2 и s3
	bge t3 t1 end_ev_odd
	lw t5 (t0)
	rem t6 t5 t2
	even:
		bnez t6, odd
		addi s2, s2, 1
	odd:
		beqz t6, end_if
		addi s3, s3, 1
	end_if:
		addi t0 t0 4
		addi t3 t3 1
		j ev_odd
	end_ev_odd:
li a7 4 # вывод кол-ва четных и нечетных чисел
la a0 ev
ecall
li a7 1
mv a0 s2
ecall
la a0 endl
li a7 4
ecall
la a0 od
ecall
li a7 1
mv a0 s3
ecall
la a0 endl
li a7 4
ecall
li t3 0 # обнуляем счетчики и указатель перед началом нового цикла по массиву
li t6 0
la t0 array
sum:
	bge t3 t1 end_sum
	lw t5 (t0)
	li s5 0 
	li s4 0
	li s6 0
	sum_gr_0: # cмотрим знаки старой суммы и нового числа массива
		bltz t4 num_gr_0
		li s6 1
	num_gr_0:
		bltz t5, xor_check
		li s7 1
	xor_check: # проверяем, что у этих двух чисел одинаковые знаки
		xor s5, s6, s7
		beqz s5, final_check
		j ok
	final_check: # проверяем, что у старой суммы и новой суммы разные знаки, если да - то было переполнение!
		add t6,t4, t5
		new_sum_gr_0:
			bltz t6 xor_check_2
			li s4 1
		xor_check_2:
			xor s5,s4,s6
			bnez s5 break
	ok: #если все хорошо, и переполнения не было
	add t4 t4 t5 # прибавляем к старой сумме новое число
	addi t0 t0 4 # сдвигаем
	addi t3 t3 1
	j sum
	break: # случай переполнения
		la a0 ex #сообщаем об переполнении
		li a7 4
		ecall
		j print_sum #печатаем последнюю корректную сумму
	end_sum:
print_sum: # печать суммы
la a0 s
li a7 4
ecall
li a7 1
mv a0 t4
ecall
li a7 10 #конец
ecall
