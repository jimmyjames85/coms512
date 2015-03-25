int position[7]; /* 0: no frog in the position; 1: green frogs in the position; 2: yellow frogs in the position */


/*
   The move function: 
   pos1: current position of a frog
   pos2: new position of the frog
   frog: 1 for green frog
         2 for yellow frog

   You will involve this function from the process "moves"

*/
#define move(pos1, pos2, frog) atomic{ printf("Frog %d moves from %d to %d\n", frog, pos1, pos2); position[pos1] = 0; position[pos2] = frog; }

/*
   Specification of moves():
   Repeat forever:
     Non-deterministically selects some position. If the frog in that position can move, then the position of the frog is updated
     by invoking the "move" function above. 
*/
proctype moves()
{ 
/* ASSIGNMENT: Write the implementation of moves here */
  
}

init 
{
   /* Initial position of all frogs: position[3] = 0 */
   position[0] = 1;
   position[1] = 1;
   position[2] = 1;
   position[4] = 2;
   position[5] = 2;
   position[6] = 2;

   run moves();
}


/* ASSIGNMENT: Write an LTL property such that violation of the property produces a counter-example showing
   the solution to the problem. 
*/

