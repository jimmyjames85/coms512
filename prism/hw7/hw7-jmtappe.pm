dtmc

module game


//*************** Init Variables ****************//    

    pickDie: [0..2] init 0;      // 0 is reset
			         // 1 is roll 1st die
			         // 2 is roll 2nd die
    
    ds : [0..7] init 7;          // (Single) Dice State - This is
			         // taken from the dice.pm in the
			         // example folder (init 7 := idle)
    
    dv : [0..6] init 0;	         // (Single) Dice Value - This is
			         // taken from the dice.pm in the
			         // example folder

    rollVal: [0..12] init 0;     // Roll Value - of both dice when
 			         // both have been rolled

    lastRoll: [0..12] init 0;    // Roll Value - of both dice when
 			         // both have been rolled

    state: [0..5] init 0;        // Actual States (s0..s5) 
				 // State=6 := Roll Dice

    nextState: [0..4] init 0;    // Next state to goto after a roll

    rollCount: [0..10] init 0;   // For the second Question

//*************** Roll Two Dice ****************//
  
   //In order to make a roll set state=5 and pickDie=0 and rollVal=0

   //After this subModule runs it sets the rollVal and sets state'= nextState

    [] state=5 & pickDie=0 & rollVal=0 -> (pickDie'=1) & (ds'=0)  ;
    [] state=5 & pickDie=1 & ds=7 -> (pickDie'=2) & (ds'=0) & (rollVal'=dv); 
    [] state=5 & pickDie=2 & ds=7  ->  (rollVal'=min(rollVal+dv, 12)) & (state'=nextState) & (rollCount'= min(rollCount + 1, 10)); 


    //*************** Roll Single Die ****************//    

    [] state=5 & pickDie!=0 & ds=0 -> 0.5 : (ds'=1) + 0.5 : (ds'=2);
    [] state=5 & pickDie!=0 & ds=1 -> 0.5 : (ds'=3) + 0.5 : (ds'=4);
    [] state=5 & pickDie!=0 & ds=2 -> 0.5 : (ds'=5) + 0.5 : (ds'=6);
    [] state=5 & pickDie!=0 & ds=3 -> 0.5 : (ds'=1) + 0.5 : (ds'=7) & (dv'=1); 
    [] state=5 & pickDie!=0 & ds=4 -> 0.5 : (ds'=7) & (dv'=2) + 0.5 : (ds'=7) & (dv'=3);
    [] state=5 & pickDie!=0 & ds=5 -> 0.5 : (ds'=7) & (dv'=4) + 0.5 : (ds'=7) & (dv'=5);
    [] state=5 & pickDie!=0 & ds=6 -> 0.5 : (ds'=2) + 0.5 : (ds'=7) & (dv'=6); 

//    [] state=5 & pickDie!=0 & ds=0 -> (1/6) : (ds'=7) & (dv'=1) +
//					(1/6) : (ds'=7) & (dv'=2) +
//					(1/6) : (ds'=7) & (dv'=3) +
//					(1/6) : (ds'=7) & (dv'=4) +
//					(1/6) : (ds'=7) & (dv'=5) +
//					(1/6) : (ds'=7) & (dv'=6); 


//*************** State ****************// 

    // First Roll
    [] state=0 -> (state'=5) & (pickDie'=0) & (rollVal'=0) & (nextState'=1) ;

    [] state=1 & (rollVal=7 | rollVal=11 ) -> (state'=2); // WIN!!!
    [] state=1 & (rollVal=2 | rollVal=3 | rollVal=12) -> (state'=3); //Lose :-(
    [] state=1 & (rollVal=4 | rollVal=5 | rollVal=6 | rollVal=8 | rollVal=9 | rollVal=10) // Roll and Play again...
	  -> (state'=5) & (pickDie'=0) & (lastRoll'=rollVal) & (rollVal'=0) & (nextState'=4); 


    
    [] state=2 -> (state'=2); //WIN!! (self loop)


    [] state=3 -> (state'=3); //LOSE (self loop)


    [] state=4 & lastRoll=7 -> (state'=3); //LOSE :-(
    [] state=4 & rollVal!=7 & lastRoll=rollVal -> (state'=2); //WIN!!!
    [] state=4 & (lastRoll!=rollVal) & lastRoll!=7 // Roll and Play again
	  -> (state'=5) & (pickDie'=0) & (lastRoll'=rollVal) & (rollVal'=0) & (nextState'=4); 


endmodule
