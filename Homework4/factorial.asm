.data 
rep: .asciz "\n" #Строка-разделитель
out: .asciz "\n max factorial in int32 is: "
.text
	li s2  2147483647 # Max int value
	li t1 1 # n = 1
	while:
		mv a0 t1
		jal     fact     # Параметр в a0
        	li      a7 1	# Вывод результата вычисления n!
        	ecall         
		addi t1 t1 1 	#++n
		div t2 s2 t1	#проверка, что n! < MaxInt, (n-1)! < MaxInt/n, тогда переполнения не будет
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
# Подпрограмма вычисления факториала
fact:	li t3, 1 # счётчик t3
       	mv t0 t3 # в t0 храним произведение
        while_f:
        	bgt t3 a0 end
        	mul t0 t0 t3
        	addi t3 t3 1
        	j while_f
       end: 	mv a0 t0
       		ret