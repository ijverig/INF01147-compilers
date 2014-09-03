#include "misc.h"

extern int yylineno;

int getLineNumber (void)
{
  return yylineno;
}

void yyerror (char const *mensagem)
{
  fprintf (stderr, "%s\n", mensagem); //altere para que apareça a linha
}

void main_init (int argc, char **argv)
{
}

void main_finalize (void)
{
	// dict_print();
}
