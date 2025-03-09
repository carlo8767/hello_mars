.data
score_1_title: .asciiz "Score:0     " # ONE BYTE FOUR LETTER
wall_2_line: .asciiz   "##############"
wall_3_line: .asciiz   "#            #"
player_p: .asciiz "P"
reward_r: .asciiz "R"
game_over: .asciiz  "GAME OVER"
clear_window: .asciiz "FF"
left: .asciiz  "A"
up: .asciiz    "W"
down: .asciiz  "S"
right: .asciiz  "D"
empty: " "
point_zero: .byte 48
point_one: .byte 49
final_score: .asciiz  "THE FINAL SCORE IS:" 
meme_p_position: .space 24



.text
  jal load_controller_local
  jal load_words
  
  # VERIFY THAT WE ARE READY TO WRITE
  controller_inital_status:
  lw $a2, ($s4) # LOAD CONTROLLER STATUS
  andi $a2, $a2, 1 # VERIFY BIT READY
  beq $a2, $zero, controller_inital_status
  li $a2, 10 # SET        
  li $a3, 0 # SET Y
  jal setting_position
  move $a0, $t0
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 1 # SET Y
  jal setting_position
  move $a0, $t1
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 2 # SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 3 # SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X      
  li $a3, 4 #  SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 5 # SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 6 # SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X       
  li $a3, 7 # SET Y
  jal setting_position
  move $a0, $t2
  jal writing_output
  
  li $a2, 10 # SET X      
  li $a3, 8 # SET Y
  jal setting_position
  move $a0, $t1
  jal writing_output
  
  li $a2, 15 # SET X      
  li $a3, 4 # SET Y
  sw $a2, 0 ($s7) # STORE THE INITIAL POSITION
  sw $a3, 4 ($s7) # STORE Y POSITION
  jal setting_position
  move $a0, $s6 # WRITE PLAYER
  jal writing_output
  
  li $a2, 12 # SETTING X      
  li $a3, 2 # SET Y
  sw $a2, 8($s7) # STORE THE INITIAL POSITION
  sw $a3, 12 ($s7) # STORE Y POSITION
  jal setting_position
  move $a0, $s5 # WRITE REWARD
  jal writing_output
  
  li $t7  1 # VARIABLE TO PRINT 10 20 30 
  li $t5, 5 # VERIFY THAT NEED TO PRINT/ADD 5
  li $t1, 0
  
  la $a1 point_zero
  li $a0, 0
  lb $a0, ($a1)
  sb $a0, 16($s7) # STORE A VALUE OF ZERO FOR DEFAULT
    
  # READING INPUT
  jal polling_input
  
 
load_words:
  la $t0, score_1_title #  IT CONTAINS THE FIRST LETTER    ( THE FIRST ADDRESS)
  la $t1, wall_2_line # IT CONTAINS 00
  la $t2, wall_3_line # IT CONTAINS 00
  jr $ra
  
load_controller_local:
  li $s4, 0xffff0008 # ENTER load_controller CONTROLLER
  li $s2, 0xffff0000 # ADDRESS FIRST REGISTER DATA 
  li $s0, 7 # LOAD BELL CHARACTER
  la $s5, reward_r
  la $s6, player_p
  la $s7, meme_p_position # ARRAY 4 WORD
  jr $ra
 
setting_position:
  # A0 BELL CHARACTER
  # A1 EXTRACT VALUE TO STORE AFTER COMBINE
  # A2 X POSITION
  # A3 Y POSITION
   # POSSIBLE MISTAKE IF IT IS NOT SET TO 1
   move $a0, $s0 # MOVE BALL
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
  lw $a0 0($s7) # LOAD X POSITION PLAYER
  lw $a1 4($s7)  # LOAD  Y POSITION PLAYER
  lw $a2 8($s7) # LOAD X POSITION REWARD
  lw $a3 12($s7)  # LOAD  Y POSITION REWARD

  
  
  # VERIFY THAT HAS THE SAME X AND Y
  seq $t8, $a0, $a2  #  VERIFY SAME X POSITION
  andi $t9, $t8, 1  
  beq $t9, $zero exit_collision
  
  seq $t8, $a1, $a3 # VERIFY Y POSITION  
  andi $t9, $t8, 1  # VERIFY X POSITION
  beq $t9, $zero exit_collision
  jal reward
   # PRINT A RANDOM COLLISION
  jal random_position_x_y_reward # SECOND
  j  exit_collision
  exit_collision:
  jal hit_wall # COME BACK HERE
  lw $ra 0($sp)
  addi $sp $sp, 4
  jr $ra
  
hit_wall:
  #VERIFY IF HIT WALL
  seq $t8, $a0, 10 # ENTER IN HIT THE WALL
  andi $t9, $t8, 1
  beq $t9, $zero  x_upper
  j end_game # END GAME IF HIT THE WALL 
  
  x_upper:
  seq $t8, $a0,  23 # ENTER IN HIT THE WALL
  andi $t9, $t8, 1
  beq $t9, $zero y_top
  j end_game # END GAME IF HIT THE WALL 
  
  y_top:
  seq $t8, $a1, 1 # ENTER IN HIT THE WALL
  andi $t9, $t8, 1
  beq $t9, $zero y_button
  j end_game # END GAME IF HIT THE WALL 
  
  y_button:
  seq $t8, $a1, 8 # ENTER IN HIT THE WALL
  andi $t9, $t8, 1
  beq $t9, $zero exit_hit_wall
  j end_game # END GAME IF HIT THE WALL
  
exit_hit_wall:
  jr $ra
 
random_position_x_y_reward:
  # MOVE OF 1 IF HAS THE SAME POSITION
  # RANDOM X
  addi $sp $sp, -4
  sw $ra 0($sp) 
  li	$a1, 12	# UPPER BOUND RANGE
  li	$v0, 42		
  syscall
  #ADJUST
  addi $a0, $a0, 11
  # VERIFY THAT IS NOT THE SAME POSITION
  lw $a2, 0($s7)
  seq  $t8, $a2, $a0
  and $t9, $t8, 1
  beq $t9, $zero, continue  
  j random_position_x_y_reward
  continue:  
  sw $a0, 8($s7) # STORE NEW X FOR
 
 
 
   
  # RANDOM Y
  li	$a1, 6	# upper bound of the range
  li	$v0, 42		# random int range
  syscall
  
   #ADJUST
  addi $a0, $a0, 2
  lw $a2, 0($s7)
  seq  $t8, $a2, $a0
  and $t9, $t8, 1
  beq $t9, $zero, continue_y
  j continue 
  continue_y:  
  sw $a0  12($s7)  
 
  lw $a2, 8($s7) # MOVE X       
  lw $a3, 12($s7) # MOVE Y
  jal setting_position
  
  move $a0 $s5
  jal writing_output 
  lw $ra 0($sp)
  addi $sp $sp, 4
  jr $ra


reward:
# REWARD WITH 5 POINT
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  li $a2, 16 # SET X  ENTER REWARD      
  li $a3, 0 # SET Y
  jal setting_position
  
  # li $t7  1 # VARIABLE TO PRINT 10 20 30 
  # li $t5, 5 # VERIFY THAT NEED TO PRINT/ADD 5
  # li $t1, 0

  # VERIFY IT THE PLAYER REACHED 100
   seq  $t8, $t7, 10  #  END GAME VERIFY
   andi $t9, $t8, 1
   beq $t9, $zero, print_five 
   li $t1, 7 # ENTER END GAME
   j write_100
   write_100:
     la $a1 point_zero # PRINT 100
     lb $a0, ($a1)
     add $a0, $a0, 1 # IT WILL PRINT ADDING THE VALUE IS T7
     sb $a0, 16 ($s7) # STORE THE INITIAL POSITION
     jal print_reward
     
     li $a2, 17 # SET X  ENTER REWARD FOR 0 PRINT 100
     li $a3, 0 # SET Y
     jal setting_position
     la $a1 point_zero
     lb $a0, ($a1)
     sb $a0, 20($s7) # STORE THE INITIAL POSITION
     jal print_reward 
     
     li $a2, 18 # SET X  ENTER REWARD FOR 0  PRINT 100    
     li $a3, 0 # SET Y
     jal setting_position
     la $a1 point_zero
     lb $a0, ($a1)
     sb $a0, 24($s7) # STORE THE INITIAL POSITION
     jal print_reward
     li $t7 200000
     j loop_wait_100
     loop_wait_100:
     add $t7, $t7, -1
     slt $t8, $t7 $zero
     andi $t9, $t7, 1
     beq $t8, $zero,loop_wait_100 
     jal end_game
 
  # FIRST TIME PRINT FIVE
  print_five:
    sle $t8, $t1, 0 # PIPPO FIRST REWARD
    andi $t9, $t8, 1
    beq $t9, $zero, else_10 # VERIFY THAT IS FIVE
    la $a1 point_zero
    lb $a0, ($a1)
    add $a0, $a0, 5
    sb $a0, 16($s7) # STORE THE INITIAL POSITION
    jal print_reward
    addi $t1, $t1, 1 # ADDING POINT TO PRINT 1 TO PRINT 10 ..20..30..
    j end_reward
 
  # VERIFY IF  YOU HAVE TO PRINT T7 (10, 20, 30)
  else_10:
    sle $t8, $t1, 1 # PIPPO SECOND REWARD 10
    andi $t9, $t8, 1
    beq $t9, $zero, else_15 # VERIFY THAT IS FIVE
    la $a1 point_zero
    lb $a0, ($a1)
    add $a0, $a0, $t7 # T7 IT WILL INCREMENT EXPONENTIALLY
    sb $a0, 16($s7) # STORE THE INITIAL POSITION
    jal print_reward
    
    li $a2, 17 # SET X  E
    li $a3, 0 # SET Y
    jal setting_position
    la $a1 point_zero
    lb $a0, ($a1)
    sb $a0, 20 ($s7) # STORE THE INITIAL POSITION
    jal print_reward
    addi $t1, $t1, 1 # ADDING POINT TO PRINT NOT ZERO BUT FIVE
    j end_reward
   
   # SECOND REWARD ADD 15 25 35 BECAUSE INCREASE
  else_15: 
    sle $t8, $t1, 2   # PIPPO SECOND THIRD 15 ALWAYS INCREMENT AUTOMATICALLY 1 2 3 ...
    andi $t9, $t8, 1
    beq $t9, $zero, end_reward # VERIFY THAT IS FIVE
    la $a1 point_zero
    lb $a0, ($a1)
    add $a0, $a0, $t7 # IT WILL PRINT ADDING THE VALUE IS T7
    sb $a0, 16 ($s7) # STORE THE INITIAL POSITION
    jal print_reward
    li $a2, 17 # SET X  ENTER REWARD FOR 0      
    li $a3, 0 # SET Y
    jal setting_position
    la $a1 point_zero
    lb $a0, ($a1)
    add $a0, $a0, 5
    sb $a0, 20 ($s7) # STORE THE INITIAL POSITION
    jal print_reward
    
    sub  $t1, $t1, 1 # SUBSTRACT POINT TO PRINT NOT ZERO BUT FIVE
    addi $t7, $t7, 1
   
   
   

  end_reward:
    # ADDING POINT TO PRINT 2
   lw $ra 0($sp)  # RELOAD THE ADDRESS
   addi $sp $sp 4
   jr $ra
    
print_reward:
     move $a1, $a0
     lw $a2, ($s4) # LOAD CONTROLLER STATUS
     andi $a2, $a2, 1 # VERIFY BIT READY
     beq $a2, $zero, print_reward
     sb $a1, 4($s4) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
     jr $ra
   
end_game:
   # CLEAR EVERYTHING
   # $t0 clear_window
   li $t0, 12
   move $a0 $t0
   jal clear
   
   # PRINT GAME OVER
   li $a2, 10 # SET X  ENTER REWARD FOR 0      
   li $a3, 0 # SET Y
   jal setting_position
   la $t0 game_over
   move $a0 $t0
   jal writing_output
   
   # PRINTING FINAL SCORE
   
   li $a2, 20 # SET X  ENTER REWARD FOR 0      
   li $a3, 0 # SET Y
   jal setting_position
   la $t0 final_score # PRINTING FINAL SCORE
   move $a0 $t0
   jal writing_output
   
   li $a2, 36 # SET X  ENTER REWARD FOR 0      
   li $a3, 0 # SET Y
   jal setting_position
   
   lb $a0, 16 ($s7) # PRINT FINAL SCORE
   jal print_reward
   
   
   li $a2, 37 # SET X  ENTER REWARD FOR 0      
   li $a3, 0 # SET Y
   jal setting_position
   lb $a0, 20 ($s7) #  PRINT FINAL SCORE
   jal print_reward
   
   
   li $a2, 38 # SET X  ENTER REWARD FOR 0      
   li $a3, 0 # SET Y
   jal setting_position
   lb $a0, 24 ($s7) #  PRINT FINAL SCORE
   jal print_reward
   
   move $a0 $t6
   jal writing_output
   
   # EXIT
   li $v0, 10 # END GAME
   syscall
  
  
clear:
   lw $t8, ($s4) # LOAD VERIFICATION BIT
   andi $t9, $t8, 1 # VERIFY BIT READY
   beq $t9, $zero, clear
   sw $a0, 4($s4) # BEGIN SETTING THE POSITION
   jr $ra
