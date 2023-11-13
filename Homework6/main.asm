.globl main
.include "macros.asm"
.eqv     BUF_SIZE 10
.data
buf1:    .space BUF_SIZE     # Буфер для чтения данных
buf2:	 .space BUF_SIZE
empty_test_str: .asciz ""   # Пустая тестовая строка
short_test_str: .asciz "Hello!"     # Короткая тестовая строка
long_test_str:  .asciz "I am long for BUF_SIZE" # Длинная тестовая строка
.text
main:
input_str(buf1)
input_str(buf2)
print_str(buf1)
print_str(buf2)
la a1 buf1
la a2 buf2
li s1 0x20
sb s1 3(a1) #создать новый буфер! третий
li a7 5
ecall
mv a3 a0
jal strncpy
print_str(buf1)
li a7 10
ecall
    
