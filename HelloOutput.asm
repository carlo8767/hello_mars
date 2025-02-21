.data

array_buffer: .space 400

# WHAT YOU STORE IN BYTE

.text
  la $t3,  array_buffer # ALL ADDRESS
  li $t0,  0xffff0000 # ADDRESS FIRST REGISTER DATA 
  li $t4,  0xffff0008 # LOAD THE TRANSMITTER CONTROLLER REGISTERS
  # li $t5,  0xffff000c # LOAD THE TRANSMITTER DATA REGISTER STORE VALUES
  jal add_stack
  
  
add_stack:
  add $sp, $sp, -4 # PIPPO STACK STORE IN THE STACK
  sw $ra, 0($sp) # STORE ADDRESS IN THE STACK
  jal reading
  
reading: 
  lw $t1 0($t0) #  PIPPO READING  READ KEYBOARD REGISTER
  andi $t1, $t1, 1 # VERIFY BIT  CONTROLLER REGISTER IS 1
  beq $t1, $zero, reading # IF CONDITION EXUCTION
  jal poll

poll:
  lw $t2, 4($t0) # STORE THE VALUE KEYBOARD IN THE RECEIVER DATA 0xffff0004	
  sw $t2, 0($t3) # STORE IN THE ARRAY PLUS INDEX
  lw $ra, 0($sp) # LOAD ADDRESS ENTER ADD STACK COME BACK ADD STACK
  
  
 
 sw $t2, 4($t4) # NO WAY WRITE IN THE DEVICE I HAVE TO LAOD SOMETHING IN THE REGISTER 0xffff000c 
 lw $t1, 4($t4) # PIPPO OUTPUT LOAD THE TRANSMITTER STATUS
 andi $t1, $t1, 1 # VERIFY THE STATUS
 beq $t1, $zero, reading # IF CONDITION EXUCTION
# sw $s2, 4($t5) # WRITE IN THE DEVICE
  
  
  
  add $sp, $sp, 4 # REMOVE SPACE IN MEMORY
  addi $t3, $t3, 4 # NEXT ADDRESS INDEX ARRAY
  jr $ra

  

