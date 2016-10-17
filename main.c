// TODO

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int generator(int rule, char *sequence);
int generate1d(int rule, int sequence);
int convertToDecimal(char *binary);
void simplify(char *raw, char *destination);
int power(int base, int exponent);

int main() {
    FILE *pFile;
    char buffer[3];
    int rule, decimalSeq;
    char sequence[64];
    char binary[32];

    char selam[] = "selam\r\n";

    pFile = fopen("input1d.txt", "r");
    fgets(buffer, 4, pFile);
    fgets(sequence, 70, pFile);
    fclose(pFile);

    rule = atoi(buffer);

    simplify(sequence, binary);
    decimalSeq = convertToDecimal(binary);
    printf("%d\r\n", rule);
    //printf("%s\r\n", sequence);
    generator(rule, binary);

    return 0;
}

int convertToDecimal(char *binary) {
    int length = strlen(binary);
    int value = 0;
    for (int i = 0; i < length; ++i) {
        if(binary[length-1 - i] == '1') {
            value += power(2, i);
        }
    }
    return value;
}

void simplify(char *raw, char *destination) {
    int j = 0;
    for (int i = 0; i < 64; ++i) {
        if(raw[i] != '0' && raw[i] != '1') {
            continue;
        }
        else {
            destination[j++] = raw[i];
        }
    }
    destination[j] = 0;
}

int power(int base, int exponent) {
    if(exponent == 0) return 1;

    int value = base;
    for (int i = 1; i < exponent; ++i) {
        value *= base;
    }
    return value;
}
