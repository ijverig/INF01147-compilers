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
#include "iks_ast.h"

extern char *yytext;

comp_tree_t *last_fun_decl;

// comp_scope *current_scope is a global from comp_scope.c

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
%nonassoc '!'

%%

program:
	%empty
			{
					scope_push();
					$$ = ast = last_fun_decl = make_node(IKS_AST_PROGRAMA, NULL);
			}
|	program	glo_decl ';'
|	program	fun_decl
			{
					add_child(last_fun_decl, $fun_decl);
					last_fun_decl = $fun_decl;
			}
;

glo_decl:
	var_decl
|	arr_decl
;

var_decl:
	type TK_IDENTIFICADOR
			{
					identifier_table_add(current_scope->identifiers, ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);

					$$ = NULL;
			}
;

arr_decl:
	type TK_IDENTIFICADOR '[' TK_LIT_INT ']'
			{
					identifier_table_add(current_scope->identifiers, ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);

					$$ = NULL;
			}
;

fun_decl:
	type TK_IDENTIFICADOR '(' params.opt ')'
	'{'
			{
				scope_push();
			}
	commands
			{
				printf("FUNCTION %s\n", ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);

				scope_pop();
			}
	'}'
			{
					identifier_table_add(current_scope->identifiers, ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);

					$$ = make_node(IKS_AST_FUNCAO, (comp_dict_item_t *) $TK_IDENTIFICADOR);
					add_child($$, $commands);
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
	'{'
			{
				scope_push();
			}
	commands
			{
				printf("BLOCK\n");

				scope_pop();
			}
	'}'
			{
					$$ = make_node(IKS_AST_BLOCO, NULL);
					add_child($$, $commands);
			}
;

commands:
	%empty
			{
					$$ = NULL;
			}
|	command
			{
					$$ = $command;
			}
|	command ';' commands[command_next]
			{
					if ($command != NULL)
					{
						add_child($command, $command_next);
					}
					//ignore local variable declarations and empty commands
					else
					{
						$$ = $command_next;
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
					$$ = make_node(IKS_AST_ATRIBUICAO, NULL);
					add_child($$, $lval);
					add_child($$, $expression);
			}
;

lval:
	identifier
|	array
;

input:
	TK_PR_INPUT identifier
			{
					$$ = make_node(IKS_AST_INPUT, NULL);
					add_child($$, $identifier);
			}
;

output:
	TK_PR_OUTPUT expressions
			{
					$$ = make_node(IKS_AST_OUTPUT, NULL);
					add_child($$, $expressions);
			}
;

return:
	TK_PR_RETURN expression
			{
					$$ = make_node(IKS_AST_RETURN, NULL);
					add_child($$, $expression);
			}
;

flow_control:
	TK_PR_IF '(' expression ')' TK_PR_THEN command
			{
					$$ = make_node(IKS_AST_IF_ELSE, NULL);
					add_child($$, $expression);
					add_child($$, $command);
			}
|	TK_PR_IF '(' expression ')' TK_PR_THEN command[command_true] TK_PR_ELSE command[command_false]
			{
					$$ = make_node(IKS_AST_IF_ELSE, NULL);
					add_child($$, $expression);
					add_child($$, $command_true);
					add_child($$, $command_false);
			}
|	TK_PR_WHILE '(' expression ')' TK_PR_DO command
			{
					$$ = make_node(IKS_AST_WHILE_DO, NULL);
					add_child($$, $expression);
					add_child($$, $command);
			}
|	TK_PR_DO command TK_PR_WHILE '(' expression ')'
			{
					$$ = make_node(IKS_AST_DO_WHILE, NULL);
					add_child($$, $command);
					add_child($$, $expression);
			}
;

fun_call:
	identifier '(' args.opt ')'
			{
					$$ = make_node(IKS_AST_CHAMADA_DE_FUNCAO, NULL);
					add_child($$, $identifier);
					add_child($$, $[args.opt]);
			}
;

args.opt:
	%empty
			{
					$$ = NULL;
			}
|	expressions
			{
					$$ = $expressions;
			}
;

expressions:
	expression
			{
					$$ = $expression;
			}
|	expression ',' expressions[expression_next]
			{
					add_child($expression, $expression_next);
			}
;

expression:
	literal
			{
					$$ = make_node(IKS_AST_LITERAL, (comp_dict_item_t *) $literal);
			}
|	identifier
			{
					$$ = $identifier;
			}
|	array
			{
					$$ = $array;
			}
|	fun_call
			{
					$$ = $fun_call;
			}
|	'-' expression[exp]
			{
					$$ = make_node(IKS_AST_ARIM_INVERSAO, NULL);
					add_child($$, $exp);
			}
|	'!' expression[exp]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_NEGACAO, NULL);
					add_child($$, $exp);
			}
|	expression[left] '>' expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_G, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '<' expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_L, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_EQ expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_IGUAL, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_NE expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_DIF, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_GE expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_GE, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_LE expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_COMP_LE, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_OR expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_OU, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_AND expression[right]
			{
					$$ = make_node(IKS_AST_LOGICO_E, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '+' expression[right]
			{
					$$ = make_node(IKS_AST_ARIM_SOMA, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '-' expression[right]
			{
					$$ = make_node(IKS_AST_ARIM_SUBTRACAO, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '*' expression[right]
			{
					$$ = make_node(IKS_AST_ARIM_MULTIPLICACAO, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '/' expression[right]
			{
					$$ = make_node(IKS_AST_ARIM_DIVISAO, NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	'(' expression[exp] ')'
			{
					$$ = $exp;
			}
;

identifier:
	TK_IDENTIFICADOR
			{
					$$ = make_node(IKS_AST_IDENTIFICADOR, (comp_dict_item_t *) $TK_IDENTIFICADOR);
			}
;

array:
	identifier '[' expression ']'
			{
					$$ = make_node(IKS_AST_VETOR_INDEXADO, NULL);
					add_child($$, $identifier);
					add_child($$, $expression);
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
