#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "list.h"
#include "node.h"
#include "stack.h"
#include "state.h"

void printList(List * list)
{
	int i = 0;
	for (i = 0; i < list->size; i++)
		printf("%s , ", (char*) list->arr[i]);

	printf("\n");
}
void printDLLList(DLLNode * head)
{
	DLLNode * cur = head;

	if (head == NULL_NODE)
		return;

	while (cur != NULL_NODE)
	{
		printf("%s\n", (char *) cur->data);
		cur = cur->next;
	}
}

//MAX 100 characters
char * newString(char * volatile format, ...)
{
	char * str = malloc(sizeof(char) * 101);
	va_list args;

	va_start(args, format);
	vsprintf(str, format, args);
	va_end(args);

	return str;
}
void printKripke(List * kripke)
{
	int i, j;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		printf("State %d: ( ", state->id);

		for (j = 0; j < state->properties->size; j++)
			printf("%s ", (char *) state->properties->arr[j]);

		printf(")\n");

		for (j = 0; j < state->markings->size; j++)
			printf("\t%s\n", (char *) state->markings->arr[j]);

		printf("\n\n");
	}
}

void resetMarking(List * kripke)
{
	int i, j;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];

		while (state->markings->size > 0)
			stateRemoveMarking(state, state->markings->arr[0]);

		for (j = 0; j < state->properties->size; j++)
			stateAddMarking(state, (char *) state->properties->arr[j]);

		stateAddMarking(state, "true");
	}

}

void markNot(List * kripke, char * p)
{
	char * m = newString("~(%s)", p);
	int i;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if (!stateHasMarking(state, p) && !stateHasMarking(state, m))
			stateAddMarking(state, m);
	}
	free(m);
}

void markAnd(List * kripke, char * p, char * q)
{
	char * m1 = newString("(%s&&%s)", p, q);
	char * m2 = newString("(%s&&%s)", q, p);

	int i;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if (stateHasMarking(state, p) && stateHasMarking(state, q))
		{
			if (!stateHasMarking(state, m1))
				stateAddMarking(state, m1);
			if (!stateHasMarking(state, m2))
				stateAddMarking(state, m2);
		}
	}
	free(m1);
	free(m2);
}
void markOr(List * kripke, char * p, char * q)
{
	char * m1 = newString("(%s||%s)", p, q);
	char * m2 = newString("(%s||%s)", q, p);

	int i;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if ((stateHasMarking(state, p) || stateHasMarking(state, q)))
		{
			if (!stateHasMarking(state, m1))
				stateAddMarking(state, m1);
			if (!stateHasMarking(state, m2))
				stateAddMarking(state, m2);
		}
	}
	free(m1);
	free(m2);
}

void markEX(List * kripke, char * p)
{
	int i, j;
	char * m = newString("EX%s", p);

	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		int marked = 0;

		List * nextStates = state->out;
		for (j = 0; j < nextStates->size && !marked; j++)
		{
			State * nextState = (State *) nextStates->arr[j];
			if (!marked && stateHasMarking(nextState, p))
			{
				stateAddMarking(state, m);
				marked = 1;
			}
		}
	}
	free(m);
}

void markAF(List * kripke, char * p)
{
	int i, j;
	char * m = newString("AF%s", p);

	int change = 1;
	while (change)
	{
		change = 0;
		for (i = 0; i < kripke->size; i++)
		{
			State * state = (State *) kripke->arr[i];
			int marked = 0;

			if (stateHasMarking(state, p) && !stateHasMarking(state, m))
			{
				marked = 1;
				stateAddMarking(state, m);
			}

			if (!marked)
			{
				int nextStateSum = 0;

				List * nextStates = state->out;
				for (j = 0; j < nextStates->size; j++)
				{
					State * nextState = (State *) nextStates->arr[j];

					if (stateHasMarking(nextState, m))
						nextStateSum++;

				}
				if (nextStateSum == nextStates->size && !stateHasMarking(state, m))
				{
					stateAddMarking(state, m);
					marked = 1;
				}
			}

			change += marked;
		}
	}

	free(m);
}

/**
 *	marks all states that satisfy E(pUq)
 */
