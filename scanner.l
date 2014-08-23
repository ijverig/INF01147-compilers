/*
 * grupo: cc
 *
 * membros:
 *    - Daniel Schmidt
 *    - Matheus Cardoso
 *
 */

%option yylineno

%{

#include "parser.h"

%}

%s IN_COMMENT

/* auxiliar */
DIGIT    [0-9]
ALPHA    [a-zA-Z]
ALNUM    [{ALPHA}0-9]
WORD     {ALNUM}*

/* reserved words */
INT      int
FLOAT    float
BOOL     bool
CHAR     char
STRING   string
IF       if
THEN     then
ELSE     else
WHILE    while
DO       do
INPUT    input
OUTPUT   output
RETURN   return

/* special characters */
SPECIAL  ,|;|:|\(|\)|\[|\]|\{|\}|\+|-|\*|\/|<|>|=|!|&|\$

/* compound operators */
COMPOUND <=|>=|==|!=|&&|\|\|

/* literals */
L_INT    -?{DIGIT}+
L_FLOAT  -?{DIGIT}+\.{DIGIT}+
L_TRUE   true
L_FALSE  false
L_CHAR   '.'
L_STRING \".*\"

/* comments */
COMMENT  \/\/.*\n

/* identifiers */
ID       [a-zA-Z_][a-zA-Z_0-9]*

/* invalid characters */
INVALID  [^ \t\n\r\f\v]

%%

{INT}       {
               return TK_PR_INT;
}

{FLOAT}     {
               return TK_PR_FLOAT;
}

{BOOL}      {
               return TK_PR_BOOL;
}

{CHAR}      {
               return TK_PR_CHAR;
}

{STRING}    {
               return TK_PR_STRING;
}

{IF}        {
               return TK_PR_IF;
}

{THEN}      {
               return TK_PR_THEN;
}

{ELSE}      {
               return TK_PR_ELSE;
}

{WHILE}     {
               return TK_PR_WHILE;
}

{DO}        {
               return TK_PR_DO;
}

{INPUT}     {
               return TK_PR_INPUT;
}

{OUTPUT}    {
               return TK_PR_OUTPUT;
}

{RETURN}    {
               return TK_PR_RETURN;
}

{SPECIAL}   {
               return yytext[0];
}

"<="        {
               return TK_OC_LE;
}

">="        {
               return TK_OC_GE;
}

"=="        {
               return TK_OC_EQ;
}

"!="        {
               return TK_OC_NE;
}

"&&"        {
               return TK_OC_AND;
}

"||"        {
               return TK_OC_OR;
}

{L_INT}     {
               return TK_LIT_INT;
}

{L_FLOAT}   {
               return TK_LIT_FLOAT;
}

{L_TRUE}    {
               return TK_LIT_TRUE;
}

{L_FALSE}   {
               return TK_LIT_FALSE;
}

{L_CHAR}    {
               return TK_LIT_CHAR;
}

{L_STRING}  {
               return TK_LIT_STRING;
}

{COMMENT}   {
               
}

   /* multi-line comment rule from http://flex.sourceforge.net/manual/How-can-I-match-C_002dstyle-comments_003f.html */
<INITIAL>{
   \/\*        BEGIN(IN_COMMENT);
}
<IN_COMMENT>{
   \*\/        BEGIN(INITIAL);
   [^*\n]+     
   \*          
   \n          
}

{ID}        {
               return TK_IDENTIFICADOR;
}

{INVALID}   {
               return TOKEN_ERRO;
}

\n          {
               
}

.           {
               
}

%%
