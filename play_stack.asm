.text

jal hello

jal hello


hello:
    addi $sp, $sp, -4   # Allocate stack space
    sw $ra, ($sp)      # Save return address
    jal another         # Jump to 'another'
    lw $ra, ($sp)      # Restore return address
    addi $sp, $sp, 4    # Deallocate stack space
    jr $ra              # Return to caller

another:
    addi $sp, $sp, -4   # Allocate 4 bytes for $a0
    sw $ra, ($sp)      # Save $a0 correctly we DE NOT NEED OFFSET
    lw $ra, ($sp)      # ADDING OFFSET OF 4 TO RECOVER THE HELLO STACK
    sw $zero ($sp)
    addi $sp, $sp, 4    # START FROM THE BUTTON
    jr $ra              # Return to caller
