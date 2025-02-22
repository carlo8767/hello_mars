.data
  myArray: .space 12 # THIS IS JUST AN ADDRESS AND I CAN OVERRIDE
  heap_begin_address: .word 0
  
.text
  addi $s0, $zero, 4
  addi $s1, $zero, 10
  addi $s3, $zero, 12
  addi $t0, $zero, 0 # INDEX
  sw $s0, myArray($t0)
  addi $t0, $zero, 4 # INDEX
  sw $s1, myArray($t0)
  addi $t0, $zero, 8 # INDEX
  sw $s3, myArray($t0)
  
  
  
  addi $t0, $zero, 4 # INDEX
  li $a0, 8# CREATE A SPACE OF 4 BYTE IN THE REGISTER SBRK
  li $v0, 9 # ALLOCATE THE HEAP
  syscall
  move $v0 $s5
  addi $t0, $zero, 4 # INDEX
  sw $t0, 0($s5) # ALWAYS 4
  addi $t0, $zero, 8 # INDEX
  sw $t0, ($s5) # ALWAYS 4
  lw $t0, 4($s5) # LOAD WORD
  
  
  addi $t0, $zero, 12 # INDEX
  sw $s3, myArray($t0)
  
  
  
  
  
  
  