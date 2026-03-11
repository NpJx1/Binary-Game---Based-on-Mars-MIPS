#Converts from decimal to binary
.data
promptDB:      .asciiz "Enter the 8-bit binary equivalent: "


.text
.globl decimalToBinary

decimalToBinary:
    addi $sp, $sp, -28 #Saving registers
    sw $ra, 24($sp)
    sw $s0, 20($sp)  #Storing current level (1-10)
    sw $s1, 16($sp)  #Storing total score
    sw $s2, 12($sp)  #Storing total questions
    sw $s3, 8($sp)   #Storing current question in level
    sw $s4, 4($sp)   #Storing lives remaining
    sw $s6, 0($sp)   #Storing the random number storage
    
    li $s0, 1        #Starts at level 1
    li $s1, 0        #Starts with Score = 0
    li $s2, 0        #Starts with Total questions = 0
    li $s4, 3        #Starts with 3 lives
    
db_levelLoop:
    blez $s4, db_gameOverNoLives #Checking if user is out of lives
    
    li $t0, 10 #Checking if all 10 levels are completed 
    bgt $s0, $t0, db_gameOver
    
    
    move $a0, $s0 #Displaying level header
    jal displayLevel
    
    #Calculating number of bits to use (is capped at 8 bits, highest decimal number is 256)
    move $t0, $s0        #Storing level number in a temp register
    li $t1, 1            #Starts with 1
    li $t2, 0            #Counter/Index
db_calcMax:
    beq $t2, $t0, db_maxDone
    sll $t1, $t1, 1      #Multiplying by 2
    addi $t2, $t2, 1
    j db_calcMax
db_maxDone:
    #Capping at 256 (so max random is 255)
    li $t3, 256
    ble $t1, $t3, db_noCapNeeded
    li $t1, 256          #Caps at 256
db_noCapNeeded:
    move $s5, $t1        #Saves max value for this level
    
    #Number of questions and current level
    li $s3, 1        #Starts at question 1
    
db_questionLoop:

    blez $s4, db_gameOverNoLives     #Checking if user is out of lives
    
    
    bgt $s3, $s0, db_levelComplete   #Checking if completed all questions for this level
    
    #Displaying question number
    move $a0, $s3
    move $a1, $s0
    jal displayQuestion
    
    #Generating random decimal number based on level
    li $v0, 42       #Random int range
    li $a0, 1        #Generator ID
    move $a1, $s5    #Upper bound is capped at 256
    syscall
    move $s6, $a0    #Saves the random number in $s6
    
    #Displaying decimal board
    move $a0, $s6    # Use saved value
    jal drawDecimalBoard
    
db_getInput:
    #Prompting user for binary input
    li $v0, 4
    la $a0, promptDB
    syscall
    
    #Reading and validating binary input
    jal readBinaryInput
    move $t1, $v0      #Stores user's decimal value
    move $t2, $v1      #Validation checker (0=invalid, 1=valid)
    
    #Checking if input was valid
    beqz $t2, db_invalidInput
    
    #Increases total questions
    addi $s2, $s2, 1
    
    #Checking answer (compares with saved random number)
    beq $s6, $t1, db_correct
    
    #Wrong answer; will play a sound and lose a life
    jal playWrongSound
    addi $s4, $s4, -1
    
    #Displaying correct binary answer
    li $v0, 4
    la $a0, wrongMsg
    syscall
    
    #Printing correct binary using saved value
    move $t3, $s6    #Uses saved random number
    li $t4, 7
db_printCorrect:
    li $t5, 1
    sllv $t5, $t5, $t4
    and $t6, $t3, $t5
    beqz $t6, db_print0
    li $v0, 1
    li $a0, 1
    syscall
    j db_printNext
db_print0:
    li $v0, 1
    li $a0, 0
    syscall
db_printNext:
    addi $t4, $t4, -1
    bgez $t4, db_printCorrect
    
    li $v0, 4
    la $a0, newline
    syscall
    
    #Displaying remaining lives
    la $a0, livesMsg
    syscall
    
    li $v0, 1
    move $a0, $s4
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    #Next question
    addi $s3, $s3, 1
    j db_questionLoop
    
db_invalidInput:
    jal displayInvalidBinaryMsg
    j db_getInput
    
db_correct:
    #Increment score
    addi $s1, $s1, 1
    
    # Play correct sound
    jal playCorrectSound
    
    li $v0, 4
    la $a0, correctMsg
    syscall
    
    # Next question
    addi $s3, $s3, 1
    j db_questionLoop
    
db_levelComplete:
    # Play level up sound
    jal playLevelUpSound
    
    # Display level score
    move $a0, $s1
    move $a1, $s2
    jal displayLevelScore
    
    # Next level
    addi $s0, $s0, 1
    j db_levelLoop

db_gameOverNoLives:
    # Play game over sound
    jal playGameOverSound
    
    # Display game over message for running out of lives
    li $v0, 4
    la $a0, gameOverLives
    syscall
    
    # Display final score
    move $a0, $s1
    move $a1, $s2
    jal displayFinalScore
    
    # Restore registers
    lw $s6, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra
    
db_gameOver:
    # Play game over sound (completed all levels)
    jal playGameOverSound
    
    # Display final score (completed all levels)
    move $a0, $s1
    move $a1, $s2
    jal displayFinalScore
    
    # Restore registers
    lw $s6, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra
