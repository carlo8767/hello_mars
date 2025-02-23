.text
    li $t0, 0xFFFF0008  # Transmitter Control Register
    li $t1, 0xFFFF000C  # Transmitter Data Register

    li $t2, 20          # X position (column)
    sll $t2, $t2, 20    # Shift X left by 20 bits

    li $t3, 10          # Y position (row)
    sll $t3, $t3, 8     # Shift Y left by 8 bits

    li $t4, 7           # ASCII 7 (Bell character)

    or $t5, $t2, $t3    # Combine X and Y positions
    or $t5, $t5, $t4    # Combine with ASCII Bell

wait:
    lw $t6, 0($t0)      # Load transmitter control register
    andi $t6, $t6, 1    # Check if transmitter is ready (bit 0 = 1)
    beqz $t6, wait      # If not ready, wait

    sw $t5, 0($t1)      # Store word to Transmitter Data Register

    li $v0, 10          # Exit
    syscall
