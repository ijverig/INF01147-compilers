/*
 * grupo: cc
 *
 * membros:
 *    - Daniel Schmidt
 *    - Matheus Cardoso
 *
 */

%{

#include "main.h"

extern char *yytext;

%}

%error-verbose

   /* tokens */
%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_CHAR
%token TK_PR_STRING
%token TK_PR_IF
%token TK_PR_THEN
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_DO
%token TK_PR_INPUT
%token TK_PR_OUTPUT
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_LIT_CHAR
%token TK_LIT_STRING
%token TK_IDENTIFICADOR
%token TOKEN_ERRO

%nonassoc TK_PR_THEN
%nonassoc TK_PR_ELSE

%left TK_OC_OR
%left TK_OC_AND
%left TK_OC_EQ TK_OC_NE 
%nonassoc '>' '<' TK_OC_GE TK_OC_LE
%left '+' '-'
%left '*' '/'

%%

program:
	%empty
|	program	glo_decl ';'
|	program glo_decl error																	{yyerror("global declaration must end with semicolon (;), not \"%s\"", yytext); return IKS_SYNTAX_ERRO;}
|	program type ';'																		{yyerror("variable declaration must have a name"); return IKS_SYNTAX_ERRO;}
|	program	fun_decl
|	program	fun_decl ';'																	{yyerror("function declaration have an extra semicolon (;) in the end"); return IKS_SYNTAX_ERRO;}
|	program	attribution																		{yyerror("command (%s) outside function scope", yytext); return IKS_SYNTAX_ERRO;}
;

glo_decl:
	var_decl
|	arr_decl
;

var_decl:
	type TK_IDENTIFICADOR
;

arr_decl:
	type TK_IDENTIFICADOR '[' TK_LIT_INT ']'
|	type TK_IDENTIFICADOR '[' error ']'														{yyerror("array declaration must have integer index size, not \"%s\"", yytext); return IKS_SYNTAX_ERRO;}
;

fun_decl:
	type TK_IDENTIFICADOR '(' params.opt ')' comm_block
;

params.opt:
	%empty
|	params
;

params:
	var_decl
|	params ',' var_decl
|	params ','																				{yyerror("extra comma in the end of argument list"); return IKS_SYNTAX_ERRO;}
;

comm_block:
	'{' commands '}'
;

commands:
	%empty
|	command
|	command ';' commands
;

command:
	';'
|	var_decl
|	attribution
|	input
|	output
|	return
|	flow_control
|	fun_call
|	comm_block
|	error																					{yyerror("command must be variable declaration, attribution, input, output, return, flow control or block, not \"%s\"", yytext); return IKS_SYNTAX_ERRO;}
;

attribution:
	TK_IDENTIFICADOR '=' expression
|	TK_IDENTIFICADOR '[' expression ']' '=' expression
;

input:
	TK_PR_INPUT TK_IDENTIFICADOR
|	TK_PR_INPUT	literal																		{yyerror("input arguments must be variables, not literals (%s)", yytext); return IKS_SYNTAX_ERRO;}
;

output:
	TK_PR_OUTPUT expressions
;

return:
	TK_PR_RETURN expression
;

flow_control:
	TK_PR_IF '(' expression ')' TK_PR_THEN command
|	TK_PR_IF '(' expression ')' command														{yyerror("if needs a then before command"); return IKS_SYNTAX_ERRO;}
|	TK_PR_IF '(' expression ')' TK_PR_THEN command TK_PR_ELSE command
|	TK_PR_WHILE '(' expression ')' TK_PR_DO command
|	TK_PR_DO command TK_PR_WHILE '(' expression ')'
;

fun_call:
	TK_IDENTIFICADOR '(' args.opt ')'
;

args.opt:
	%empty
|	expressions
;

expressions:
	expression
|	expressions ',' expression
;

expression:
	literal
|	TK_IDENTIFICADOR
|	TK_IDENTIFICADOR '[' expression ']'
|	fun_call
|	'-' expression
|	expression '>' expression
|	expression '<' expression
|	expression TK_OC_EQ expression
|	expression TK_OC_NE expression
|	expression TK_OC_GE expression
|	expression TK_OC_LE expression
|	expression TK_OC_OR expression
|	expression TK_OC_AND expression
|	expression '+' expression
|	expression '-' expression
|	expression '*' expression
|	expression '/' expression
|	'(' expression ')'
;

literal:
	TK_LIT_INT
|	TK_LIT_FLOAT
|	TK_LIT_CHAR
|	TK_LIT_STRING
|	TK_LIT_TRUE
|	TK_LIT_FALSE
;

type:
	TK_PR_FLOAT
|	TK_PR_INT
|	TK_PR_CHAR
|	TK_PR_BOOL
|	TK_PR_STRING
|	error																					{yyerror("type must be int, float, bool, char or string, not \"%s\"", yytext); return IKS_SYNTAX_ERRO;}
;

%%
