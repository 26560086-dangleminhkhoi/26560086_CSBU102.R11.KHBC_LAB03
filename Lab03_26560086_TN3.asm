# Name: Đặng Lê Minh Khôi
# Student ID: 26560086
# Purpose: Calculate totals, pass counts, minimum and maximum scores.


# Listing 4 - a small gradebook library
.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
msgA:   .asciiz "Class A total: "
msgB:   .asciiz "Class B total: "
nl:     .asciiz "\n"
passA:  .asciiz "Class A passed: "
passB:  .asciiz "Class B passed: "
minA: .asciiz "Class A min: "
maxA: .asciiz "Class A max: "
minB: .asciiz "Class B min: "
maxB: .asciiz "Class B max: "

.text
.globl main
main:
    la   $a0, classA            # argument 1: address of classA[0]
    addi $a1, $zero, 10         # argument 2: number of scores
    jal sum_array               # $v0 = total of class A
    la   $a0, msgA
    add  $a1, $v0, $zero
    jal show

    la   $a0, classB
    addi $a1, $zero, 8
    jal sum_array               # $v0 = total of class B
    la   $a0, msgB
    add  $a1, $v0, $zero
    jal show

    la   $a0, classA
    addi $a1, $zero, 10
    addi $a2, $zero, 79
    jal count_pass
    la   $a0, passA
    add  $a1, $v0, $zero
    jal show

    la   $a0, classB
    addi $a1, $zero, 8
    addi $a2, $zero, 79
    jal count_pass
    la   $a0, passB
    add  $a1, $v0, $zero
    jal show
    
    la   $a0, classA
    addi $a1, $zero, 10
    jal  min_max

    add  $s0, $v0, $zero
    add  $s1, $v1, $zero

    la   $a0, minA
    add  $a1, $s0, $zero
    jal  show

    la   $a0, maxA
    add  $a1, $s1, $zero
    jal  show

    la   $a0, classB
    addi $a1, $zero, 8
    jal  min_max

    add  $s0, $v0, $zero
    add  $s1, $v1, $zero

    la   $a0, minB
    add  $a1, $s0, $zero
    jal  show

    la   $a0, maxB
    add  $a1, $s1, $zero
    jal  show

    li   $v0, 10
    syscall

# sum_array(addr = $a0, n = $a1): returns the sum of n words in $v0
sum_array:
    addi $v0, $zero, 0          # sum = 0
    addi $t0, $zero, 0          # i = 0
sum_loop:
    slt  $t1, $t0, $a1           # $t1 = 1 if i < n
    beq  $t1, $zero, sum_end
    sll  $t2, $t0, 2             # $t2 = 4 * i
    add  $t2, $t2, $a0           # $t2 = address of element i
    lw   $t3, 0($t2)
    add  $v0, $v0, $t3           # sum = sum + element i
    addi $t0, $t0, 1            # i = i + 1
    j    sum_loop
sum_end:
    jr   $ra

# show(msg = $a0, value = $a1): prints msg, value and a new line
show:
    li   $v0, 4                 # $a0 already holds the address of msg
    syscall
    li   $v0, 1
    add  $a0, $a1, $zero
    syscall
    li   $v0, 4
    la   $a0, nl
    syscall
    jr   $ra

# Listing 5 - count_pass, to be added to your TN3 file
# count_pass(addr = $a0, n = $a1, mark = $a2): count of words >= mark
count_pass:
    addi $v0, $zero, 0          # count = 0
    addi $t0, $zero, 0          # i = 0
    
cp_loop:
    slt  $t1, $t0, $a1
    beq  $t1, $zero, cp_end
    sll  $t2, $t0, 2
    add  $t2, $t2, $a0
    lw   $t3, 0($t2)
    slt  $t4, $t3, $a2
    bne  $t4, $zero, cp_next
    addi $v0, $v0, 1
cp_next:
    addi $t0, $t0, 1            # i = i + 1
    j    cp_loop
cp_end:
    jr   $ra

# min_max(addr = $a0, n = $a1): returns min in $v0 and max in $v1
min_max:
    lw   $v0, 0($a0)
    lw   $v1, 0($a0)
    addi $t0, $zero, 1

mm_loop:
    slt  $t1, $t0, $a1
    beq  $t1, $zero, mm_end

    sll  $t2, $t0, 2
    add  $t2, $t2, $a0
    lw   $t3, 0($t2)

    slt  $t4, $t3, $v0
    beq  $t4, $zero, mm_max
    add  $v0, $t3, $zero

mm_max:
    slt  $t4, $v1, $t3
    beq  $t4, $zero, mm_next
    add  $v1, $t3, $zero

mm_next:
    addi $t0, $t0, 1
    j    mm_loop

mm_end:
    jr   $ra

