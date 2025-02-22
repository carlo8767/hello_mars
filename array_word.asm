
.data
myArray: .space 12 #12 bytes for 3 integers
multidimensio: .word 35
.text


la $a0, multidimensio


addi $s0, $zero, 4
addi $s1, $zero, 10
addi $s2, $zero, 12
addi $t0, $zero, 0 #index = $t0
sw $s0, myArray($t0) #Store contents of s0 in first position of array
addi $t0, $t0, 4 #increment the index by 4
sw $s1, myArray($t0) #Store contents of s2 in second position of array
addi $t0, $t0, 4 #increment the index by 4
sw $s2, myArray($t0) #Store the contents of s3 in third location of array
lw $t6, myArray($zero) #load the word in the first location of myArray into $t6
li $v0, 1
addi $a0, $t6, 0 #Print the value of t6
syscall