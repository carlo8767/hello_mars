.text
main:
	lw $a0, x # load x as argument
	lw $a1, y # load y as argument
	addi $sp, $sp, -8 # reserved two aparments
	sw $a0, 0($sp)  # set the address in the stack plus offset
	sw $a1, 4($sp)	# set the address in the stack plus offset
	addi $a0,$zero, 7 # modify the register
	addi $v0, $zero, 1 # print the register
	syscall
	lw $ra, 0($sp),    # return the address
	move $a0, $ra      # repristinate the older value
	addi $v0, $zero, 1  # print the register
	syscall
	add $sp, $sp, 4  # remove space from stack
  	add $sp, $sp, 4  # remove space from stack
	addi $v0, $zero, 10  # exit
	syscall
.data
	x: .word 5
	y: .word 9
.globl main	
	
	
	

