/*
 * grupo: cc
 *
 * membros:
 *    - Daniel Schmidt
 *    - Matheus Cardoso
 *
 */

%option noyywrap
%option yylineno

%{

#define YYSTYPE comp_dict_item_t *

#include "main.h"

%}

%x ML_COMMENT

   /* comments */
COMMENT           "//".*\n

   /* special characters */
SPECIAL           [,;:()[\]{}+\-*/<>=!&$]

   /* literals */
L_INT             [[:digit:]]+
L_FLOAT           [[:digit:]]+"."[[:digit:]]+
L_CHAR            '.'
L_STRING          \"[^"]*\"

   /* identifiers */
ID                [[:alpha:]_][[:alnum:]_]*

   /* invalid characters */
INVALID           [^[:space:]]

%%

   /* comments */
{COMMENT}         // yylineno counts line-breaks automatically
"/*"              BEGIN(ML_COMMENT);
<ML_COMMENT>.     
<ML_COMMENT>\n    // yylineno counts line-breaks automatically
<ML_COMMENT>"*/"  BEGIN(INITIAL);

   /* reserved words */
int               return TK_PR_INT;
float             return TK_PR_FLOAT;
bool              return TK_PR_BOOL;
char              return TK_PR_CHAR;
string            return TK_PR_STRING;
if                return TK_PR_IF;
then              return TK_PR_THEN;
else              return TK_PR_ELSE;
while             return TK_PR_WHILE;
do                return TK_PR_DO;
input             return TK_PR_INPUT;
output            return TK_PR_OUTPUT;
return            return TK_PR_RETURN;

   /* special characters */
{SPECIAL}         return yytext[0];

   /* compound operators */
"<="              return TK_OC_LE;
">="              return TK_OC_GE;
"=="              return TK_OC_EQ;
"!="              return TK_OC_NE;
"&&"              return TK_OC_AND;
"||"              return TK_OC_OR;

   /* literals */
{L_INT}           {yylval = add_or_update_symbol_line(yytext, yyleng, IKS_SIMBOLO_LITERAL_INT, yylineno); return TK_LIT_INT;}
{L_FLOAT}         {yylval = add_or_update_symbol_line(yytext, yyleng, IKS_SIMBOLO_LITERAL_FLOAT, yylineno); return TK_LIT_FLOAT;}
true              {yylval = add_or_update_symbol_line(yytext, yyleng, IKS_SIMBOLO_LITERAL_BOOL, yylineno); return TK_LIT_TRUE;}
false             {yylval = add_or_update_symbol_line(yytext, yyleng, IKS_SIMBOLO_LITERAL_BOOL, yylineno); return TK_LIT_FALSE;}
{L_CHAR}          {yylval = add_or_update_symbol_line(&yytext[1], yyleng - 2, IKS_SIMBOLO_LITERAL_CHAR, yylineno); return TK_LIT_CHAR;}
{L_STRING}        {yylval = add_or_update_symbol_line(&yytext[1], yyleng - 2, IKS_SIMBOLO_LITERAL_STRING, yylineno); return TK_LIT_STRING;}

   /* identifiers */
{ID}              {yylval = add_or_update_symbol_line(yytext, yyleng, IKS_SIMBOLO_IDENTIFICADOR, yylineno); return TK_IDENTIFICADOR;}

   /* invalid characters */
{INVALID}         return TOKEN_ERRO;

   /* line-breaks */
\n                // yylineno counts line-breaks automatically

   /* blanks */
[[:space:]]       

%%
