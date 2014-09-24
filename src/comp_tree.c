#include <stdlib.h>
#include <string.h>
#include "main.h"

comp_tree_t *ast;

void tree_print(comp_tree_t *node)
{
	tree_print_with_level(node, 0);
}

void tree_print_with_level(comp_tree_t *node, int level)
{
	if (node != NULL)
	{
		int l;
		for (l = 0; l < level; ++l)
		{
			printf("    ");
		}
		printf("%s\n", node->label);
		
		tree_print_with_level(node->child, level + 1);
		tree_print_with_level(node->sibling, level);
	}
}

comp_tree_t *make_node(char *label)
{
	comp_tree_t *node = (comp_tree_t *) malloc(sizeof(comp_tree_t));
	
	node->label = label;
	// node->child = NULL;
	// node->sibling = NULL;
	
	return node;
}

void add_child(comp_tree_t *node, comp_tree_t *child)
{
	node->child = child;
}

void add_sibling(comp_tree_t *node, comp_tree_t *sibling)
{
	node->sibling = sibling;
}
