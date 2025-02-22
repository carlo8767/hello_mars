.data

# WALL CORDINATES
wall_X: .word 9
wall_Y: .word 9
wall_char: .asciiz "#"
new_line: .asciiz "\n"
bit_value: .word 1

array: .data 40
.text

jal load_cordinates
jal load_controller
move $t0, $s0 # HOW MANY PRINT
move $t1, $s3 # WHAT DRAW
jal writing_output
add  $t0, $zero, 1  # HOW MANY PRINT
move $t1, $s6 # WHAT DRAW
jal writing_output
move $t0, $s0 # HOW MANY PRINT
move $t1, $s3 # WHAT DRAW
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
  la $s6, new_line
  lb $s6, new_line
  

load_controller:
  la $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  la $s5  0xffff000c
  jr $ra
  
  
writing_output:
  addi $sp, $sp, -4 # ENTER WALL X CONTROLLER
  sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
  move $a0, $t0 # A0 HOW MANY WORDS YOU WANT PRINT
  move $a1, $t1 # WHATT YOU WANT PRINT
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
     sb $a1, ($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
     sub $a0, $a0, 1 # SUBSTRACT THE VALUE OF #
     lw $ra, 0($sp) #  LOAD FROM THE BUTTON
     addi $sp, $sp, 4 # RETURN AT DRAWING
     jr $ra
  end_drawing:
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 

  
  
  




