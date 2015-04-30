mtype = { ok, err, msg1, msg2, msg3, msg4, keyA, keyB, keyI, agentA, agentB, agentI, nonceA, nonceB, nonceI, secretData };

typedef Crypt {mtype key;
	       mtype data1;
	       mtype data2; };

chan network = [0] of {mtype, mtype, Crypt};

mtype partnerA;
mtype statusA = err;

#define printAS(msg, data) atomic{ printf("\n\n\t\t   Alice: Sending\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printAR(msg, data) atomic{ printf("\n\n\t\t   Alice: Receiving\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printARecog(recog ,data) atomic{ printf("\n\n\t\t   Alice: Recognizes\t%e in < %e, %e>_%e \n\n", recog, data.data1, data.data2, data.key);}
#define printBS(msg, data) atomic{ printf("\n\n\t\t     Bob: Sending\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printBR(msg, data) atomic{ printf("\n\n\t\t     Bob: Receiving\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printBRecog(recog ,data) atomic{ printf("\n\n\t\t     Bob: Recognizes\t%e in < %e, %e>_%e \n\n", recog, data.data1, data.data2, data.key);}
#define printIS(msg, data) atomic{ printf("\n\n\t\tIntruder: Sending\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printIR(msg, data) atomic{ printf("\n\n\t\tIntruder: Receiving\t   %e = < %e, %e>_%e \n\n", msg, data.data1, data.data2, data.key);}
#define printIRecog(recog ,data) atomic{ printf("\n\n\t\tIntruder: Recognizes\t%e in < %e, %e>_%e \n\n", recog, data.data1, data.data2, data.key);}



active proctype Alice()
{
  mtype pkey, pnonce;
  if
    ::atomic{partnerA = agentB; pkey = keyB;};
    ::atomic{partnerA = agentI; pkey = keyI;};
  fi;
  
  /* Send msg1 *hopefuly* to Bob */
  Crypt dataMsg1;
  atomic {
    dataMsg1.key = pkey;
    dataMsg1.data1 = agentA;
    dataMsg1.data2 = nonceA;
  };

  printAS(msg1, dataMsg1 );
  network ! msg1 , partnerA , dataMsg1 ;

  /* Wait for Bob to send back msg2 */
  Crypt dataMsg2;
  do
    ::  network ? msg2, agentA, dataMsg2; -> goto RECBOBSMSG
  od;
RECBOBSMSG:

  /*If this condition doesn't hold the Alice Process will not continue */
  (dataMsg2.key == keyA) && (dataMsg2.data1 == nonceA);

  printAR(msg2,dataMsg2);
  printARecog(dataMsg2.data1, dataMsg2);
  pnonce = dataMsg2.data2;

  
  /* Send msg3 back to Bob */
  Crypt dataMsg3;
  atomic {
    dataMsg3.key = pkey;
    dataMsg3.data1 = pnonce;
    dataMsg3.data2 = ok;
  };
  printAS(msg3, dataMsg3);
  network ! msg3 , partnerA , dataMsg3 ;


  /* Wait for Bob to send secretData */
  Crypt dataMsg4;
  do
    :: network ? msg4, agentA, dataMsg4 -> goto SECRETDATA
  od;

SECRETDATA:
  /*If this condition doesn't hold the Alice Process will not continue */
  (dataMsg2.key == keyA);
  printAR(msg4, dataMsg4);
  statusA = ok;  
}

/*********************************************************************************
BOB
*********************************************************************************/
mtype partnerB;
mtype statusB = err;
active proctype Bob()
{
  mtype pkey, pnonce;
  Crypt dataMsg1;

  if
    ::atomic{partnerB = agentA; pkey = keyA;};
    ::atomic{partnerB = agentI; pkey = keyI;};
  fi;

  network ? msg1, agentB, dataMsg1
BRESPONDS:
  
  /*If this condition doesn't hold the Bob Process will not continue */
  (dataMsg1.key == keyB) && (dataMsg1.data1 == agentA);
  printBR(msg1, dataMsg1)  
  printBRecog(dataMsg1.data1, dataMsg1);

  pnonce = dataMsg1.data2;
  
  /* Send msg2 *hopefuly* to Alice */
  Crypt dataMsg2;
  atomic{
    dataMsg2.key = pkey;
    dataMsg2.data1 = pnonce;
    dataMsg2.data2 = nonceB;
  }
  
  printBS(msg2,dataMsg2);
  network ! msg2 , partnerB , dataMsg2 ;

  /* Wait for Alice to send msg3 */
  Crypt dataMsg3;
  do
    :: network ? msg3, agentB, dataMsg3; -> goto BCOMPLETE;
  od;

BCOMPLETE:
  /*If this condition doesn't hold the Bob Process will not continue */
  (dataMsg3.key == keyB) && (dataMsg3.data1 == nonceB);
  printBR(msg3, dataMsg3);
  printBRecog(dataMsg3.data1, dataMsg3);

  
  Crypt dataMsg4;
  atomic{
    dataMsg4.key = pkey;
    dataMsg4.data1 = secretData;
    dataMsg4.data2 = secretData;
  }
  printBS(msg4, dataMsg4);
  network !msg4, partnerB, dataMsg4;

  statusB = ok;
}

