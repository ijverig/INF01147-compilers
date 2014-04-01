#include "main.h"

void yyerror (char const *mensagem)
{
  fprintf (stderr, "%s\n", mensagem); //altere para que apareça a linha
}

int main (int argc, char **argv)
{
  gv_init(NULL);
  int resultado = yyparse();
  gv_close();
  return resultado;
}
