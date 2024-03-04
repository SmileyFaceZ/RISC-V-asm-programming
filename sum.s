# #include <stdio.h>

# int arr1[10];
# int arr2[10];

# int main()
# {

#     int size=10, i, sum1 = 0, sum2 = 0;

#     for(i = 0; i < size; i++)
#         arr1[i] = i + 1;

#     for(i = 0; i < size; i++)
#         arr2[i] = 2*i;

#     for(i = 0; i < size; i++) {
#         sum1 = sum1 + arr1[i];
#         sum2 = sum2 + arr2[i];
#     }

#     printf("%d\n", sum1);
#     printf("%d\n", sum2);

#     return 0;
# }

.data
arr1:       .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0
arr2:       .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0
new_line:   .string "\n"


.text
main:
    # Registers NOT to be used x0-x4 and x10-x17
    # Registers that we can use x5-x9 and x18-x31

    # int size=10, i, sum1 = 0, sum2 = 0;

    addi x5, x0, 10             # Let x5 be size and set it to 10
    addi x6, x0, 0              # Let x6 be sum1 and set it to 0
    addi x7, x0, 0              # Let x7 be sum2 and set it to 0

    # for(i = 0; i < size; i++)

    addi x8, x0, 0              # Let x8 be i    and set it to 0
    la x9, arr1                 # Loading the address of arr1 to x9

LOOP1:
    bge x8, x5, EXIT1           # If x8 >= x5 go to EXIT1 label

        # arr1[i] = i + 1;
    # We need to calculate &arr[i]

    # We need the base address of arr1, then we add an offset of i*4 to the base address
    slli x18, x8, 2             # Set x18 to i*4
    add x19, x18, x9            # Add i*4 to the base address of arr1 and put it to x19
    addi x20, x8, 1             # Set x20 to i + 1
    sw x20, 0(x19)              # arr1[i] = i + 1
    addi x8, x8, 1              # i++
    j LOOP1

EXIT1:
    addi x8, x0, 0              # Let x8 be i    and set it to 0
    la x21, arr2                # Loading the address of arr2 to x21

    # for(i = 0; i < size; i++)

LOOP2:
    bge x8, x5, EXIT2           # If x8 >= x5 go to EXIT1 label

        # arr2[i] = 2*i;
    # We need to calculate &arr[i]

    # We need the base address of arr1, then we add an offset of i*4 to the base address
    slli x18, x8, 2             # Set x18 to i*4
    add x19, x18, x21           # Add i*4 to the base address of arr2 and put it to x19
    add x20, x8, x8             # Set x20 to i*2 (i + i)
    sw x20, 0(x19)              # arr2[i] = i*2
    addi x8, x8, 1              # i++
    j LOOP2

EXIT2:

    # for(i = 0; i < size; i++)
    addi x8, x0, 0              # Let x8 be i    and set it to 0

LOOP3:
    bge x8, x5, EXIT3
        # sum1 = sum1 + arr1[i];
    slli x18, x8, 2             # Set x18 to i*4
    add x19, x18, x9            # Add i*4 to the base address of arr1 and put it to x19
    lw x20, 0(x19)              # x20 has arr1[i]
    add x6, x6, x20             # sum1 = sum1 + arr1[i]
        # sum2 = sum2 + arr2[i];
    add x19, x18, x21           # Add i*4 to the base address of arr1 and put it to x19
    lw x20, 0(x19)              # x20 has arr2[i]
    add x7, x7, x20             # sum2 = sum2 + arr2[i]

    addi x8, x8, 1              # i++
    j LOOP3

EXIT3:
    # printf("%d\n", sum1);
    li a0, 1
    mv a1, x6
    ecall

    li a0, 4
    la a1, new_line
    ecall

    # printf("%d\n", sum2);
    li a0, 1
    mv a1, x7
    ecall

    # return 0
    li a0, 10
    ecall
