#define BUFSIZE 128

#define P(_str) printf("\n%s\n", _str);
#define P_ERR(_str) printf("\nError: %s\n", _str);

#define PRINT_COUNTERS\
    printf("-----------------------\n");\
    for(i = 0; i < 4; ++i)\
    {\
        printf("counter[%d] = %u\n", i, counters[i]);\
    }

#define RESET_COUNTERS\
    for(i = 0; i < 4; ++i)\
    {\
        counters[i] = 0;\
    }


int get_counters(char* cmd, unsigned int counters[]);
void extract_number(char *str, unsigned int *array);
