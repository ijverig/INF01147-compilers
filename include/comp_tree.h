struct _comp_tree_t
{
    char *label;
    struct _comp_tree_t *sibling;
    struct _comp_tree_t *child;
};

typedef struct _comp_tree_t comp_tree_t;

void tree_print(comp_tree_t *node);
void tree_print_indented(comp_tree_t *node, int level);
comp_tree_t *make_node(char *label);
void tree_add_child(comp_tree_t *node, comp_tree_t *child);
void add_child(comp_tree_t *node, comp_tree_t *child);
void tree_add_sibling(comp_tree_t *node, comp_tree_t *sibling);
void add_sibling(comp_tree_t *node, comp_tree_t *sibling);

extern comp_tree_t *ast;
