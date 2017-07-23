/* *
 * Beregovoe. 09 aug 2008. 22:34
 * DeXPeriX
 * http://dexperix.net
 * */

#define MAX_LEN 2000
#define MAX_REGISTERS 2000
#define MAGIC 20

#include <stdio.h>
#include <string.h>
#include <math.h>


int getline(char *s, int lim) {
    char *t;
    int c;

    t = s;
    while (--lim>1 && (c=getchar()) != EOF && c != '\n')
        *s++ = c;
    if (c == '\n')
        *s++ = c;
    else if (lim == 1) {
		*s++ = '\n';
		fprintf(stderr, "WARNING. getline: Line too long, splitted.\n");
    }
    *s = '\0';
    return s - t;
}


int main (int argc, char **argv){

	char convStr[MAX_LEN+1]; //string to convert into brain fuck
	int registers[MAX_REGISTERS+1]; //brain fuck's processor's registors
	int regNum = 0; //it's count
	int nowReg = 0; //Now register

	memset(registers, 0, MAX_REGISTERS+1); //zero fill
	memset(convStr, 0, MAX_LEN); //zero fill

	if(argc<2){
		//Args is not OK
		//printf("Usage: %s \"text and another text\"\n", argv[0]); return 0;
		getline(convStr, MAX_LEN);
	} else {
		//Args is OK
		if( strlen(argv[1]) <= MAX_LEN ) strncpy(convStr, argv[1], strlen(argv[1]) ); //copy
		else{
			fprintf(stderr, "String is too large!");
			return 0;
		}
	}

	int nCh, nR, j; //nCh - now Character; nR - now Register; j - another circle variable

	int ChValue, nowSub, tmpSub;
	for(nCh=0; nCh < strlen(convStr); nCh++){ //Make registers

		ChValue = (  (int) (convStr[nCh] / 10)  ) * 10; // 148->140, 73->70 etc

		if(regNum==0){ //Add one register, if empty
			regNum = 1;
			registers[0] = ChValue;
		}

		nowSub = fabs( registers[0] - (int) convStr[nCh] ); //First register value - current value

		for(nR=0; nR < regNum; nR++){ //Find perfect register
			tmpSub = fabs(registers[nR] - (int) convStr[nCh]); 
			if( tmpSub < nowSub ) nowSub = tmpSub; 
		}

		if( (nowSub > MAGIC) && (ChValue > 0) ){ //If "-" is greater than constant - add register
			registers[regNum] = ChValue;
			regNum++;
		}

	}

//	for(j=0; j< regNum; j++) printf("%d ", registers[j]); return 0;


	//Physically makes the registers
	printf("++++++++++[>"); //brain fuck does 10 circles
	for(nR=0; nR < regNum; nR++){
		for(j=0; j < (int) (registers[nR] / 10); j++) putchar('+'); //registers are 10-normied
		if(nR < regNum-1) putchar('>'); //do not need print ">" with last register
	}
	for(nR=0; nR < regNum; nR++) //prints closing "<"
		putchar('<');
	printf("-]>"); //end of bf circle

	
	int selectedReg; //Selected register for action
	//Main string brute circle
	for(nCh=0; nCh < strlen(convStr); nCh++){
		nowSub = fabs(registers[0]-convStr[nCh]); //Best subsidion
		selectedReg = 0;
		for(nR=0; nR < regNum; nR++){
			tmpSub = fabs(registers[nR]-convStr[nCh]);
			if(tmpSub<nowSub){ //If tmp is better than now - do it
				nowSub = tmpSub;
				selectedReg = nR; //remember this tag
			}
		}
		//jumps from current to selected register
		if(selectedReg>nowReg){
			for(j=nowReg; j<selectedReg; j++) putchar('>');
		} else {
			for(j=selectedReg; j<nowReg; j++) putchar('<');
		}

		//Increase or decrease needed register
		for(j=0; j<nowSub; j++)
			if(convStr[nCh]>registers[selectedReg]) putchar('+');
				else putchar('-');

		putchar('.');


		registers[selectedReg]=convStr[nCh];
		nowReg = selectedReg;
	}


	return 0;
}

