.global testing1
.include "macros.asm"
.data
in1: .asciz "test1.txt"
in2: .asciz "test2.txt"
in3: .asciz "test3.txt"
out1: .asciz "out1.txt"
out2: .asciz "out2.txt"
out3: .asciz "out3.txt"
buf1: .space 4096
buf2: .space 4096
buf3: .space 4096

.text
testing2:
#test1
read_file(buf1, in1) #только макрос
la a0 buf1	#подпрограмма
jal count_digits
li t3 10
write_ans(a1,t3,out1) #тут тоже только макрос
print_str(a1) # и тут)

#test2
read_file(buf2, in2) 
la a0 buf2	
jal count_digits
li t3 10
write_ans(a1,t3,out2) 
print_str(a1)

#test 3
read_file(buf3, in3) 
la a0 buf3	
jal count_digits
li t3 10
write_ans(a1,t3,out3) 
print_str(a1)
li a7 10
ecall
