#ifndef __MISC_H
#define __MISC_H
#include <stdio.h>

int getLineNumber(void);
void yyerror(char *s);
void main_init(int argc, char **argv);
void main_finalize(void);

#endif
