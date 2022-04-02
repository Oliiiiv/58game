##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Yawen Zhang, 1006739772, zhan9153, weng.zhang@mail.utoronto.ca
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4 
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1/2/3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes / no / yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
#####################################################################

#about address/position
.eqv	FRAME_BASE	0x10008000
.eqv	FIRST_PLATFORM	0x10008800
.eqv	BOTTOM_LINE	0x1000BF00
.eqv	DOWN_RIGHT_CORNER	0x1000BFFC
.eqv	LAND_RIGHT_CORNER	0x1000B8FC

.eqv	RAB_INITIAL	0x10008014
#about graph size
.eqv	WIDTH	64
.eqv	HEIGHT	64
.eqv	WIDTH_BY4	256
.eqv	HEIGHT_BY4	256
.eqv	MINUS_WIDTH_BY4	-256
.eqv	MINUS_HEIGHT_BY4	-256

.eqv	RAB_WIDTH	6
.eqv	RAB_HEIGHT	8
.eqv	RAB_WIDTH_BY4	24
.eqv	RAB_HEIGHT_BY4	32

.eqv	TAIL_OFFSET	1536

#about color
.eqv	FIRE_COLOR	0x00F06D30
.eqv	RAB_BASE_COLOR	0x00E8C4C0
.eqv	RAB_EYE_COLOR	0x00B00F00
.eqv	RAB_EAR_COLOR	0x00D2687B
.eqv	RAB_CHEEK_COLOR	0x00DB6371

.eqv	TIMOTHY_COLOR	0x008CCC74

.eqv	ENEMY_BASE_COLOR	0x00B474CC
.eqv	ENEMY_EYE_COLOR	0x009314A9

.eqv	BLACK	0x00000000

.text
.globl main

main:

################Draw Land###############
DrawLand:
	li $t1, BOTTOM_LINE
	li $t2, DOWN_RIGHT_CORNER
	li $t0, TIMOTHY_COLOR
	
LoopDrawLand1:
	bgt $t1, DOWN_RIGHT_CORNER, DrawLand2
	#draw
	sw $t0, 0($t1)
	
	#go to the next pixel
	addi $t1, $t1, 4
	j LoopDrawLand1	
	
DrawLand2:
	addi $t2, $t2, MINUS_WIDTH_BY4	#this should be the second last line
	li $t1, BOTTOM_LINE
	addi $t1, $t1, MINUS_WIDTH_BY4
	
LoopDrawLand2:
	bgt $t1, $t2, DrawLand3
	#draw
	sw $t0, 0($t1)
	
	#go to the next pixel
	addi $t1, $t1, 4
	j LoopDrawLand2
	
DrawLand3:
	addi $t2, $t2, MINUS_WIDTH_BY4	#this should be the third last line
	li $t1, BOTTOM_LINE
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	
LoopDrawLand3:
	bgt $t1, $t2, DrawLand4
	#draw
	sw $t0, 0($t1)
	
	#go to the next pixel
	addi $t1, $t1, 4
	j LoopDrawLand3
	
DrawLand4:
	addi $t2, $t2, MINUS_WIDTH_BY4	#this should be the third last line
	li $t1, BOTTOM_LINE
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	
LoopDrawLand4:
	bgt $t1, $t2, MakeFloatPlatform
	#draw
	sw $t0, 0($t1)
	
	#go to the next pixel
	addi $t1, $t1, 4
	j LoopDrawLand4

########Generate Float Platform##########
MakeFloatPlatform:
	li $t2, FIRST_PLATFORM	#use t2 to store the begin pixel of platforms
	li $t1, 64
	move $a1, $t1	#a1 stroes the length of platform
	move $a2, $t2	#a2 stores begin pixel

	jal DrawFloatPlatform
	
	li $t3, 48
	li $t2, 0x1000ABA0
	move $a1, $t3	#a1 stroes the length of platform
	move $a2, $t2	#a2 stores begin pixel
	jal DrawFloatPlatform
	
	li $t3, 52
	li $t2, 0x10009B20
	move $a1, $t3	#a1 stroes the length of platform
	move $a2, $t2	#a2 stores begin pixel
	jal DrawFloatPlatform
	
	j DrawRabbit
##########Draw Float Platform############
DrawFloatPlatform:
	li $t1, TIMOTHY_COLOR
	move $t2, $a2
	move $t3, $a1
	
