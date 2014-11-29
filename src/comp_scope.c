#include <stdlib.h>
#include "main.h"

// current_scope is global
comp_scope *current_scope;

void scope_free()
{
	// free(current_scope->identifiers);
	identifier_table_free(current_scope->identifiers);
	free(current_scope);
}

void scope_push()
{
	comp_scope *new_scope = malloc(sizeof(comp_scope));

	new_scope->identifiers = identifier_table_create();
	new_scope->previous = current_scope;

	current_scope = new_scope;
}

void scope_pop()
{
	comp_scope *previous_scope = current_scope->previous;

	scope_free();

	current_scope = previous_scope;
}
