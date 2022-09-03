#define BUFSIZE 128

#define P(_str) printf("\n%s\n", _str);
#define P_ERR(_str) printf("\nError: %s\n", _str);

#define PRINT_COUNTERS\
    printf("-----------------------\n");\
    printf("      sent[0] = %u\n", counters[0]);\
    printf("  received[0] = %u\n", counters[1]);\
    printf("      sent[1] = %u\n", counters[2]);\
    printf("  received[1] = %u\n", counters[3]);\

#define PRINT_REGISTERS\
    printf("-----------------------\n");\
    printf(" sending time = %lu\n", registers[0]);\
    printf(" receiving time = %lu\n", registers[1]);\

#define RESET_COUNTERS\
    counters[0] = 0;\
    counters[1] = 0;\
    counters[2] = 0;\
    counters[3] = 0;


#define RESET_REGISTERS\
    registers[0] = 0;\
    registers[1] = 0;\

#define HISTORY_COUNTERS\
    history[0] = counters[0];\
    history[1] = counters[1];\
    history[2] = counters[2];\
    history[3] = counters[3];

#define PRINT_HISTORY\
    printf("-----------------------\n");\
    printf("history[0] = %u\n", history[0]);\
    printf("history[0] = %u\n", history[1]);\
    printf("history[1] = %u\n", history[2]);\
    printf("history[1] = %u\n", history[3]);\

#define RESET_HISTORY\
    history[0] = 0;\
    history[1] = 0;\
    history[2] = 0;\
    history[3] = 0;
int get_counters(char* cmd, unsigned int counters[]);
void extract_number(char *str, unsigned int *array);
