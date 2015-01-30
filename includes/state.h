#ifndef STATE_H
#define STATE_H
#include "node.h"

//typedef char * Property;//properties are just strings
//typedef List PropertyList;//PropertyList only contains Property's
/*typedef struct _struct_state_data <=might need this later <=this is a stupid comment <== you're stupid
{
		Property * pList;
} StateData;*/

typedef Node State;//(states are nodes where data type is PropertyList

State * newState();
void freeState(State * state);

void stateAddProperty(State * state, char * p);
int stateHasProperty(State * state, char * p);
int stateRemoveProperty(State * state, char * p);
//void satisfies(State * state, Property p);


#endif
