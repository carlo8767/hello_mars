.text

jal hello

hello:
    addi $sp, $sp, -4   # Allocate stack space
    sw $ra, 0($sp)      # Save return address
    jal another         # Jump to 'another'
    
    lw $ra, 0($sp)      # Restore return address
    addi $sp, $sp, 4    # Deallocate stack space
    jr $ra              # Return to caller

another:
    addi $sp, $sp, -4   # Allocate 4 bytes for $a0
    sw $ra, 0($sp)      # Save $a0 correctly we DE NOT NEED OFFSET
    lw $ra, 0($sp)      # ADDING OFFSET OF 4 TO RECOVER THE HELLO STACK
    addi $sp, $sp, 4    # START FROM THE BUTTON
    jr $ra              # Return to caller
