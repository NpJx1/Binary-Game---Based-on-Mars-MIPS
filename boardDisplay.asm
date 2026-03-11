#Draws ASCII game boards for both modes

.data
pipe:          .asciiz " | "
boxEmpty:      .asciiz "   "
boxEnd:        .asciiz " "
separator:     .asciiz "+----+----+----+----+----+----+----+----+----+\n"
leftBracket:   .asciiz " ["
rightBracket:  .asciiz "] "

.text
.globl drawBinaryBoard
.globl drawDecimalBoard

#Drawing board for Binary ? Decimal mode
#Input: $a0 = 8-bit number to display in binary
drawBinaryBoard:
    addi $sp, $sp, -8             #Making space on stack
    sw $ra, 4($sp)                #Saving return address
    sw $s0, 0($sp)                #Saving register

    move $s0, $a0                 #Storing number to display

    li $v0, 4                     #Printing top separator
    la $a0, separator
    syscall

    la $a0, pipe                  #Printing starting pipe
    syscall

    li $t0, 7                     #Setting bit position counter to 7 (MSB)

drawBinary_loop:
    li $t1, 1                     #Setting up bitmask = 1
    sllv $t1, $t1, $t0            #Shifting bitmask left by $t0 positions
    and $t2, $s0, $t1             #Isolating that specific bit

    beqz $t2, drawBinary_zero     #Branching if bit is 0

    li $v0, 1                     #Printing '1'
    li $a0, 1
    syscall
    j drawBinary_next

drawBinary_zero:
    li $v0, 1                     #Printing '0'
    li $a0, 0
    syscall

drawBinary_next:
    li $v0, 4                     #Printing separator between bits
    la $a0, pipe
    syscall

    addi $t0, $t0, -1             #Moving to next bit (right)
    bgez $t0, drawBinary_loop     #Repeating until all bits printed

    li $v0, 4                     #Printing newline
    la $a0, newline
    syscall

    la $a0, separator             #Printing bottom separator
    syscall

    lw $s0, 0($sp)                #Restoring $s0
    lw $ra, 4($sp)                #Restoring $ra
    addi $sp, $sp, 8              #Resetting stack
    jr $ra                        #Returning to caller


#Drawing board for Decimal ? Binary mode
#Input: $a0 = decimal number to display
drawDecimalBoard:
    addi $sp, $sp, -8             #Making space on stack
    sw $ra, 4($sp)                #Saving return address
    sw $s0, 0($sp)                #Saving decimal value

    move $s0, $a0                 #Storing decimal number

    li $v0, 4                     #Printing top separator
    la $a0, separator
    syscall

    la $a0, pipe                  #Printing starting pipe
    syscall

    li $t0, 0                     #Initializing counter for 8 boxes

drawDecimal_loop:
    li $v0, 4                     #Printing empty box
    la $a0, boxEmpty
    syscall

    la $a0, pipe                  #Printing separator after each box
    syscall

    addi $t0, $t0, 1              #Increasing counter
    blt $t0, 8, drawDecimal_loop  #Looping until 8 boxes are printed

    li $v0, 4                     #Printing left bracket
    la $a0, leftBracket
    syscall

    li $v0, 1                     #Printing decimal number
    move $a0, $s0
    syscall

    li $v0, 4                     #Printing right bracket
    la $a0, rightBracket
    syscall

    la $a0, pipe                  #Printing end pipe
    syscall

    la $a0, newline               #Printing newline
    syscall

    la $a0, separator             #Printing bottom separator
    syscall

    lw $s0, 0($sp)                #Restoring $s0
    lw $ra, 4($sp)                #Restoring $ra
    addi $sp, $sp, 8              #Resetting stack
    jr $ra                        #Returning to caller
