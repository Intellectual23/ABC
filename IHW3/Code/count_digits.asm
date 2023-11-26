#Подпрограмма обработки входной строки, возвращает указатель на массив счетчиков всех цифр строки
.data
.align 2 #word
counts: .space 40 #Массив в котором хранятся счетчики цифр, от 0 до 9 соотв.
arrend_c:
.text
.globl count_digits
.include "macros.asm"
count_digits:
	push_int(ra) # Cохраняю регистры на стек, локальные переменные и входные параметры
	push_int(a0)
	push_int(s0)
	push_int(s1)
	push_int(s2)
	loop:
		la a1 counts
	 	li s0 0x30	# цифра-счетчик, будет от 0 до 9
		lb t1 (a0)         # очередной символ
        	beqz    t1 fin          # нулевой — конец строки
        	li s2 0
        	li t3 10
        	digit_loop: #проверка на цифру от 0 до 9
        		beq s2 t3 nosp
        		bne     t1 s0 next   # не текушая цифра — идем дальше
        		lw s1 (a1)
        		addi    s1 s1 1         # текущая цифра - увеличим счётчик
        		sw s1 (a1)
        		j nosp
        		next:
        		addi a1 a1 4 #идем дальше, пока не найдем подходящий счетчик или строка не кончится
        		addi s0 s0 1
        		addi s2 s2 1
        		j digit_loop
        	
	nosp:   addi    a0 a0 1         # следующий символ
        	j       loop
	fin:
		pop_int(s2) # Восстанавливаю регистры
		pop_int(s1)
		pop_int(s0)
		pop_int(a0)
		pop_int(ra)
		la a1 counts # Возврашаю указатель на массив счетчиков цифр
		ret
