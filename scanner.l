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

#include "parser.h"

%}

%x ML_COMMENT

   /* comments */
COMMENT           "//".*\n

   /* special characters */
SPECIAL           [,;:()[\]{}+\-*/<>=!&$]

   /* literals */
L_INT             -?[[:digit:]]+
L_FLOAT           -?[[:digit:]]+"."[[:digit:]]+
L_CHAR            '.'
L_STRING          \"[^"]*\"

   /* identifiers */
ID                [[:alpha:]_][[:alnum:]_]*

   /* invalid characters */
INVALID           [^[:space:]]

%%

   /* comments */
{COMMENT}         
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
{L_INT}           {add_or_update_symbol_line(yytext, yylineno); return TK_LIT_INT;}
{L_FLOAT}         {add_or_update_symbol_line(yytext, yylineno); return TK_LIT_FLOAT;}
true              {add_or_update_symbol_line(yytext, yylineno); return TK_LIT_TRUE;}
false             {add_or_update_symbol_line(yytext, yylineno); return TK_LIT_FALSE;}
{L_CHAR}          {yytext[0] = yytext[1]; yytext[1] = '\0'; add_or_update_symbol_line(yytext, yylineno);
                   yytext[1] = yytext[0]; yytext[0] = '\''; return TK_LIT_CHAR;}
{L_STRING}        {int len = strlen(yytext); ++yytext; yytext[len - 2] = '\0'; add_or_update_symbol_line(yytext, yylineno);
                   yytext[len - 2] = '"'; --yytext; return TK_LIT_STRING;}

   /* identifiers */
{ID}              {add_or_update_symbol_line(yytext, yylineno); return TK_IDENTIFICADOR;}

   /* invalid characters */
{INVALID}         return TOKEN_ERRO;

   /* line-breaks */
\n                // yylineno counts line-breaks automatically

   /* blanks */
[[:space:]]       

%%
