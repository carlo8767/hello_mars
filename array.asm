# library for linked lists in mips
	.data # static 
	
head:   .word 5  # list is initialize to 0 THIS IS THE STATIC
	.text	
	
# each node is two words allocated by sbrk;
# first word contain the data
# second word contains the address of next node

new_node_head: # takes as argument a new value, stored in a0
	# sbrk for two words on heaps:
	add $t0, $a0, $zero # ADD IN A0 
	li $a0, 8 # ALLOCATE TWO WORD 8 BYTE IN THE HEAP THE HEAP IS IN $v0
	li $v0, 9
	syscall 

	# store old head value in second word from sbrk
	lw $t1, head # load inside the register $t1 the head conte3nct
	sw $t1, 0($v0) # store the value of 0 in the heap
	# head should contain the address of the new memory block
	sw $v0, head
	# save $ao in the first word returned by sbrk
	sw $t0, 4($v0)
	jr $ra



