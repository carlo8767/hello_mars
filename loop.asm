.data
.text


 
# SENTINEL CONTROL LOOP
  add $a1, $zero, 0 # SET TARGET
  add $a0, $zero, 12
  
  sentinel_loop:
  add $a0, $a0, -1
  sle  $t0, $a0, $a1  # TEST IF A0 < A1 -> 0 IS TRUE 1 IS FALSE
  beq $t0, $zero, else # VERIFY RESULT CONDITION IF 0 JUMP TO ELSE
  jal exit # CONDITION TRUE
  
  else:
   jal sentinel_loop # CALL ANOTHER TIME THE FUNCTION
  
  exit:
   li $v0, 1 # EXIT
   syscall
    
 
# COUNTER CONTRO LOOP

 
