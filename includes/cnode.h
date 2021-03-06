#ifndef C_NODE_H
#define C_NODE_H
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
void * freeDLLNode(DLLNode * node);
DLLNode * setNextDLLNode(DLLNode * node, DLLNode * next);
DLLNode * setPrevDLLNode(DLLNode * node, DLLNode * prev);

//################# Single Linked List ####################

typedef struct _struct_sllnode
{
		struct _struct_sllnode * next;
		void * data;
} SLLNode;

SLLNode * newSLLNode(void * data);
void * freeSLLNode(SLLNode * node);
SLLNode * setNextSLLNode(SLLNode * node, SLLNode * next);

//######################### Node ##########################

typedef struct _struct_node
{
		List * out; //List of neighbors I point to
		List * in; //List of neighbors that point to me
		void * data;
} CNode;

CNode * newNode(void * data);

//returns the data
void * freeNode(CNode * node);

void addOutNode(CNode * node, CNode * outNode);
void addInNode(CNode * node, CNode * inNode);

//void removeOutNode(Node * node, Node * outNode);
//void removeInNode(Node * node, Node * inNode);




#endif

