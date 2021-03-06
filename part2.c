#include <stdio.h>                            
#include <stdlib.h>
#include <string.h>

int generator(char* rule, char *sequence, int row, int column);  		// assembly fonksiyonu
void simplify(char *raw, char *destination);
int power(int base, int exponent);
void simply(char *raw, char *row, char *column); 

int main() {

    FILE *ruleFile,*inputFile;

    char buffer[65],rule[33];
    ruleFile = fopen("rule2d.txt", "r"); 			
    fgets(buffer, 65, ruleFile);
    simplify(buffer,rule);				
    
    int row,column,k=0;
    inputFile = fopen("input2d.txt", "r"); 			
    fscanf(inputFile, "%d",&row );
    fscanf(inputFile, "%d",&column );
    char buf[column*2],inp[column+1],input[100]=""; 
	   
   while(fgets(buf, column*2, inputFile)){
	simplify(buf,inp);
	strcat(input,inp);
	k++;

   }
        //printf("%s",input);
	//generator(int rule, char *inp, int row, int column);
	
    fclose(inputFile);
    fclose(ruleFile);

    printf("%s\r\n", rule);
    printf("%s\r\n", input);
    printf("%d\r\n", row);
    printf("%d\r\n", column);

    generator(rule, input, row, column);
    return 0;
}


void simplify(char *raw, char *destination) {  		
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


