.data
score_title: .asciiz   " Score:     0\n" # ONE BYTE FOUR LETTER
wall_first_line: .asciiz "###########\n"
wall_second_line: .asciiz "#         #\n"


.text
  jal create_heap
  jal load_words


  move $a0, $t0
  jal loop_full_square_game
  move $a0, $t1
  jal loop_full_square_game
   move $a0, $t2
  jal loop_full_square_game
  


  move $a0, $v0 # move the 
  addi $v0,$zero, 10 # Exit
  syscall
 
load_words:
  la $t0, score_title #  IT CONTAINS THE FIRST LETTER    ( THE FIRST ADDRESS)
  la $t1, wall_first_line # IT CONTAINS 00
  la $t2, wall_second_line # IT CONTAINS 00
  
  jr $ra
  
  
create_heap:
  li $a0, 40 # CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP START ADDRESS # DISPLAY IN 0060  
  syscall
  move $s0, $v0
  li $a0, 0
  jr $ra
 
# CREATE A FLAG I KNOW THAT FROM 1 TO 12

loop_full_square_game:
 # A0 STORE ADDRESS
 # A1 EXTRACT  1 BIT
 # A3 SET TO 1
 add $a3, $zero, 1
 addi $sp, $sp, -4 
 sw $ra, 0($sp)
 jal begin_store
 begin_store:
   addi $sp, $sp, -4 
   sw $ra, 0($sp)
   lb $a1 ($a0) # LOAD FIRST BIT
   slt  $t3, $a3, $a1 # ADD LINE 0 < 12
   beq $t3, $zero exit_store
   jal storing
 storing:
   sb $a1 4($s0) # STORE THE WORD
   addi $s0, $s0 , 4 # POINT THE NEXT ADDRESS # I CREAT A WORD BOUNDARY
   move $s3, $s0 # STORE THE POSITION OF THE LAST SAVING
   addi $a0, $a0, 1 # ADD 1
   lw $ra 0($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra

 exit_store:
   add $a0, $zero, 0
   add $a1, $zero, 0
   add $a3, $zero, 0
   lw $ra 4($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
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

  