/* States Definition */
mtype = {s1, s2, s3, s4, s5}

/* Current State */
byte pi=s1;/* Start state = s1 */


#define move(from, to) \
atomic \
{\
 printf("==================  %e -> %e  ==================\n",from,to);\
 pi=to;\
}

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


/*  <>  :=  F
    []  :=  G
*/





/*====================================================================
H4.1.A     FGc

 This is false. Consider the path:

    s1 -> s3 -> s4 -> s5 -> s4 -> s5 ... -> s4 -> s5 ...

 Thus there exists a path where Gc is never true
 

ltl p1 { ( <> [] c )  }
*/




/*====================================================================
H4.1.B     GFc

 This is false. Consider the path 

   s1 -> s3 -> s4 -> s5 -> s5 -> ... -> s5 ...

 Thus there exists a path where Fc is not globably true
 
ltl p2 { ( [] <> c )  } 
*/

/*====================================================================
H4.1.C:    X~c => XXc

This is vacuously true because in every path starting from s1, X~C is
false and thus the implication is always true. There are only two
paterns of paths

   i. s1 -> s3 -> ...
  ii. s1 -> s4 -> ...

 and in both next states in each pattern ~c is false thus
 s1 := (X~c => XXc)

ltl p3  { ! ( (X (! c) ) -> X X c) }
*/

/*====================================================================
H4.1.D:    a U G(b V c)

 This is false: Consider the path

   s1 -> s4 -> s5 -> s5 -> ... -> s5 ...

 In this path a holds until s5. But s5 is neither labled with b or c.

 

 ltl p4 { ! ( a U ([] ( b || c ))) }
 ltl p4 { !  ( ( pi == s1 || pi == s4 ) U ( [] ( pi == s5 )  ) ) }

NOTE: I couldn't get spin to accept my ltl never claim ????
*/

