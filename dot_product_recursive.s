# #include <stdio.h>

# int a[5] = {1, 2, 3, 4, 5};
# int b[5] = {6, 7, 8, 9, 10};

# int dot_product_recursive(int *a, int *b, int size) {
#     if (size == 1) return a[0]*b[0];
#     return a[0]*b[0] + dot_product_recursive(a+1, b+1, size-1);
# }

# int main() {
#     int result;

#     result = dot_product_recursive(a, b, 5);
#     printf("The dot product is: %d\n", result);
#     return 0;
# }

.data

a: .word 1, 2, 3, 4, 5
b: .word 6, 7, 8, 9, 10
output: .string "The dot product is: "
newline: .string "\n"

.text
main:
    # passing the two arguments to a0, a1 and a2
    la a0, a                     # Loading the address of a[] to x8
    la a1, b                     # Loading the address of b[] to x9
    li a2, 5                     # x5 = 5
    addi t0, x0, 1               # t0 = 1
    
    jal dot_product_recursive
    
    mv t3, a0
    
    li a0, 4                    # print output label
    la a1, output
    ecall
    
    li a0, 1                    # print result
    mv a1, t3
    ecall
    
    li a0, 4                    # print new line
    la a1, newline
    ecall

    li a0, 10                       # program out
    ecall
    
    
dot_product_recursive:
    beq a2, t0, exit_recur          # if size == 1 go to exit
    
    # save ra register on to the stack
    addi sp, sp, -12
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw ra, 0(sp)
    
    addi a0, a0, 4                  # a += 1
    addi a1, a1, 4                  # b += 1
    addi a2, a2, -1                 # size -= 1
    
    jal dot_product_recursive

    # load ra register on to the stack
    lw t1, 8(sp)
    lw t2, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12

    lw t1, 0(t1)
    lw t2, 0(t2)
    
    mul t1, t1, t2
    add a0, a0, t1
   
    jr ra
    
exit_recur:
    # return
    lw t1, 0(a0)                    # a[0]
    lw t2, 0(a1)                    # b[0]
    mul a0, t1, t2                  # a[0]*b[0]
    jr ra
