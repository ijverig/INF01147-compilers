/*
 * grupo: cc
 *
 * membros:
 *    - Daniel Schmidt
 *    - Matheus Cardoso
 *
 */

%{

#include "parser.h"

%}

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
L_BOOL   true|false
L_CHAR   '.'
L_STRING \".*\"

/* identifiers */
ID       [a-zA-Z_][a-zA-Z_0-9]*

/* comments */
COMMENT  \/\*(.|\n)*\*\/|\/\/.*\n

/* invalid characters */
INVALID  [^ \t\n\r\f\v]

%%

{INT}       {
               printf("&&&%s&&&", yytext);
}

{FLOAT}     {
               printf("&&&%s&&&", yytext);
}

{BOOL}      {
               printf("&&&%s&&&", yytext);
}

{CHAR}      {
               printf("&&&%s&&&", yytext);
}

{STRING}    {
               printf("&&&%s&&&", yytext);
}

{IF}        {
               printf("&&&%s&&&", yytext);
}

{THEN}      {
               printf("&&&%s&&&", yytext);
}

{ELSE}      {
               printf("&&&%s&&&", yytext);
}

{WHILE}     {
               printf("&&&%s&&&", yytext);
}

{DO}        {
               printf("&&&%s&&&", yytext);
}

{INPUT}     {
               printf("&&&%s&&&", yytext);
}

{OUTPUT}    {
               printf("&&&%s&&&", yytext);
}

{RETURN}    {
               printf("&&&%s&&&", yytext);
}

{SPECIAL}   {
               printf("---%s---", yytext);
}

{COMPOUND}  {
               printf("^^^%s^^^", yytext);
}

{L_INT}       {
               printf("###%s###", yytext);
}

{L_FLOAT}     {
               printf("###%s###", yytext);
}

{L_BOOL}      {
               printf("###%s###", yytext);
}

{L_CHAR}      {
               printf("###%s###", yytext);
}

{L_STRING}    {
               printf("###%s###", yytext);
}

{ID}        {
               printf("@@@%s@@@", yytext);
}

{COMMENT}   {
               printf("***%s***", yytext);
}

{INVALID}   {
               printf("!!!%s!!!", yytext);
}

%%
