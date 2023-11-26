#Подпрограмма преобразования целого числа word в буфер byte
.data
digits: .space 4096
answer: .space 4096
.globl to_string
.include "macros.asm"
 to_string: # число хранится в a1
 push_int(ra) # Сохраняю регистры на стек, локальные переменные и входные параметры
 push_int(a1)
 push_int(s0)
 push_int(s1)
 push_int(s2)
 push_int(s3)
 push_int(s4)
 if_zero: bnez a1 else #Проверка на ноль, тут просто возрвращаем код цифры 0 как буфер
 	  li t0 0x30
 	  la t1 answer
 	  sb t0 (t1)
 	  j end_reverse_while
 else: # Если не ноль, придется попотеть
 li t0 10 #десятка, чтобы брать остаток == последнюю цифру
 la s2 digits #буфер байтов, в каждом будет цифра числа, но здесь все в обратном порядке
 mv s3 s2
 la s4 answer # а тут в прямом порядке, это и будет ответ
 while_gr_0:	blez a1 end_while_gr_0 # делю на 10 пока могу
 		li t1 0x30 #цифра 0 в байт
 		rem s0 a1 t0 # текущая последняя цифра
 		add t1 t1 s0 # перевели цифру в byte = 0x30 + цифра
 		sb t1 (s2) # Кладем текущую цифру числа
 		addi s2 s2 1 
 		div a1 a1 t0 #Делим на 10 наше число
 		b while_gr_0
 		end_while_gr_0: # получили буфер цифр числа в формате байт, но в обратном порядке
  reverse_while: #теперь делаю реверс как цикл do_while, в s2 хранится адрес конца буфера, будем идти в начало, приписывая все цифры в буфер answer
  		addi s2 s2 -1 #сдвиг
 		lb t1 (s2)
 		sb t1 (s4)#сохранил в буфер ans
 		addi s4 s4 1
 		beq s2 s3 end_reverse_while # Если s2=s3, то s2 снова пришел в начало, конец цикла
		b reverse_while
 end_reverse_while:
 		pop_int(s4) # Восстанавливаю регистры
 		pop_int(s3)
 		pop_int(s2)
 		pop_int(s1)
 		pop_int(s0)
 		pop_int(a1)
 		pop_int(ra)
 		la a0 answer #возвращаю адрес буфера с цифрами числа, ура!
 		ret
