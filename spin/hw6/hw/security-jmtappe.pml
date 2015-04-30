/*
   Every message has
   - sender name
   - receiver name
   - encrypted message
     - clear message 
     - encryption key 1
     - encryption key 2 (optional)

   - A peer can encrypt message using its own encryption key
   - A peer can decrypt message that has been encrypted by its own encryption key
   - Encrption is commutative

   keyA: Key of Alice
   keyB: Key of Bob
   keyC: Key of Charlie
   MSG: Message being exchanged
*/
mtype = {keyA, keyB, keyC, msg1, msg2, NONE, Alice, Bob, Charlie, ok, err};

mtype statusB = err;
mtype statusC = err;
bool flag;

typedef Crypt 
{
  /* To represent one encryption: set key2 to NONE */ 
  mtype key1;   
  mtype key2;
  mtype message;  /* clean text message */
}

/*
   Use these macros for sending, receiving and intercepting messages with print statements
*/

#define send(sender, receiver, packet, chan)  { printf("\n\n\t\tINFO: %e sends %e to %e with encryptions: %e: %e\n\n", sender, packet.message, receiver, packet.key1, packet.key2); chan! sender, receiver, packet; }
#define receive(sender, receiver, packet, chan)  { chan? sender, receiver, packet; printf("\n\n\t\tINFO: %e receives %e from %e with encryptions: %e: %e\n\n", receiver, packet.message, sender, packet.key1, packet.key2); }
#define intercept(sender, receiver, packet, chan)  { chan? sender, receiver, packet; printf("\n\n\t\tINFO: Charlie intercepts %e from %e to %e with encryptions: %e: %e\n\n", packet.message, sender, receiver, packet.key1, packet.key2); }

chan comm = [1] of {mtype, mtype, Crypt}; /* sender, receiver, encrypted message */

/*
   Alice may want to share some secret with Bob and Charlie
*/
active proctype AliceBehavior()  /* normal behavior of originator */
{
  mtype partner1 = Bob;
  mtype partner2 = Charlie;
  mtype partner;
  Crypt data1;
  Crypt data2;
  
  atomic /* Construct the message */ 
  {
    data1.key1 = keyA;
    data1.key2 = NONE; 
    data1.message = msg1;

    data2.key1 = keyA;
    data2.key2 = NONE;
    data2.message = msg2;
  }
  
  send(Alice, Bob, data1, comm);
  send(Alice, Charlie, data2, comm);
  
LA:
  do
    ::  
       receive(partner, Alice, data1, comm);
       if
	 :: data1.key1 == keyA -> data1.key1 = NONE; /* decrypt the message */
	 :: else -> goto LA;
       fi;
       send(Alice, partner, data1, comm);
  od;
}

#define encrypt2(data,key) atomic{data.key1 != NONE && data.key2 == NONE -> data.key2 = key;};
#define decypher(sender, receiver, data, key) atomic{data.key1 == NONE && data.key2==key -> data.key2=NONE; printf("\n\n\t\tINFO: %e decyphers %e's %e\n\n",receiver, sender, data.message)}


/****************************************************
   Write the implementation of honest Bob
****************************************************/
active proctype BobBehavior() 
{
  mtype partner;
  Crypt data;
  
LB:
  do
    ::  
       receive(partner, Bob, data, comm);
       if
	 :: encrypt2(data,keyB);  /* encrypt the message a second time */
	 :: data.key1 == NONE && data.key2==keyB && data.message==msg1 -> goto BOBFIN;
	 :: else -> goto LB;
       fi;
       data.key2==keyB -> send(Bob, partner, data, comm);
       /*data.key1!=NONE && data.key2==keyB -> send(Bob, partner, data, comm);*/
  od;

BOBFIN:
  atomic{
    statusB = ok;
    printf("\n\n\t\tINFO: Bob is okay!!!!!!!!!!!!!!!!\n\n");
  }

}

#define copyMessage(data1, data2) atomic{data2.key1 = data1.key1; data2.key2 = data1.key2; data2.message = data1.message};

/****************************************************
   Write the behavior of dishonest Charlie
****************************************************/
active proctype CharlieBehavior()
{
  int msgCount=0;
  Crypt dataStore[5];
  int msgId;
  
  mtype recpt;

  Crypt data;
  mtype sender;
  mtype receiver;
  
LC:
  do
    ::
       /* Note: Charlie can Intercept his own messages resulting in a normal receive */
       if
	 :: intercept(Alice, receiver, data, comm)-> goto PROCESS;
	 :: intercept(Bob, receiver, data, comm)-> goto PROCESS;
	 :: goto NOINTERCEPT; /*don't retrieve/intercept*/
       fi;
       
PROCESS:
       /* Save message for later */
       copyMessage(data,dataStore[msgCount]);
       msgCount = msgCount + 1;

       if
	 :: data.key1 == NONE && data.key2==keyC && data.message==msg1-> atomic{statusC=ok; printf("\n\n\t\tINFO: Charlie intercepted msg1!!!!!\n\n");};
	 :: data.key1 == NONE && data.key2==keyC && data.message==msg2-> printf("\n\n\t\tINFO: Charlie read his own message msg1!!!!!\n\n");
	 :: else -> skip;
       fi;

       
NOINTERCEPT:
       
       /*Select which message we will send*/
       if
	 :: msgCount>0 -> msgId=0;
	 :: msgCount>1 -> msgId=1;
	 :: msgCount>2 -> msgId=2;
	 :: msgCount>3 -> msgId=3;
	 :: msgCount>4 -> msgId=4;
	 :: else -> goto NOPROCESS;
       fi;


       
       /* Retrieve that message from the dataStore */
       printf("\n\n\t\tmsgId=%d %e %e %e\n\n",msgId,  data.key1, data.key2, data.message);
       copyMessage(dataStore[msgId],data);
       printf("\n\n\t\tmsgId=%d %e %e %e\n\n",msgId,  data.key1, data.key2, data.message);

       
       /*May or may not double encrypt
       if
	 :: receiver==Charlie -> atomic{encrypt2(data,keyC); printf( "\n\n\t\tINFO: Charlie Encrypting \n\n");}  /* encrypt the message a second time */
/*	 :: else -> skip;
       fi;*/
	 
       /* select recipient */ 
       if 
	 :: recpt = Bob
	 :: recpt = Alice 
       fi;
        
       /* send message */
       if
	 :: send(Charlie, recpt, data, comm); 
	 :: skip; /* or not*/
       fi;

NOPROCESS:
       
  od;  
}

#define safe (statusB == ok) /* && statusA == ok)*/
#define unsafe (statusC == ok)
ltl p1 { [] !(safe && unsafe) };
/*ltl p1 { [] (safe -> (partnerA == agentB && partnerB == agentA)) }; */

/*ltl safe /* Write your property here */