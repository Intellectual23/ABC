.globl main
.include "macros.asm"
.eqv     BUF_SIZE 100
.data
sep: .asciz "\n"
dest:    .space BUF_SIZE     # Буфер для чтения данных
src: .space BUF_SIZE
empty_str: .asciz ""   # Пустая тестовая строка
test_str: .asciz "Hello!"     # строка символов
.global dest
.global src
.text
main:
	read_str(dest) # Считывание строк с клавиатуры
	read_str(src)
li a7 5
ecall
mv a3 a0

# 1 тест - две строки с консоли
strncpy(dest, src, a3) # Вызов макроса функции strncpy
print_str(dest) # Печать результата

# 2 тест - с пустой строкой и строкой символов
li a3 7 
strncpy(empty_str, test_str, a3)
print_str(empty_str)
li a7 4
la a0 sep
ecall
# 3 тест - со строкой символов и src
li a3 5
strncpy(test_str, src, a3)
print_str(test_str)
li a7 10 # Exit
ecall
    
