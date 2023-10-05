.data 
rep: .asciz "\n" #Строка-разделитель
out: .asciz "\n max factorial in int32 is: "
.text
	li t5  2147483647 # Max int value
	li t1 1 # n = 1
	while:
		mv a0 t1
		jal     fact     # Параметр в a0
        	li      a7 1	# Вывод результата вычисления n!
        	ecall          # Параметр уже в a0 ))
		addi t1 t1 1 	#++n
		div t2 t5 t1	#проверка, что n! < MaxInt, (n-1)! < MaxInt/n, тогда переполнения не будет
		bgt a0 t2 end_while
		la a0 rep
        	li a7 4
        	ecall
		j while
	end_while:
        addi t1 t1 -1
	li a7 4
	la a0 out
	ecall
	li a7 1
	mv a0 t1
	ecall
        li      a7 10		#exit call
        ecall
# Рекурсивная подпрограмма вычисления факториала с использованием s-регистра
fact:   addi    sp sp -8        # выделяем две ячейки в стеке
        sw      ra 4(sp)        # сохраняем ra
        sw      s1 (sp)         # сохраняем s1
        mv      s1 a0           # s1 = n
        addi    a0 s1 -1        # a0 = n - 1
        li      t0 1
        ble     a0 t0 done      # Если n=1, выводим
        jal     fact            # рекурсивный вызов
        mul     s1 s1 a0 
# Возврат из подпрограммы и восстановление регистров
done:   mv      a0 s1           
        lw      s1 (sp)         
        lw      ra 4(sp)        
        addi    sp sp 8
        ret
