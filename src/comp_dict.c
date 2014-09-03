#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "comp_dict.h"

comp_dict_item_t *symbols[DICT_SIZE];

unsigned dict_hash(unsigned char *str)
{
	unsigned long hash = 5381;
	
	int mix = str[0] * B;
	int c = str[strlen(str) - 1] * A;
	
	while (c = *str++)
	{
		hash = ((hash << 5) + hash) ^ c;
	}
	
	return hash + mix;
}

int dict_index(char *key)
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
			printf("%2d %11p => %s (%3X) : %2d\n", index, item, item->symbol, dict_hash(item->symbol), get_symbol_line(item->symbol));
			
			item = item->next;
		}
	}
}

int get_symbol_line(char *symbol)
{
	int index = dict_index(symbol);
	
	comp_dict_item_t *item = symbols[index];
	
	while ((item != NULL) && (strcmp(item->symbol, symbol) != 0))
	{
		item = item->next;
	}
	
	if (item == NULL)
	{
		return -1;
	}
	
	return item->last_seen;
}

void add_or_update_symbol_line(char *symbol, int line)
{
	int index = dict_index(symbol);
	
	comp_dict_item_t *item = symbols[index];
	
	while ((item != NULL) && (strcmp(item->symbol, symbol) != 0))
	{
		item = item->next;
	}
	
	if (item == NULL)
	{
		item = (comp_dict_item_t *) malloc(sizeof(comp_dict_item_t));
		
		item->symbol = (char *) malloc((strlen(symbol) + 1) * sizeof(char));
		strcpy(item->symbol, symbol);
		
		item->next = symbols[index];
		
		symbols[index] = item;
	}
	
	item->last_seen = line;
}
