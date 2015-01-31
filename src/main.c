#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "list.h"
#include "node.h"
#include "stack.h"
#include "state.h"

void printList(List * list)
{
	int i = 0;
	for (i = 0; i < list->size; i++)
		printf("%s , ", (char*) list->arr[i]);

	printf("\n");
}
void printDLLList(DLLNode * head)
{
	DLLNode * cur = head;

	if (head == NULL_NODE)
		return;

	while (cur != NULL_NODE)
	{
		printf("%s\n", (char *) cur->data);
		cur = cur->next;
	}
}

//MAX 100 characters
char * newString(char * volatile format, ...)
{
	char * str = malloc(sizeof(char) * 101);
	va_list args;

	va_start(args, format);
	vsprintf(str, format, args);
	va_end(args);

	return str;
}
void printKripke(List * kripke)
{
	int i, j;
	for(i=0;i<kripke->size;i++)
	{
		State * state = (State *) kripke->arr[i];
		printf("State %d: ( ",state->id);

		for(j=0;j<state->properties->size;j++)
			printf("%s ",(char *)state->properties->arr[j]);

		printf(")\n");

		for(j=0;j<state->markings->size;j++)
			printf("\t%s\n",(char *)state->markings->arr[j]);

		printf("\n\n");
	}
}
void markEXp(List * kripke, char * p)
{
	int i, j;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];

		List * nextStates = state->out;
		for (j = 0; j < nextStates->size; j++)
		{
			State * nextState = (State *) nextStates->arr[j];
			if (stateHasProperty(nextState, p))
			{
				char * m = newString("EX%s", p);
				printf("%s\n",m);
				stateAddMarking(state, m);
				free (m);
			}
		}
	}
}

int main(int argc, char * argv[])
{
	State * state0 = newState();
	State * state1 = newState();
	State * state2 = newState();
	State * state3 = newState();
	State * state4 = newState();

	stateAddProperty(state1, "a");
	stateAddProperty(state2, "a");
	stateAddProperty(state2, "b");
	stateAddProperty(state3, "b");
	stateAddProperty(state4, "b");

	stateAddOut(state0, state1);
	stateAddOut(state0, state4);

	stateAddOut(state1, state2);

	stateAddOut(state2, state3);

	stateAddOut(state3, state1);
	stateAddOut(state3, state3);

	stateAddOut(state4, state4);

	List * kripke = newList();
	list_add(kripke, state0);
	list_add(kripke, state1);
	list_add(kripke, state2);
	list_add(kripke, state3);
	list_add(kripke, state4);

	markEXp(kripke,"b");
	printKripke(kripke);

	freeState(state0);
	freeState(state1);
	freeState(state2);
	freeState(state3);
	freeState(state4);
	freeList(kripke);



	return 0;
}
