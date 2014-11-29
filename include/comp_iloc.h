enum _op_code_t
{
	ADD,
	SUB,
	MULT,
	DIV,
	ADDI,
	SUBI,
	RSUBI,
	MULTI,
	DIVI,
	RDIVI,
	LSHIFT,
	LSHIFTI,
	RSHIFT,
	RSHIFTI,
	LOAD,
	LOADAI,
	LOADAO,
	CLOAD,
	CLOADAI,
	CLOADAO,
	LOADI,
	STORE,
	STOREAI,
	STOREAO,
	CSTORE,
	CSTOREAI,
	CSTOREAO,
	I2I,
	C2C,
	C2I,
	I2C,
	CMPLT,
	CMPLE,
	CMPEQ,
	CMPGE,
	CMPGT,
	CMPNE,
	CBR,
	JUMPI,
	JUMP,
	AND,
	ANDI,
	OR,
	XOR,
	ORI,
	XORI,
	NOP
};

typedef enum _op_code_t op_code_t;

char *new_register(void);
char *new_label(void);
void *generate_instruction_code(op_code_t op_code, char *target, int n_args, ...);
char *operation2string(op_code_t op_code);

extern int register_counter;
extern int label_counter;
