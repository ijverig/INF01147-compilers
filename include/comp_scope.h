struct _comp_scope
{
    struct _comp_identifier_item **identifiers;
    struct _comp_scope *previous;
};

typedef struct _comp_scope comp_scope;

void scope_push();
void scope_pop();

// current_scope is global
extern comp_scope *current_scope;
