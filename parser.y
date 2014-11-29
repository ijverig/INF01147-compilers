/*
 * grupo: cc
 *
 * membros:
 *    - Daniel Schmidt
 *    - Matheus Cardoso
 *
 */

%{

#include <stdlib.h>
#include "main.h"
#include "iks_ast.h"
#include "semantics.h"

comp_tree_t *last_fun_decl;
int params;
int params_type;

// comp_scope *current_scope is a global from comp_scope.c

int type2size(int type);
void declare_identifier(char *identifier, int kind, int type, int size);
comp_identifier_item *_get_identifier(comp_scope *scope, char *identifier);
comp_identifier_item *get_identifier(char *identifier);
int is_identifier_declared(char *identifier);
int is_identifier_declared_in_this_scope(char *identifier);
int infer_type(int type1, int type2);
int cast_type(int type1, int type2);
void char_cannot_be_casted();
void string_cannot_be_casted();

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
					// checks if already declared
					if (is_identifier_declared_in_this_scope(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key))
					{
						yyerror("variable \"%s\" is already declared", ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);
						exit(IKS_ERROR_DECLARED);
					}

					declare_identifier(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key, IKS_KIND_VARIABLE, $type->type, type2size($type->type));
					params_type = $type->type;

					$$ = NULL;
			}
;

arr_decl:
	type TK_IDENTIFICADOR '[' TK_LIT_INT ']'
			{
					// checks if already declared
					if (is_identifier_declared_in_this_scope(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key))
					{
						yyerror("variable \"%s\" is already declared", ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);
						exit(IKS_ERROR_DECLARED);
					}

					declare_identifier(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key, IKS_KIND_ARRAY, $type->type, type2size($type->type) * ((comp_dict_item_t *) $TK_LIT_INT)->symbol.int_value);

					$$ = NULL;
			}
;

