#define DICT_SIZE 3919

#define A 1451 // a prime
#define B 6131 // another prime

struct _comp_dict_item_t
{
    char *symbol;
    int last_seen;
    struct _comp_dict_item_t *next;
};

typedef struct _comp_dict_item_t comp_dict_item_t;

unsigned int dict_hash(char *s);
unsigned int dict_index(char *key);
void dict_print();
void dict_free();
int get_symbol_line(char *key);
void add_or_update_symbol_line(char *key, int symbol_length, int line);

extern comp_dict_item_t *symbols[DICT_SIZE];
