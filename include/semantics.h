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
