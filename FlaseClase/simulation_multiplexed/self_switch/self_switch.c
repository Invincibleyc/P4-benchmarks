#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include "alternate_marking.h"
#include <time.h>
#include <sys/time.h>
#define ITERATIONS 60
#define CYCLE 8
#define PHASE CYCLE/2

typedef enum state {UP, DOWN, INIT} color;

static bool verbose = false;

int main(){
    
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

	while(iter < ITERATIONS){
    
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
