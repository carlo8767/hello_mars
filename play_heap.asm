.data
score_title: .asciiz   "Score:    0\n" # ONE BYTE FOUR LETTER
wall_first_line: .asciiz "############\n"
wall_second_line: .asciiz "#          #\n"


.text
  jal create_heap
  jal load_words
  jal load_controller


  move $a0, $t0
  jal loop_full_square_game
  move $a0, $t1
  jal loop_full_square_game
  move $a0, $t2
  jal loop_full_square_game
  

  move $a0, $t0
  jal writing_output

  
 
  move $a0, $v0 # move the 
  addi $v0,$zero, 10 # Exit
  syscall
 
load_words:
  la $t0, score_title #  IT CONTAINS THE FIRST LETTER    ( THE FIRST ADDRESS)
  la $t1, wall_first_line # IT CONTAINS 00
  la $t2, wall_second_line # IT CONTAINS 00
  jr $ra
  
load_controller:
  la $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  la $s5, 0xffff000c # ENTER load_controller CONTROLLER
  
  
create_heap:
  li $a0, 40 # CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP START ADDRESS # DISPLAY IN 0060  
  syscall
  move $s0, $v0
  li $a0, 0
  jr $ra
 
# CREATE A FLAG I KNOW THAT FROM 1 TO 12

loop_full_square_game:
 # A0 STORE ADDRESS WHAT YOU WANT STORE
 # A1 EXTRACT VALUE  1 BIT
 # A3 SET TO 1
 add $a3, $zero, 1
 addi $sp, $sp, -4 
 sw $ra, 0($sp)
 jal begin_store
 begin_store:
   addi $sp, $sp, -4 
   sw $ra, 0($sp)
   lb $a1 ($a0) # LOAD FIRST BIT
   slt  $t3, $a3, $a1 # WHEN CONTAIN NULL CHARACHTER EXIT
   beq $t3, $zero exit_store
   jal storing
 storing:
   sb $a1 4($s0) # STORE THE WORD
   addi $s0, $s0 , 4 # POINT THE NEXT ADDRESS # I CREAT A WORD BOUNDARY
   move $s3, $s0 # STORE THE POSITION OF THE LAST SAVING
   addi $a0, $a0, 1 # ADD 1 ON THE NEXT BIT --> NEXTR ADDRESS
   lw $ra 0($sp)
   sw $zero ($sp) # REMOVE ADDRESS FROM THE STACK
   addi $sp, $sp, 4 # COME BACK TO SQUARE
   jr $ra

 exit_store:
   add $a0, $zero, 0
   add $a1, $zero, 0
   add $a3, $zero, 0
   lw $ra 4($sp)
   sw $zero ($sp)
   sw $zero 4($sp)
   addi $sp, $sp, 4 # COME BACK TO SQUARE
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
   slt $t3, $a3, $a1  # 0 < ARGUMENT
   beq $t3, $zero, end_drawing 
   jal drawing_begin
   drawing_begin:
     lw $t3, ($s4) # LOAD CONTROLLER STATUS
     andi $t3, $t3, 1 # VERIFY BIT READY
     beq $t3, $zero, drawing_begin
     sb $a1, 0($s5) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
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

  