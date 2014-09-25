#include <stdlib.h>
#include <string.h>
#include "main.h"

comp_tree_t *ast;

void tree_print(comp_tree_t *node)
{
	tree_print_indented(node, 0);
}

void tree_print_indented(comp_tree_t *node, int level)
{
	if (node != NULL)
	{
		int l;
		for (l = 0; l < level; ++l)
		{
			printf("    ");
		}
		printf("%s\n", node->label);
		
		tree_print_indented(node->child, level + 1);
		tree_print_indented(node->sibling, level);
	}
}

comp_tree_t *make_node(char *label)
{
	comp_tree_t *node = (comp_tree_t *) malloc(sizeof(comp_tree_t));
	
	node->label = label;
	node->child = node->sibling = NULL;
	
	return node;
}

void tree_add_child(comp_tree_t *node, comp_tree_t *child)
{
	node->child = child;
}

void add_child(comp_tree_t *node, comp_tree_t *child)
{
	if (node->child == NULL)
	{
		tree_add_child(node, child);
	}
	else
	{
		add_sibling(node->child, child);
	}
}

void tree_add_sibling(comp_tree_t *node, comp_tree_t *sibling)
{
	node->sibling = sibling;
}

void add_sibling(comp_tree_t *node, comp_tree_t *sibling)
{
	if (node->sibling == NULL)
	{
		tree_add_sibling(node, sibling);
	}
	else
	{
		tree_add_sibling(node->sibling, sibling);
	}
}

void tree_free(comp_tree_t *node)
{
	if (node != NULL)
	{
		tree_free(node->child);
		tree_free(node->sibling);

		free(node);
	}
}
