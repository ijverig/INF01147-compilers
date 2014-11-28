struct _comp_identifier_item
{
    char *string;
    int kind;
    int type;
    int size;
    struct _comp_identifier_item *next;
};

typedef struct _comp_identifier_item comp_identifier_item;

comp_identifier_item **identifier_table_create();
void identifier_table_print(comp_identifier_item *identifiers[DICT_SIZE]);
void identifier_table_free(comp_identifier_item *identifiers[DICT_SIZE]);
comp_identifier_item *identifier_table_get(comp_identifier_item *identifiers[DICT_SIZE], char *string);
void identifier_table_add(comp_identifier_item *identifiers[DICT_SIZE], char *string, int kind, int type, int size);
