#Handles level display, question display, and score updates

.data
levelMsg1:     .asciiz "\n\n\n+============================================+\n"
levelMsg2:     .asciiz "|            LEVEL "
levelMsg3:     .asciiz " of 10               			\n"
levelMsg4:     .asciiz "+============================================+\n"

questionMsg1:  .asciiz "\n+------------------------------------------+\n"
questionMsg2:  .asciiz "|  Question "
questionMsg3:  .asciiz " of "
questionMsg4:  .asciiz "                         	\n"
questionMsg5:  .asciiz "+------------------------------------------+\n"

scoreMsg1:     .asciiz "\n\n+============================================+\n"
scoreMsg2:     .asciiz "|                                            			\n"
scoreMsg3:     .asciiz "|          LEVEL COMPLETE!                   			\n"
scoreMsg4:     .asciiz "|                                            			\n"
scoreMsg5:     .asciiz "+============================================+\n"
currentScore:  .asciiz "|  Current Score: "
scoreSlash:    .asciiz " / "
scorePad:      .asciiz "                         			\n"

gameOverMsg1:  .asciiz "\n\n+============================================+\n"
gameOverMsg2:  .asciiz "|                                            			\n"
gameOverMsg3:  .asciiz "|          GAME COMPLETE!                    			\n"
gameOverMsg4:  .asciiz "|                                            			\n"
gameOverMsg5:  .asciiz "+============================================+\n"
finalScore:    .asciiz "|  Final Score: "
finalPad:      .asciiz "                           			\n"
gameOverMsg6:  .asciiz "+============================================+\n"

newline:       .asciiz "\n"
pressEnter:    .asciiz "|  Press Enter to continue...                			\n"
pressEnter2:   .asciiz "+============================================+\n"
enterBuffer:   .space 4

.text
.globl displayLevel
.globl displayQuestion
.globl displayLevelScore
.globl displayFinalScore

#Displaying the level header
#input: $a0 = current level number
displayLevel:
    addi $sp, $sp, -8             #Making space on stack
    sw $ra, 4($sp)                #Saving return address
    sw $s0, 0($sp)                #Saving register
    
    move $s0, $a0                 #Moving level number into $s0
    
    li $v0, 4                     #Printing top border
    la $a0, levelMsg1
    syscall
    
    la $a0, levelMsg2             #Printing 'LEVEL '
    syscall
    
    li $v0, 1                     #Printing current level number
    move $a0, $s0
    syscall
    
    li $v0, 4                     #Orinting ' of 10'
    la $a0, levelMsg3
    syscall
    
    la $a0, levelMsg4             #Printing bottom border
    syscall
    
    lw $s0, 0($sp)                #Restoring register
    lw $ra, 4($sp)                #Restoring return address
    addi $sp, $sp, 8              #Resetting stack
    jr $ra                        #Returning to caller


#Displaying question info
#input: $a0 = current question, $a1 = total questions
displayQuestion:
    addi $sp, $sp, -12            #Making space on stack
    sw $ra, 8($sp)                #Saving return address
    sw $s0, 4($sp)                #Saving current question
    sw $s1, 0($sp)                #Saving total questions
    
    move $s0, $a0                 #Moving current question into $s0
    move $s1, $a1                 #Moving total questions into $s1
    
    li $v0, 4                     #Printing top border
    la $a0, questionMsg1
    syscall
    
    la $a0, questionMsg2          #Printing 'Question '
    syscall
    
    li $v0, 1                     #Printing current question number
    move $a0, $s0
    syscall
    
    li $v0, 4                     #Printing ' of '
    la $a0, questionMsg3
    syscall
    
    li $v0, 1                     #Printing total number of questions
    move $a0, $s1
    syscall
    
    li $v0, 4                     #Finishing question line
    la $a0, questionMsg4
    syscall
    
    la $a0, questionMsg5          #Printing bottom border
    syscall
    
    lw $s1, 0($sp)                #Restoring $s1
    lw $s0, 4($sp)                #Restoring $s0
    lw $ra, 8($sp)                #Restoring $ra
    addi $sp, $sp, 12             #Resetting stack
    jr $ra


#Displaying score after a level is completed
#input: $a0 = correct answers, $a1 = total questions
displayLevelScore:
    addi $sp, $sp, -12            #Making space on stack
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    move $s0, $a0                 #storing correct answers
    move $s1, $a1                 #storing total questions
    
    li $v0, 4                     #Printing level complete box
    la $a0, scoreMsg1
    syscall
    la $a0, scoreMsg2
    syscall
    la $a0, scoreMsg3
    syscall
    la $a0, scoreMsg4
    syscall
    la $a0, scoreMsg5
    syscall
    
    la $a0, currentScore          #Printing score label
    syscall
    
    li $v0, 1                     #Printing correct answers
    move $a0, $s0
    syscall
    
    li $v0, 4                     #Printing '/'
    la $a0, scoreSlash
    syscall
    
    li $v0, 1                     #Printing total questions
    move $a0, $s1
    syscall
    
    li $v0, 4                     #Printing padding line
    la $a0, scorePad
    syscall
    
    la $a0, pressEnter            #Showing 'press enter' message
    syscall
    la $a0, pressEnter2
    syscall
    
    li $v0, 8                     #Waiting for user to press Enter
    la $a0, enterBuffer
    li $a1, 4
    syscall
    
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra


#Displaying the final game over score
#Same as before, input: $a0 = total correct answers,and $a1 = total questions
displayFinalScore:
    addi $sp, $sp, -12            #Making space on stack
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    move $s0, $a0                 #storing total correct
    move $s1, $a1                 #storing total questions
    
    li $v0, 4                     #Printing top border
    la $a0, gameOverMsg1
    syscall
    la $a0, gameOverMsg2
    syscall
    la $a0, gameOverMsg3          #Printing title
    syscall
    la $a0, gameOverMsg4
    syscall
    la $a0, gameOverMsg5
    syscall
    
    la $a0, finalScore            #Printing 'Final Score: '
    syscall
    
    li $v0, 1                     #Printing total correct
    move $a0, $s0
    syscall
    
    li $v0, 4                     #Printing '/'
    la $a0, scoreSlash
    syscall
    
    li $v0, 1                     #Printing total questions
    move $a0, $s1
    syscall
    
    li $v0, 4                     #Printing padding line
    la $a0, finalPad
    syscall
    
    la $a0, gameOverMsg6          #Printing bottom border
    syscall
    
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra
