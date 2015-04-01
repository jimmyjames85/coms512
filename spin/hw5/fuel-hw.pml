

#define PROBLEM_E 0

bool lost[2];    /* 
                      This keeps track of lossy property: non-deterministic 
                      lost[0]: if the channel from the master to controller is lossy
                      lost[1]: if the channel from the backup to controller is lossy
		 */




/*
    0-buffer channels: source to destination as the name suggests
*/
chan sensor_to_master = [0] of {bit};
chan sensor_to_backup = [0] of {bit};

chan master_to_controller = [0] of {bit};
chan backup_to_controller = [0] of {bit};

bit fueling=0;
bit master_responsive = 1;      /* 0 means unresponsive */
bit fuel_level;                 /* 0 means low; 1 means ok */
bit sent_to_master;             /* for the sensor to keep track of whether or not to send message to backup */



proctype master(chan input; chan output)
{
  /* If the master receives a signal from the sensor
      it informs the controller to pump fuel to the tank
  */
  bit x;
  do
    :: input? x;
       
       /*
          Non-deterministically choose to make the master responsive
       */
       if
	 ::  master_responsive = 1; 
	 ::  master_responsive = 0;
       fi;
       
       /*
          If the master is responsive and the channel to controller is not lossy, 
          then deliver the message 

          NOTE:the lost[0] entity is "set" to 1 
               lost[0] when set to 0 does not require any checking of master being
               responsive or not (the message remains undelivered)
       */
       if
	 ::  atomic{ master_responsive == 1 -> lost[0] = 1; output! 1; }
	 ::  atomic{ master_responsive == 0 -> skip; }  /* master is unresponsive */
	 ::  atomic{ lost[0] = 1 -> skip; }             /* message from the master is lost */
       fi;
Lm:    printf("\n\n    The master has run: %d\n\n\n====================================\n", x);            /* to keep track whether the master has run once */ 
  od;
}

proctype backup(chan input; chan output)
{
  /*
      bkup only sends message if the master is unresponsive
  */
  bit x;
  do
    ::   input? x;
       if
	 :: atomic{ master_responsive == 0 -> output! 1; }
	 :: else -> skip;
       fi;
Lb:    printf("\n\n    The backup has run: %d\n\n\n====================================\n", x);          /* to keep track whether the backup has run once */  
  od;
}

proctype sensor(chan output1; chan output2)
{

  /* fuel_level is low: sensor in action
         Sensor sends message to backup only after it has sent message to the master
     */
Ls:
#if PROBLEM_E
  do
    :: atomic{ fueling == 1 -> fuel_level = 1; sent_to_master = 0; } /* reset */
    :: atomic{ fueling == 0 && sent_to_master==0 && fuel_level == 0 -> output1! 1; sent_to_master = 1; }
    :: atomic{ fueling == 0 && fuel_level == 0 & sent_to_master == 1 -> output2! 1; }
    :: atomic{ fueling == 0 && fuel_level == 1 -> sent_to_master = 0; fuel_level = 0; }
  od;
#else
  do
    :: atomic{ fuel_level == 0 -> output1! 1; sent_to_master = 1; }
    :: atomic{ fuel_level == 0 & sent_to_master == 1 -> output2! 1; }
    :: atomic{ fuel_level == 1 -> sent_to_master = 0; fuel_level = 0; }
   od; 
#endif
  
}


/*
   Controller waits for message from master or backup and sets the fuel-level to 1
*/
proctype controller(chan input1; chan input2)
{
  bit x;
Lc:
  do
    :: atomic{ input1? x -> fuel_level = 1; PROBLEM_E == 1 -> sent_to_master = 0; fueling = 1;}
    :: atomic{ input2? x -> fuel_level = 1; PROBLEM_E == 1 -> sent_to_master = 0;  fueling = 1;}
  od;
}



init
{ 
  run master(sensor_to_master, master_to_controller);
  run backup(sensor_to_backup, backup_to_controller);
  run sensor(sensor_to_master, sensor_to_backup);
  run controller(master_to_controller, backup_to_controller);
}

/* You can use these for the properties */
#define runM (master@Lm)
#define runB (backup@Lb)
#define safe ( fuel_level == 1)
#define fair ( runM ) 
#define noloss ( lost[0] == 0 )
#define responsive ( master_responsive == 1 )

