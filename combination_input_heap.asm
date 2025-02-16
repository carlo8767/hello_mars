.data

array_buffer: .space 0

# WHAT YOU STORE IN BYTE

.text

  la $t3,  array_buffer # ALL ADDRESS
  li $t0,  0xffff0000 # ADDRESS FIRST REGISTER DATA 
  li $a0, 4# CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP
  syscall
  jal add_stack
  
  
add_stack:
  sw $v0, ($t3) # ASSIGN THE HEAP 
  add $sp, $sp, -4 # PIPPO STACK STORE IN THE STACK
  sw $ra, 0($sp) # STORE ADDRESS IN THE STACK
  jal reading
  
reading:
  lw $t1 0($t0) #  PIPPO READING  READ KEYBOARD REGISTER
  andi $t1, $t1, 1 # VERIFY BIT CONTROLLER REGISTER IS 1
  beq $t1, $zero, reading # IF CONDITION EXUCTION
  jal poll

poll:
  add $t4, $t4, 1 # PIPPO POLL
  lw $t2, 4($t0) # STORE THE VALUE KEYBOARD
  sw $t2, 0($v0) # STORE IN THE ARRAY PLUS INDEX
  addi $a0, $a0, 4 # INCREASE THE HEAP
  lw $ra, 0($sp) # LOAD ADDRESS ENTER ADD STACK COME BACK ADD STACK
  add $sp, $sp, 4 # REMOVE SPACE IN MEMORY
  jr $ra
 
 

  
  

