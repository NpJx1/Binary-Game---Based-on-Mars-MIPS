#Handles all sound effects for the game using MIDI syscalls

.data
correctPitch:   .word 72      #C5 pitch for correct answer
wrongPitch:     .word 60      #C4 pitch for wrong answer
levelUpPitch:   .word 76      #E5 pitch for level up
gameOverPitch:  .word 48      #C3 pitch for game over

duration:       .word 300     #Sound duration in ms
instrument:     .word 0       #Piano instrument
volume:         .word 100     #Volume level (0–127)

.text
.globl playCorrectSound
.globl playWrongSound
.globl playLevelUpSound
.globl playGameOverSound

#Playing sound for correct answer
playCorrectSound:
    addi $sp, $sp, -4         #Making space on stack
    sw $ra, 0($sp)            #Saving return address

    li $v0, 31                #Setting syscall for MIDI out
    li $a0, 67                #G4 tone
    li $a1, 150               #Duration
    li $a2, 0                 #Piano instrument
    li $a3, 100               #Volume
    syscall                   #Playing first tone

    li $v0, 31
    li $a0, 72                #C5 tone
    li $a1, 150
    li $a2, 0
    li $a3, 100
    syscall                   #Playing second tone

    li $v0, 31
    li $a0, 76                #E5 tone
    li $a1, 200
    li $a2, 0
    li $a3, 100
    syscall                   #Playing final rising tone

    lw $ra, 0($sp)            #Restoring return address
    addi $sp, $sp, 4          #Resetting stack
    jr $ra                    #Returning


#Playing sound for wrong answer
playWrongSound:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 31
    li $a0, 64                #E4 tone
    li $a1, 150
    li $a2, 0
    li $a3, 100
    syscall                   #Playing first low tone

    li $v0, 31
    li $a0, 60                #C4 tone
    li $a1, 150
    li $a2, 0
    li $a3, 100
    syscall                   #Playing second lower tone

    li $v0, 31
    li $a0, 57                #A3 tone
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall                   #Finishing with deepest tone

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


#Playing sound for level completion
playLevelUpSound:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 31
    li $a0, 60                #C4 tone
    li $a1, 100
    li $a2, 0
    li $a3, 100
    syscall

    li $v0, 31
    li $a0, 64                #E4 tone
    li $a1, 100
    li $a2, 0
    li $a3, 100
    syscall

    li $v0, 31
    li $a0, 67                #G4 tone
    li $a1, 100
    li $a2, 0
    li $a3, 100
    syscall

    li $v0, 31
    li $a0, 72                #C5 tone
    li $a1, 300
    li $a2, 0
    li $a3, 100
    syscall                   #Ending with a bright high note

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


#Playing sound for game over
playGameOverSound:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 31
    li $a0, 72                #C5 tone
    li $a1, 200
    li $a2, 0
    li $a3, 100
    syscall                   #Starting high tone

    li $v0, 31
    li $a0, 67                #G4 tone
    li $a1, 200
    li $a2, 0
    li $a3, 100
    syscall

    li $v0, 31
    li $a0, 64                #E4 tone
    li $a1, 200
    li $a2, 0
    li $a3, 100
    syscall

    li $v0, 31
    li $a0, 60                #C4 tone
    li $a1, 500
    li $a2, 0
    li $a3, 100
    syscall                   #Ending with long deep note

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
