.data

zero: .byte  53  # ASCII representation of 0
five: .byte 53
multiply: .byte 3


.text

jal load_controller_local


la $t0, zero
lb $t1, ($t0)
la $t3, multiply
lb $t4, ($t3)
mul $t2, $t4, $t1
move $a0, $t2

jal writing_output


 
writing_output:
  # A0 ADDRESS YOU WANT PRINT
  # A1 EXTRACT VALUE TO STORE
  # A3 VERIFY NULL CHARACTER
  add $a3, $zero, 1 # ENTER IN WRITING
  addi $sp, $sp, -4 # ENTER WALL X CONTROLLER
  sw $ra, 0($sp) #  SAVE THE ADDRESS IN THE STACK
  move $a1, $a0
   drawing_begin:
     lw $a2, ($s4) # LOAD CONTROLLER STATUS
     andi $a2, $a2, 1 # VERIFY BIT READY
     beq $a2, $zero, drawing_begin
     sb $a1, 4($s4) # BEGIN WRITING STORE VALUE IN DATA CONTROLLER
     lw $ra, 0($sp) #  LOAD FROM THE BUTTON
     addi $sp, $sp, 4 # RETURN AT DRAWING
     add $t4, $t4, 1
     jr $ra
  end_drawing:
    lw $ra, 4($sp) #  LOAD THE ADDRESS WRITING OUTPUT
    addi $sp, $sp, 8 # REMOVE STACK
    jr $ra  # END WRITING OUTPUT 








# Load Controller Routine
load_controller_local:
  li $s4, 0xffff0008 # Controller address
  li $s2, 0xffff0000 # First register data address
  jr $ra             # Return
