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
	State * state = newState();
	stateAddProperty(state, "green");
	stateAddProperty(state, "blue");

	char * p = "blue";

	if(stateHasProperty(state, p))
		printf("does have %s property\n", p);
	else
		printf("does NOT have %s property\n", p);



	stateRemoveProperty(state,"blue");

	if(stateHasProperty(state, p))
		printf("does have %s property\n", p);
	else
		printf("does NOT have %s property\n", p);

	freeState(state);
	return 0;
}
