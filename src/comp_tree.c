#include <stdlib.h>
#include <string.h>
#include "main.h"
#include "iks_ast.h"

comp_tree_t *ast;

char *iks_type2string(int type)
{
	switch (type)
	{
		case (IKS_AST_PROGRAMA):
			return "program";
			break;
		case (IKS_AST_FUNCAO):
			return "fun";
			break;
		case (IKS_AST_IF_ELSE):
			return "if";
			break;
		case (IKS_AST_DO_WHILE):
			return "do";
			break;
		case (IKS_AST_WHILE_DO):
			return "while";
			break;
		case (IKS_AST_INPUT):
			return "input";
			break;
		case (IKS_AST_OUTPUT):
			return "output";
			break;
		case (IKS_AST_ATRIBUICAO):
			return "attribution";
			break;
		case (IKS_AST_RETURN):
			return "return";
			break;
		case (IKS_AST_BLOCO):
			return "block";
			break;
		case (IKS_AST_IDENTIFICADOR):
			return "id";
			break;
		case (IKS_AST_LITERAL):
			return "literal";
			break;
		case (IKS_AST_ARIM_SOMA):
			return "+";
			break;
		case (IKS_AST_ARIM_SUBTRACAO):
			return "-";
			break;
		case (IKS_AST_ARIM_MULTIPLICACAO):
			return "*";
			break;
		case (IKS_AST_ARIM_DIVISAO):
			return "÷";
			break;
		case (IKS_AST_ARIM_INVERSAO):
			return "-";
			break;
		case (IKS_AST_LOGICO_E):
			return "&&";
			break;
		case (IKS_AST_LOGICO_OU):
			return "||";
			break;
		case (IKS_AST_LOGICO_COMP_DIF):
			return "!=";
			break;
		case (IKS_AST_LOGICO_COMP_IGUAL):
			return "==";
			break;
		case (IKS_AST_LOGICO_COMP_LE):
			return "<=";
			break;
		case (IKS_AST_LOGICO_COMP_GE):
			return ">=";
			break;
		case (IKS_AST_LOGICO_COMP_L):
			return "<";
			break;
		case (IKS_AST_LOGICO_COMP_G):
			return ">";
			break;
		case (IKS_AST_LOGICO_COMP_NEGACAO):
			return "!";
			break;
		case (IKS_AST_VETOR_INDEXADO):
			return "array";
			break;
		case (IKS_AST_CHAMADA_DE_FUNCAO):
			return "fun_call";
			break;
	}
}

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
		
		printf("%s %s\n", iks_type2string(node->type), (node->type == IKS_AST_IDENTIFICADOR || node->type == IKS_AST_LITERAL || node->type == IKS_AST_FUNCAO) ? node->attributes->key : "");
		
		tree_print_indented(node->child, level + 1);
		tree_print_indented(node->sibling, level);
	}
}

comp_tree_t *make_node(int type, comp_dict_item_t *attributes)
{
	comp_tree_t *node = (comp_tree_t *) malloc(sizeof(comp_tree_t));
	
	node->type = type;
	node->attributes = attributes;
	node->child = node->sibling = NULL;
	
	gv_declare(type, node, (node->type == IKS_AST_IDENTIFICADOR || node->type == IKS_AST_LITERAL || node->type == IKS_AST_FUNCAO) ? node->attributes->key : NULL);
	
	return node;
}

void tree_add_child(comp_tree_t *node, comp_tree_t *child)
{
	node->child = child;
}

void add_child(comp_tree_t *node, comp_tree_t *child)
{
	if (child == NULL)
	{
		return;
	}
	
	if (node->child == NULL)
	{
		tree_add_child(node, child);
	}
	else
	{
		add_sibling(node->child, child);
	}
	
	gv_connect(node, child);
}

void tree_add_sibling(comp_tree_t *node, comp_tree_t *sibling)
{
	node->sibling = sibling;
}

void add_sibling(comp_tree_t *node, comp_tree_t *sibling)
{
	if (sibling == NULL)
	{
		return;
	}
	
	if (node->sibling == NULL)
	{
		tree_add_sibling(node, sibling);
	}
	else
	{
		add_sibling(node->sibling, sibling);
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