fun_decl:
	type TK_IDENTIFICADOR '('
		{
			params = params_type = 0;
		}
	params.opt ')'
	'{'
		{
			// checks if already declared
			if (is_identifier_declared_in_this_scope(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key))
			{
				yyerror("function \"%s\" is already declared", ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);
				exit(IKS_ERROR_DECLARED);
			}

			// declares before reduction to allow recursive calls
			declare_identifier(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key, IKS_KIND_FUNCTION, $type->type, 0);
			comp_identifier_item *identifier = get_identifier(((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);
			identifier->params = params;
			if (params > 0)
			{
				identifier->params_type = params_type;
			}
			
			scope_push();
		}
	commands
		{
			printf("FUNCTION %s\n", ((comp_dict_item_t *) $TK_IDENTIFICADOR)->key);

			scope_pop();
		}
	'}'
			{
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
			{
					++params;
			}
|	params ',' var_decl
			{
					++params;
			}
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
					// checks if not declared
					if (!is_identifier_declared($lval->attributes->key))
					{
						yyerror("variable \"%s\" is not yet declared", $lval->attributes->key);
						exit(IKS_ERROR_UNDECLARED);
					}

					comp_identifier_item *item = get_identifier($lval->attributes->key);

					// checks if it is used correctly
					int right_kind = ($lval->kind == IKS_AST_VETOR_INDEXADO) ? IKS_KIND_ARRAY : IKS_KIND_VARIABLE;
					if (item->kind != right_kind)
					{
						yyerror("\"%s\" is not a%s", $lval->attributes->key, (right_kind == IKS_KIND_VARIABLE) ? " variable" : "n array");
						exit((item->kind == IKS_KIND_VARIABLE) ? IKS_ERROR_VARIABLE : (item->kind == IKS_KIND_ARRAY) ? IKS_ERROR_VECTOR : IKS_ERROR_FUNCTION);
					}

					// checks if can cast rval
					$expression->type = cast_type(item->type, $expression->type);

					// checks type compatibility
					if (item->type != $expression->type)
					{
						yyerror("types incompatible (trying to assign %c to %c)", $expression->type, item->type);
						exit(IKS_ERROR_WRONG_TYPE);
					}

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
	identifier '('
		{
			params = params_type = 0;
		}
	args.opt ')'
			{
					// checks if not declared
					if (!is_identifier_declared($identifier->attributes->key))
					{
						yyerror("function \"%s\" is not yet declared", $identifier->attributes->key);
						exit(IKS_ERROR_UNDECLARED);
					}

					comp_identifier_item *item = get_identifier($identifier->attributes->key);

					// checks if it is used correctly
					if (item->kind != IKS_KIND_FUNCTION)
					{
						yyerror("\"%s\" is not a function", $identifier->attributes->key);
						exit(IKS_ERROR_VARIABLE);
					}

					// checks if matchs with declared parameters
					if (params > item->params)
					{
						yyerror("too many arguments to function %s", item->string);
						exit(IKS_ERROR_EXCESS_ARGS);
					}
					else if (params < item->params)
					{
						yyerror("too few arguments to function %s", item->string);
						exit(IKS_ERROR_MISSING_ARGS);
					}
					else if (params_type != item->params_type)
					{
						yyerror("arguments to function %s do not match", item->string);
						exit(IKS_ERROR_WRONG_TYPE_ARGS);
					}

					$$ = make_typed_node(IKS_AST_CHAMADA_DE_FUNCAO, item->type, IKS_CAST_NO, NULL);
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
					++params;
			}
|	expression ',' expressions[expression_next]
			{
					add_child($expression, $expression_next);
					++params;
			}
;

expression:
	literal
			{
					$$ = make_typed_node(IKS_AST_LITERAL, $literal->type, IKS_CAST_NO, (comp_dict_item_t *) $literal->attributes);
			}
|	identifier
			{
					comp_identifier_item *item = get_identifier($identifier->attributes->key);
					$$ = make_typed_node($identifier->kind, item->type, IKS_CAST_NO, $identifier->attributes);
			}
|	array
			{
					comp_identifier_item *item = get_identifier($array->attributes->key);
					$$ = make_typed_node($array->kind, item->type, IKS_CAST_NO, $array->attributes);
			}
|	fun_call
			{
					// already typed
					$$ = $fun_call;
			}
|	'-' expression[exp]
			{
					$$ = make_typed_node(IKS_AST_ARIM_INVERSAO, IKS_CAST_NO, $exp->type, NULL);
					add_child($$, $exp);
			}
|	'!' expression[exp]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_NEGACAO, IKS_CAST_NO, $exp->type, NULL);
					add_child($$, $exp);
			}
|	expression[left] '>' expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_G, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '<' expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_L, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_EQ expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_IGUAL, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_NE expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_DIF, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_GE expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_GE, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_LE expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_COMP_LE, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_OR expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_OU, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] TK_OC_AND expression[right]
			{
					$$ = make_typed_node(IKS_AST_LOGICO_E, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '+' expression[right]
			{
					$$ = make_typed_node(IKS_AST_ARIM_SOMA, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '-' expression[right]
			{
					$$ = make_typed_node(IKS_AST_ARIM_SUBTRACAO, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '*' expression[right]
			{
					$$ = make_typed_node(IKS_AST_ARIM_MULTIPLICACAO, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
					add_child($$, $left);
					add_child($$, $right);
			}
|	expression[left] '/' expression[right]
			{
					$$ = make_typed_node(IKS_AST_ARIM_DIVISAO, IKS_CAST_YES, infer_type($left->type, $right->type), NULL);
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
					// checks if can cast index expression
					cast_type(IKS_TYPE_INT, $expression->type);

					$$ = make_node(IKS_AST_VETOR_INDEXADO, $identifier->attributes);
					add_child($$, $identifier);
					add_child($$, $expression);
			}
;

literal:
	TK_LIT_INT
			{
					$$ = make_typed_node(-1, IKS_TYPE_INT, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_INT);
			}
|	TK_LIT_FLOAT
			{
					$$ = make_typed_node(-1, IKS_TYPE_FLOAT, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_FLOAT);
			}
|	TK_LIT_CHAR
			{
					$$ = make_typed_node(-1, IKS_TYPE_CHAR, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_CHAR);
			}
|	TK_LIT_STRING
			{
					$$ = make_typed_node(-1, IKS_TYPE_STRING, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_STRING);
			}
|	TK_LIT_TRUE
			{
					$$ = make_typed_node(-1, IKS_TYPE_BOOL, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_TRUE);
			}
|	TK_LIT_FALSE
			{
					$$ = make_typed_node(-1, IKS_TYPE_BOOL, IKS_CAST_NO, (comp_dict_item_t *) $TK_LIT_FALSE);
			}
;

type:
	TK_PR_FLOAT
			{
					$$ = make_typed_node(-1, IKS_TYPE_FLOAT, IKS_CAST_NO, NULL);
			}
|	TK_PR_INT
			{
					$$ = make_typed_node(-1, IKS_TYPE_INT, IKS_CAST_NO, NULL);
			}
|	TK_PR_CHAR
			{
					$$ = make_typed_node(-1, IKS_TYPE_CHAR, IKS_CAST_NO, NULL);
			}
|	TK_PR_BOOL
			{
					$$ = make_typed_node(-1, IKS_TYPE_BOOL, IKS_CAST_NO, NULL);
			}
|	TK_PR_STRING
			{
					$$ = make_typed_node(-1, IKS_TYPE_STRING, IKS_CAST_NO, NULL);
			}
;

%%

int type2size(int type)
{
	switch (type)
	{
		case IKS_TYPE_CHAR:
		case IKS_TYPE_BOOL:
			return 1;
		case IKS_TYPE_INT:
			return 4;
		case IKS_TYPE_FLOAT:
			return 8;
		// string size should be annotated in attribution, when we know the number of chars
		case IKS_TYPE_STRING:
			return -1;
	}
}

void declare_identifier(char* identifier, int kind, int type, int size)
{
	identifier_table_add(current_scope->identifiers, identifier, kind, type, size);
}

// returns the identifier or NULL if it is not declared
comp_identifier_item *_get_identifier(comp_scope *scope, char *identifier)
{
	if (scope == NULL)
	{
		return NULL;
	}

	comp_identifier_item *item = identifier_table_get(scope->identifiers, identifier);
	
	return (item != NULL) ? item : _get_identifier(scope->previous, identifier);
}

// wrapper for _get_identifier
// since current_scope is global, it's not necessary to pass it to the function
comp_identifier_item *get_identifier(char *identifier)
{
	return _get_identifier(current_scope, identifier);
}

// returns true if identifier is declared
int is_identifier_declared(char *identifier)
{
	return (long) get_identifier(identifier);
}

// returns true if identifier is declared in the current scope only
int is_identifier_declared_in_this_scope(char *identifier)
{
	return (long) identifier_table_get(current_scope->identifiers, identifier);
}

// type inference in expressions
int infer_type(int type1, int type2)
{
	if (type1 == IKS_TYPE_CHAR || type2 == IKS_TYPE_CHAR)
	{
		char_cannot_be_casted();
	}

	if (type1 == IKS_TYPE_STRING || type2 == IKS_TYPE_STRING)
	{
		string_cannot_be_casted();
	}

	if (type1 == IKS_TYPE_FLOAT || type2 == IKS_TYPE_FLOAT)
	{
		return IKS_TYPE_FLOAT;
	}

	if (type1 == IKS_TYPE_INT || type2 == IKS_TYPE_INT)
	{
		return IKS_TYPE_INT;
	}

	return IKS_TYPE_BOOL;
}

// type casting in attribution
int cast_type(int type1, int type2)
{
	if (type1 == type2)
	{
		return type1;
	}

	if (type2 == IKS_TYPE_CHAR)
	{
		char_cannot_be_casted();
	}

	if (type2 == IKS_TYPE_STRING)
	{
		string_cannot_be_casted();
	}

	if (type1 == IKS_TYPE_CHAR || type1 == IKS_TYPE_STRING)
	{
		return type2;
	}

	return type1;
}

void char_cannot_be_casted()
{
	yyerror("char cannot be casted");
	exit(IKS_ERROR_CHAR_TO_X);
}

void string_cannot_be_casted()
{
	yyerror("string cannot be casted");
	exit(IKS_ERROR_STRING_TO_X);
}
