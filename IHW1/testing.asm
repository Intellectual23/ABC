.include "macros.asm"
.data
.align 2
test: .space 40
test_end:
.align 2
sorted: .space 40
sorted_end:
.text
#1 массив
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
li a7 10
ecall
