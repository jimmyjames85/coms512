#include "node.h"

void * NULL_NODE = (void *) 0;

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
	if (node == NULL_NODE)
		return;

	DLLNode * prev = node->prev;
	DLLNode * next = node->next;

	if (prev != NULL_NODE)
		prev->next = next;
	if (next != NULL_NODE)
		next->prev = prev;

	if (freeData)
		free((void *) node->data);

	free((void *) node);

}

DLLNode * setNextDLLNode(DLLNode * node, DLLNode * next)
{
	if (node == NULL_NODE)
		return NULL_NODE;

	DLLNode * ret = node->next;

	node->next = next;
	if (next != NULL_NODE)
		next->prev = node;

	return ret;
}

DLLNode * setPrevDLLNode(DLLNode * node, DLLNode * prev)
{
	if (node == NULL_NODE)
		return NULL_NODE;

	DLLNode * ret = node->prev;

	node->prev = prev;
	if (prev != NULL_NODE)
		prev->next = node;

	return ret;
}

Node * newNode(void * data)
{
	Node * ret = (Node *) malloc(sizeof(Node));
	ret->out = newList();
	ret->in = newList();
	ret->data = data;
	return ret;
}

void * freeNode(Node * node)
{
	if (node == NULL_NODE)
		return 0;

	void * ret = node->data;

	freeList(node->in);
	freeList(node->out);
	free(node);
	return ret;
}
void addOutNode(Node * node, Node * outNode)
{
	if (node == NULL_NODE || outNode == NULL_NODE)
		return;

	list_add(node->out,outNode);
	list_add(outNode->in,node);
}

void addInNode(Node * node, Node * inNode)
{
	addOutNode(inNode, node);
}

//void removeOutNode(Node * node, Node * outNode);
//void removeInNode(Node * node, Node * inNode);

