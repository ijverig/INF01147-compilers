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

%}

%define parse.error verbose

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

%%

program:
	%empty
|	program	glo_decl ';'
|	program	fun_decl
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
;

comm_block:
	'{' commands.opt '}'
;

commands.opt:
	%empty
|	commands
;

commands:
	command
|	commands ';' command
;

command:
	%empty
|	var_decl
;

type:
	TK_PR_FLOAT
|	TK_PR_INT
|	TK_PR_CHAR
|	TK_PR_BOOL
|	TK_PR_STRING
;

%%
