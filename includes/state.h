#ifndef STATE_H
#define STATE_H
#include "node.h"


typedef struct _struct_State
{
		int id;
		List * out; //List of neighbors I point to
		List * in; //List of neighbors that point to me
		List * properties;//Property List (list of char *)
		List * markings;//list of char *
} State;

State * newState();
void freeState(State * state);

void stateAddOut(State * state, State * outState);
void stateAddIn(State * state, State * inState);

void stateAddProperty(State * state, char * p);
int stateHasProperty(State * state, char * p);
int stateRemoveProperty(State * state, char * p);

void stateAddMarking(State * state, char * m);
int stateHasMarking(State * state, char * m);
int stateRemoveMarking(State * state, char * m);

//void satisfies(State * state, Property p);


#endif
