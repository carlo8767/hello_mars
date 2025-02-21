.data

# WALL CORDINATES
wall_X: .word 9
wall_Y: .word 9
wall_char: .ascii "#"
bit_value: .word 1

array: .data 40
.text

jal load_cordinates
jal load_controller
move $t0, $s0
jal writing_output
move $t0, $s1
jal writing_output

move $a0, $v0 # move the 
addi $v0,$zero, 10 # Exit
syscall

# FUNCTION

load_cordinates:
  la $s0, wall_X # ENTER load_cordinates CONTROLLER
  lw $s0, wall_X
  la $s1, wall_Y
  lw $s1, wall_Y
  la $s3, wall_char
  lb $s3, wall_char

load_controller:
  la $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  la $s5  0xffff000c
  jr $ra
  
  
writing_output:
  addi $sp, $sp, -4 # ENTER WALL X CONTROLLER
  sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
  move $a0, $t0
  jal drawing
  drawing:
   addi $sp, $sp, -4
   sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
   slt $t5, $zero, $a0  # 0 < ARGUMENT
   beq $t5, $zero, end_drawing 
   jal drawing_begin
   drawing_begin:
     lw $t3, 0($s4) # LOAD CONTROLLER
     andi $t3, $t3, 1 # VERIFY BIT READY
     beq $t3, $zero, drawing_begin
     sb $s3, ($s5) # BEGIN WRITING LOAD DATA CONTROLLER
     sub $a0, $a0, 1 # SUBSTRACT THE VALUE OF #
     lw $ra, 0($sp) #  LOAD FROM THE BUTTON
     addi $sp, $sp, 4 # RETURN AT DRAWING
     jr $ra
  end_drawing:
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 

  
  
  




