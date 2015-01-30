#include <stdlib.h>
#include "stack.h"
#include "node.h"

//int _terminal_node_ = 217;//different than null_node
//void * TERMINAL_NODE = (void *) &_terminal_node_;


Stack * newStack()
{
	Stack * ret = newSLLNode((void *)0);
	ret->next = NULL_NODE;
	return ret;
}

void stackPush(Stack * stack, void * data)
{
	Stack * top = newSLLNode(stack->data);
	top->next = stack->next;

	stack->data = data;
	stack->next = top;
}

void * stackPop(Stack * stack)
{
	if(stackIsEmpty(stack))
		return (void * )0;

	void * popped = stack->next;
	void * ret= stack->data;

	stack->data = stack->next->data;
	stack->next = stack->next->next;

	freeSLLNode(popped);
	return ret;

}

inline void * stackPeek(Stack * stack)
{
	return stack->data;
}


void freeStack(Stack * stack)
{
	while(!stackIsEmpty(stack))
		stackPop(stack);

	freeSLLNode(stack);
}

inline int stackIsEmpty(Stack * stack)
{
	return (stack->next==NULL_NODE);
}

