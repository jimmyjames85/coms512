



/* States Definition */
mtype = {s1, s2, s3, s4, s5}

/* Current State */
byte pi=s1;/* Start state = s1 */


#define move(from, to) atomic {  printf("==================  %e -> %e  ==================\n",from,to); pi=from; pi=to; }

active proctype transitionTable()
{
  
  do
    :: (pi==s1) -> move(s1, s3);
    :: (pi==s1) -> move(s1, s4); 

    :: (pi==s2) -> move(s2, s4);
		     
    :: (pi==s3) -> move(s3, s4);
		     
    :: (pi==s4) -> move(s4, s2); 
    :: (pi==s4) -> move(s4, s3); 
    :: (pi==s4) -> move(s4, s5);
		     
    :: (pi==s5) -> move(s5, s4); 
    :: (pi==s5) -> move(s5, s5);
  od;
}

/* Labeling Function */
#define a ( (pi==s1) || (pi==s4) )
#define b ( (pi==s3) || (pi==s4) )
#define c ( (pi==s2) || (pi==s3) || (pi==s4) )
#define e ( (pi==s5) )

/*  <>  :=  F
    []  :=  G
*/



/*
ltl p1 { ( <> [] c )  } /* FGc */
/*
ltl p2 { ( [] <> c )  } /* GFc */

ltl p3  { ! ( (X (! c) ) -> X X c) }
/* ltl p3 { ! ( <> [] ( ( a -> c) ) ) } */