#include <stdlib.h>
#include <string.h>
#include "main.h"

comp_dict_item_t *symbols[DICT_SIZE];

unsigned int dict_hash(char *s)
{
	unsigned long hash = 5381;
	
	int mix = s[0] * B;
	
	int c;

	// handle empty string symbols
	if (s[0] == '\0')
	{
		c = s[0] * A;
	}
	else
	{
		c = s[strlen(s) - 1] * A;
	}
	
	while (c = *s++)
	{
		hash = ((hash << 5) + hash) ^ c;
	}
	
	return hash + mix;
}

unsigned int dict_index(char *key)
{
	return dict_hash(key) % DICT_SIZE;
}

void dict_print()
{
	int index;
	for (index = 0; index < DICT_SIZE; ++index)
	{
		comp_dict_item_t *item = symbols[index];
		
		while (item != NULL)
		{
			printf("%4d %11p => ", index, item);
			
			switch (item->type)
			{
				case IKS_SIMBOLO_LITERAL_INT:
					printf("(%c) %d ", 'i', item->symbol.int_value);
					break;
				case IKS_SIMBOLO_LITERAL_FLOAT:
					printf("(%c) %f ", 'f', item->symbol.float_value);
					break;
				case IKS_SIMBOLO_LITERAL_CHAR:
					printf("(%c) %c ", 'c', item->symbol.char_value);
					break;
				case IKS_SIMBOLO_LITERAL_STRING:
					printf("(%c) %s ", 's', item->symbol.string_value);
					break;
				case IKS_SIMBOLO_LITERAL_BOOL:
					printf("(%c) %d ", 'b', item->symbol.bool_value);
					break;
				case IKS_SIMBOLO_IDENTIFICADOR:
					printf("(%c) %s ", 'n', item->symbol.string_value);
			}

			printf("%s [%3X] : %2d\n", item->key, dict_hash(item->key), item->last_seen);

			item = item->next;
		}
	}
}

void dict_free()
{
	int index;
	for (index = 0; index < DICT_SIZE; ++index)
	{
		comp_dict_item_t *item_next, *item = symbols[index];
		
		while (item != NULL)
		{
			item_next = item->next;
			
			free(item->key);
			free(item);
			
			item = item_next;
		}
	}
}

int get_symbol_line(char *key, int type)
{
	int index = dict_index(key);
	
	comp_dict_item_t *item = symbols[index];
	
	while ((item != NULL) && ((strcmp(item->key, key) != 0) || (item->type != type)))
	{
		item = item->next;
	}
	
	if (item == NULL)
	{
		return -1;
	}
	
	return item->last_seen;
}

comp_dict_item_t *add_or_update_symbol_line(char *lexeme, int symbol_length, int type, int line)
{
	// trim key quotes
	char *symbol = (char *) malloc((symbol_length + 1) * sizeof(char));
	strncpy(symbol, lexeme, symbol_length);
	symbol[symbol_length] = '\0';

	int index = dict_index(symbol);
	
	comp_dict_item_t *item = symbols[index];
	
	// find key in the bucket
	while ((item != NULL) && ((strcmp(item->key, symbol) != 0) || (item->type != type)))
	{
		item = item->next;
	}
	
	// create new entry if not found
	if (item == NULL)
	{
		item = (comp_dict_item_t *) malloc(sizeof(comp_dict_item_t));
		
		item->key = symbol;

		switch (type)
		{
			case IKS_SIMBOLO_LITERAL_INT:
				item->symbol.int_value = atoi(item->key);
				break;
			case IKS_SIMBOLO_LITERAL_FLOAT:
				item->symbol.float_value = atof(item->key);
				break;
			case IKS_SIMBOLO_LITERAL_CHAR:
				item->symbol.char_value = item->key[0];
				break;
			case IKS_SIMBOLO_LITERAL_STRING:
			case IKS_SIMBOLO_IDENTIFICADOR:
				item->symbol.string_value = item->key;
				break;
			case IKS_SIMBOLO_LITERAL_BOOL:
				item->symbol.bool_value = !strcmp(item->key, "true");
				break;
		}

		item->type = type;
		
		item->next = symbols[index];
		
		symbols[index] = item;
	}
	// free symbol if found, since the entry already has the symbol and only the line needs update
	else
	{
		free(symbol);
	}
	
	item->last_seen = line;

	return item;
}
