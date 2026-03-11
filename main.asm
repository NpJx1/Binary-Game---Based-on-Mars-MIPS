#Main module, calls menu to start the game
.include "SysCalls.asm"
.include "menuConditional.asm"
.include "levelManager.asm"
.include "boardDisplay.asm"
.include "inputValidation.asm"
.include "soundEffects.asm"
.include "binaryToDecimal.asm"
.include "decimalToBinary.asm"

.text
.globl main

main:
    jal menuProcedure 		#Calling the menuProcedure to start the game.
    li $v0, 10			#Loading the exit syscall
    syscall			#Ends the program
