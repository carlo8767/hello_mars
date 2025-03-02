.data
score_1_title: .asciiz "Score:0     \n" # ONE BYTE FOUR LETTER
wall_2_line: .asciiz   "############\n"
wall_3_line: .asciiz   "#          #\n"
wall_4_line: .asciiz   "#          #\n"
wall_5_line: .asciiz   "#          #\n"
wall_6_line: .asciiz   "#          #\n"
wall_7_line: .asciiz   "############\n"
player_p: .asciiz "P"
meme_p_position:.space 16
reward_r: .asciiz "R"
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
  sw $a2, ($s7) # STORE THE INITIAL POSITION
  sw $a3, 4 ($s7) # STORE Y POSITION
  jal setting_position
  move $a0, $s6 # WRITE PLAYER
  jal writing_output
  
  li $a2, 12 # GO AT POSITION 34       
  li $a3, 2 # GO Y
  sw $a2,8($s7) # STORE THE INITIAL POSITION
  sw $a3, 12 ($s7) # STORE Y POSITION
  jal setting_position
  move $a0, $s5 # WRITE REWARD
  jal writing_output
  
  
  
  
  
  
  # READING INPUT
  jal polling_input
  
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
  li $s2, 0xffff0000 # ADDRESS FIRST REGISTER DATA 
  li $s0, 7 # LOAD BELL CHARACTER
  la $s5, reward_r
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
   sll $a2, $a2, 20    # SHIFT X  20 bits # REGISTER IS 32 BIT
   sll $a3, $a3, 8     # SHIFT Y  8 bits
   or $a1, $a2, $a3    # COMBIN X AND Y
   or $a1, $a1, $a0    # Combine with ASCII Bell
   lw $t8, ($s4) # LOAD VERIFICATION BIT
   andi $t9, $t8, 1 # VERIFY BIT READY
   beq $t9, $zero, setting_position
   sw $a1, 4($s4) # BEGIN SETTING THE POSITION
   lw $a0, 4($s4)  
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
     sb $a1, 4($s4) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
     add $a0, $a0, 1 # ADD NEXT ADDRESS IN THE MEMORY
     lw $ra, 0($sp) #  LOAD FROM THE BUTTON
     addi $sp, $sp, 4 # RETURN AT DRAWING
     jr $ra
  end_drawing:
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 

polling_input:
  lw $t8, 0($s2)  # READ STATUS INPUT REGISTER
  andi $t9, $t8, 1 # VERIFY STATUS REGISTER
  beq $t9, $zero, polling_input  # KEEP LOOPING IF IS NOT READY
  lw $a2, 4($s2) # READ THE CHARACTER
  sb $a2, 0($s1) # STORE IN THE BUFFER
  addi $s1, $s1, 4 # INCREMENT THE BUFFER
  jal move_player # MOVE PLAYER
  j polling_input # KEEP POOLING


move_player:
  addi $sp $sp -4  # SAVE POLLING
  sw $ra, 0($sp)
  # VERIFICATION A 
  # A0 CONTAINS THE WORD INPUT
  la $t0, left
  lb $t0, ($t0) # VERIFY IS THE SAME CHARACTER
  seq $t8, $t0, $a2 
  andi $t9, $t8, 1
  beq  $t9, $zero, else_S
  li $t3, 0
  add $t3, $t3, -1 # SUBSTRACT MINUS ONE AT THE
  li $t4, 0
  jal clear_move_new_position # SETTING NEW POSITION
  j error
  
 
  # VERIFICATION S
  else_S:
  la $t0, down # VERIFICATION S
  lb $t0, ($t0)
  seq $t8, $t0, $a2
  andi $t9, $t8, 1
  beq  $t9, $zero, else_D
  li $t3, 0
  li $t4, 0
  add $t4, $t4, 1 # SUBSTRACT MINUS ONE AT THE
  jal clear_move_new_position # SETTING NEW POSITION
  
 
  # VERIFICATION D
  else_D:
  la $t0, right
  lb $t0, ($t0)
  seq $t8, $t0, $a2
  andi $t9, $t8, 1
  beq  $t9, $zero, else_W
  li $t3, 0
  li $t4, 0
  add $t3, $t3, 1 # SUBSTRACT MINUS ONE AT THE
  jal clear_move_new_position # SETTING NEW POSITION
  
  
   # VERIFICATION W
  else_W:
  lb $t0, up
  seq $t8, $t0, $a2
  andi $t9, $t8, 1
  beq  $t9, $zero, error
  li $t3, 0
  li $t4, 0
  add $t4, $t4, -1 # SUBSTRACT MINUS ONE AT THE
  jal clear_move_new_position # SETTING NEW POSITION
  
  
  
  
  # THIN AT THE ERROR
  error:
  lw $ra 0($sp)  # RELOAD THE ADDRESS
  addi $sp $sp 4
  jr $ra




clear_move_new_position:
# A2 POSITION X PLAYER
# A3 POSITION Y PLAYER
# A0 EMPTY CHAR
# T3 WHERE  LEFT RIGHT
# T4 MOVE UP AND DOWN
  addi $sp $sp -4  # SAVE RETURN NEW POSITION
  sw $ra, 0($sp)

# 1 UPLOAPD PREVIOUS POSITION
  lw $a2, 0($s7) # MOVE X       
  lw $a3, 4($s7) # MOVE Y
  jal setting_position
  
  
  
 # 2 ELIMINATE THE POSITION
  la $a0, empty  # 2 PIPPO
  jal writing_output
  
# 3 MOVE A NEW POSITION  
  lw $a2, 0($s7) # MOVE X        
  lw $a3, 4($s7) # MOVE Y
  # IF T3 AND T4 ARE DIFFERENT FROM 
  add $a2, $a2, $t3 # SUBSTRACT MINUS ONE AT THE 
  add $a3, $a3, $t4 # SUBSTRACT MINUS ONE AT THE     
# 4 STORE NEW POSITION
  sw $a2, 0($s7) # 4 PIPPO
  sw $a3  4($s7) 
  
  jal verify_collision #  PIPPO VERIFY THAT YOU TAKE THE REWARD
    
  lw $a2, 0($s7) # MOVE X       
  lw $a3, 4($s7) # MOVE Y 
  jal setting_position #  JUMP HERE
 # 5 WRITING THE POSITION
  move $a0, $s6 # 5 PIPPO
  jal writing_output 
  lw $ra, 0($sp)  # RELOAD THE ADDRESS
  addi $sp $sp 4
  jr $ra
  
  
  
 verify_collision:
# VERIFY IF THE MEME POSITION HAS THE SAME VALUE
# IF YES DELETE THE R 
# GENERATE A NEW RANDOM POSITION FOR R
# INCREASE THE SCORE
# a0 LOAD X POSITION P
# a1 LOAD Y POSITION P
# a2 LOAD X POSITION R
# a3 LOAD Y POSITION R
# COMPARE WITH 8 AND 2 INDEX OF MY ARRAY IN $S7
  addi $sp $sp, -4
  sw $ra 0($sp)
  lw $a0 0($s7) # LOAD X POSITION P
  lw $a1 4($s7)  # LOAD  Y POSITION P
  lw $a2 8($s7) # LOAD X POSITION P
  lw $a3 12($s7)  # LOAD  Y POSITION P
  seq $t8, $a0, $a2   
  andi $t9, $t8, 1
  beq $t9, $zero exit_collision
  
  seq $t8, $a1, $a3 # VERIFY Y POSITION  
  andi $t9, $t8, 1  # VERIFY X POSITION
  beq $t9, $zero exit_collision
  
  jal random_position_x_y_reward # SECOND
  j  exit_collision
  exit_collision:
  lw $ra 0($sp)
  addi $sp $sp, 4
  jr $ra
  
 
random_position_x_y_reward:
  # RANDOM X
  addi $sp $sp, -4
  sw $ra 0($sp)
  li	$a0, 1		# ID SEED
  move 	$a1, $t0	# seed from time
  li	$v0, 40		# seed random number generator syscall
  syscall
  li	$a0, 1	# as said, this id is the same as random generator id
  li	$a1, 10	        # upper bound of the range
  li	$v0, 42		# random int range
  syscall
  #ADJUST
  addi $a0, $a0, 11
  
  sw $a0, 8($s7) # STORE NEW X FOR
 
  
  # RANDOM Y
  li	$a0, 1		# random generator id (will be used later)
  move 	$a1, $t0	# seed from time
  li	$v0, 40		# seed random number generator syscall
  syscall
  li	$a0, 1		# as said, this id is the same as random generator id
  li	$a1, 4	# upper bound of the range
  li	$v0, 42		# random int range
  syscall
  
   #ADJUST
  addi $a0, $a0, 1
  
  sw $a0  12($s7)  
 
  lw $a2, 8($s7) # MOVE X       
  lw $a3, 12($s7) # MOVE Y
  jal setting_position
  
  move $a0 $s5
  jal writing_output 
  lw $ra 0($sp)
  addi $sp $sp, 4
  jr $ra
