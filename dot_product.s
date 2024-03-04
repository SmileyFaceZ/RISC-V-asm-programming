# #include <stdio.h>

# int a[5] = {1, 2, 3, 4, 5};
# int b[5] = {6, 7, 8, 9, 10};

# int main() {
#     int i, sop = 0;

#     for (i = 0; i < 5; i++) {
#         sop += a[i] * b[i];
#     }

#     printf("The dot product is: %d\n", sop);
#     return 0;
# }

.data
a:  .word   1, 2, 3, 4, 5
b:  .word   6, 7, 8, 9, 10
output: .string "The dot product is: "
new_line: .string "\n"

.text
main:
    # Registers NOT to be used x0-x4 and x10-x17
    # Registers that we can use x5-x9 and x18-x31

    li x5, 5            # x5 = size = 5
    li x6, 0            # x6 = sop
    li x7, 0            # x7 = i

    la x8, a            # Loading the address of a[] to x8
    la x9, b            # Loading the address of b[] to x9

LOOP:
    bge x7, x5, EXIT

    slli x18, x7, 2             # Set x18 to i*4
    add x19, x18, x8            # Add i*4 to the base address of a and put it to x19
    lw x20, 0(x19)              # x20 = a[i]

    add x22, x18, x9            # Add i*4 to the base address of a and put it to x19
    lw x23, 0(x22)              # x22 = b[i]

    mul x24, x20, x23           # x24 = a[i] * b[i]
    add x6, x6, x24             # x6 += x24

    addi x7, x7, 1               # i++

    j LOOP

EXIT:
    li a0, 4                    # Print Output Label
    la a1, output
    ecall

    la a1, new_line             # Print New linw
    ecall

    li a0, 1                    # Print sop
    mv a1, x6
    ecall

    li a0, 10
    ecall
