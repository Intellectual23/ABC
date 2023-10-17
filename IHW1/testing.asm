#Программа тестирования, сделал 3 теста в соответсвии с требованием.
.include "macros.asm"
.data
.align 2
test: .space 40 #заполняем сами
test_end:
.align 2
sorted: .space 40 #отсортированный
sorted_end:
.text
#1 тест (просто вручную заполняем, потом вызываем сортировку и вывод, и сравниваем)
li a1 7
la a0 test
li t0 5
sw t0 (a0)
li t0 3
sw t0 4(a0)
li t0 4
sw t0 8(a0)
li t0 2
sw t0 12(a0)
li t0 6
sw t0 16(a0)
li t0 1
sw t0 20(a0)
li t0 7
sw t0 24(a0)
print(a0 a1)
la a2 sorted
sort(a0 a1 a2)
print(a2 a1)
li a7 4
la a0 endl
ecall

#2 тест
li a1 10
la a0 test
li t0 -12
sw t0 (a0)
li t0 43
sw t0 4(a0)
li t0 -7
sw t0 8(a0)
li t0 45
sw t0 12(a0)
li t0 2
sw t0 16(a0)
li t0 112
sw t0 20(a0)
li t0 -6
sw t0 24(a0)
li t0 -12
sw t0 28(a0)
li t0 9
sw t0 32(a0)
li t0 122
sw t0 36(a0)
print(a0 a1)
la a2 sorted
sort(a0 a1 a2)
print(a2 a1)
li a7 4
la a0 endl
ecall

#3 тест
li a1 5
la a0 test
li t0 -1
sw t0 (a0)
li t0 1
sw t0 4(a0)
li t0 -1
sw t0 8(a0)
li t0 1
sw t0 12(a0)
li t0 0
sw t0 16(a0)
print(a0 a1)
la a2 sorted
sort(a0 a1 a2)
print(a2 a1)
li a7 4
la a0 endl
ecall
li a7 10 #exit
ecall
