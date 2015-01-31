#include <stdlib.h>
#include <string.h>
#include "state.h"

int uid = 0;

State * newState()
{
	State * ret = (State*) malloc(sizeof(State));
	ret->out = newList();
	ret->in = newList();
	ret->properties = newList();
	ret->markings = newList();
	ret->id = uid++;
	return ret;
}

void freeState(State * state)
{
	freeList(state->in);
	freeList(state->out);

	while (state->properties->size > 0)
		free(list_remove(state->properties, 0));
	freeList(state->properties);

	while (state->markings->size > 0)
		free(list_remove(state->markings, 0));
	freeList(state->markings);

	free(state);
}

void stateAddOut(State * state, State * outState)
{
	list_add(state->out, outState);
	list_add(outState->in, state);
}
void stateAddIn(State * state, State * inState)
{
	stateAddOut(inState, state);
}

void addStrToList(List * list, char * str)
{
	size_t len = strlen(str)+1;
	char * newStr = malloc(len * sizeof(char));
	strcpy(newStr, str);
	list_add(list, newStr);
}
int doesListOfStringsContain(List * list, char * str)
{
	int i;
	short found = 0;
	for (i = 0; !found && i < list->size; i++)
		found = (strcmp(str, list->arr[i]) == 0);
	return found;
}
void removeStrFromList(List * list, char * str)
{
	int i;
	for (i = list->size - 1; i >= 0; i--)
	{
		if (strcmp(str, list->arr[i]) == 0)
			free(list_remove(list, i));
	}
}
void stateAddProperty(State * state, char * p)
{
	addStrToList(state->properties, p);
}
void stateAddMarking(State * state, char * m)
{
	addStrToList(state->markings, m);
}

int stateHasProperty(State * state, char * p)
{
	return doesListOfStringsContain(state->properties, p);
}

int stateHasMarking(State * state, char * m)
{
	return doesListOfStringsContain(state->markings, m);
}

int stateRemoveProperty(State * state, char * p)
{
	removeStrFromList(state->properties,p);
	return 1;
}
int stateRemoveMarking(State * state, char * m)
{
	removeStrFromList(state->markings,m);
	return 1;
}
