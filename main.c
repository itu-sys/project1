#include <stdio.h>                            
#include <stdlib.h>
#include <string.h>

int generator(int rule, char *sequence, int length, int generation);  		// assembly fonksiyonu
int generate1d(int rule, int sequence);
void simplify(char *raw, char *destination);
int power(int base, int exponent);


int main() {

    FILE *pFile;
    char buffer[10],fileName[25];
    int rule,generation;
    printf("Dosya adi:");
    scanf("%s",fileName);
    pFile = fopen(fileName, "r"); 			// dosya adı okundu
    fgets(buffer, 11, pFile);				// ilk satırdan rastgele uzunluktaki bit dizisinin uzunluğu okundu 
    char sequence[atoi(buffer)*2+1];			// bit dizisi kadar yer açıldı boşluk karakteri de dahil
    char binary[atoi(buffer)];  			// simplify edilmiş bit dizisi burda tutulacak
    fgets(sequence,atoi(buffer)*2+1, pFile);		// bit dizisi alındı
    fclose(pFile);    
   
    printf("Rule->");    
    scanf("%d",&rule);
    printf("Generation->");    
    scanf("%d",&generation);
        
    simplify(sequence, binary);				// bit dizisindeki boşluk karakterleri silindi
    
    generator(rule, binary, atoi(buffer), generation);				// assembly code çağrıldı
   

    return 0;
}

void simplify(char *raw, char *destination) {  		//boşluklardan kurtarıyor sequence
    int j = 0;
    for (int i = 0; i < strlen(raw); ++i) {
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