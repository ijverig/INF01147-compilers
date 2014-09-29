struct _comp_tree_t
{
    int type;
    struct _comp_dict_item_t *attributes;
    struct _comp_tree_t *sibling;
    struct _comp_tree_t *child;
};

typedef struct _comp_tree_t comp_tree_t;

char *iks_type2string(int type);
void tree_print(comp_tree_t *node);
void tree_print_indented(comp_tree_t *node, int level);
comp_tree_t *make_node(int type, comp_dict_item_t *attributes);
void tree_add_child(comp_tree_t *node, comp_tree_t *child);
void add_child(comp_tree_t *node, comp_tree_t *child);
void tree_add_sibling(comp_tree_t *node, comp_tree_t *sibling);
void add_sibling(comp_tree_t *node, comp_tree_t *sibling);

extern comp_tree_t *ast;
