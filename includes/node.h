#ifndef NODE_H
#define NODE_H
#include <stdlib.h>
#include "list.h"

extern void * NULL_NODE;

//################# Double Linked List ####################
typedef struct _struct_dllnode
{
		struct _struct_dllnode * prev;
		struct _struct_dllnode * next;
		void * data;
} DLLNode;

DLLNode * newDLLNode(void * data);
void freeDLLNode(DLLNode * node, int freeData);
DLLNode * setNextDLLNode(DLLNode * node, DLLNode * next);
DLLNode * setPrevDLLNode(DLLNode * node, DLLNode * prev);


//################# Double Linked List ####################

//#########################################################
//#########################################################

typedef struct _struct_node
{
		List * out; //List of neighbors I point to
		List * in; //List of neighbors that point to me
		void * data;
} Node;

Node * newNode(void * data);

//returns the data
void * freeNode(Node * node);

void addOutNode(Node * node, Node * outNode);
void addInNode(Node * node, Node * inNode);

//void removeOutNode(Node * node, Node * outNode);
//void removeInNode(Node * node, Node * inNode);




#endif

