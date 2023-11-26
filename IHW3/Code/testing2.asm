.global testing2
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
testing1:
#test 1
read_file(buf1, in1) #макросы!
count_digits(buf1)
li t3 10
write_ans(a1,t3,out1)

#test 2
read_file(buf2, in2)
count_digits(buf2)
li t3 10
write_ans(a1,t3,out2)

#test 3
read_file(buf3, in3)
count_digits(buf3)
li t3 10
write_ans(a1,t3,out3)

li a7 10 #exit
ecall
