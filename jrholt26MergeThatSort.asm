#File: jrholt26MergeThatSort.asm
#CS 2144 winter 2024
#Jackson Holt Trasny U
#
#        this is a program that takes in an array from the user 
#        and uses merge sort to
# 
.data 
	array0: .space 400
	tempArray: .space 800
	userPrompt: .asciiz "how many items in this array? [must be greater than -1]: "
	a0Title: .asciiz "Input data for first array: "
	endl: .asciiz "\n"
	intPlease: .asciiz "Number: "
	originalArray: .asciiz "the original Array is: "
	finalArray: .asciiz "the final Array is: " 
	
	
.text 

#main program driver for my mergeThatSort function that takes in two arrays and sorts them
#S0 - base address of array0
#s1 - length of array0
#s2 - iterator
main: 
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	la $s0, array0
	
	li $v0, 4
	la $a0, a0Title
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall

#validate input length of array
vloop0:	
	li $v0, 4
	la $a0, userPrompt
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	slt $t5, $s1, $0
	bne $t5, $0, vloop0

#input data loop for array0
	li $s2, 0
loop0: 
	beq $s2, $s1, endLoop0
	
	li $v0, 4
	la $a0, intPlease
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	sll $t0, $s2, 2
	add $t1, $s0, $t0
	sw $t2, 0($t1) 
	addi $s2, $s2, 1 
	j loop0 
	
endLoop0:

	li $v0, 4
	la $a0, originalArray
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall

	move $a0, $s0
	move $a1, $s1
	jal printArray


#mergesort 
	move $a0, $s0
	move $a1, $s1
	jal MergeThatSort

#print array
	li $v0, 4
	la $a0, finalArray
	syscall
	
	li $v0, 4
	la $a0, endl
	syscall
	
	move $a0, $s0
	move $a1, $s1
	jal printArray

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	jr $ra


#MergeThatSort a function that recursivley sorts arrays by merging them togethe
# 	passed in is the length of the array and the base address of the array
#S0 - base addresss of array0
#s1 - length of array0
#s2 - base address of secound half of the array
#s3 - lenght of half the array0
#s4 - centinal value of 1
MergeThatSort:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	li $s4, 1
	move $s0, $a0
	move $s1, $a1
	
	#check if the length is zero or one Base cases
	beq $s1, $0, return
	beq $s1, $s4, return
	
	#split array in half by dividing by 2 and then multiplying by 4 to get a fo base address
	srl $t1, $s1, 1
	move $s3, $t1
	sub $s1, $s1, $s3
	sll $t2, $s1, 2
	add $s2, $s0, $t2
	 
	move $a0, $s0
	move $a1, $s1
	jal MergeThatSort
	
	move $a0, $s2
	move $a1, $s3
	jal MergeThatSort
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3
	jal getItTogether
	
return:	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	jr $ra

#getItTogether a function that merges two sorted arrays and returns the length of the final array
#s0 - base address of array0
#s1 - base address of array1
#s2 - base address of temp array 
#s3 is the length of array0
#s4 is the length of array1
#s5 - iterator for array0
#s6 - iterator for array1
#s7 - iterator for temp array
# passed in is the base address of array0, the lenght of array0, the base address of array1, 
# the length of array1, and returns the length of merged array
getItTogether: 
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	
	move $s0, $a0
	move $s1, $a2
	move $s3, $a1
	move $s4, $a3
	li $s5, 0
	li $s6, 0
	li $s7, 0
	la $s2, tempArray
	
	#while loop to iterate over both arrays until they are compltley sorted 
loop: 
	beq $s3, $0, zero0
	beq $s4, $0, zero1
	add $t6, $s4, $s3
	slt $t0, $s7, $t6
	beq $t0, $0, endloop
	beq $s5, $s3, case0
	beq $s6, $s4, case1 
	
	sll $t2, $s5, 2
	add $t3, $s0, $t2
	lw $t4, 0($t3)
	
	sll $t2, $s6, 2
	add $t3, $s1, $t2
	lw $t5, 0($t3)
	
	beq $t4, $t5, equal
	slt $t0, $t4, $t5
	beq $t0, $0, a1work

	sll $t2, $s7, 2
	add $t3, $s2, $t2
	sw $t4, 0($t3)
	
	addi $s5, $s5, 1
	addi $s7, $s7, 1
	
	j loop

#else array1 value is greater 
a1work: 
	sll $t2, $s7, 2
	add $t3, $s2, $t2
	sw $t5, 0($t3)

	addi $s6, $s6, 1
	addi $s7, $s7, 1

	j loop
	
equal: 

	sll $t2, $s7, 2
	add $t3, $s2, $t2
	sw $t5, 0($t3)
	sw $t4, 0($t3)
	
	addi $s6, $s6, 1
	addi $s7, $s7, 1
	
	j loop

#case for when we have exhausted array0
zero0:
	sll $t2, $s6, 2
	add $t3, $s1, $t2
	lw $t5, 0($t3)
case0: 
	beq $s6, $a3, endloop
	
	sll $t2, $s7, 2
	add $t3, $s2, $t2
	sw $t5, 0($t3)

	addi $s6, $s6, 1
	addi $s7, $s7, 1
	
	sll $t2, $s6, 2
	add $t3, $s1, $t2
	lw $t5, 0($t3)
	
	j case0

#case for when we have exhausted array1
zero1:
	sll $t2, $s5, 2
	add $t3, $s0, $t2
	lw $t4, 0($t3)
case1: 
	beq $s5, $a1, endloop
	
	sll $t2, $s7, 2
	add $t3, $s2, $t2
	sw $t4, 0($t3)
	
	addi $s5, $s5, 1
	addi $s7, $s7, 1
	
	sll $t2, $s5, 2
	add $t3, $s0, $t2
	lw $t4, 0($t3)
	
	j case1

endloop:
	
#return values in array0 
	li $s7, 0
	li $s5, 0

returnLoop: 
	add $t7, $s4, $s3
	slt $t0, $s7, $t7
	beq $t0, $0, end
	
	sll $t2, $s7, 2
	add $t3, $s2, $t2
	lw $t4, 0($t3)
	 
	sll $t2, $s5, 2
	add $t3, $s0, $t2
	sw $t4, 0($t3)
	
	addi $s7, $s7, 1
	addi $s5, $s5, 1

	j returnLoop
	
end: 
	add $t7, $s4, $s3
	move $v0, $t7
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	jr $ra

# printArray
# s0 - length of array
# s1 - index runner
# s7 - base address
# passed in as base and length in
# no return value
printArray:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)

	move $s7, $a0
	move $s0, $a1

	li $s1, 0

printLoop:	slt $t1, $s1, $s0
	beq $t1, $0, printEndloop

		add $t2, $s1, $s1
		add $t2, $t2, $t2
		add $t3, $s7, $t2
		lw $t4, 0($t3)

		li $v0, 1
		move $a0, $t4
		syscall

		li $v0, 4
		la $a0, endl
		syscall

		addi $s1, $s1, 1
	j printLoop

printEndloop:	
	lw $ra, 32($sp)
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 36
	
	jr $ra
	