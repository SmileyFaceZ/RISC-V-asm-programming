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
    la x8, a                # Loading the address of a[] to x8
    la x9, b                # Loading the address of b[] to x9
    li x5, 5                # x5 = 5
    
    mv a0, x8
    mv a1, x9
    mv a2, x5
    
    jal dot_product_recursive
    
    li a0, 4
    la a1, output
    ecall
    
    mv a1, a0
    li a0, 1
    ecall
    
    li a0, 4
    la a1, newline
    ecall

    addi a0, x0, 10                 # program out
    ecall
    
    
dot_product_recursive:
    addi t0, x0, 1                  # t0 = 1
    beq a1, t0, exit                # if b == 1 go to exit

    addi sp, sp, -4
    sw ra, 0(sp)

    addi sp, sp, -8
    sw a0, 0(sp)
    sw a1, 4(sp)

    
    jal dot_product_recursive

    lw a0, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 8

    lw ra, 0(sp)
    addi sp, sp, 4
    
    jr ra


    
exit:
    # return a[0]*b[0]
    mul x25, a0, a1
    mv ra, x25
    jr ra