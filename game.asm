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
# - Milestone 3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. health (heart)
# 2. fail condition
# 3. won condition
# 4. moving platform
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
#####################################################################
#about address/position
.eqv	FRAME_BASE	0x10008000
.eqv	FIRST_PLATFORM	0x10008800
.eqv 	SECOND_PLATFORM	0x1000ABA0
.eqv 	THIRD_PLATFORM	0x10009B20
.eqv	BOTTOM_LINE	0x1000BF00
.eqv	DOWN_RIGHT_CORNER	0x1000BFFC
.eqv	LAND_RIGHT_CORNER	0x1000B8FC
.eqv	RAB_INITIAL	0x10008014

.eqv	OOPS_START_IDX	0x10009B40
.eqv	WIN_START_IDX	0x10009B34

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
.eqv	RAB_RIGHT_DOWN_OFFSET	1812
.eqv	RAB_LEFT_DOWN_OFFSET	1792
.eqv	HP_OFFSET	464

.eqv	FIRST_PLATFORM_LEN	64
.eqv 	SECOND_PLATFORM_LEN	48
.eqv	THIRD_PLATFORM_LEN	52

#about color
.eqv	HEALTH_COLOR	0x00EBBEE3

.eqv	RAB_BASE_COLOR	0x00E8C4C0
.eqv	RAB_EYE_COLOR	0x00B00F00
.eqv	RAB_EAR_COLOR	0x00D2687B
.eqv	RAB_CHEEK_COLOR	0x00DB6371

.eqv	TIMOTHY_COLOR	0x008CCC74

.eqv	ENEMY_BASE_COLOR	0x00B474CC
.eqv	ENEMY_EYE_COLOR	0x009314A9

.eqv	BLACK	0x00000000
.eqv	IMMUNE_COLOR	0x00DE86C1
.eqv	GRAY	0x009E9E9E

.eqv	GOAL_COLOR	0x004A8D46
.eqv	WIN_COLOR	0x00DFA1CF

.text
.globl main
main:
###########Initialize Data##############
	li $s0, RAB_INITIAL	#the initial address of the rabbit
	li $s1, SECOND_PLATFORM	#the second platform address(the moving one)
	li $s2, 3	#health
	li $s3, -1	#platform moving direction
	li $s4, 20	#platform movw time
	li $s5, 2	#for double jump
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
	li $t1, FIRST_PLATFORM_LEN
	addi $sp, $sp, -4
	sw $t1, 0($sp)	#push the length of platform
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#push begin pixel
	jal DrawFloatPlatform
	
	lw $t2, 0($sp)	#pop the return value: end pixel of the platform
	addi $sp, $sp, 4

	li $t3, SECOND_PLATFORM_LEN
	li $t2, SECOND_PLATFORM
	addi $sp, $sp, -4
	sw $t3, 0($sp)	#push the length of platform
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#push begin pixel
	jal DrawFloatPlatform
	
	lw $t2, 0($sp)	#pop the return value: end pixel of the platform
	addi $sp, $sp, 4
	
	sw $t2, 0($sp)	#push the end pixel of the platform
	addi $sp, $sp, -4
	jal DrawEnemyFunc
	
	li $t3, THIRD_PLATFORM_LEN
	li $t2, THIRD_PLATFORM
	addi $sp, $sp, -4
	sw $t3, 0($sp)	#push the length of platform
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#push begin pixel
	jal DrawFloatPlatform
	
	lw $t2, 0($sp)	#pop the return value: end pixel of the platform
	addi $sp, $sp, 4
	
	sw $t2, 0($sp)	#push the end pixel of the platform
	addi $sp, $sp, -4
	jal DrawEnemyFunc
	
	j DrawRabbit
##########Draw Float Platform############
#enemies are on the platform
DrawFloatPlatform:
	li $t1, TIMOTHY_COLOR
	lw $t2, 0($sp)	#pop begin pixel
	addi $sp, $sp, 4
	lw $t3, 0($sp)	#pop the length of platform
	addi $sp, $sp, 4

LoopDrawFloatPlatform:
	sw $t1, 0($t2)

	addi $t2, $t2, 4
	addi $t3, $t3, -4
	bgtz $t3, LoopDrawFloatPlatform
	
EndDrawPlatform:
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#return the end pixel of the platform
	jr $ra
	
