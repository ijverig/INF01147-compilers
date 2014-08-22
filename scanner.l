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
int      int
float    float
bool     bool
char     char
string   string
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
INT      -?{DIGIT}+
FLOAT    -?{DIGIT}+\.{DIGIT}+
BOOL     true|false
CHAR     '.'
STRING   \".*\"

/* identifiers */
ID       [a-zA-Z_][a-zA-Z_0-9]*

/* comments */
COMMENT  \/\*(.|\n)*\*\/|\/\/.*\n

/* invalid characters */
INVALID  [^ \t\n\r\f\v]

%%

{int}       {
               printf("&&&%s&&&", yytext);
}

{float}     {
               printf("&&&%s&&&", yytext);
}

{bool}      {
               printf("&&&%s&&&", yytext);
}

{char}      {
               printf("&&&%s&&&", yytext);
}

{string}    {
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

{INT}       {
               printf("###%s###", yytext);
}

{FLOAT}     {
               printf("###%s###", yytext);
}

{BOOL}      {
               printf("###%s###", yytext);
}

{CHAR}      {
               printf("###%s###", yytext);
}

{STRING}    {
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
