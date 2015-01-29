#include <stdio.h>
#include <string.h>
#include "node.h"


printDLLList(DLLNode * head)
{
	if(head==NULL_NODE)
		return;

	DLLNode * cur = head;

	while(cur!= NULL_NODE)
	{
		printf("%s\n", (char *)cur->data);
		cur = cur->next;
	}
}

int main(int argc, char * argv[])
{

	DLLNode * head = newDLLNode("hello world");
	DLLNode * cur = head;

	int i;
	for(i=0;i<10;i++)
	{
		char * str = malloc(sizeof(char)*80);
		strcpy(str,"node  # %d", i);
		setNextDLLNode(cur, newDLLNode(str));
		cur=cur->next;
	}
	//printf("%s\n", (char *) head->data);
	printDLLList(head);
	return 0;
}
