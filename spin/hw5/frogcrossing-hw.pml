/*

My plan to model this was to have the byte rock be
non-deterministically chosen. This is the decider of what frog will
may make a move (if possible). The moves() proc always increments or
decrements this value and it always stays between 0 and 6.

After the rock position has been decided the moves() proc moves the
frog at that posistion to another rock (if possible). My ltl spec:

 ltl frogCross { ! ( <> ( finalPositions ) ) }

says, "There is no future where finalPositions is true" where
finalPositions is defined as:
 
                       (  ( position[0] == 2 ) && \ All yellow  
			  ( position[1] == 2 ) && \ frogs on the 
			  ( position[2] == 2 ) && \ left
			  ( position[3] == 0 ) && \
			  ( position[4] == 1 ) && \ All green
			  ( position[5] == 1 ) && \ frogs on the 
			  ( position[6] == 1 ) )    right


This ltl propisition is false and spin outputs a path where
finalPositions is true. To see the final solution run spin -t and pipe
it into grep "^ Frog"
 
 Frog 2 moves from 4 to 3
 Frog 1 moves from 2 to 4
 Frog 1 moves from 1 to 2
 Frog 2 moves from 3 to 1
 Frog 2 moves from 5 to 3
 Frog 2 moves from 6 to 5
 Frog 1 moves from 4 to 6
 Frog 1 moves from 2 to 4
 Frog 1 moves from 0 to 2
 Frog 2 moves from 1 to 0
 Frog 2 moves from 3 to 1
 Frog 2 moves from 5 to 3
 Frog 1 moves from 4 to 5
 Frog 1 moves from 2 to 4
 Frog 2 moves from 3 to 2


Another way that works is:

  ltl frogCross {  ( [] ( ! finalPositions ) ) }

 
*/

int position[7]; /* 0: no frog in the position; 1: green frogs in the position; 2: yellow frogs in the position */

#define GREEN 1
#define YELLOW 2


byte rock = 0;


/*
   The move function: 
   pos1: current position of a frog
   pos2: new position of the frog
   frog: 1 for green frog
         2 for yellow frog

   You will involve this function from the process "moves"

*/


#define move(pos1, pos2, frog) atomic{ printf("\n\n Frog %d moves from %d to %d\n\n", frog, pos1, pos2); position[pos1] = 0; position[pos2] = frog; }

/*
   Specification of moves():
   Repeat forever:
     Non-deterministically selects some position. If the frog in that position can move, then the position of the frog is updated
     by invoking the "move" function above. 
*/
proctype moves()
{

  /* ASSIGNMENT: Write the implementation of moves here */
  do
    ::
       if
	    :: ( rock<6 ) -> rock=rock+1 -> printf ("\n\n ________checking Rock # %d\n\n", rock) 
	    :: ( rock>0 ) -> rock=rock-1-> printf ("\n\n ________checking Rock # %d\n\n", rock) 
       fi 
    :: position[rock] == GREEN && rock < 6 && position[rock+1] == 0 -> move(rock, rock+1, GREEN) 
    :: position[rock] == GREEN && rock < 5 && position[rock+2] == 0  -> move(rock, rock+2, GREEN)
    :: position[rock] == YELLOW && rock > 0 && position[rock-1] == 0  ->move(rock, rock-1, YELLOW)
    :: position[rock] == YELLOW && rock > 1 && position[rock-2] == 0  -> move(rock, rock-2,YELLOW)
  od
}

init 
{
   /* Initial position of all frogs: position[3] = 0 */
   position[0] = 1;
   position[1] = 1;
   position[2] = 1;
   position[3] = 0;  
   position[4] = 2;
   position[5] = 2;
   position[6] = 2;
   run moves();
}


/* ASSIGNMENT: Write an LTL property such that violation of the property produces a counter-example showing
   the solution to the problem. 
*/

/*  <>  :=  F
    []  :=  G
*/



#define finalPositions (  ( position[0] == 2 ) && \
			  ( position[1] == 2 ) && \
			  ( position[2] == 2 ) && \
			  ( position[3] == 0 ) && \
			  ( position[4] == 1 ) && \
			  ( position[5] == 1 ) && \
			  ( position[6] == 1 ) )

/*ltl frogCross {  ( [] ( ! finalPositions ) ) } */
ltl frogCross { ! ( <> ( finalPositions ) ) }
