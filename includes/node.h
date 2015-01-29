#ifndef NODE_H
#define NODE_H
#include <stdlib.h>

extern void * NULL_NODE;

typedef struct _struct_dllnode
{
		struct _struct_dllnode * prev;
		struct _struct_dllnode * next;
		void * data;
} DLLNode;

DLLNode * newDLLNode(void * data);

#endif



