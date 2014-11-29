#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "main.h"

int register_counter = 0;
int label_counter = 0;

char *new_register(void)
{
	char new_register[8];

	sprintf(new_register, "r%d", register_counter++);

	return strdup(new_register);
}

char *new_label(void)
{
	char new_label[8];

	sprintf(new_label, "L%d:", label_counter);

	return strdup(new_label);
}

void *generate_instruction_code(op_code_t op_code, char *target, int n_args, ...)
{
	va_list args;
	va_start(args, n_args);

	printf("%s\t\t", operation2string(op_code));

	switch(op_code)
	{
		// r1, r2 => r3
		case ADD:
		case SUB:
		case MULT:
		case DIV:
		case LSHIFT:
		case RSHIFT:
		case AND:
		case OR:
		case XOR:
		case LOADAO:
		case CLOADAO:
		case CMPLT:
		case CMPLE:
		case CMPEQ:
		case CMPGE:
		case CMPGT:
		case CMPNE:
			printf("%s, %s => %s\n", va_arg(args, char *), va_arg(args, char *), target);
			break;
		// r1 => r2, r3
		case STOREAO:
		case CSTOREAO:
			printf("%s => %s, %s\n", va_arg(args, char *), target, va_arg(args, char *));
			break;
		// r1, c2 => r3
		case ADDI:
		case SUBI:
		case RSUBI:
		case MULTI:
		case DIVI:
		case RDIVI:
		case LSHIFTI:
		case RSHIFTI:
		case ANDI:
		case ORI:
		case XORI:
		case LOADAI:
		case CLOADAI:
			printf("%s, %s => %s\n", va_arg(args, char *), va_arg(args, char *), target);
			break;
		case STOREAI:
			printf("%s => %s, %d\n", va_arg(args, char *), target, va_arg(args, int));
			break;
		case CSTOREAI:
			printf("%s => %s, %d\n", va_arg(args, char *), target, va_arg(args, int));
			break;
		// r1 => r2
		case LOAD:
		case CLOAD:
		case STORE:
		case CSTORE:
		case I2I:
		case C2C:
		case C2I:
		case I2C:
			printf("%s => %s\n", va_arg(args, char *), target);
			break;
		// => r1
		case JUMP:
			printf("=> %s\n", target);
			break;
		// c1 => r2
		case LOADI:
			printf("%s => %s\n", va_arg(args, char *), target);
			break;
		// r1 => l2, l3
		case CBR:
			printf("%s => %s, %s\n", target, va_arg(args, char *), va_arg(args, char *));
			break;
		// => l1
		case JUMPI:
			printf("=> %s\n", va_arg(args, char *));
			break;
	}

	va_end(args);
}

char *operation2string(op_code_t op_code)
{
	switch (op_code)
	{
		case ADD:		return "add";
		case SUB:		return "sub";
		case MULT:		return "mult";
		case DIV:		return "mult";
		case LSHIFT:	return "lshift";
		case RSHIFT:	return "rshift";
		case LOADAO:	return "loadAO";
		case CLOADAO:	return "cloadAO";
		case STOREAO:	return "storeAO";
		case CSTOREAO:	return "cstoreAO";
		case CMPLT:		return "cmp_LT";
		case CMPLE:		return "cmp_LE";
		case CMPEQ:		return "cmp_EQ";
		case CMPGE:		return "cmp_GE";
		case CMPGT:		return "cmp_GT";
		case CMPNE:		return "cmp_NE";
		case ADDI:		return "addI";
		case SUBI:		return "subI";
		case RSUBI:		return "rsubI";
		case MULTI:		return "multI";
		case DIVI:		return "divI";
		case RDIVI:		return "rdivI";
		case LSHIFTI:	return "lshiftI";
		case RSHIFTI:	return "rshiftI";
		case LOADAI:	return "loadI";
		case CLOADAI:	return "cloadAI";
		case STOREAI:	return "storeAI";
		case CSTOREAI:	return "cstoreAI";
		case LOAD:		return "load";
		case CLOAD:		return "cload";
		case STORE:		return "store";
		case CSTORE:	return "cstore";
		case I2I:		return "i22";
		case C2C:		return "c2c";
		case C2I:		return "c2i";
		case I2C:		return "i2c";
		case JUMP:		return "jump";
		case LOADI:		return "loadI";
		case CBR:		return "cbr";
		case JUMPI:		return "jumpI";
		case AND:		return "and";
		case ANDI:		return "andI";
		case OR:		return "or";
		case XOR:		return "xor";
		case ORI:		return "orI";
		case XORI:		return "orI";
		case NOP:
		default:		return "nop";
	}
}
