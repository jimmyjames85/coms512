#ifndef STACK_H
#define STACK_H
#include "cnode.h"

typedef SLLNode Stack;

Stack * newStack();
void freeStack(Stack * stack);
void * stackPop(Stack * stack);
void stackPush(Stack * stack, void * data);
void * stackPeek(Stack * stack);
int stackIsEmpty(Stack * stack);

#endif
