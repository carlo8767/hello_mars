.data
wall_up:9
wall_down:9
wall_left:9
wall_right:9

wall: .ascii "#"
x: .word 1

array: .data 40
.text

# li $a0, 4 # CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
# li $v0, 9 # ALLOCATE THE HEAP
# syscall

la $s0, wall # STORE THE WALL IN THE MEMORY
lb $s0 wall # EXTRACT THE BIT
lw $s1, x

move $a0, $s0 # ARGUMENT FUNCTION

la $t0, 0xffff0008 # LOAD TRANSMITTER CONTROLLER
sw $s1, 0($t0) # STORE ONE BIT OF THE WALL
la $t2, 0xffff000c # LOAD TRASMITTER DATA
add $t4, $t4, 9 # ADD 9 X

jal writing_wall
slt $t6, $zero, $t4 # VERIFY THAT IS FINISH TO PRINT
beq $t6, $zero, else # VERIFY THAT THE 0 < 9 
writing_wall:
  lw $t3, 0($t0)     # LOAD TRANSMITTER CONTROLLER REGISTER
  andi $t3, $t3, 1 # VERIFY BIT  CONTROLLER REGISTER IS 1
  beq $t3, $zero, writing_wall # IF CONDITION EXUCTION
  sb $s0, ($t2) # STORE WORD TRANSMITTER DATA
  # RETURNING THE ADDRESS
  sub $t4, $t4, 1
  jr $ra
else:
move $a0, $v0 # move the 
addi $v0,$zero, 10 # Exit
syscall
