#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "list.h"
#include "node.h"
#include "stack.h"

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
	Stack * stack = newStack();
	if (stackIsEmpty(stack))
		printf("Stack is empty.\n");
	else
		printf("Stack is NOT empty.\n");

	printf("Loading...\n");
	stackPush(stack, newString("one"));
	stackPush(stack, newString("two"));
	stackPush(stack, newString("three"));
	stackPush(stack, newString("four"));
	stackPush(stack, newString("five"));

	while(!stackIsEmpty(stack))
		free(stackPop(stack));

	freeStack(stack);

	/*if (stackIsEmpty(stack))
		printf("Stack is empty.\n");
	else
		printf("Stack is NOT empty.\n");

	printf("Stack peek='%s'\n",(char *)stackPeek(stack));*/



	return 0;
}
