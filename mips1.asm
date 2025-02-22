.data

indexHeap: .word 0
wall: .asciiz  "#"
 
.text
   
  jal create_heap
  la $s1, wall
  
  lb $s1, ($s1)
  move $a2, $s1
  add $a0, $a0, 12
  jal loop_full_square_game
  
  jal  load_word
  
  move $a0, $v0 # move the 
  addi $v0,$zero, 10 # Exit
  syscall
 
 
create_heap:
  li $a0, 12# CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP START ADDRESS
  syscall
  move $s0, $v0
  li $a0, 0
  jr $ra
 
 
 
loop_full_square_game:
 # A0 NUMBER OF LINE
 # A1 NUMBER OF COLUNT
 # A2 STORE WORD
 # A3 NEW LINE CHARACTER
 addi $sp, $sp, -4 
 sw $ra, 0($sp)
 jal begin_store
 begin_store:
   addi $sp, $sp, -4 
   sw $ra, 0($sp)
   slt $t3, $zero, $a0 # ADD LINE 0 < 12
   beq $t3, $zero exit
   jal storing
 storing:
   sb $a2 ($s0) # STORE THE WORD
   addi $s0, $s0 , 1 # POINT THE NEXT ADDRESS
   sub $a0, $a0, 1 # REDUCTION LINE 
   lw $ra 0($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra
 
 exit:
   lw $ra 4($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra
  
 load_word:
 addi $s0, $s0 , -1 # POINT THE NEXT ADDRESS
 lb $t0, ($s0) # IS JUST A FUCKING ADDRESSS 
 jr $ra