.text
   lw  $a1, x # load values
   lw $a2, y # load values
   addi $a3,  $zero 5 # target
   jal sum_recursive
   addi $sp, $sp, -8 # allocate stack 
   sw $ra, 0($sp) # store the address 
   sle  $t0, $a3, $v0 # test if v0 less than target
   beq $t0, $zero, else # verify the result
   
   jal endIf # endIf
    
   else:
    add $a1, $a1, 1 # addition plus 1
    add $a2, $a2, 1 # addition plus 1
    jal sum_recursive
    lw $ra, ($sp) # upload address come back line  to the if
    jr $ra # jump and return
      
   endIf:
   add $a0, $a1, $a2 # print the sum
   addi $v0, $zero, 1 # exit recursive
   syscall 
   addi $v0, $zero, 10 # exit recursive
   syscall 
   
   sum_recursive: 
   add $v0, $a1, $a2 # addition
   jr  $ra
   
   
.data
x: .word 1
y: .word 2
  



