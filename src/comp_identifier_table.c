#include <stdlib.h>
#include <string.h>
#include "main.h"

comp_identifier_item **identifier_table_create()
{
	return (comp_identifier_item **) calloc(DICT_SIZE, sizeof(comp_identifier_item *));
}

void identifier_table_print(comp_identifier_item *identifiers[DICT_SIZE])
{
	int index;
	for (index = 0; index < DICT_SIZE; ++index)
	{
		comp_identifier_item *item = identifiers[index];
		
		while (item != NULL)
		{
			printf("%4d %11p => [%010X] %c %c %2d %s\n", index, item, dict_hash(item->string), item->kind, item->type, item->size, item->string);
			
			item = item->next;
		}
	}
}

void identifier_table_free(comp_identifier_item *identifiers[DICT_SIZE])
{
	int index;
	for (index = 0; index < DICT_SIZE; ++index)
	{
		comp_identifier_item *item_next, *item = identifiers[index];
		
		while (item != NULL)
		{
			item_next = item->next;
			
			free(item);
			
			item = item_next;
		}
	}

	free(identifiers);
}

comp_identifier_item *identifier_table_get(comp_identifier_item *identifiers[DICT_SIZE], char *string)
{
	int index = dict_index(string);
	
	comp_identifier_item *item = identifiers[index];
	
	// find key in the bucket
	while ((item != NULL) && (strcmp(item->string, string) != 0))
	{
		item = item->next;
	}
	
	return item;
}

void identifier_table_add(comp_identifier_item *identifiers[DICT_SIZE], char *string, int kind, int type, int size)
{
	int index = dict_index(string);
	
	comp_identifier_item *item = identifiers[index];
	
	// create new entry
	item = (comp_identifier_item *) malloc(sizeof(comp_identifier_item));
	
	item->string = string;
	item->kind = kind;
	item->type = type;
	item->size = size;
	item->params = 0;
	item->params_type = 0;
	
	item->next = identifiers[index];
	
	identifiers[index] = item;
}
