/* States Definition */
mtype = {s0, s1, s2, s3}

/* Current State */
byte pi=s1;/* Start state = s0 */


#define move(from, to) \
atomic \
{\
 printf("==================  %e -> %e  ==================\n",from,to);\
 pi=to;\
}

active proctype transitionTable()
{

  do
    
    :: (pi==s0) -> move(s0, s0);
    :: (pi==s0) -> move(s0, s1); 
    :: (pi==s0) -> move(s0, s2);
		   
    :: (pi==s1) -> move(s1, s3); 

    :: (pi==s2) -> move(s2, s1);
		     
    :: (pi==s3) -> move(s3, s3);
    :: (pi==s3) -> move(s3, s2);

  od;
}

/* Labeling Function */
#define a ( (pi==s0) || (pi==s2) || (pi==s3) )
#define b ( (pi==s0) )


/*
    <>  :=  F
    []  :=  G
*/


/*====================================================================
H4.2

 All states satisfy F(a && Xa)

s0:
 s0 has three paterns determined by the first transition
     i. s0 -> s0 -> ... In this path the 1st s0 satisfies (a && Xa)
    ii. s0 -> s2 -> ... In this path the 1st s0 satisfies (a && Xa)
 
   iii. s0 -> s1 -> s3 -> ... and s3 satisfies (a && Xa) *see below

 so s0 satisfies F(a && Xa)

s1:
 s1 has one patern
     i. s1 -> s3 -> ... and s3 satisfies (a && Xa)

 so s1 eventually satisfies (a && Xa)


s2:
 s2 has one pattern
     i. s2 -> s1 -> ... and s1 satisfies (a && Xa)

 so s2 eventually satisfies (a && Xa)

s3:
 s3 has 2 paterns determined by the first transition
     i. s3 -> s3 -> ... In this path the 1st s3 satisfies (a && Xa)
    ii. s3 -> s2 -> ... In this path the 1st s3 satisfies (a && Xa)

 thus s3 satisfies F(a && Xa)

Thus all states satisfy F(a && Xa)





 ltl p1 { ! ( <> (a && X a)) } 
*/

