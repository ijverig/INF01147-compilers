/* Tipo de dado do identificador */
#define IKS_TYPE_INT	'I'
#define IKS_TYPE_FLOAT	'F'
#define IKS_TYPE_CHAR	'C'
#define IKS_TYPE_STRING	'S'
#define IKS_TYPE_BOOL	'B'

/* Coerções */
#define IKS_CAST_NO				0
#define IKS_CAST_BOOL_TO_INT	1
#define IKS_CAST_BOOL_TO_FLOAT	2
#define IKS_CAST_INT_TO_BOOL	4
#define IKS_CAST_INT_TO_FLOAT	8
#define IKS_CAST_FLOAT_TO_BOOL	16
#define IKS_CAST_FLOAT_TO_INT	32
#define IKS_CAST_YES			64

/* Categoria do identificador */
#define IKS_KIND_VARIABLE	'V'
#define IKS_KIND_ARRAY		'A'
#define IKS_KIND_FUNCTION	'F'

#define IKS_SUCCESS					0 //caso não houver nenhum tipo de erro

/* Verificação de declarações */
#define IKS_ERROR_UNDECLARED		1 //identificador não declarado
#define IKS_ERROR_DECLARED			2 //identificador já declarado

/* Uso correto de identificadores */
#define IKS_ERROR_VARIABLE			3 //identificador deve ser utilizado como variável
#define IKS_ERROR_VECTOR			4 //identificador deve ser utilizado como vetor
#define IKS_ERROR_FUNCTION			5 //identificador deve ser utilizado como função

/* Tipos e tamanho de dados */
#define IKS_ERROR_WRONG_TYPE		6 //tipos incompatíveis
#define IKS_ERROR_STRING_TO_X		7 //coerção impossível do tipo string
#define IKS_ERROR_CHAR_TO_X			8 //coerção impossível do tipo char

/* Argumentos e parâmetros */
#define IKS_ERROR_MISSING_ARGS    9  //faltam argumentos 
#define IKS_ERROR_EXCESS_ARGS     10 //sobram argumentos 
#define IKS_ERROR_WRONG_TYPE_ARGS 11 //argumentos incompatíveis

/* Verificação de tipos em comandos */
#define IKS_ERROR_WRONG_PAR_INPUT  12 //parâmetro não é identificador
#define IKS_ERROR_WRONG_PAR_OUTPUT 13 //parâmetro não é literal string ou expressão
#define IKS_ERROR_WRONG_PAR_RETURN 14 //parâmetro não é expressão compatível com tipo do retorno
