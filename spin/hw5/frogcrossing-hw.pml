int position[7]; /* 0: no frog in the position; 1: green frogs in the position; 2: yellow frogs in the position */

mtype { green, yellow };

byte rock=0;


/*
   The move function: 
   pos1: current position of a frog
   pos2: new position of the frog
   frog: 1 for green frog
         2 for yellow frog

   You will involve this function from the process "moves"

*/
#define move(pos1, pos2, frog) atomic{ printf("Frog %d moves from %d to %d\n", frog, pos1, pos2); position[pos1] = 0; position[pos2] = frog; }

#define increaseRock() atomic { rock=rock+1; }
#define decreaseRock() atomic { rock=rock-1; }


/*
#define nextPos(curPos) (position[curPos]==green && curPos < 6 && [curPos+1]==0 ? curPos+1 : \
			 (position[curPos]==green && curPos < 5 && [curPos+2]==0 ? curPos+2 : \
			  (position[curPos]==yellow && curPos > 0 && [curPos-1]==0 ? curPos-1 : \
			   (position[curPos]==yellow && curPos > 1 && [curPos-2]==0 ? curPos-2 : \
			    curPos))))

*/
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
/*    :: rock > 0 -> rock=rock-1;
    :: rock < 6 -> rock=rock+1;*/
    :: rock<6 -> increaseRock();
    :: rock==6 -> rock=rock - 1;
    :: printf("rock==%d\n", rock);
  od;
  
/*  do
  :: position[farmerp] == position[cabbage] -> move(cabbage);
  :: position[farmer] == position[wolf] -> move(wolf);
  :: position[farmer] == position[goat] -> move(goat);
  :: moveAlone();
  od;*/
  
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


ltl frogCross { ! <> ( [] (rock==6)) }