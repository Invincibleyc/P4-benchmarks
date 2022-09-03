#include <stdio.h>

void main(){

	long double i = 1.0 / (2 << 24);

	printf("\n%Le\n", i);
}
