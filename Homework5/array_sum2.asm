.include "macros.asm"
.data
sep: .asciz "\n"
sep2: .asciz "-------\n"
.align 2
array:  .space 40 #�������� ������ ��� ������� �� �������� 10 �����
arrend:
.text
main:
	check_n (a1)#�������� ������ �� �������� ����� �������, � ��� ��� ������� ����
	la a0 array
	fill (a0 a1)#�������� ������ ��� �����, � �1 ��� �������� �����, � � �0 ����� �������
	li a7 4
	la a0 sep2
	ecall
	la a0 array
	sum(a0 a1) #�������� ������ ��� ������������
	li a7 1 #�����
	ecall
	li a7 4
	la a0 sep
	ecall
	li a7 1
	mv a0 a1
	ecall
	li a7 10 #�����
	ecall