# library for linked lists in mips
.data # static 	
  head:  .word 0 # THIS IS A ADDRESS LABEL

.text
# FIRST WORD CONTAIN THE DATA AND SECOND WORD CONTAIN THE ADDRESS
	

	
	li $a0, 5
	jal new_node_head
	li $a0, 10
	jal new_node_head
	move $a0, $v0
	addi $v0,$zero, 10 # Exit
    	syscall

  new_node_head:
	add $t0, $a0, 0 # STORE AN EMPTY ADDRESS IN $TO
	li $a0, 8# CREATE A SPACE OF 8 BYTE IN THE REGISTER SBRK
	li $v0, 9 # ALLOCATE THE HEAP 
	syscall 

	lw $t1, head # STORE THE VALUE INSIDE $T1 REGISTER
	sw $t1	0($v0) # STORE THE ADDRESS OF INDEX 0 IN THE HEAP
	sw $t0, 4($v0) # STORE THE POINT TO THE NEXT ELEMENT
	sw $v0, head # HEAD WILL POINT AT THE NEW ADDRESS AT THE MEMORY
	jr $ra

	

