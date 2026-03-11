#Converts from binary to decimal.
.data
promptBD:      .asciiz "Enter the decimal equivalent: "
correctMsg:    .asciiz "\n[v] Correct!\n"
wrongMsg:      .asciiz "\n[x] Wrong! The correct answer was: "
livesMsg:      .asciiz "\n[*] Lives remaining: "
gameOverLives: .asciiz "\n\n+============================================+\n|                                            			\n|  GAME OVER - No lives remaining!           			\n|                                            			\n+============================================+\n"


.text
.globl binaryToDecimal

binaryToDecimal:
    #Saving registers
    addi $sp, $sp, -28
    sw $ra, 24($sp)
    sw $s0, 20($sp)  #Stores current level (1-10)
    sw $s1, 16($sp)  #Stores total score
    sw $s2, 12($sp)  #Stores total questions
    sw $s3, 8($sp)   #Stores current question in level
    sw $s4, 4($sp)   #Stores lives remaining
    sw $s6, 0($sp)   #Stores random number storage
    
    li $s0, 1        #Starts at level 1
    li $s1, 0        #Starts at score = 0
    li $s2, 0        #Total questions = 0
    li $s4, 3        #Starts with 3 lives
    
bd_levelLoop:
    #Checking if out of lives
    blez $s4, bd_gameOverNoLives
    
    #Checking if completed all 10 levels
    li $t0, 10
    bgt $s0, $t0, bd_gameOver
    
    #Displayinging the level header
    move $a0, $s0
    jal displayLevel
    
    #Calculating number of bits to use 
    move $t0, $s0        #Level number
    li $t1, 1            #Starts with 1
    li $t2, 0            #Counter/Index
bd_calcMax:
    beq $t2, $t0, bd_maxDone
    sll $t1, $t1, 1      #Multiplying by 2
    addi $t2, $t2, 1
    j bd_calcMax
bd_maxDone:
    move $s5, $t1        #Saving max value for this level
    
    # Number of questions = current level
    li $s3, 1        #Starts at question 1
    
bd_questionLoop:
    #Checking if out of lives
    blez $s4, bd_gameOverNoLives
    
    #Checking if completed all questions for this level
    bgt $s3, $s0, bd_levelComplete
    
    #Displayinging question number
    move $a0, $s3
    move $a1, $s0
    jal displayQuestion
    
    #Generating random binary number based on level
    li $v0, 42       #Random int range
    li $a0, 1        #Generator ID
    move $a1, $s5    #Upper bound
    syscall
    move $s6, $a0    #Saving the random number in $s6
    
    #Displaying binary board
    move $a0, $s6    #Use saved value
    jal drawBinaryBoard
    
    #Prompting user for decimal
    li $v0, 4
    la $a0, promptBD
    syscall
    
    #Getting user input
    li $v0, 5
    syscall
    move $t1, $v0      #Stores user answer
    
    #Increases total questions
    addi $s2, $s2, 1
    
    #Checking answer (comparing with saved random number)
    beq $s6, $t1, bd_correct
    
    #Wrong answer; will play a sound and lose a life
    jal playWrongSound
    addi $s4, $s4, -1
    
    li $v0, 4
    la $a0, wrongMsg
    syscall
    
    li $v0, 1
    move $a0, $s6    #Printing the correct answer from saved register
    syscall
    
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
    j bd_questionLoop
    
bd_correct:
    #Increases score
    addi $s1, $s1, 1
    
    #Playing correct sound
    jal playCorrectSound
    
    li $v0, 4
    la $a0, correctMsg
    syscall
    
    #Next question
    addi $s3, $s3, 1
    j bd_questionLoop
    
bd_levelComplete:
    #Playing level up sound
    jal playLevelUpSound
    
    #Displaying level score
    move $a0, $s1
    move $a1, $s2
    jal displayLevelScore
    
    #Next level
    addi $s0, $s0, 1
    j bd_levelLoop

bd_gameOverNoLives:
    #Playing game over sound
    jal playGameOverSound
    
    #Displaying game over message for running out of lives
    li $v0, 4
    la $a0, gameOverLives
    syscall
    
    #Displaying final score
    move $a0, $s1
    move $a1, $s2
    jal displayFinalScore
    
    #Restoring registers
    lw $s6, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra
    
bd_gameOver:
    #Playing game over sound (completed all levels)
    jal playGameOverSound
    
    #Displaying final score (completed all levels)
    move $a0, $s1
    move $a1, $s2
    jal displayFinalScore
    
    #Restore registers
    lw $s6, 0($sp)
    lw $s4, 4($sp)
    lw $s3, 8($sp)
    lw $s2, 12($sp)
    lw $s1, 16($sp)
    lw $s0, 20($sp)
    lw $ra, 24($sp)
    addi $sp, $sp, 28
    jr $ra
