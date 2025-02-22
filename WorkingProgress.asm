.data

# WALL CORDINATES
wall_X: .word 9
wall_Y: .word 9
wall_char: .asciiz "#"
new_line: .asciiz "\n"
space: .asciiz " "
bit_value: .word 1

array: .data 40
.text

jal load_cordinates
jal load_controller

move $a0, $s0 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW 
jal writing_something 

add $a0, $zero, 7 # HOW MANY PRINT
move $a1, $s7 # WHAT DRAW SPACE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 



add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW 
jal writing_something 

add $a0, $zero, 7 # HOW MANY PRINT
move $a1, $s7 # WHAT DRAW SPACE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 





add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW 
jal writing_something 

add $a0, $zero, 7 # HOW MANY PRINT
move $a1, $s7 # WHAT DRAW SPACE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 




add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW 
jal writing_something 

add $a0, $zero, 7 # HOW MANY PRINT
move $a1, $s7 # WHAT DRAW SPACE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 




add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW 
jal writing_something 

add $a0, $zero, 7 # HOW MANY PRINT
move $a1, $s7 # WHAT DRAW SPACE
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something 

add $a0, $zero, 1 # HOW MANY PRINT
move $a1, $s6 # WHAT DRAW NEW LINE
jal writing_something 

move $a0, $s0 # HOW MANY PRINT
move $a1, $s3 # WHAT DRAW #
jal writing_something



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
  la $s7, space
  lb $s7, space
  

load_controller:
  la $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  la $s5  0xffff000c
  jr $ra
  
   
writing_something: 
# ARGUMENT
# A0 HOW MANY WORDS YOU WANT PRINT 
# A1 WHAT YOU WANT PRINT
  addi $sp, $sp, -4 # ENTER WALL X CONTROLLER
  sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
  slt $t5, $zero, $a0
  beq $t5, $zero, drawing
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

  

  




