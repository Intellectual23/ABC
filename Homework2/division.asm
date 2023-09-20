li a7, 5
ecall
mv t0, a0 #t0 - n, t1 - d
ecall	  #t2 - q, t3 - m
mv t1, a0
li t3, 1 
if_d_less_0:
	bgez t1, if_0
	mv t4, t1 #9-11: d*=-1
	sub t1, t1, t4 
	sub t1, t1, t4
	li t3, -1 #m=-1
if_0:
	bnez t1, if_less_0
	li a7 10 #exit
	ecall
if_less_0:
	bgtz t0, if_greater_0
	mv t4, t3
	sub t3, t3,t4
	sub t3, t3, t4
	mv t4, t0
	add t4, t4,t1 # n+d
	while_less: # while n+d <= 0
		bgtz  t4, end_while_less
		add t0, t0,t1 #n+=d
		add t2,t2,t3 #q+=m
		add t4,t4,t1 
		j while_less
	end_while_less:
if_greater_0:
	while_greater: #while n>=d
		blt t0, t1, end_while_greater
		sub t0, t0, t1 #n-=d
		add t2,t2,t3 #q+=m
		j while_greater
	end_while_greater:
.text #cout<<quotient<<remainder
	la a0, string_q
	li a7, 4
	ecall
	li a7, 1
	mv a0, t2
	ecall
	la a0, string_r
	li a7, 4
	ecall
	li a7, 1
	mv a0, t0
	ecall
	li a7, 10
	ecall
.data 
	string_q: .asciz " quotient: "
	string_r: .asciz "\n remainder: "
