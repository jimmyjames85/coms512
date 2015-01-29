#include "node.h"

int _NULL_NODE_ = 0;
void * NULL_NODE = (void *) &_NULL_NODE_;

DLLNode * newDLLNode(void * data)
{
	DLLNode * ret = (DLLNode *) malloc(sizeof(DLLNode));
	ret->next = NULL_NODE;
	ret->prev = NULL_NODE;
	ret->data = data;
	return ret;
}
