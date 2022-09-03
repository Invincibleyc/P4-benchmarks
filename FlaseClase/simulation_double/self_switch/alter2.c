#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include "alternate_marking.h"
#include <time.h>
#include <sys/time.h>
#include <pthread.h>

#define ITERATIONS 60
#define CYCLE 8
#define PHASE CYCLE/2

typedef enum state {UP, DOWN, INIT} color;

void ts_handler(unsigned long ts);
void delta_ts_handler(unsigned long ts0, unsigned long ts1);
int get_regiters(char* cmd, unsigned long registers[]);
void extract_number_reg(char *str, unsigned long *array);
void* delay(void* useless);
void* loss(void* useless);


static bool verbose = false;
static long double histo = 0.0;


int main(){


    return 0;
}

void* loss(void* useless){
    
    time_t sample;
    int iter = 0;
	unsigned int counters[4] = {0,0,0,0};
	unsigned int history[4] = {0,0,0,0};
	unsigned int base[4] = {0,0,0,0};
    color s = INIT;

	printf("Alternate Marking...\n");
	system("./../reset_counters.sh");
    
    if(get_counters("./../read_counters_line.sh", counters) == -1)
    {P_ERR("get_counters function failed.")}

    /*  Detect when we switch to color on '0'. */
    while(s == INIT){
        sleep(1);
        HISTORY_COUNTERS
        RESET_COUNTERS
        if(get_counters("./../read_counters_line.sh", counters) == -1)
            {P_ERR("get_counters function failed.")}
       if( verbose ) {  PRINT_HISTORY }
        /* Only UP grow. */
        if( counters[0] > history[0] &&  counters[1] > history[1] &&
        counters[2] == history[2] &&  counters[3] == history[3] ){
            s = UP;
        } 
    } 
    if( verbose ) { P("Coloring on '0' detected.") }
    /* Start to color on '0' --> reset the '1' coloring. */
    base[2] = counters[2];
    base[3] = counters[3];


    /* Detect when we switch to count '1' */
    while(s == UP){
        sleep(1);
        HISTORY_COUNTERS
        RESET_COUNTERS
        if(get_counters("./../read_counters_line.sh", counters) == -1)
            {P_ERR("get_counters function failed.")}
       if( verbose ) { PRINT_HISTORY }
        /* Only DOWN grow. */
        if( counters[2] > history[2] && counters[3] > history[3] ){
            s = DOWN;
        } 
    } 
    if( verbose ) { P("Coloring on '1' detected.") }
    /* Start to color on '0' --> reset the '0' coloring. */
    base[0] = counters[0];
    base[1] = counters[1];

    /* Start a two simetric phase function. Wait until the non-changing color 
     * start to grow. Print the other color's counter and update history. Wait 
     * until the next color changes at repeat the process. */

	while(iter < ITERATIONS/CYCLE){
    
        /*  Detect when we switch to color on '0'. */
        while(s == DOWN){
            sleep(1);
            HISTORY_COUNTERS
            RESET_COUNTERS
            if(get_counters("./../read_counters_line.sh", counters) == -1)
                {P_ERR("get_counters function failed.")}
  if( verbose )     {      PRINT_HISTORY }
            /* Only UP grow. */
            if( counters[0] > history[0] && counters[1] > history[1] ){
                s = UP;
            }
        } 
	 if( verbose ){printf("Color - '1'\n");
  	       printf("Sent '1' was of %u datagrams.\n", counters[2]-base[2]);
  	       printf("Received '1' was of %u datagrams.\n", counters[3]-base[3]); }
	if(counters[2] != 0){
		printf("Cycle packet loss: %lf%%\n",(( (double)counters[2]-
    						      (double)base[2]-
                                	              (double)counters[3]+
						      (double)base[3] ) /
					  	    ( (double)counters[2]-
						      (double)base[2] )) * 100.0);
	}
        base[2] = counters[2];
        base[3] = counters[3];
        
        /*  Detect when we switch to color on '1'. */
        while(s == UP){
            sleep(1);
            HISTORY_COUNTERS
            RESET_COUNTERS
            if(get_counters("./../read_counters_line.sh", counters) == -1)
                {P_ERR("get_counters function failed.")}
         if( verbose ) {   PRINT_HISTORY }
            /* Only UP grow. */
            if( counters[2] > history[2] && counters[3] > history[3] ){
                s = DOWN;
            }
        } 
	 if( verbose ){printf("Color - '0'\n");
  	       printf("Sent '0' was of %u datagrams.\n", counters[0]-base[0]);
	       printf("Received '0' was of %u datagrams.\n", counters[1]-base[1]); }
	if(counters[0] != 0){
		printf("Cycle packet loss: %lf%%\n",(( (double)counters[0]-
    						      (double)base[0]-
                                	              (double)counters[1]+
						      (double)base[1] ) /
					  	    ( (double)counters[0]-
						      (double)base[0] )) * 100.0);
	}
        base[0] = counters[0];
        base[1] = counters[1];

	}
    return NULL;
}