void markEU(List * kripke, char * p, char * q)
{
	int i, j;
	char * mEpUq = newString("E(%sU%s)", p, q);
	for (i = 0; i < kripke->size; i++)
	{
		State * state = kripke->arr[i];
		if (stateHasMarking(state, q))
			stateAddMarking(state, mEpUq);
	}

	int subChange;
	int change = 1; //intially to get into the loop
	while (change)
	{
		change = 0;
		for (i = 0; i < kripke->size; i++)
		{
			State * state = kripke->arr[i];
			if (stateHasMarking(state, p) && !stateHasMarking(state, mEpUq))
			{
				subChange = 0;
				for (j = 0; j < state->out->size && !subChange; j++)
				{
					State * outState = (State *) state->out->arr[j];

					if (stateHasMarking(outState, mEpUq))
					{
						subChange = 1;
						change = 1;
						stateAddMarking(state, mEpUq);
					}
				}

			}
		}
	}
	free(mEpUq);
}

void markAX(List * kripke, char * p)
{

	markNot(kripke, p);
	char * m = newString("~(%s)", p);
	markEX(kripke, m); //EX~p
	free(m);
	m = newString("EX~(%s)", p);
	markNot(kripke, m);
	free(m);
	m = newString("~(EX~(%s))", p);
	char * mAXp = newString("AX%s", p);

	int i;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if (stateHasMarking(state, m))
		{
			stateRemoveMarking(state, m);
			stateAddMarking(state, mAXp);
		}
	}
	free(m);
	free(mAXp);

}
void markEG(List * kripke, char * p)
{
	markNot(kripke, p);
	char * m = newString("~(%s)", p);
	markAF(kripke, m);
	free(m);
	m = newString("AF~(%s)", p);
	markNot(kripke, m);
	free(m);

	m = newString("~(AF~(%s))", p);
	char * mEGp = newString("EG%s", p);

	int i;
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if (stateHasMarking(state, m))
		{
			stateRemoveMarking(state, m);
			stateAddMarking(state, mEGp);
		}
	}
	free(m);
	free(mEGp);
}
void markEF(List * kripke, char *p)
{
	int i;
	char * m = newString("E(trueU%s)",p);
	char * mEFp = newString("EF%s",p);

	markEU(kripke, "true", p);
	for (i = 0; i < kripke->size; i++)
	{
		State * state = (State *) kripke->arr[i];
		if (stateHasMarking(state, m))
		{
			stateRemoveMarking(state, m);
			stateAddMarking(state, mEFp);
		}
	}

	free(m);
	free(mEFp);
}
void markAG(List * kripke, char * p)
{

	char * m;
	char * mAGp = newString("AG%s",p);
	int i;

	markNot(kripke,p);

	m= newString("~(%s)",p);
	markEF(kripke,m);

	free(m);
	m=newString("EF~(%s)",p);

	markNot(kripke,m);
	free(m);
	m=newString("~(EF~(%s))",p);

	for(i=0;i<kripke->size;i++)
	{
		State * state = (State *)kripke->arr[i];
		if(stateHasMarking(state,m))
		{
			stateRemoveMarking(state,m);
			stateAddMarking(state,mAGp);
		}
	}

	free(m);
	free(mAGp);

}

int main(int argc, char * argv[])
{
	State * state0 = newState();
	State * state1 = newState();
	State * state2 = newState();
	State * state3 = newState();

	stateAddProperty(state1, "p");
	stateAddProperty(state1, "q");
	stateAddProperty(state2, "q");
	stateAddProperty(state2, "r");

	stateAddOut(state0, state1);
	stateAddOut(state0, state2);

	stateAddOut(state1, state2);

	stateAddOut(state2, state1);

	stateAddOut(state3, state1);

	List * kripke = newList();
	list_add(kripke, state0);
	list_add(kripke, state1);
	list_add(kripke, state2);
	list_add(kripke, state3);
	resetMarking(kripke);

	markNot(kripke,"p");
	markNot(kripke,"q");
	markOr(kripke,"~(p)","~(q)");

	markAF(kripke,"(~(p)||~(q))");
	markAG(kripke,"AF(~(p)||~(q))");

	//markAFp(kripke,"AG(p&&q)");



	printKripke(kripke);
	freeState(state0);
	freeState(state1);
	freeState(state2);
	freeState(state3);
	freeList(kripke);

	return 0;
}
