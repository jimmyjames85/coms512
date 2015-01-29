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

void freeDLLNode(DLLNode * node, int freeData)
{
	if(node==NULL_NODE)
		return;

	DLLNode * prev = node->prev;
	DLLNode * next = node->next;

	if(prev!=NULL_NODE)
		prev->next = next;
	if(next!=NULL_NODE)
		next->prev = prev;

	if(freeData)
		free((void *) node->data);

	free((void *) node);

}


DLLNode * setNextDLLNode(DLLNode * node, DLLNode * next)
{
	if(node==NULL_NODE)
		return NULL_NODE;

	DLLNode * ret = node->next;

	node->next = next;
	if(next!=NULL_NODE)
		next->prev = node;

	return ret;
}

DLLNode * setPrevDLLNode(DLLNode node, DLLNode * prev)
{
	if(node==NULL_NODE)
		return NULL_NODE;

	DLLNode * ret = node->prev;

	node->prev= prev;
	if(prev!=NULL_NODE)
		prev->next= node;

	return ret;
}
