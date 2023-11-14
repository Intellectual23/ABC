.include "macros.asm"
.globl strncpy #(a1- dest, a2 - src,  a3 - len)
strncpy:
	push(ra)
	strlen(a2) # для проверки в будущем считаем длину строки src
	mv t2 a0
	li t3 0 # счетчик цикла
	for:
		beq t3 a3 end_for # от 0 до len.
		bge t3 t2 fill # если кончилась длина src, обрезаем.
		lb t4 (a2) #копируем
		sb t4 (a1)
		j next
		fill:
			sb t0 (a1)
			b end_for # обрезаем строку, нет смысла вставлять больше одного \0
		next:
			addi a1 a1 1 # следующая итерация
			addi a2 a2 1
			addi t3 t3 1
			b for
		end_for:
	pop(ra)				
	ret
