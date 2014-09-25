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
#include "string.h"

extern char *yytext;

%}

%define api.value.type {comp_tree_t *}

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
			{
					$$ = ast = make_node("program");
			}
|	program	glo_decl ';'
|	program	fun_decl
			{
					$$ = $1;
					add_child($$, $2);
			}
;

glo_decl:
	var_decl
|	arr_decl
;

var_decl:
	type identifier
			{
					$$ = NULL;
			}
;

arr_decl:
	type identifier '[' TK_LIT_INT ']'
;

fun_decl:
	type identifier '(' params.opt ')' comm_block
			{
					char *l = (char *) malloc(sizeof(char) * (sizeof("fun_decl ") + strlen($2->label + 3) + 1));
					strcpy(l, "fun_decl ");
					strcat(l, $2->label + 3);
					$$ = make_node(l);
					add_child($$, $6->child);
			}
;

params.opt:
	%empty
|	params
;

params:
	var_decl
|	params ',' var_decl
;

comm_block:
	'{' commands '}'
			{
					$$ = make_node("comm_block");
					add_child($$, $2);
			}
;

commands:
	%empty
			{
					$$ = NULL;
			}
|	command
			{
					$$ = $1;
			}
|	command ';' commands
			{
					if ($1 != NULL)
					{
						add_sibling($1, $3);
					}
					//ignore local variable declarations
					else
					{
						$$ = $3;
					}
			}
;

command:
	';'
			{
					$$ = NULL;
			}
|	var_decl
|	attribution
|	input
|	output
|	return
|	flow_control
|	fun_call
|	comm_block
;

attribution:
	lval '=' expression
			{
					$$ = make_node("attribution");
					add_child($$, $1);
					add_child($$, $3);
			}
;

lval:
	identifier
|	array
;

input:
	TK_PR_INPUT identifier
			{
					$$ = make_node("input");
					add_child($$, $2);
			}
;

output:
	TK_PR_OUTPUT expressions
			{
					$$ = make_node("output");
					add_child($$, $2);
			}
;

return:
	TK_PR_RETURN expression
			{
					$$ = make_node("return");
					add_child($$, $2);
			}
;

flow_control:
	TK_PR_IF '(' expression ')' TK_PR_THEN command
			{
					$$ = make_node("if");
					add_child($$, $3);
					add_child($$, $6);
			}
|	TK_PR_IF '(' expression ')' TK_PR_THEN command TK_PR_ELSE command
			{
					$$ = make_node("if");
					add_child($$, $3);
					add_child($$, $6);
					add_child($$, $8);
			}
|	TK_PR_WHILE '(' expression ')' TK_PR_DO command
			{
					$$ = make_node("while");
					add_child($$, $3);
					add_child($$, $6);
			}
|	TK_PR_DO command TK_PR_WHILE '(' expression ')'
			{
					$$ = make_node("do");
					add_child($$, $2);
					add_child($$, $5);
			}
;

fun_call:
	identifier '(' args.opt ')'
			{
					$$ = make_node("fun_call");
					add_child($$, $1);
					add_child($$, $3);
			}
;

args.opt:
	%empty
|	expressions
;

expressions:
	expression
			{
					$$ = $1;
			}
|	expressions ',' expression
			{
					add_sibling($1, $3);
			}
;

expression:
	literal
			{
					char *l = (char *) malloc(sizeof(char) * (sizeof("LIT ") + strlen($1->label) + 1));
					strcpy(l, "LIT ");
					strcat(l, $1->label);
					$$ = make_node(l);
			}
|	identifier
			{
					$$ = $1;
			}
|	array
			{
					$$ = $1;
			}
|	fun_call
			{
					$$ = $1;
			}
|	'-' expression
			{
					$$ = make_node("-");
					add_child($$, $2);
			}
|	expression '>' expression
			{
					$$ = make_node(">");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression '<' expression
			{
					$$ = make_node("<");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_EQ expression
			{
					$$ = make_node("==");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_NE expression
			{
					$$ = make_node("!=");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_GE expression
			{
					$$ = make_node(">=");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_LE expression
			{
					$$ = make_node("<=");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_OR expression
			{
					$$ = make_node("||");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression TK_OC_AND expression
			{
					$$ = make_node("&&");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression '+' expression
			{
					$$ = make_node("+");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression '-' expression
			{
					$$ = make_node("-");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression '*' expression
			{
					$$ = make_node("*");
					add_child($$, $1);
					add_child($$, $3);
			}
|	expression '/' expression
			{
					$$ = make_node("÷");
					add_child($$, $1);
					add_child($$, $3);
			}
|	'(' expression ')'
			{
					$$ = $2;
			}
;

identifier:
	TK_IDENTIFICADOR
			{
					char *l = (char *) malloc(sizeof(char) * (sizeof("ID ") + strlen($1->label) + 1));
					strcpy(l, "ID ");
					strcat(l, $1->label);
					$$ = make_node(l);
			}
;

array:
	identifier '[' expression ']'
			{
					$$ = make_node("array");
					add_child($$, $1);
					add_child($$, $3);
			}
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
;

%%
