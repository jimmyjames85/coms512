#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "list.h"
#include "node.h"

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

	Node * node1 = newNode(newString("red"));
	Node * node2 = newNode(newString("yellow"));
	Node * node3 = newNode(newString("green"));
	Node * node4 = newNode(newString("black"));

	addOutNode(node1, node3);
	addOutNode(node3, node2);
	addOutNode(node2, node1);
	addOutNode(node2, node4);
	addOutNode(node4, node2);



	int n = 4;
	Node * nList[] =
	{ node1, node2, node3, node4 };

	for (n = 0; n < 4; n++)
	{
		List * n2list = nList[n]->out;
		int i = 0;
		printf("node%u->out\n",n+1);
		for (i = 0; i < n2list->size; i++)
			printf("\t\t%s\n", (char *) ((Node *) n2list->arr[i])->data);

		List * in2list = nList[n]->in;
		printf("node%u->in\n",n+1);
		for (i = 0; i < in2list->size; i++)
			printf("\t\t%s\n", (char *) ((Node *) in2list->arr[i])->data);

	}
	int i;
	for (i = 0; i < 4; i++)
		free(freeNode(nList[i]));

	List * list1 = newList();

	for (i = 0; i < 10; i++)
	{
		list_add(list1, newString("item%u", i));
		printf("list->size = %u, list->capacity = %u :", list1->size, list1->capacity);
		printList(list1);
	}

	for (i = 0; i < 10; i++)
	{
		char * rem = list_remove(list1, 0);
		printf("removing %s\n", rem);
		free(rem);
		printf("list->size = %u, list->capacity = %u :", list1->size, list1->capacity);
		printList(list1);
	}

	free(list1->arr);
	free(list1);

	return 0;
}
