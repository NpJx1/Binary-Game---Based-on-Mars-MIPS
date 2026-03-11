#Main menu file,links to the 2 modes of the games, exit call is here.
.data

menu1:   .asciiz "\n\n+============================================+\n"
menu2:   .asciiz "|                                            			\n"
menu3:   .asciiz "|       WELCOME TO THE BINARY GAME!          		\n"
menu4:   .asciiz "|                                            			\n"
menu5:   .asciiz "+============================================+\n"
menu6:   .asciiz "|                                            			\n"
menu7:   .asciiz "|  Select Mode:                              			\n"
menu8:   .asciiz "|                                            			\n"
menu9:   .asciiz "|   1) Binary to Decimal                     			\n"
menu10:  .asciiz "|   2) Decimal to Binary                     			\n"
menu11:  .asciiz "|   3) Exit                                  			\n"
menu12:  .asciiz "|                                            			\n"
menu13:  .asciiz "+============================================+\n"
menuPrompt: .asciiz "Enter choice: "



invalid:        .asciiz "\n[!] Invalid choice! Please enter 1, 2, or 3.\n"

displayMode1msg1: .asciiz "\n+============================================+\n"
displayMode1msg2: .asciiz "|                                            			 \n"
displayMode1msg3: .asciiz "|        BINARY TO DECIMAL MODE             			 \n"
displayMode1msg4: .asciiz "|                                           			 \n"
displayMode1msg5: .asciiz "+============================================+\n"

displayMode2msg1: .asciiz "\n+============================================+\n"
displayMode2msg2: .asciiz "|                                            			\n"
displayMode2msg3: .asciiz "|        DECIMAL TO BINARY MODE              			\n"
displayMode2msg4: .asciiz "|                                           			\n"
displayMode2msg5: .asciiz "+============================================+\n"

exitMsg1:       .asciiz "\n+============================================+\n"
exitMsg2:       .asciiz "|                                            			\n"
exitMsg3:       .asciiz "|        THANK YOU FOR PLAYING!              			\n"
exitMsg4:       .asciiz "|                                            			\n"
exitMsg5:       .asciiz "+============================================+\n\n"

.text
.globl menuProcedure

menuProcedure:
    addi $sp, $sp, -4           #Pushing return address space on stack
    sw $ra, 0($sp)              #Saving return address

    li $v0, 30                  #Getting current time
    syscall
    move $a1, $a0               #Moving time into $a1 (seed)
    li $a0, 1                   #Setting generator ID
    li $v0, 40                  #Setting seed syscall
    syscall

menuLoop:
    li $v0, 4                   #Printing each line of the menu
    la $a0, menu1
    syscall
    la $a0, menu2
    syscall
    la $a0, menu3
    syscall
    la $a0, menu4
    syscall
    la $a0, menu5
    syscall
    la $a0, menu6
    syscall
    la $a0, menu7
    syscall
    la $a0, menu8
    syscall
    la $a0, menu9
    syscall
    la $a0, menu10
    syscall
    la $a0, menu11
    syscall
    la $a0, menu12
    syscall
    la $a0, menu13
    syscall

    la $a0, menuPrompt          #Printing the menu prompt
    syscall

    li $v0, 5                   #Reading user input (int)
    syscall
    move $t0, $v0               #Storing user's choice

    beq $t0, 1, BinaryMode      #Branching if choice is 1
    beq $t0, 2, DecimalMode     #Branching if choice is 2
    beq $t0, 3, Exit            #Branching if choice is 3

    li $v0, 4                   #Printing invalid message
    la $a0, invalid
    syscall
    j menuLoop                  #Going back to the menu

BinaryMode:
    li $v0, 4                   #Printing binary to decimal header
    la $a0, displayMode1msg1
    syscall
    la $a0, displayMode1msg2
    syscall
    la $a0, displayMode1msg3
    syscall
    la $a0, displayMode1msg4
    syscall
    la $a0, displayMode1msg5
    syscall

    jal binaryToDecimal          #Calling binary to decimal mode
    j menuLoop                   #Returning to menu after finishing

DecimalMode:
    li $v0, 4                   #Printing decimal to binary header
    la $a0, displayMode2msg1
    syscall
    la $a0, displayMode2msg2
    syscall
    la $a0, displayMode2msg3
    syscall
    la $a0, displayMode2msg4
    syscall
    la $a0, displayMode2msg5
    syscall

    jal decimalToBinary           #Calling decimal to binary mode
    j menuLoop                    #Returning to menu after finishing

Exit:
    li $v0, 4                    #Printing exit messages
    la $a0, exitMsg1
    syscall
    la $a0, exitMsg2
    syscall
    la $a0, exitMsg3
    syscall
    la $a0, exitMsg4
    syscall
    la $a0, exitMsg5
    syscall

    lw $ra, 0($sp)               #Restoring return address
    addi $sp, $sp, 4             #Popping stack
    li $v0, 10                   #Loading exit syscall
    syscall                      #Exiting program
