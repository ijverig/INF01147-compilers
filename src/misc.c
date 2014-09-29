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
}

void main_finalize(void)
{
	tree_free(ast);
	dict_free();
}
