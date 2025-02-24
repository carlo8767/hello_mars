.data
score_1_title: .asciiz "Score:0     \n" # ONE BYTE FOUR LETTER
wall_2_line: .asciiz   "############\n"
wall_3_line: .asciiz   "#          #\n"
wall_4_line: .asciiz   "#          #\n"
wall_5_line: .asciiz   "#          #\n"
wall_6_line: .asciiz   "#          #\n"
wall_7_line: .asciiz   "############\n"
player_p: .asciiz "P"
meme_p_position:.space 8
buffer:.space 1000 # IMPLEMENT WITH HEAP

bell: .ascii  "␇"

left: .asciiz  "A"
up: .asciiz    "W"
down: .asciiz  "S"
right: .asciiz  "D"

empty: " "



.text
  # IN THE TRANSMITTER DATA REGISTER UPLOAD BELL 
 
  jal load_controller_local
  jal load_words
  
  li $a2, 10 # MOVE 10       
  li $a3, 0 # MOVE Y
  jal setting_position
  move $a0, $t0
  jal writing_output
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 1 # GO Y
  jal setting_position
  move $a0, $t1
  jal writing_output
  
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 2 # GO Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 3 # GO Y
  jal setting_position
  move $a0, $t3
  jal writing_output
  
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 4 # GO Y
  jal setting_position
  move $a0, $t4
  jal writing_output
  
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 5 # GO Y
  jal setting_position
  move $a0, $t5
  jal writing_output
  
  li $a2, 10 # GO AT POSITION 34       
  li $a3, 6 # GO Y
  jal setting_position
  move $a0, $t6
  jal writing_output
  
  li $a2, 15 # GO AT POSITION 34       
  li $a3, 4 # GO Y
  sw $a2, ($s7) # STORE THE POSITION
  sw $a3, 4 ($s7) # STORE Y POSITION
  jal setting_position
  move $a0, $s6 # WRITE PLAYER
  jal writing_output
  
  # READING INPUT
  jal main_loop
  
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
  jr $ra
  
load_controller_local:
  li $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  li $s5, 0xffff000c # ENTER load_controller CONTROLLER
  li $s2, 0xffff0000 # ADDRESS FIRST REGISTER DATA 
  li $s3, 0xffff0004 # ADDRESS FIRST REGISTER DATA 
  li $s0, 7 # LOAD BELL CHARACTER
  la $s6, player_p
  la $s7, meme_p_position # ARRAY 5 BYTE
  la $s1 buffer
  jr $ra
 
setting_position:
  # A0 BELL CHARACTER
  # A1 EXTRACT VALUE TO STORE AFTER COMBINE
  # A2 X POSITION
  # A3 Y POSITION
   # POSSIBLE MISTAKE IF IT IS NOT SET TO 1
   move $a0, $s0
   sll $a2, $a2, 20    # SHIFT X  20 bits
   sll $a3, $a3, 8     # SHIFT Y  8 bits
   or $a1, $a2, $a3    # COMBIN X AND Y
   or $a1, $a1, $a0    # Combine with ASCII Bell
   lw $t8, ($s4) # LOAD VERIFICATION BIT
   andi $t9, $t8, 1 # VERIFY BIT READY
   beq $t9, $zero, setting_position
   sw $a1, 0($s5) # BEGIN SETTING THE POSITION
   lw $a0, 0($s5)  
   # li $t8  0 # IF I STORE 0 IT CANCEL EVERITHING
   li $a0  0
   li $a2 0
   li $a3 0
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
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 

main_loop:
  lw   $t8, 0($s2)      # Read the status register
  andi $t9, $t8, 1      # Check ready flag
  beq  $t9, $zero, main_loop  # Wait if no data
  lw   $a2, 0($s3)      # Read the character
  sw   $a2, 0($s1)      # Store it in the buffer
  addi $s1, $s1, 4      # Increment buffer pointer (adjust for word size)
  jal move_player       # MOVE PLAYER
  j    main_loop       # Continue polling


move_player:
  # VERIFICATION A 
  # A0 CONTAINS THE WORD INPUT
  la $t0, left
  lb $t0, ($t0)
  seq $t8, $t0, $a2 
  andi $t9, $t8, 1
  beq  $t9, $zero, else_S
  
  # 1 UPLOAD PREVIOUS POSITION
  
  lw $a2, 0($s7) # MOVE 10       
  lw $a3, 4($s7) # MOVE Y
  jal setting_position
  # 2 ELIMINATE THE POSITION
  la $a0, empty 
  jal writing_output
  # 3 MOVE A NEW POSITION  
  lw $a2, 0($s7) # MOVE 10       
  lw $a3, 4($s7) # MOVE Y
  add $a2, $a2, -1 # SUBSTRACT MINUS ONE AT THE     
  jal setting_position
  # 4 WRITING THE POSITION
  move $a0, $s6
  jal writing_output  
  j error
  
  # VERIFICATION S
  else_S:
  la $t0, down
  lb $t0, ($t0)
  seq $t8, $t0, $a1
  andi $t9, $t8, 1
  beq  $t9, $zero, else_D
  

  
  
  # VERIFICATION D
  else_D:
  la $t0, right
  lb $t0, ($t0)
  seq $t8, $t0, $a1
  andi $t9, $t8, 1
  beq  $t9, $zero, else_W
  
  
   # VERIFICATION D
  else_W:
  lb $t0, up
  seq $t8, $t0, $a1
  andi $t9, $t8, 1
  beq  $t9, $zero, error
  
  # THIN AT THE ERROR
  error:
  jr $ra
