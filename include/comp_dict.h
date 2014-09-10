#define DICT_SIZE 3919

#define A 1451 // a prime
#define B 6131 // another prime

union _literal_t
{
   int int_value;
   float float_value;
   char char_value;
   char *string_value;
   char bool_value;
};

typedef union _literal_t literal_t;

struct _comp_dict_item_t
{
    char *key;
    literal_t symbol;
    int type;
    int last_seen;
    struct _comp_dict_item_t *next;
};

typedef struct _comp_dict_item_t comp_dict_item_t;

unsigned int dict_hash(char *s);
unsigned int dict_index(char *key);
void dict_print();
void dict_free();
int get_symbol_line(char *key, int type);
void add_or_update_symbol_line(char *lexeme, int symbol_length, int type, int line);

extern comp_dict_item_t *symbols[DICT_SIZE];
