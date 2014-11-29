#include <stdlib.h>
#include <string.h>
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
