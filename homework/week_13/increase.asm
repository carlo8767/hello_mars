.data
  array: .data 16 # ARRAY THAT CAN STORE 4 WORD
.text
  add $t1, $t1, $zero # TARGET INDEX
  la $t2, 	array  # LOAD ADDRESS ARRAY LABEL IN T0
  
  
  jal size
  
  size:
  add $a3, $a3, 4 # COUNT THE SIZE
  sle $t0, $t2 ,$t1
  beq $t0, $zero else
  jal exit
  
  else:
    sub $t2, $t2, 4
    jal size
  exit:
    addi $v0, $zero, 10
    syscall
  
 
  
  
  
   
