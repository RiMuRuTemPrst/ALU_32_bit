#include <stdio.h>

// Hàm in mã nhị phân của số nguyên 32 bit
void printBinary(signed int number) {
    for (int i = 31; i >= 0; i--) {
        // In bit thứ i
        printf("%d", (number >> i) & 1);
        if (i % 4 == 0) {
            printf("");  // In khoảng trắng sau mỗi 4 bit cho dễ đọc
        }
    }
    printf("\n");
}

void calculate (signed int a, signed int b)
{
    printf("A = %d\n", a);
    printBinary(a);
    printf("B = %d\n", b);
    printBinary(b);

    printf("And \n");
    printBinary(a & b);

    printf("Or \n");
    printBinary(a | b);

    printf("Xor \n");
    printBinary(a ^ b);

    printf("Not \n");
    printBinary(~a);

    printf(" Neg A\n");
    printBinary(-a);

    printf(" Neg B\n");
    printBinary(-b);

    printf("+\n");
    printBinary(a + b);

    printf("-\n");
    printBinary(a - b);

    printf("x\n");
    printBinary(a * b);

    printf("/\n");
    printBinary(a / b);

    printf("Remainder\n");
    printBinary(a % b);

}

int main() {
    signed int a;
    signed int b;

    calculate( 2147483647  , 1);




    return 0;
}
