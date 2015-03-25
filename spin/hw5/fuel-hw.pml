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
          NOTE: the lost[0] entity is "set" to 1 
                lost[0] when set to 0 does not require any checking of master being
                responsive or not (the message remains undelivered)
      */
      if
      ::  atomic{ master_responsive == 1 -> lost[0] = 1; output! 1; }
      ::  atomic{ master_responsive == 0 -> skip; }  /* master is unresponsive */
      ::  atomic{ lost[0] = 1 -> skip; }             /* message from the master is lost */
      fi;
      Lm: printf("The master has run\n");            /* to keep track whether the master has run once */ 
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
        Lb: printf("The backup has run\n");          /* to keep track whether the backup has run once */  
   od;
}

proctype sensor(chan output1; chan output2)
{
   /* fuel_level is low: sensor in action
      Sensor sends message to backup only after it has sent message to the master
   */
   Ls:
   do
   :: atomic{ fuel_level == 0 -> output1! 1; sent_to_master = 1; }
   :: atomic{ fuel_level == 0 & sent_to_master == 1 -> output2! 1; }
   :: atomic{ fuel_level == 1 -> sent_to_master = 0; fuel_level = 0; }
   od; 
}


/*
   Controller waits for message from master or backup and sets the fuel-level to 1
*/
proctype controller(chan input1; chan input2)
{
   bit x;
   Lc: 
   do
   :: atomic{ input1? x -> fuel_level = 1; }
   :: atomic{ input2? x -> fuel_level = 1; }
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


ltl p1 /* write your property for Q2a */
ltl p2 /* write your property for Q2b */
ltl p3 /* write your property for Q2c */
ltl p4 /* write your property for Q2d */

/**************************************

Answers to the Questions 2a-e:  


***************************************/ 