int get_counters(char* cmd, unsigned int counters[]) {

    char buf[BUFSIZE];
    FILE *fp;
    int i;

    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }
    fgets(buf, BUFSIZE, fp);

    extract_number(buf, counters);

    if(pclose(fp))  {
        printf("Command not found or exited with error status\n");
        return -1;
    }

    return 0;
}

void extract_number(char *str, unsigned int *array){
    int i, j = 0;
    for(i = 0; i < 4; ++i){
	while(str[j] != '\0'){
	    if(str[j] != ','){
	        array[i] = array[i]*10 + str[j] - 48;
		j++;
	    }else{
		j++;
		break;
	    }
	}
    }
}





/* This function is all about wraping a loop for calling each second the 
 * get_registers function. */
void* delay(void* useless){
    
	int iter = 0;
	long unsigned* registers = (long unsigned*)malloc(2*sizeof(long unsigned));
	//registers[0] = 0;
	//registers[1] = 0;
	RESET_REGISTERS
	printf("Alternate Marking...\n");
    
	while(iter < ITERATIONS){
	if( verbose ){ printf("Iteration: %d ------------\n", iter); }
    
            RESET_REGISTERS
            if(get_regiters("./../read_registers_line.sh", registers) == -1)
                {P_ERR("get_counters (registers) function failed.")}
            sleep(1);
	iter++;
	}
	free(registers);

	return NULL;
}




/* This function use popen to wrap the bash script that gets the data from the
 * registers. Next it transfer the given time stamps to be printed. */
int get_regiters(char* cmd, unsigned long registers[]) {

    char buf[BUFSIZE];
    FILE *fp;
    int i;

    if ((fp = popen(cmd, "r")) == NULL) {
        printf("Error opening pipe!\n");
        return -1;
    }
    fgets(buf, BUFSIZE, fp);

    extract_number_reg(buf, registers);
 if( verbose ){    ts_handler(registers[0]); }
 if( verbose ){    ts_handler(registers[1]); }
    delta_ts_handler(registers[0], registers[1]);


    if(pclose(fp))  {
        printf("Command not found or exited with error status\n");
        return -1;
    }

    return 0;
}




/* This function is about turning a number represented by a 64 bit to 2 numbers
 * represented each by an unsigned long and printing them.
 * It gets a time stamp (unsigned long) and preform the following: 
 * right --> The right 32 bit of the 64 bit input number representing the 
 *           fraction of seconds.
 * whole --> The left 32 bit of the 64 bit input number representing the
 * 	     whole part.
 * The printing of the fraction is with %Le physics kind of printing. */
void ts_handler(unsigned long ts){
    int i;
    unsigned long right = ts % ((unsigned long)2 << 32);
    unsigned long whole = ts >> 32;
    long double fraction = 0;

    // Don't care about 2^(-24) and lower resolution.	
    right = right >> 8;
    for(i = 24; i > 0; i--){
	if((right % 2) == 1){
            unsigned long tmp = (unsigned long)1 << i;
	    fraction += (long double)1 / tmp;
	}
	right = right >> 1;
    }
    printf("%lu.%Le\n\n", whole, fraction);
}




void delta_ts_handler(unsigned long ts0, unsigned long ts1){
    int i;
    unsigned long right0 = ts0 % ((unsigned long)2 << 32);
    unsigned long whole0 = ts0 >> 32;
    long double fraction0 = 0;

    // Don't care about 2^(-24) and lower resolution.	
    right0 = right0 >> 8;
    for(i = 24; i > 0; i--){
	if((right0 % 2) == 1){
            unsigned long tmp0 = (unsigned long)1 << i;
	    fraction0 += (long double)1 / tmp0;
	}
	right0 = right0 >> 1;
    }
    

    unsigned long right1 = ts1 % ((unsigned long)2 << 32);
    unsigned long whole1 = ts1 >> 32;
    long double fraction1 = 0;

    // Don't care about 2^(-24) and lower resolution.	
    right1 = right1 >> 8;
    for(i = 24; i > 0; i--){
	if((right1 % 2) == 1){
            unsigned long tmp1 = (unsigned long)1 << i;
	    fraction1 += (long double)1 / tmp1;
	}
	right1 = right1 >> 1;
    }
    long double tmp = whole1 - whole0 + fraction1 - fraction0; 
    if( whole1 - whole0 >= 0 && tmp < 20 && tmp != histo ){  
	    printf("Cycle delay is: %Le seconds.\n", tmp);
	    histo = tmp;
	    if( verbose ){ printf("%lu.%Le\n\n", whole1 - whole0, fraction1 - fraction0); } 
    }
}





/* This function get a string containing a two numbers separeated by a comma.
 * It returns two unsigned integers (stacked in a signel array). */
void extract_number_reg(char *str, unsigned long *array){
    int i, j = 0;
    for(i = 0; i < 2; ++i){
	while(str[j] != '\0'){
	    if(str[j] != ','){
	        array[i] = array[i]*10 + str[j] - 48;
		j++;
	    }else{
		j++;
		break;
	    }
	}
    }
}





