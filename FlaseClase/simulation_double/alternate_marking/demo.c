#include <stdio.h>
#include <unistd.h>

#include  <stdio.h>
#include  <string.h>
#include  <sys/types.h>

#define   MAX_COUNT  200
#define   BUF_SIZE   100

void  main(void)
{
    pid_t pid = getpid();
    printf("I'm the father with pid: %d\n", pid);
    int rc;
     rc = fork();
    if(rc > 0 ){ /* Father. */
	pid = getpid();
	printf("I'm the father with pid: %d\n", pid);
    }else if(rc == 0){
	pid = getpid();
	printf("I'm the son with pid: %d\n", pid);
    }else{
	printf("Error");
    }
}
