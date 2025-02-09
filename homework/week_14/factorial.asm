.data
.text

addi $s0, $s0, 5
addi $a1, $a1, 1
move $a0, $s0
jal factorial
move $v0, $a0 # MOVE THE VALUE AND PRINT 
addi $v0, $zero, 1
syscall
addi  $v0, $zero, 10
syscall

factorial: 
 addi $sp, $sp, -4
 sw $ra, 0($sp) # STORE THE ADDRESS FOR THE RETURN
 slt    $t0, $a0, $a1 # VERIFY THAT THE NUMBER IS NOT LESS THE TARGET
 beq $t0, $zero else # IF $T0 IS ZERO TRUE OR IS FALSE
 jal exit
 
 else:
   sub  $a0, $a0, 1 # SUBSTRACT THE NEXT TERM
   mul $v1, $s0, $a0 # MULTIPLY FACTOR
   add $v0, $v0, $v1 # ADDD THE PREVIOUS RESULT
   jal factorial

 exit:
   lw $ra, 0($sp)
   add $sp, $sp, 4
   jr $ra
 