bool knows_nonceA=false;
bool knows_nonceB=false;
mtype statusI = err;

active proctype Intruder()
{
  mtype msg, recpt;
  Crypt data;
  Crypt intercepted;

  do
    ::network? msg, _, data ->
       printIR(msg,data);
       if /* perhaps store the message */
	 :: intercepted.data1 = data.data1; intercepted.data2 = data.data2; intercepted.key = data.key; 
	 :: skip;
       fi;
       if /* record newly learnt nonces */
	 :: (data.key == keyI) ->
	    if
	      :: (data.data1 == nonceA) || (data.data2 == nonceA) -> knows_nonceA = true; printIRecog(nonceA, data);
	      :: else -> skip;
	    fi;
	    if
	      :: (data.data1 == nonceB) || (data.data2 == nonceB) -> knows_nonceB = true; printIRecog(nonceB, data);
	      :: else -> skip;
	    fi;
	 ::else -> skip;
       fi;
    :: /* Replay or send a message */
       if /* choose message type */
	 :: msg = msg1;
	 :: msg = msg2;
	 :: msg = msg3;
       fi;
       if /* choose recipient */
	 :: recpt = agentA;
	 :: recpt = agentB;
       fi;
       if /* replay intercepted message or assemble it */
	 :: data.data1 = intercepted.data1; data.data2 = intercepted.data2; data.key = intercepted.key;
	 :: if
	      :: data.data1 = agentA;
	      :: data.data1 = agentB;
	      :: data.data1 = agentI;
	      :: knows_nonceA -> data.data1 = nonceA;
	      :: knows_nonceB -> data.data1 = nonceB;
	      :: data.data1 = nonceI;
	    fi;
	 :: if
	      :: data.data2 = agentA;
	      :: data.data2 = agentB;
	      :: data.data2 = agentI;
	      :: knows_nonceA -> data.data2 = nonceA;
	      :: knows_nonceB -> data.data2 = nonceB;
	      :: data.data2 = nonceI;
	    fi;
	 :: if
	      :: data.key = keyA;
	      :: data.key = keyB;
	      :: data.key = keyI;
	    fi;
       fi;
       printIS(msg, data);
       network ! msg, recpt, data;
  od;
}

#define safe (statusB == ok && statusA == ok)


ltl p1 { [] (safe -> (partnerA == agentB && partnerB == agentA)) }; 
/* ltl p2 { [] (safe -> (! knows_nonceA))} */
/* ltl p3 { [] (safe -> (! knows_nonceB))} */



/*
 
run:  spin -t -v ns.pml | grep -E "^[[:space:]]+(Alice)|^[[:space:]]+(Bob)|^[[:space:]]+(Intruder)"

		   Alice: Sending	   msg1 = < agentA, nonceA>_keyI 
		Intruder: Receiving	   msg1 = < agentA, nonceA>_keyI 
		Intruder: Recognizes	nonceA in < agentA, nonceA>_keyI 
		Intruder: Sending	   msg1 = < agentA, nonceA>_keyB 
		     Bob: Receiving	   msg1 = < agentA, nonceA>_keyB 
		     Bob: Recognizes	agentA in < agentA, nonceA>_keyB 
		     Bob: Sending	   msg2 = < nonceA, nonceB>_keyA 
		Intruder: Receiving	   msg2 = < nonceA, nonceB>_keyA 
		Intruder: Sending	   msg2 = < nonceA, nonceB>_keyA 
		   Alice: Receiving	   msg2 = < nonceA, nonceB>_keyA 
		   Alice: Recognizes	nonceA in < nonceA, nonceB>_keyA 
		   Alice: Sending	   msg3 = < nonceB, ok>_keyI 
		Intruder: Receiving	   msg3 = < nonceB, ok>_keyI 
		Intruder: Recognizes	nonceB in < nonceB, ok>_keyI 
		Intruder: Sending	   msg3 = < nonceB, ok>_keyB 
		     Bob: Receiving	   msg3 = < nonceB, ok>_keyB 
		     Bob: Recognizes	nonceB in < nonceB, ok>_keyB 
		     Bob: Sending	   msg4 = < secretData, secretData>_keyA 
		Intruder: Sending	   msg1 = < nonceB, ok>_keyI 
		   Alice: Receiving	   msg4 = < secretData, secretData>_keyA 

This doesn't make sense to me. Why would Alice every use the
Intruder's public key? I think maybe I don't understand crytography.

*/