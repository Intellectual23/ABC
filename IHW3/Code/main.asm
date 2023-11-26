.include "macros.asm"
.globl main
.data
strbuf:	.space 4096 # Буфер для читаемого текста
message: .asciz "Enter Y for print on console or N for don't print: "
.text
main:
	#print_buf(input_prompt) #после введения окна диалога эта строка уже не нужна
	read_buf(input_prompt, input_file) # Запрашиваем имя файла с входными данными через диалоговое окно(макрос)
	read_file(strbuf, input_file) # Чтение файла, на вход получаем буфер и имя файла
	count_digits(strbuf) #Обработка входных данных и подсчет счетчиков - цифр, на вход передаем буфер с входными данными, на выходе получаем адрес массива счетчиков цифр в регистре a1
	#print_buf(output_prompt) #после введения окна диалога эта строка уже не нужна
	read_buf(output_prompt,output_file)# Запрашиваем диалоговым окном имя файла в который запишем ответ
	li t3 10 #длина массива счетчиков - цифр это 10, так удобно
	write_ans(a1,t3, output_file) #макрос который получает на вход указатель на массив счетчиков цифр, длину(10) и имя файла, в который нужно записать счетчики
	li t0 0x59 #код Y
	li t1 0x4E #код N
	print_buf(message) #Дополнительеый вывод результата на консоль
	li a7 12
	ecall
	yes: beq a0 t1 no #показываем результат в консоли рарса
		print_buf(endl)
		print_str(a1)
	no: #не показываем - exit 
		li a7 10
		ecall
