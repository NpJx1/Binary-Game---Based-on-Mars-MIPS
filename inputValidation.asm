#Handles user input validation for binary strings

.data
invalidBinMsg: .asciiz "Invalid input! Please enter exactly 8 binary digits (0s and 1s only).\n"
userInput:     .space 12          #Reserving space for user input string

.text
.globl validateBinaryInput
.globl readBinaryInput

#Reading binary input and validating it
#Returning $v0 = decimal value, $v1 = 1 if valid, 0 if invalid
readBinaryInput:
    addi $sp, $sp, -4             #Making space on stack
    sw $ra, 0($sp)                #Saving return address
    
    li $v0, 8                     #Loading syscall code for reading string
    la $a0, userInput             #Loading address to store input
    li $a1, 12                    #Setting max input length
    syscall                       #Reading input from user
    
    la $a0, userInput             #Loading input address for validation
    jal validateBinaryInput       #Calling validation routine
    
    lw $ra, 0($sp)                #Restoring return address
    addi $sp, $sp, 4              #Resetting stack
    jr $ra                        #Returning to caller


#Validating binary string and converting to decimal
#Input: $a0 = address of string
#Output: $v0 = decimal value, $v1 = 1 if valid, 0 if invalid
validateBinaryInput:
    addi $sp, $sp, -4             #Making space on stack
    sw $s0, 0($sp)                #Saving register
    
    move $t0, $a0                 #Storing string address
    li $t1, 0                     #Initializing result (decimal value)
    li $t2, 0                     #Initializing digit counter
    
validate_loop:
    lb $t3, 0($t0)                #Loading current character
    
    beq $t3, 10, validate_done    #Checking for newline
    beq $t3, 0, validate_done     #Checking for null terminator
    beq $t3, 13, validate_done    #Checking for carriage return
    
    li $t4, 48                    #ASCII for '0'
    beq $t3, $t4, valid_zero      #Branching if character is '0'
    
    li $t4, 49                    #ASCII for '1'
    beq $t3, $t4, valid_one       #Branching if character is '1'
    
    li $v0, 0                     #Marking input as invalid
    li $v1, 0
    lw $s0, 0($sp)                #Restoring register
    addi $sp, $sp, 4
    jr $ra                        #Returning since invalid
    
valid_zero:
    sll $t1, $t1, 1               #Shifting result left (multiply by 2)
    addi $t2, $t2, 1              #Increasing digit count
    addi $t0, $t0, 1              #Moving to next character
    j validate_loop               #Continuing loop
    
valid_one:
    sll $t1, $t1, 1               #Shifting left
    addi $t1, $t1, 1              #Adding 1 to result
    addi $t2, $t2, 1              #Increasing digit count
    addi $t0, $t0, 1              #Moving to next character
    j validate_loop               #Continuing loop
    
validate_done:
    li $t4, 8                     #Checking if exactly 8 digits
    bne $t2, $t4, validate_invalid
    
    move $v0, $t1                 #Storing decimal result
    li $v1, 1                     #Marking as valid
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra                        #Returning to caller
    
validate_invalid:
    li $v0, 0                     #Returning 0 for invalid input
    li $v1, 0
    lw $s0, 0($sp)
    addi $sp, $sp, 4
    jr $ra                        #Returning to caller


#Displaying invalid binary input message
.globl displayInvalidBinaryMsg
displayInvalidBinaryMsg:
    addi $sp, $sp, -4             #Making space on stack
    sw $ra, 0($sp)                #Saving return address
    
    li $v0, 4                     #Loading syscall for print string
    la $a0, invalidBinMsg         #Loading invalid input message
    syscall                       #Printing message
    
    lw $ra, 0($sp)                #Restoring return address
    addi $sp, $sp, 4              #Resetting stack
    jr $ra                        #Returning to caller
