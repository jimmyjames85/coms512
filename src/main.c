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

int main(int argc, char * argv[])
{
	State * state2 = newState();


	State * state1 = newState();

	State * state3 = newState();

	printf("state1->id=%i\n",state1->id);
	printf("state2->id=%i\n",state2->id);
	printf("state3->id=%i\n",state3->id);

	stateAddProperty(state1, "green");
	stateAddProperty(state1, "blue");

	char * p = "blue";

	if(stateHasProperty(state1, p))
		printf("does have %s property\n", p);
	else
		printf("does NOT have %s property\n", p);



	stateRemoveProperty(state1,"blue");

	if(stateHasProperty(state1, p))
		printf("does have %s property\n", p);
	else
		printf("does NOT have %s property\n", p);
	freeState(state3);
	freeState(state1);
	freeState(state2);
	return 0;
}
