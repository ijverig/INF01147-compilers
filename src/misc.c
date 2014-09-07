#include "misc.h"

extern int yylineno;

int getLineNumber(void)
{
	return yylineno;
}

void yyerror(char *s)
{
	fprintf(stderr, "line %d: %s\n", getLineNumber(), s);
}

void main_init(int argc, char **argv)
{
}

void main_finalize(void)
{
	// dict_print();
	dict_free();
}
