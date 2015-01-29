#include <stdio.h>

#include "node.h"

int main(int argc, char * argv[])
{
	DLLNode * head = newDLLNode("hello world\n");
	printf("%s\n", (char *) head->data);
	return 0;
}
