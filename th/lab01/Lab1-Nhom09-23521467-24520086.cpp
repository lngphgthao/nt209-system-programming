#include <stdio.h>

// 1.1 negative(x): tra ve -x
int negative(int x)
{
    return (~x) + 1;
}

// 1.2 cal50x(x): tra ve x * 50
int cal50x(int x){
    return (x << 5) + (x << 4) + (x << 1);
}

// 1.3 getByte(x, n): lay byte thu n (0-indexed, tu phai sang trai) cua x
int getByte(int x, int n)
{
    return (x >> (n << 3)) & 0xFF;
}

// 1.4 flipByte(x, n): dao nguoc (flip) tat ca 8 bit cua byte thu n trong x
int flipByte(int x, int n) {
    return x ^ (0xFF << (n << 3));
}

// 1.5 divpw2(x, n): tinh x / 2^n (n >= 0: chia, n < 0: nhan)
int divpw2(int x, int n) {
    int mask = n >> 31;               
    int negN = ~n + 1;                  
    int bias = (x >> 31) & ((1 << n) + ~0); 

    int divRes = (x + bias) >> n;       
    int mulRes = x << negN;             

    return (mulRes & mask) | (divRes & ~mask);
}

// 2.1 isOpposite(x, y): kiem tra x va y la 2 so doi nhau (x = -y)
int isOpposite(int x, int y) {
    return !(x ^ (~y + 1)) & !!((x | y));
}

// 2.2 is16x(x): kiem tra x la boi so cua 16
int is16x(int x) {
    return !(x & 0xF);
}

// 2.3 isPositive(x): kiem tra x > 0, tra ve 0 neu x <= 0
int isPositive(int x) {
    return !!x & !(x >> 31);
}

//2.4 isGE2n(x, n): kiem tra x >= 2^n
int isGE2n(int x, int n) {
    return !!(x >> n);
}

int main()
{
    int score = 0;
    // 1.1
    printf("1.1 negative");
    if (negative(0) == 0 && negative(9) == -9 && negative(-5) == 5)
    {
        printf("\tPass.");
        score += 1;
    }
    else
        printf("\tFailed.");

    //1.2
    printf("\n1.2 cal50x");
    if (cal50x(0) == 0 && cal50x(10) == 500 && cal50x(-5) == -250)
    {
        printf("\tPass.");
        score += 1;
    }
    else
        printf("\tFailed.");

    //1.3
    printf("\n1.3 getByte");
    if (getByte(26,0) == 0x1A  && getByte(0x11223344,1) == 0x33)
    {
        printf("\tPass.");
        score += 2;
    }
    else
        printf("\tFailed.");

    //1.4
    printf("\n1.4 flipByte");
    if (flipByte(10,0)==245 && flipByte(0,1)==65280 && flipByte(0x5501,1)==0xaa01)
    {
        printf("\tPass.");
        score += 2;
    }
    else
        printf("\tFailed.");

    //1.5
    printf("\n1.5 divpw2");
    if (divpw2(0xfffffff, -4) == 0xfffffff0 && divpw2(15, -2) == 60 && divpw2(2, -4) == 32)
    {
        if (divpw2(10, 1) == 5 && divpw2(50, 2) == 12)
        {
            printf("\tAdvanced Pass.");
            score += 4;
        }
        else
        {
            printf("\tPass.");
            score += 3;
        }
    }
    else
        printf("\tFailed.");

    //2.1
    printf("\n2.1 isOpposite");
    if (isOpposite(4,4)==0 &&  isOpposite(-2,2)==1 && isOpposite(5,-6)==0 && isOpposite(0,0)==0)
    {
        printf("\tPass.");
        score += 2;
    }
    else
        printf("\tFailed.");

    //2.2
    printf("\n2.2 is16x");
    if (is16x(16) == 1 && is16x(23) == 0 && is16x(0) == 1)
    {
        printf("\tPass.");
        score += 2;
    }
    else
        printf("\tFailed.");

    //2.3
    printf("\n2.3 isPositive");
    if (isPositive(16) == 1 && isPositive(0) == 0 && isPositive(-8) == 0)
    {
        printf("\tPass.");
        score += 3;
    }
    else
        printf("\tFailed.");

    //2.4
    printf("\n2.4 isGE2n");
    if (isGE2n(15,1)==1 && isGE2n(8,3)==1 && isGE2n(12,4)==0)
    {
        printf("\tPass.");
        score += 3;
    }
    else
        printf("\tFailed.");

    printf("\n------\nYour score: %.1f", (float)score / 2);
    return 0;
}