.data
input_prompt:  .asciz "Input file path: "     # Путь до читаемого файла
input_file: .space	256		# Имя читаемого файла
output_file: .space	256		# Имя читаемого файла
sep: .asciz " " #строка-разделитель
endl: .asciz "\n"
output_prompt:  .asciz "Output file path: "     # Путь до читаемого файла
er_name_mes: .asciz "Incorrect file name\n"
default_name: .asciz "testout.txt"      # Имя файла по умолчанию
er_read_mes:    .asciz "Incorrect read operation\n"
.text

.macro write_file(%strbuf, %file) #Запись содержимого буфера в файл
    # Убрать перевод строки
    li  t4 '\n'
    la  t5  %file
    mv  t3 t5	# Сохранение начала буфера для проверки на пустую строку
loop:
    lb	t6  (t5)
    beq t4	t6	replace
    addi t5 t5 1
    b   loop
replace:
    beq t3 t5 default	# Установка имени введенного файла
    sb  zero (t5)
    mv   a0, t3 	# Имя, введенное пользователем
    b out
default:
    la   a0, default_name 
out:
    # Open (for writing) a file that does not exist
    li   a7, 1024     # system call for open file
    li   a1, 1        # Open for writing (flags are 0: read, 1: write)
    ecall             # open a file (file descriptor returned in a0)
    mv   s6, a0       # save the file descriptor
    ###############################################################
    # Write to file just opened
    li   a7, 64       # system call for write to file
    mv   a0, s6       # file descriptor
    la   a1, %strbuf  # address of buffer from which to write
    strlen(%strbuf, a2)
   #li   a2, 5       # hardcoded buffer length
    ecall             # write to file
    ###############################################################
    # Close the file
    li   a7, 57       # system call for close file
    mv   a0, s6       # file descriptor to close
    ecall             # close file
    ###############################################################
.end_macro

.macro read_buf(%message %buf) #Диалоговое окно для получения буфера из него, на вход получает сообщение(в окне) и сам буфер
push_int(ra) #Сохраняю регистры на стек чтобы их значения не портились
push_int(a0)
push_int(a1)
push_int(a2)
la a0 %message
la a1 %buf
    li      a2 256
    li      a7 54
    ecall
pop_int(a2) #Восстанавливаю регистры в стеке
pop_int(a1)
pop_int(a0)
pop_int(ra)
.end_macro

.macro read_file(%strbuf, %file)# Чтение текста из файла, задаваемого в диалоге, в буфер
.text
    # Убрать перевод строки
    li	t4 '\n'
    la	t5	%file
loop:
    lb	t6  (t5)
    beq t4	t6	replace
    addi t5 t5 1
    b	loop
replace:
    sb	zero (t5)
    ###############################################################
    li   	a7 1024     	# Системный вызов открытия файла
    la      a0 %file   # Имя открываемого файла
    li   	a1 0        	# Открыть для чтения (флаг = 0)
    ecall             		# Дескриптор файла в a0 или -1)
    li		s1 -1			# Проверка на корректное открытие
    beq		a0 s1 er_name	# Ошибка открытия файла
    mv   	s0 a0       	# Сохранение дескриптора файла
    ###############################################################
    # Чтение информации из открытого файла
    li   a7, 63       # Системный вызов для чтения из файла
    mv   a0, s0       # Дескриптор файл
    la   a1, %strbuf   # Адрес буфера для читаемого текста
    li   a2, 2048# Размер читаемой порции
    #li   a2, 10 # Размер читаемой порции
    ecall             # Чтение
    # Проверка на корректное чтение
    beq		a0 s1 er_read	# Ошибка чтения
    mv   	s2 a0       	# Сохранение длины текста
    ###############################################################
    # Закрытие файла
    li   a7, 57       # Системный вызов закрытия файла
    mv   a0, s0       # Дескриптор файла
    ecall             # Закрытие файла
    ###############################################################
    # Установка нуля в конце прочитанной строки
    la	t0 %strbuf	 # Адрес начала буфера
    add t0 t0 s2	 # Адрес последнего прочитанного символа
    addi t0 t0 1	 # Место для нуля
    sb	zero (t0)	 # Запись нуля в конец текста
    ###############################################################
    # Завершение  программы
    j end_read
er_name:
    # Сообщение об ошибочном имени файла
    la		a0 er_name_mes
    li		a7 4
    ecall
    # И завершение программы
    j end_read
er_read:
    # Сообщение об ошибочном чтении
    la		a0 er_read_mes
    li		a7 4
    ecall
    # И завершение программы
    end_read:
    .end_macro

.macro push_int(%x)# Сохранение целого числа на верхушку стека
 addi sp, sp, -4
 sw  %x, (sp)
.end_macro 

.macro pop_int(%x)# Удаление целого числа из верхушки стека
 lw  %x, (sp)
 addi sp, sp, 4
.end_macro 

.macro write_ans(%arr %len %file)#Берем массив типа word, по очереди записываем все его счетчики через пробел в буфер, и записываем это в файл
.data 
fin_buf: .space 4096 #Тут будет храниться ответ 
.text
push_int(ra)
push_int(s1) #Сохраняю локальные переменные на стек
push_int(s2)
push_int(s3)
push_int(s4)
la s2 fin_buf
li s0 0 
mv s1 %arr
li s4 ' ' # пробел-разделитель счетчиков
write_for: bge s0 %len end_write
	lw a1 (s1)
	jal to_string #переводим word в строку байт при помощи подпрограммы to_string, которая кладет результат приведения в регистр a0(т.е адрес)
	append_loop: #в a0 адрес буфера текущего счетчика, теперь посимвольно припишем его в fin_buf и добавим пробел
		lb s3 (a0) 
		beqz s3 end_append #Конец - нулевой символ
		sb s3 (s2) 
		addi s2 s2 1
		sb s4 (s2) #вставили пробел!
		addi a0 a0 1
		addi s2 s2 1
		b append_loop
		end_append: #Добавили в fin_buf счетчик
	addi s0 s0 1 #следующий шаг, увеличиваем счетчик цикла и берем следующий word из массив счетчиков
	addi s1 s1 4
	b write_for
	end_write: #все 10 счетчиков записаны через пробел в буфере fin_buf
		la a1 fin_buf #Возвращаю адрес fin_buf для дополнительного вывода в консоль
		write_file(fin_buf, %file) # Долгожданная запись ответа в файл!
		pop_int(s4) # Восстанавливаю локальные переменные 
		pop_int(s3)
		pop_int(s2)
		pop_int(s1)
		pop_int(ra)
		.end_macro

.macro count_digits(%buf) #Обернутая в макрос подпрограмма count_digits
	push_int(ra)
	push_int(a0) # на всякий случай чтоб не портился регистр a0
	la a0 %buf
	jal count_digits #вызов
	pop_int(a0)
	pop_int(ra)
.end_macro

.macro strlen(%buf %to) # strlen из семинара
    li      t0 0        # Счетчик
    la t2 %buf
loop:
    lb      t1 (t2)   # Загрузка символа для сравнения
    beqz    t1 end
    addi    t0 t0 1		# Счетчик символов увеличивается на 1
    addi    t2 t2 1		# Берется следующий символ
    b       loop
end:
    mv      %to t0
.end_macro

.macro print_buf(%buf) #печать строки 
	push_int(a0)
	la a0 %buf
	li a7 4
	ecall
	pop_int(a0)
.end_macro

.macro print_str(%str) #печать строки по ее адресу
	push_int(a0)
	mv a0 %str
	li a7 4
	ecall
	pop_int(a0)
.end_macro
