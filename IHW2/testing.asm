.text
.include "macrolib.asm"
.globl testing
testing:
	#1
	li t0 5
	fcvt.d.w fa1, t0
	li t0 7
	fcvt.d.w fa2, t0
	li t0 2
	fcvt.d.w fa3, t0
	li t0 5
	fcvt.d.w fa4, t0
	jal integrate
	print_double(fa0)
	
	#2
	li t0 -1
	fcvt.d.w fa1, t0
	li t0 2
	fcvt.d.w fa2, t0
	li t0 6
	fcvt.d.w fa3, t0
	li t0 7
	fcvt.d.w fa4, t0
	jal integrate
	print_double(fa0)
	
	#3
	li t0 1
	fcvt.d.w fa1, t0
	li t0 2
	fcvt.d.w fa2, t0
	li t0 3
	fcvt.d.w fa3, t0
	li t0 4
	fcvt.d.w fa4, t0
	jal integrate
	print_double(fa0)
	#exit
	li a7 10
	ecall
		
