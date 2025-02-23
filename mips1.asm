.data
score_1_title: .asciiz "Score:0       \n" # ONE BYTE FOUR LETTER
wall_2_line: .asciiz "############\n"
wall_3_line: .asciiz "#          #\n"
wall_4_line: .asciiz "#          #\n"
wall_5_line: .asciiz "#          #\n"
wall_6_line: .asciiz "#          #\n"
wall_7_line: .asciiz "#          #\n"
wall_8_line: .asciiz "############\n"
x: .word 10
y: .word 5

bell: .asciiz  "␇1020"



.text
  # IN THE TRANSMITTER DATA REGISTER UPLOAD BELL 
 
  jal load_controller
 
  li $t2, 2         # X position (column)
  sll $t2, $t2, 20    # Shift X left by 20 bits

  li $t3,  1        # Y position (row)
  sll $t3, $t3, 8     # Shift Y left by 8 bits

  li $t4, 7           # ASCII 7 (Bell character)
  or $t5, $t2, $t3    # Combine X and Y positions
  or $t5, $t5, $t4    # Combine with ASCII Bell
   
  move $a0, $t5 # BELL PRINT
  jal store_bell
   
  jal load_words
   
  move $a0, $t0
  jal writing_output
  move $a0, $t1
  jal writing_output
  move $a0, $t2
  jal writing_output
   move $a0, $t3
  jal writing_output
  move $a0, $t4
  jal writing_output
  move $a0, $t5
  jal writing_output
   move $a0, $t6
  jal writing_output
  move $a0, $t7
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
  

  
reading_output:
la $s5, 0xffff000c
sra   $s5, $5, 1
lb $a1, 0($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
lb $a1, 0($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
jr $ra


store_bell:
 # A0 ADDRESS YOU WANT PRINT
  # A1 EXTRACT VALUE TO STORE
   move $a1, $a0
   lw $a2, ($s4) # LOAD CONTROLLER STATUS
   andi $a2, $a2, 1 # VERIFY BIT READY
   beq $a2, $zero, store_bell
   sw $a1, 0($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
   add $a0, $zero, 0
   add $a1, $zero, 0
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


  