/*  <>  :=  F
    []  :=  G
*/



/*
============================================================================
 
 I've interpreted this question in two ways for each sub problem. The
 homework said this SPIN model was for the specification (without
 hazards). This to me means the master is never lossy, always
 responsive and is always executed. However, I wasn't sure if the
 hazards presented in homework 3 were supposed to be included. In
 other words lossines, responsiveness and fairness can be
 non-deterministic. So I give an alternate answer for each problem below.


============================================================================
Problem 2 (a)

Assumptions:
 
    noloss:      holds all the time
    responsive:  holds all the time

 
Proposition:
 
    infinitely often runM -> infinitely often safe
 

LTL:
 
    ltl p1 { ( ([] noloss && [] responsive &&   (  [] <> (runM)  )) -> ( [] <> (safe) ) )}


Result: TRUE
 
    No Cycles were found implying this property is true


 
Problem 2 (a) - Alternate Assumptions

Alternate Assumptions:
 
    noloss:      non-deterministic
    responsive:  non-deterministic

Proposition:

    infinitely often runM -> infinitely often safe


LTL:

    ltl p1_alternate { ( (  [] <> (runM)  ) -> ( [] <> (safe) ) )}

Result: FALSE

    A Cycle is found where the master is responsive but is always
    lossy and the backup never signals the fuel controller

============================================================================
 */


/*
Problem 2 (b)

Assumptions:
 
    responsive:  holds all the time

 
Proposition:
 
    infinitely often noloss AND infinitely often runM -> infinitely safe
 

LTL:

    ltl p2 { ( ([] responsive && ([] <> noloss) &&  (  [] <> (runM)  )) -> ( [] <> (safe) ) )}

Result: TRUE

    No Cycles were found implying this property is true




Problem 2 (a) - Alternate Assumptions

Alternate Assumptions:
 
    responsive:  non-deterministic

Proposition:

    infinitely often noloss AND infinitely often runM -> infinitely safe


LTL:

    ltl p2_alternate { ( ( ([] <> noloss) &&  (  [] <> (runM)  )) -> ( [] <> (safe) ) )}

Result: FALSE

    A Cycle is found where the master is always unresponsive and never
    signals the fuel controller. When the backup is run the controller
    sets the fuel_level to 1 but the sensor is never immediately aware
    this. This is because of the way it was modled. This is fixed in
    in problem 2(e).

 

*/


    ltl p2_alternate { ( ( ([] <> noloss) &&  (  [] <> (runM)  )) -> ( [] <> (safe) ) )}

/*


Problem 2 (c)

Assumptions:
 
    none

 
Proposition:
 
    infinitely often responsive infinitely often noloss AND infinitely often runM -> infinitely safe

 
LTL:

     ltl p3 { ( ( ([] <> responsive ) && ([] <> noloss) &&  (  [] <> (runM)  ) ) -> ( [] <> (safe) ) )}


Result: TRUE

    No Cycles were found implying this property is true




Problem 2 (c) - No Alternate Assumptions

*/


/*

Problem 2 (d)

Assumptions:
 
    noloss:  holds all the time
      runM:  holds all the time
 
Proposition:
 
     infinitely often responsive -> ( [] <> (safe))
 

LTL:
    
    ltl p4 { ( ( ([] noloss ) && ([] runM) &&  (  [] <> (responsive)  ) ) -> ( [] <> (safe) ) )}

 
Result: TRUE

    No Cycles were found implying this property is true


 
Problem 2 (d) - Alternate Assumptions

Alternate Assumptions:
 
    noloss:  non-deterministic
      runM:  non-deterministic 

 
Proposition:

     infinitely often responsive -> ( [] <> (safe))

LTL:

     ltl p4_alternate { ( ( (  [] <> (responsive)  ) ) -> ( [] <> (safe) ) )}


Result: FALSE

    A Cycle is found where the master is always lossy and fuel sensor
    only executes the first option in the do block. It doesn't keep
    track of whether it already sent a message to the master. I think
    ther should be a gaurd on the first option that prevents it from
    being executed unless sent_to_master==0. However, when I put this
    gaurd on another cycle was found where the backup does get called
    but the backup never calls the fuel controller because the master
    responsive.

*/








