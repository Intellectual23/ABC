.macro read_int(%x) #макрос для ввода числа с клавиатуры
   li a7, 5
   ecall
   mv %x, a0
.end_macro

.macro check_n(%x) #макрос для проверки числа элементов на интервал от 1 до 10 
	read_int(%x) # вызываем макрос для ввода числа
	if_less: bgtz %x if_greater
		li %x 1
		j end_check_n
	if_greater:
		li t0 10
		ble %x t0 end_check_n
		li %x 10
	end_check_n: 
.end_macro

.macro fill (%arr %len)#макрос для заполнения массива, параметры - указатель на массив и длина массива
	li t0 0
	mv t1 %arr
	fill_for: bge t0 %len end_fill
		read_int(%arr)#вызов макроса для ввода числа
		sw %arr (t1)
		addi t0 t0 1
		addi t1 t1 4
		j fill_for
	end_fill:
.end_macro

.macro sum (%arr %len)#макрос суммирования элементов массива с проверкой на переполнение
	
	li t0 0 
	mv t1 %arr
	sum_for: bge t0 %len end_sum
		lw %arr (t1)
		li s2 0
		li s3 0
		li s6 0
		old_sum_sign: bltz s1 cur_num_sign
			li s2 1
		cur_num_sign: bltz %arr check
			li s3 1
		check:	xor s4 s2 s3 
			beqz s4 new_sum_sign
			j ok
		new_sum_sign:
			add s5 s1 %arr
			bltz s5 last_check
			li s6 1		
		last_check: xor s7 s6 s3
			bnez s7 end_sum
		ok:
			add s1 s1 %arr
			addi t0 t0 1#это по совместительству и кол-во просуммированных чисел
			addi t1 t1 4
			j sum_for
	end_sum: 
		mv a0 s1 # сама сумма
		mv a1 t0 # кол-во чисел в сумме
.end_macro
