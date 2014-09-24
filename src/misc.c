#include <stdarg.h>
#include "main.h"
#include "misc.h"

extern int yylineno;

int getLineNumber(void)
{
	return yylineno;
}

void yyerror(char *s, ...)
{
	va_list args;
	va_start(args, s);
	fprintf(stderr, "line %d: ", getLineNumber());
	vfprintf(stderr, s, args);
	fprintf(stderr, "\n");
	va_end(args); 
}

void main_init(int argc, char **argv)
{
	ast = make_node("program");
	comp_tree_t *n1_1 = make_node("1-1");
	add_child(ast, n1_1);
	comp_tree_t *n2_11 = make_node("2-1.1");
	add_child(n1_1, n2_11);
	comp_tree_t *n3_111 = make_node("3-1.1.1");
	add_child(n2_11, n3_111);
	comp_tree_t *n3_112 = make_node("3-1.1.2");
	add_sibling(n3_111, n3_112);
	comp_tree_t *n1_2 = make_node("1-2");
	add_sibling(n1_1, n1_2);
	comp_tree_t *n2_21 = make_node("2-2.1");
	add_child(n1_2, n2_21);
	comp_tree_t *n2_22 = make_node("2-2.2");
	add_sibling(n2_21, n2_22);
	comp_tree_t *n3_221 = make_node("3-2.2.1");
	add_child(n2_22, n3_221);
	comp_tree_t *n3_222 = make_node("3-2.2.2");
	add_sibling(n3_221, n3_222);
	comp_tree_t *n3_223 = make_node("3-2.2.3");
	add_sibling(n3_222, n3_223);
	comp_tree_t *n1_3 = make_node("1-3");
	add_sibling(n1_2, n1_3);
}

void main_finalize(void)
{
	// dict_print();
	tree_print(ast);
	dict_free();
}
