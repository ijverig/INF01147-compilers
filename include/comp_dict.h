#define DICT_SIZE 3919
#define A 1451 /* a prime */
#define B 6131 /* another prime */

struct _comp_dict_item_t
{
    char *symbol;
    int last_seen;
    struct _comp_dict_item_t *next;
};

typedef struct _comp_dict_item_t comp_dict_item_t;

unsigned dict_hash(unsigned char *str);
int dict_index(char *key);
void dict_print();
int get_symbol_line(char *symbol);
void add_or_update_symbol_line(char *symbol, int line);

extern comp_dict_item_t *symbols[DICT_SIZE];