###############Draw Rabbit###############
DrawRabbit:
	#the initial address and store in t4
	li $s0, RAB_INITIAL
	move $t4, $s0
	
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

###############Draw Timothy#############
DrawTimothy:
	#calculate address
	li $t2, LAND_RIGHT_CORNER
	addi $t2, $t2, -8
	#color
	li $t0, GOAL_COLOR
	
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
	
mainLoop:
	#key_update(int rabbit) 
	addi $sp, $sp, -4	#store rabbit address
	sw $s0, 0($sp)
        jal key_update
        
	#take the return value of key_update, which is the new address of rabbit
	lw $s0, 0($sp)	
	addi $sp, $sp, 4

clear_hp:
	li $t2, FRAME_BASE
	addi $t2, $t2, HP_OFFSET
        li $t3, BLACK

	sw $t3, 0($t2)
        sw $t3, 8($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 4($t2)
        addi $t2, $t2, MINUS_WIDTH_BY4
        
	sw $t3, 16($t2)
        sw $t3, 24($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 20($t2)
        addi $t2, $t2, MINUS_WIDTH_BY4

        sw $t3, 32($t2)
        sw $t3, 40($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 36($t2)

draw_hp:
	li $t2, FRAME_BASE
	addi $t2, $t2, HP_OFFSET
        li $t3, HEALTH_COLOR
        
        beq $s2, 3, hp_3
        beq $s2, 2, hp_2
        beq $s2, 1, hp_1
        blez, $s2, gg
hp_3:
	sw $t3, 0($t2)
        sw $t3, 8($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 4($t2)
        addi $t2, $t2, MINUS_WIDTH_BY4
hp_2:
	sw $t3, 16($t2)
        sw $t3, 24($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 20($t2)
        addi $t2, $t2, MINUS_WIDTH_BY4
hp_1:
        sw $t3, 32($t2)
        sw $t3, 40($t2)
        addi $t2, $t2, WIDTH_BY4
        sw $t3, 36($t2)
        
movePlatform:
	move $t2, $s1	#t2 stores address of platform
	move $t4, $s3	#t3 stores moving direction of platform
	
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#push the address of platform
	addi $sp, $sp, -4
	sw $t4, 0($sp)	#push the direction of platform
	jal movePLatformFunc
	
	lw $t4, 0($sp)	#pop the direction of platform
	addi $sp, $sp, 4
	lw $t2, 0($sp)	#pop the address of platform
	addi $sp, $sp, 4
	
	move $s1, $t2
	move $s3, $t4
	
gravity:
	move $t0, $s0
	#if it is on a platform just go to refresh
	#left
	move $t3, $zero
	addi $t3, $t3, RAB_LEFT_DOWN_OFFSET
	add $t3, $t0, $t3	#t3 stores the left down corner of the rabbit

	li $t6, WIDTH_BY4
	add $t6, $t6, $t3
	lw $t5, 0($t6)	#t5 stores the color of t6
	beq $t5, TIMOTHY_COLOR, refresh
	beq $t5, ENEMY_BASE_COLOR, refresh
	beq $t5, ENEMY_EYE_COLOR, refresh
	
	#right
	move $t3, $zero
	addi $t3, $t3, RAB_RIGHT_DOWN_OFFSET
	add $t3, $t0, $t3	#t3 stores the right down corner of the rabbit

	li $t6, WIDTH_BY4
	add $t6, $t6, $t3
	lw $t5, 0($t6)	#t5 stores the color of t6
	beq $t5, TIMOTHY_COLOR, refresh
	beq $t5, ENEMY_BASE_COLOR, refresh
	beq $t5, ENEMY_EYE_COLOR, refresh

	#if it is at the bottom line just go to refresh
	li $t1, LAND_RIGHT_CORNER
	addi $t1, $t1, MINUS_WIDTH_BY4
	bge $t0, $t1, refresh

	#if rabbit is not on platform or on land, gravity works.
        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal clear_rabbit

        #draw the new rabbit
        addi $t0, $t0, WIDTH_BY4

        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal DrawRabFunc

        lw $t0, 0($sp)	
        addi $sp, $sp, 4

        addi $s0, $s0, WIDTH_BY4

about_crash:
	addi $sp, $sp, -4
	sw $s2, 0($sp)	#push the hp of rabbit
	addi $sp $sp, -4
	sw $s0, 0($sp)	#push the address of rabbit
	jal if_crash
	
	lw $s2, 0($sp)	#pop the hp of rabbit
	addi $sp, $sp, 4
	
refresh:
	li $v0, 32
	addi $a0, $a0, 1
	syscall

	j mainLoop
END:
	li $v0, 10
	syscall
	
###################END MAIN FUNC##################
###############MOVE PLATFORM FUNCS################
movePLatformFunc:
	lw $t3, 0($sp)	#pop the direction of platform
	addi $sp, $sp, 4
	lw $t2, 0($sp)	#pop the address of platform
	addi $sp, $sp, 4
	
	li $t5, TIMOTHY_COLOR
	li $t8, BLACK
loopMoveFunc:
	#if platform reach the edge then chan direction
	beqz $s4, changeDir
	j notChange
changeDir:
	beq $t3, 1, changeDirToLeft
	beq $t3, -1, changeDirToRight
	#else just move the platform
notChange:
	beq $t3, 1, moveRight
	beq $t3, -1, moveLeft	
	
moveRight:
	sw $t8, 0($t2)
	sw $t5, 52($t2)
	addi $s4, $s4, -1
	addi $t2, $t2, 4
	j endMove
moveLeft:
	sw $t5, -4($t2)
	sw $t8, 52($t2)
	addi $s4, $s4, -1
	addi $t2, $t2, -4
	j endMove
changeDirToLeft:
	#in this case platform will not move
	addi $t3, $zero, -1
	li $s4, 20
	j endMove
changeDirToRight:
	addi $t3, $zero, 1
	li $s4, 20
	j endMove
endMove:
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#push the new address
	addi $sp, $sp, -4
	sw $t3, 0($sp)	#push the new direction
	jr $ra
####################END MOVE######################
#if crashed, hp will decrease by 1 and rabbit will
#show again near the crashed address with 2 seconds
#immunity.
###################CRASH FUNCS####################
if_crash:
	lw $t0, 0($sp)	#pop the address of rabbit
	addi $sp, $sp, 4
	lw $t2, 0($sp)	#pop the hp of rabbit
	addi $sp, $sp, 4
	
	addi $t0, $t0, MINUS_WIDTH_BY4	#the row above the rabbit
	lw $t6, 8($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 16($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row1
	lw $t6, 4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 20($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row2
	lw $t6, 4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 20($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row3
	lw $t6, 4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 20($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row4
	lw $t6, -4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 24($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row5
	lw $t6, -4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 24($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row6
	lw $t6, -4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 24($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row7
	lw $t6, -4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 24($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#row8
	lw $t6, -4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 24($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	addi $t0, $t0, WIDTH_BY4	#the row below the rabbit
	lw $t6, 0($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 4($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 8($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 12($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 16($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	lw $t6, 20($t0)
	beq $t6, ENEMY_BASE_COLOR, is_crashed
	beq $t6, ENEMY_EYE_COLOR, is_crashed
	
	#restore the address of rabbit
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4
	addi $t0, $t0, MINUS_WIDTH_BY4

crash_return:
	addi $sp, $sp, -4
	sw $t2, 0($sp)	#return the new hp to main function
	jr $ra

is_crashed:
	addi $t2, $t2, -1	#hp-1
	j crash_return

###################KEY CONTROL####################
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
        #press r to restart
        beq $t2, 0x70, respond_restart	#this is p
        beq $t2, 0x61, respond_a	#go left
        beq $t2, 0x64, respond_d	#go right
        beq $t2, 0x77, respond_w	#jump/move up 2 lines
        j k_re

respond_a:
	#check whether reach the left end
	li $t8, WIDTH_BY4
        addi $t7, $t0, 0
        div $t7, $t8
        mflo $t9
        beqz $t9, k_re
        
        #t0 stores the address of the rabbit
        addi $t3, $t0, TAIL_OFFSET
        li $t1, 256
        
        div $t3, $t1
        mfhi $t1
        beq $t1, $zero, k_re
        
       	move $t8, $t0
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
       
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
  
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
     
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
     
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
       
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
       
        lw $t9, -4($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
    
        
        #refresh the picture of rabbit
        #make the current position black
        addi $sp, $sp, -4
        sw $ra, 0($sp)	#push the old $ra into the stack
        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal clear_rabbit
        

        #draw the new rabbit
        addi $t0, $t0, -4

        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal DrawRabFunc
        
        lw $t0, 0($sp)	#use s0 to store the address of rabbit
        addi $sp, $sp, 4
        
        lw $ra, 0($sp)	#pop out the old $ra
        addi $sp, $sp, 4
        
        j k_re
        
respond_d:
	#check whether reach the left end
        #t1 stores the address of the rabbit
       	li $t8, WIDTH_BY4
        addi $t7, $t0, 0
        div $t7, $t8
        mflo $t8
        beq $t8, 255, k_re
        
        addi $t3, $t0, TAIL_OFFSET
        li $t1, 256
        
        div $t3, $t1
        mfhi $t1
        beq $t1, $zero, k_re
        
        move $t8, $t0
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4

        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win
        addi $t8, $t8, WIDTH_BY4
        
        lw $t9, 24($t8)
        beq $t9, TIMOTHY_COLOR, k_re
        beq $t9, ENEMY_BASE_COLOR, k_re
        beq $t9, ENEMY_EYE_COLOR, k_re
        beq $t9, GOAL_COLOR, win

        #refresh the picture of rabbit
        #make the current position black
        addi $sp, $sp, -4
        sw $ra, 0($sp)	#push the old $ra into the stack
        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal clear_rabbit
        
        #draw the new rabbit
        addi $t0, $t0, 4
        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal DrawRabFunc
        
        lw $t0, 0($sp)	#use s0 to store the address of rabbit
        addi $sp, $sp, 4
        
        lw $ra, 0($sp)	#pop out the old $ra
        addi $sp, $sp, 4

        j k_re

respond_w:
	beq $s5, 2, checkIfOnGround
	beq $s5, 1, IfPlatformUpward
	beqz $s5, cannotJump
checkIfOnGround:
	move $t8, $t0
	
	move $t3, $zero
	addi $t3, $t3, RAB_LEFT_DOWN_OFFSET
	add $t3, $t0, $t3	 #t3 stores the left down corner of the rabbit
 	li $t6, WIDTH_BY4
 	add $t6, $t6, $t3
 	lw $t5, 0($t6) #t5 stores the color of t6
	bne $t5, TIMOTHY_COLOR, k_re

	move $t3, $zero
 	addi $t3, $t3, RAB_RIGHT_DOWN_OFFSET
	add $t3, $t0, $t3 	#t3 stores the right down corner of the rabbit

 	li $t6, WIDTH_BY4
 	add $t6, $t6, $t3
 	lw $t5, 0($t6) #t5 stores the color of t6
 	bne $t5, TIMOTHY_COLOR, k_re

	#if there is a platform upward then is blocked
IfPlatformUpward:
	move $t8, $t0
        li $t7, 24
        li $t6, TIMOTHY_COLOR
LoopIfPlatform1:
	lw $t9, 0($t8)
	sub $t9, $t9, $t6
	beqz $t9, k_re
	
	addi $t8, $t8, 4
	addi $t7, $t7, -4
        bnez $t7, LoopIfPlatform1
  	
  	addi $t8, $t8, -24
        addi $t8, $t8, MINUS_WIDTH_BY4
        li $t7, 24
        li $t6, TIMOTHY_COLOR
LoopIfPlatform2:
	lw $t9, 0($t8)
	sub $t9, $t9, $t6
	beqz $t9, k_re
	
	addi $t8, $t8, 4
	addi $t7, $t7, -4
        bnez $t7, LoopIfPlatform2
        
        addi $t8, $t8, -24
        addi $t8, $t8, MINUS_WIDTH_BY4
        li $t7, 24
        li $t6, TIMOTHY_COLOR
LoopIfPlatform3:
	lw $t9, 0($t8)
	sub $t9, $t9, $t6
	beqz $t9, k_re
	
	addi $t8, $t8, 4
	addi $t7, $t7, -4
        bnez $t7, LoopIfPlatform3
        
        addi $t8, $t8, -24
        addi $t8, $t8, MINUS_WIDTH_BY4
        li $t7, 24
        li $t6, TIMOTHY_COLOR
LoopIfPlatform4:
	lw $t9, 0($t8)
	sub $t9, $t9, $t6
	beqz $t9, k_re
	
	addi $t8, $t8, 4
	addi $t7, $t7, -4
        bnez $t7, LoopIfPlatform4

	#if is at the ceiling of the screen then is blocked
	move $t1, $t0
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4
	addi $t1, $t1, MINUS_WIDTH_BY4

	li $t2, FRAME_BASE
	ble $t1, $t2, k_re

        #refresh the picture of rabbit
        #make the current position black
        addi $sp, $sp, -4
        sw $ra, 0($sp)	#push the old $ra into the stack
        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal clear_rabbit

        #draw the new rabbit
        addi $t0, $t0, MINUS_WIDTH_BY4
        addi $t0, $t0, MINUS_WIDTH_BY4
        addi $t0, $t0, MINUS_WIDTH_BY4
        addi $t1, $t1, MINUS_WIDTH_BY4
        addi $t1, $t1, MINUS_WIDTH_BY4

        addi $sp, $sp, -4
        sw $t0, 0($sp)	#push the address of rabbit
        jal DrawRabFunc

        lw $t0, 0($sp)	#use s0 to store the address of rabbit
        addi $sp, $sp, 4

        lw $ra, 0($sp)	#pop out the old $ra
        addi $sp, $sp, 4

	addi $s5, $s5, -1
        j k_re
        
cannotJump:
	li $s5, 2
	j k_re
respond_restart:
	jal clear_screen
        j main

##############CLEAR RABBIT FUNC################
clear_rabbit:
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	li $t2, BLACK

ClearRabbit:
	#row 1
	sw $t2, 8($t4)
	sw $t2, 16($t4)
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
	
	jr $ra

################DRAW RABBIT FUNC##################
DrawRabFunc:
	#pop the addr and store in t4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	li $t0, RAB_BASE_COLOR
	li $t1, RAB_EYE_COLOR
	li $t2, RAB_EAR_COLOR
	li $t3, RAB_CHEEK_COLOR
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
	
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	addi $t4, $t4, MINUS_WIDTH_BY4
	
	addi $sp, $sp, -4
        sw $t4, 0($sp)	#push the address of rabbit
        
	jr $ra 
	
#################DRAW ENEMY FUNC##################
DrawEnemyFunc:
	lw $t2, 0($sp)	#pop the address of enemy
	addi $sp, $sp, 4
	
	#adjust the address
	addi $t2, $t2, MINUS_WIDTH_BY4
	addi $t2, $t2, MINUS_WIDTH_BY4
	addi $t2, $t2, MINUS_WIDTH_BY4
	addi $t2, $t2, MINUS_WIDTH_BY4
	addi $t2, $t2, -20
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
	addi $sp, $sp, 4
	
	jr $ra
	
##############IMMUNE RABBIT FUNC################
DrawImmunity:
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	li $t2, IMMUNE_COLOR

	#row 1
	sw $t2, 8($t4)
	sw $t2, 16($t4)
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
	
	jr $ra
#################CLEAR THE SCREEN#################
clear_screen:
	li $t4, FRAME_BASE	
	
draw_black:
	li $t1, BLACK
	sw $t1, 4($t4)
	addi $t4, $t4, 4
	ble $t4, DOWN_RIGHT_CORNER, draw_black
EndClear:
	jr $ra

######################GG##########################
gg:
	li $t7, GRAY
	addi $t8, $zero, OOPS_START_IDX
	jal clear_screen
	#row 1
	sw $t7, 4($t8)
	sw $t7, 8($t8)
	
	sw $t7, 24($t8)
	sw $t7, 28($t8)
	
	sw $t7, 40($t8)
	sw $t7, 44($t8)
	sw $t7, 48($t8)
	
	sw $t7, 64($t8)
	sw $t7, 68($t8)
	sw $t7, 72($t8)
	
	addi $t8, $t8, WIDTH_BY4	#row 2
	sw $t7, 0($t8)
	sw $t7, 12($t8)
	
	sw $t7, 20($t8)
	sw $t7, 32($t8)
	
	sw $t7, 40($t8)
	sw $t7, 52($t8)
	sw $t7, 60($t8)
	
	addi $t8, $t8, WIDTH_BY4	#row 3
	sw $t7, 0($t8)
	sw $t7, 12($t8)
	
	sw $t7, 20($t8)
	sw $t7, 32($t8)
	
	sw $t7, 40($t8)
	sw $t7, 44($t8)
	sw $t7, 48($t8)

	sw $t7, 64($t8)
	sw $t7, 68($t8)
	
	addi $t8, $t8, WIDTH_BY4	#row 4
	sw $t7, 0($t8)
	sw $t7, 12($t8)
	
	sw $t7, 20($t8)
	sw $t7, 32($t8)
	
	sw $t7, 40($t8)
	sw $t7, 72($t8)
	
	addi $t8, $t8, WIDTH_BY4	#row 5
	sw $t7, 4($t8)
	sw $t7, 8($t8)
	
	sw $t7, 24($t8)
	sw $t7, 28($t8)
	
	sw $t7, 40($t8)
	
	sw $t7, 60($t8)
	sw $t7, 64($t8)
	sw $t7, 68($t8)
	sw $t7, 84($t8)
	sw $t7, 100($t8)
	sw $t7, 116($t8)
	#wait for the keyboard respond
ReceiveRestart:
	#check whether the user has pressed any key
        li $t3, 0xffff0000 
        lw $t2, 0($t3) 
        beq $t2, 1, restartCheck
restartCheck: #Branch to correponding keystroke event
        lw $t2, 4($t3)
        beq $t2, 0x70, respond_restart	#this is p

RedrawOops:
	#else remain this page
	li $v0, 32
	li $a0, 50
	syscall
	j gg
	
###################WON FUNC####################
win:
	jal clear_screen
DrawWin:
	li $t6, WIN_COLOR
	li $t7, WIN_START_IDX
	
	#row 1
	sw $t6, 0($t7)
	sw $t6, 16($t7)
	
	sw $t6, 28($t7)
	sw $t6, 32($t7)
	
	sw $t6, 44($t7)
	sw $t6, 56($t7)
	
	sw $t6, 72($t7)
	sw $t6, 88($t7)
	
	sw $t6, 100($t7)
	sw $t6, 104($t7)
	
	sw $t6, 116($t7)
	sw $t6, 128($t7)
	
	sw $t6, 140($t7)
	
	addi $t7, $t7, WIDTH_BY4	#row 2
	sw $t6, 0($t7)
	sw $t6, 16($t7)
	
	sw $t6, 24($t7)
	sw $t6, 36($t7)
	
	sw $t6, 44($t7)
	sw $t6, 56($t7)
	
	sw $t6, 72($t7)
	sw $t6, 88($t7)
	
	sw $t6, 96($t7)
	sw $t6, 108($t7)
	
	sw $t6, 116($t7)
	sw $t6, 120($t7)
	sw $t6, 128($t7)
	
	sw $t6, 140($t7)
	
	addi $t7, $t7, WIDTH_BY4	#row 3
	sw $t6, 4($t7)
	sw $t6, 8($t7)
	sw $t6, 12($t7)
	
	sw $t6, 24($t7)
	sw $t6, 36($t7)
	
	sw $t6, 44($t7)
	sw $t6, 56($t7)
	
	sw $t6, 72($t7)
	sw $t6, 80($t7)
	sw $t6, 88($t7)
	
	sw $t6, 96($t7)
	sw $t6, 108($t7)
	
	sw $t6, 116($t7)
	sw $t6, 124($t7)
	sw $t6, 128($t7)
	
	sw $t6, 140($t7)
	
	addi $t7, $t7, WIDTH_BY4	#row 4
	sw $t6, 8($t7)
	
	sw $t6, 24($t7)
	sw $t6, 36($t7)
	
	sw $t6, 44($t7)
	sw $t6, 56($t7)
	
	sw $t6, 72($t7)
	sw $t6, 80($t7)
	sw $t6, 88($t7)
	
	sw $t6, 96($t7)
	sw $t6, 108($t7)
	
	sw $t6, 116($t7)
	sw $t6, 128($t7)

	addi $t7, $t7, WIDTH_BY4	#row 5
	sw $t6, 8($t7)
	
	sw $t6, 28($t7)
	sw $t6, 32($t7)
	
	sw $t6, 48($t7)
	sw $t6, 52($t7)
	
	sw $t6, 72($t7)
	sw $t6, 88($t7)
	
	sw $t6, 100($t7)
	sw $t6, 104($t7)
	
	sw $t6, 116($t7)
	sw $t6, 128($t7)
	
	sw $t6, 140($t7)
	
Receivep:
	#check whether the user has pressed any key
        li $t3, 0xffff0000 
        lw $t2, 0($t3) 
        beq $t2, 1, pCheck
pCheck: #Branch to correponding keystroke event
        lw $t2, 4($t3)
        beq $t2, 0x70, respond_restart	#this is p

RedrawWin:
	#else remain this page
	li $v0, 32
	li $a0, 50
	syscall
	j win
		
	
