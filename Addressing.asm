.data
score_1_title: .asciiz "Score:0       \n" # ONE BYTE FOUR LETTER
wall_2_line: .asciiz "###############\n"
wall_3_line: .asciiz "#             #\n"
wall_4_line: .asciiz "#             #\n"
wall_5_line: .asciiz "#             #\n"
wall_6_line: .asciiz "#             #\n"
wall_7_line: .asciiz "#             #\n"
wall_8_line: .asciiz "###############\n"

caring: .asciiz "\033[0;50]CARLOMOVERIGHT\n"
bit_move: .byte 2





.text
  
  jal load_controller

  jal load_words
  la $t8, caring
  move $a0, $t8
  jal writing_output
 
 
  move $a0, $t0
  jal writing_output
 
  move $a0, $t1
  jal writing_output


 
  move $a0, $v0 # move the 
  addi $v0,$zero, 10 # Exit
  syscall
 
load_words:
  la $t0, score_1_title #  IT CONTAINS THE FIRST LETTER    ( THE FIRST ADDRESS)
  la $t1, wall_2_line # IT CONTAINS 00
  la $t2, wall_3_line # IT CONTAINS 00
  la $t3, wall_4_line # IT CONTAINS 00
  la $t4, wall_5_line # IT CONTAINS 00
  la $t5, wall_6_line # IT CONTAINS 00
  la $t6, wall_7_line # IT CONTAINS 00
  la $t7, wall_8_line # IT CONTAINS 00
   jr $ra
  
load_controller:
  la $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  la $s5, 0xffff000c # ENTER load_controller CONTROLLER
  jr $ra
  

 
writing_output:
  # A0 ADDRESS YOU WANT PRINT
  # A1 EXTRACT VALUE TO STORE
  # A3 VERIFY NULL CHARACTER
  add $a3, $zero, 1 # ENTER IN WRITING
  addi $sp, $sp, -4 # ENTER WALL X CONTROLLER
  sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
  jal drawing
  drawing:
   addi $sp, $sp, -4
   sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
   lb $a1, ($a0)
   slt $a2, $a3, $a1  # 0 < ARGUMENT
   beq $a2, $zero, end_drawing 
   jal drawing_begin
   drawing_begin:
     lw $a2, ($s4) # LOAD CONTROLLER STATUS
     andi $a2, $a2, 1 # VERIFY BIT READY
     beq $a2, $zero, drawing_begin
     sb $a1, ($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
     lb $t8, ($s5)
     la $t9, ($s5)
     add $a0, $a0, 1 # ADD NEXT ADDRESS IN THE MEMORY
     lw $ra, 0($sp) #  LOAD FROM THE BUTTON
     addi $sp, $sp, 4 # RETURN AT DRAWING
     jr $ra
  end_drawing:
    add $a0, $zero, 0
    add $a1, $zero, 0
    add $a3, $zero, 0
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 