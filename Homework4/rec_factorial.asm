.data 
rep: .asciz "\n" #������-�����������
out: .asciz "\n max factorial in int32 is: "
.text
	li t5  2147483647 # Max int value
	li t1 1 # n = 1
	while:
		mv a0 t1
		jal     fact     # �������� � a0
        	li      a7 1	# ����� ���������� ���������� n!
        	ecall          # �������� ��� � a0 ))
		addi t1 t1 1 	#++n
		div t2 t5 t1	#��������, ��� n! < MaxInt, (n-1)! < MaxInt/n, ����� ������������ �� �����
		bgt a0 t2 end_while
		la a0 rep
        	li a7 4
        	ecall
		j while
	end_while:
        addi t1 t1 -1
	li a7 4
	la a0 out
	ecall
	li a7 1
	mv a0 t1
	ecall
        li      a7 10		#exit call
        ecall
# ����������� ������������ ���������� ���������� � �������������� s-��������
fact:   addi    sp sp -8        # �������� ��� ������ � �����
        sw      ra 4(sp)        # ��������� ra
        sw      s1 (sp)         # ��������� s1
        mv      s1 a0           # s1 = n
        addi    a0 s1 -1        # a0 = n - 1
        li      t0 1
        ble     a0 t0 done      # ���� n=1, �������
        jal     fact            # ����������� �����
        mul     s1 s1 a0 
# ������� �� ������������ � �������������� ���������
done:   mv      a0 s1           
        lw      s1 (sp)         
        lw      ra 4(sp)        
        addi    sp sp 8
        ret