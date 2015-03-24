/* To execute from command line: 
   > spin -a rivercrossing.pml
   > gcc -o pan pan.c
   > spin -t rivercrossing.pml 
*/

/* type is used to describe an enumerated type: in this case describes the players of the puzzle */
mtype = {farmer, goat, wolf, cabbage}; 


/* position describes the location of the players
   Go from 0 to 1 bank; by default initialized to 0: position[1] denotes the position of the farmer */
bool position[5]; 

/*****************************************/
/* Print Statements and position updates */
/* Farmer moving X \in {goat, wolf, cabbage}. "atomic" keyword is used to disallow any interleaving at this point */
#define move(X) atomic{ printf("Farmer moves with %e\n", X); position[farmer] = !position[farmer]; position[X] = !position[X]; }

/* Farmer moving alone */
#define moveAlone() atomic{ printf("Farmer moves alone\n"); position[farmer] = !position[farmer]; }
/*****************************************/


/*****************************************/
/* If the position of the farmer and X are equal, then X can move with the farmer */
/* This is a process: model checker explores all possible executions of this process
   (You can have many processes in your model: model checker explores all possible
    executions resulting from asynchronous composition of those processes)
*/
active proctype moves()
{
  /* non-deterministic options: model checker considers all possible choices for which the guard is satisfied */
  /* moveAlone does not have any guard */
  do
  :: position[farmer] == position[cabbage] -> move(cabbage);
  :: position[farmer] == position[wolf] -> move(wolf);
  :: position[farmer] == position[goat] -> move(goat);
  :: moveAlone();
  od;
}

/* This is the for writing the property */
#define safe ( (position[wolf] == position[goat] || position[goat] == position[cabbage]) -> position[farmer] == position[goat] )
#define otherside ( position[farmer] == 1 && position[goat] == 1 && position[cabbage] == 1 && position[wolf] == 1 )

/* All paths from any of the start states, the following holds:
   - safe until otherside is not true 
   Voilation of the property will present a counter-example: the solution
*/
ltl safeCross { ! (safe U otherside ) }
