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

   KA: Key of Alice
   KB: Key of Bob
   KC: Key of Charlie
   MSG: Message being exchanged
*/
mtype = {KA, KB, KC, MSG1, MSG2, NONE, Alice, Bob, Charlie};
bool flag;

typedef crypt 
{
    /* To represent one encryption: set key2 to NONE */ 
    mtype key1;   
    mtype key2;
    mtype message;  /* clean text message */
}

/*
   Use these macros for sending, receiving and intercepting messages with print statements
*/
#define send(sender, receiver, packet, chan) atomic { printf("%e sends %e to %e with encryptions: %e: %e\n", sender, packet.message, receiver, packet.key1, packet.key2); chan! sender, receiver, packet; }
#define receive(sender, receiver, packet, chan) atomic { chan? sender, receiver, packet; printf("%e receives %e from %e with encryptions: %e: %e\n", receiver, packet.message, sender, packet.key1, packet.key2); }
#define intercept(sender, receiver, packet, chan) atomic { chan? sender, receiver, packet; printf("Charlie intercepts %e from %e to %e with encryptions: %e: %e\n", packet.message, sender, receiver, packet.key1, packet.key2); }

chan comm = [0] of {mtype, mtype, crypt}; /* sender, receiver, encrypted message */

/*
   Alice may want to share some secret with Bob and Charlie
*/
active proctype AliceBehavior()  /* normal behavior of originator */
{
   mtype partner1 = Bob;
   mtype partner2 = Charlie;
   mtype partner;
   crypt data1, data2;

   atomic /* Construct the message */ 
   {
      data1.key1 = KA; data2.key1 = KA;     
      data1.key2 = NONE; data2.key2 = NONE;
      data1.message = MSG1; data2.message = MSG2;
   }
   send(Alice, Bob, data1, comm);
   send(Alice, Charlie, data2, comm);

L1:
   do
   ::  
       receive(partner, Alice, data1, comm);
       if
       :: data1.key1 == KA -> data1.key1 = NONE; /* decrypt the message */
       :: else -> goto L1;
       fi;
       send(Alice, partner, data1, comm);
   od;
}


/*
   Write the implementation of honest Bob
*/
active proctype BobBehavior() 
{

}


/*
   Write the behavior of dishonest Charlie
*/
active proctype CharlieBehavior()
{

}


ltl safe /* Write your property here */