LoopDrawFloatPlatform:
	sw $t1, 0($t2)
	
	addi $t2, $t2, 4
	addi $t3, $t3, -4
	bgtz $t3, LoopDrawFloatPlatform
EndDrawPlatform:
	jr $ra
	
###############Draw Rabbit###############
DrawRabbit:
	#the initial address and store in t4
	li $t4, RAB_INITIAL
	
DrawRabbitColor:
	li $t0, RAB_BASE_COLOR
	li $t1, RAB_EYE_COLOR
	li $t2, RAB_EAR_COLOR
	li $t3, RAB_CHEEK_COLOR

DrawRabbitEnd:
	#row 1
	sw $t0, 8($t4)
	sw $t0, 16($t4)

	addi $t4, $t4, WIDTH_BY4	#row 2
	sw $t2, 8($t4)
	sw $t2, 16($t4)

	addi $t4, $t4, WIDTH_BY4	#row 3
	sw $t2, 8($t4)
	sw $t2, 16($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 4
	sw $t0, 4($t4)
	sw $t0, 8($t4)
	sw $t0, 12($t4)
	sw $t0, 16($t4)
	sw $t0, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 5
	sw $t0, 4($t4)
	sw $t0, 8($t4)
	sw $t0, 12($t4)
	sw $t0, 16($t4)
	sw $t0, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 6
	sw $t0, 4($t4)
	sw $t1, 8($t4)
	sw $t0, 12($t4)
	sw $t1, 16($t4)
	sw $t0, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 7
	sw $t0, 0($t4)
	sw $t3, 4($t4)
	sw $t0, 8($t4)
	sw $t0, 12($t4)
	sw $t0, 16($t4)
	sw $t3, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 8
	sw $t0, 4($t4)
	sw $t0, 8($t4)
	sw $t0, 12($t4)
	sw $t0, 16($t4)
	sw $t0, 20($t4)
	
restoreRabAddr:
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
###############Draw Enemy###############
DrawEnemy:
	#calculate address
	li $t2, FRAME_BASE
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	addi $t2, $t2, WIDTH_BY4
	
	#color
	li $t0, ENEMY_BASE_COLOR
	li $t1, ENEMY_EYE_COLOR
	
	#begin to draw
	#row 1
	sw $t0, 0($t2)
	sw $t0, 8($t2)
	
	addi $t2, $t2, WIDTH_BY4	#row 2
	sw $t0, 0($t2)
	sw $t0, 4($t2)
	sw $t0, 8($t2)
	sw $t0, 16($t2)
	
	addi $t2, $t2, WIDTH_BY4	#row 3
	sw $t1, 0($t2)
	sw $t0, 4($t2)
	sw $t1, 8($t2)
	sw $t0, 12($t2)
	sw $t0, 20($t2)

	addi $t2, $t2, WIDTH_BY4	#row 4
	sw $t0, 0($t2)
	sw $t0, 4($t2)
	sw $t0, 8($t2)

###############Draw Timothy#############
DrawTimothy:
	#calculate address
	li $t2, LAND_RIGHT_CORNER
	addi $t2, $t2, -8
	#color
	li $t0, TIMOTHY_COLOR
	
	#begin to draw
	#row 1
	sw $t0, 4($t2)

	addi $t2, $t2, WIDTH_BY4	#row 2
	sw $t0, 4($t2)
	sw $t0, 8($t2)
	
	addi $t2, $t2, WIDTH_BY4	#row 3
	sw $t0, 0($t2)
	sw $t0, 4($t2)
	
	addi $t2, $t2, WIDTH_BY4	#row 4
	sw $t0, 4($t2)
	
	li $s0, RAB_INITIAL
mainLoop:
	#key_update(int rabbit) 
	addi $sp, $sp, -4	#store rabbit address
	sw $s0, 0($sp)
        jal key_update
        
	#take the return value of key_update, which is the new address of rabbit
	lw $s0, 0($sp)	
	addi $sp, $sp, 4
	
refresh:
	li $v0, 32
	addi $a0, $a0, 40
	syscall
	
	j mainLoop
END:
	li $v0, 10
	syscall
	
###################END MAIN FUNC##################
key_update:
	#pop the address of the rabbit in t1
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	#check whether the user has pressed any key
        li $t3, 0xffff0000 
        lw $t2, 0($t3) 
        beq $t2, 1, k_event
        
k_re:
	#push the new address of the rabbit in the stack
	addi $sp, $sp, -4
        sw $t0, 0($sp)
        
	jr $ra #Return from key_update() function
        
k_event: #Branch to correponding keystroke event
        lw $t2, 4($t3)
    	#load colors 
        li $t6, RAB_CHEEK_COLOR
        li $t7, RAB_BASE_COLOR
        li $t8, RAB_EYE_COLOR
        li $t9, RAB_EAR_COLOR
        #press r to restart
        beq $t2, 0x70, respond_restart
        beq $s2, -1, k_re
        beq $t2, 0x61, respond_a
        beq $t2, 0x64, respond_d
        beq $t2, 0x77, respond_w
        j k_re
        
respond_a:
	#check whether reach the left end
        #t1 stores the address of the rabbit
        addi $t3, $t0, TAIL_OFFSET
        li $t1, 256
        
        div $t3, $t1
        mfhi $t1
        beq $t1, $zero, k_re
        
        #refresh the picture of rabbit
        #make the current position black
        move $a0, $t0
        jal clear_rabbit
        #draw the new rabbit
        addi $t0, $t0, -4
        
        move $a0, $t0
        jal DrawRabFunc
        
        lw $t0, 0($sp)	#use s0 to store the address of rabbit
        addi $sp, $sp, 4
        j k_re
        
respond_d:
	#check whether reach the left end
        #t1 stores the address of the rabbit
        addi $t3, $t0, TAIL_OFFSET
        li $t1, 256
        
        div $t3, $t1
        mfhi $t1
        beq $t1, $zero, k_re
        
        #refresh the picture of rabbit
        #make the current position black
        move $a0, $t0
        jal clear_rabbit
        #draw the new rabbit
        addi $t0, $t0, 4	#update the new addr of rabbit
        
        move $a0, $t0	#push the address of rabbit
        jal DrawRabFunc
        
        lw $t0, 0($sp)	#use s0 to store the address of rabbit
        addi $sp, $sp, 4
        j k_re
respond_w:

	j k_re
respond_restart:

##############END OF KEY CONTROL###############
clear_rabbit:
	lw $t0, 0($a0)
	li $t2, BLACK

ClearRabbit:
	#row 1
	sw $t0, 8($t4)
	sw $t0, 16($t4)

	addi $t4, $t4, WIDTH_BY4	#row 2
	sw $t2, 8($t4)
	sw $t2, 16($t4)

	addi $t4, $t4, WIDTH_BY4	#row 3
	sw $t2, 8($t4)
	sw $t2, 16($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 4
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 5
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 6
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 7
	sw $t2, 0($t4)
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	
	addi $t4, $t4, WIDTH_BY4	#row 8
	sw $t2, 4($t4)
	sw $t2, 8($t4)
	sw $t2, 12($t4)
	sw $t2, 16($t4)
	sw $t2, 20($t4)
	
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	
	jr $ra
	
	
	
DrawRabFunc:
	#calculate the address and store in t4
	
	li $t0, RAB_BASE_COLOR
	li $t1, RAB_EYE_COLOR
	li $t2, RAB_EAR_COLOR
	li $t3, RAB_CHEEK_COLOR

	#row 1
	sw $t0, 8($a0)
	sw $t0, 16($a0)

	addi $a0, $a0, WIDTH_BY4	#row 2
	sw $t2, 8($a0)
	sw $t2, 16($a0)

	addi $a0, $a0, WIDTH_BY4	#row 3
	sw $t2, 8($a0)
	sw $t2, 16($a0)
	
	addi $a0, $a0, WIDTH_BY4	#row 4
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)
	sw $t0, 20($a0)
	
	addi $a0, $a0, WIDTH_BY4	#row 5
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)
	sw $t0, 20($a0)
	
	addi $a0, $a0, WIDTH_BY4	#row 6
	sw $t0, 4($a0)
	sw $t1, 8($a0)
	sw $t0, 12($a0)
	sw $t1, 16($a0)
	sw $t0, 20($a0)
	
	addi $a0, $a0, WIDTH_BY4	#row 7
	sw $t0, 0($a0)
	sw $t3, 4($a0)
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)
	sw $t3, 20($a0)
	
	addi $a0, $a0, WIDTH_BY4	#row 8
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)
	sw $t0, 20($a0)
	
	#revise and return the new addtress of the rabbit
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	addi $a0, $a0, MINUS_WIDTH_BY4
	
	move $v1, $a0
	jr $ra
