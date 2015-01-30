#include <stdlib.h>
#include <string.h>
#include "state.h"

State * newState()
{
	State * ret = (State *) newNode(newList());
	return ret;
}

void freeState(State * state)
{
	List * pList = state->data;
	while (pList->size > 0)
		free(list_remove(pList, 0));

	freeList(state->data);
	freeNode(state);
}

void stateAddProperty(State * state, char * p)
{
	size_t len = strlen(p);
	char * newStr = malloc(len * sizeof(char));
	strcpy(newStr,p);
	list_add(state->data,newStr);
}

int stateHasProperty(State * state, char * p)
{
	List * pList = state->data;
	int i;
	short found =0;
	for(i=0;!found && i<pList->size;i++)
		found = (strcmp(p,pList->arr[i])==0);
	return found;
}


int stateRemoveProperty(State * state, char * p)
{
	List * pList = state->data;
	int i;
	for(i=pList->size-1;i>=0;i--)
	{
		if(strcmp(p,pList->arr[i])==0);
			free(list_remove(pList,i));
	}
	return 1;
}
