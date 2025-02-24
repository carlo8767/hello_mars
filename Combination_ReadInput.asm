.data

array_buffer: .space 400

# WHAT YOU STORE IN BYTE

.text
  la $t3,  array_buffer # ALL ADDRESS
  li $t0,  0xffff0000 # ADDRESS FIRST REGISTER DATA 
  jal add_stack
  
  
add_stack:
  add $sp, $sp, -4 # PIPPO STACK STORE IN THE STACK
  sw $ra, 0($sp) # STORE ADDRESS IN THE STACK
  jal reading
  
reading: 
  lw $t1 ($t0) #  PIPPO READING  READ KEYBOARD REGISTER
  andi $t1, $t1, 1 # VERIFY BIT  CONTROLLER REGISTER IS 1
  beq $t1, $zero, reading # IF CONDITION EXUCTION
  jal poll

poll:
  lw $t2, 4($t0) # STORE THE VALUE KEYBOARD
  sw $t2, ($t3) # STORE IN THE ARRAY PLUS INDEX
  lw $ra, ($sp) # LOAD ADDRESS ENTER ADD STACK COME BACK ADD STACK
  add $sp, $sp, 4 # REMOVE SPACE IN MEMORY
  addi $t3, $t3, 4 # NEXT ADDRESS INDEX ARRAY
  jr $ra

  

