mtype = { ok, err, msg1, msg2, msg3, keyA, keyB, keyI, agentA, agentB, agentI, nonceA, nonceB, nonceI };

typedef Crypt {mtype key;
	       mtype data1;
	       mtype data2; };

chan network = [0] of {mtype, mtype, Crypt};

mtype partnerA;
mtype partnerB;
mtype statusA = err;

active proctype Alice()
{
  mtype pkey, pnonce;
  Crypt data;

  if
    ::partnerA = agentB; pkey = keyB;
    ::partnerA = agentI; pkey = keyI;
  fi;

  
  /* Send msg1 *hopefuly* to Bob */
  atomic {
    Crypt cc;
    cc.key = pkey;
    cc.data1 = agentA;
    cc.data2 = nonceA;
    printf("\nAlice: Sending <%e,%e>_%e to *hopefuly* Bob...\n\n", cc.data1, cc.data2, cc.key);
    network ! msg1 , partnerA , cc ;
  };


/*
  atomic {
    network ? msg2, agentA, data;
    printf ("receiving message \n\n\n");
  };*/

  
  /* Wait for Bob to send back msg2 */ 
  do
    ::  atomic{network ? msg2, agentA, data ->  printf ("\nAlice: Receiving <%e,%e>_%e\n\n",data.data1, data.data2, data.key);}
    ::  data.data1 == nonceA -> goto RECBOBSMSG
  od;
  
RECBOBSMSG:
  printf("\nAlice: recognizes her own nonce in <%e,%e>_%e\n\n", data.data1, data.data2, data.key);
  pnonce = data.data2;

  /* Send msg3 back to Bob */
  atomic {
    printf("\n\nsAlice: Sending <msg3> to *hopefuly* Bob...\n");
    Crypt ccc;
    ccc.key = pkey;
    ccc.data1 = pnonce;
    ccc.data2 = ok;
    network ! msg3 , partnerA , ccc ;
  };

  /*
  (data.key == keyA) && (data.data1 == nonceA);

  Crypt ccc;
  ccc.key = pkey;
  ccc.data1 = pnonce;
  ccc.data2 = 0;

  network ! msg3, partnerA, ccc ;*/
  statusA = ok;
  
}

active proctype Bob()
{

  mtype pkey, pnonce;
  Crypt data;

  if
    ::partnerB = agentA; pkey = keyA;
    ::partnerB = agentI; pkey = keyI;
  fi;


  /* Wait for Alice to send msg1 */
  do
    ::  atomic{network ? msg1, agentB, data ->  printf ("Bob: received msg1\n\n");}
    ::  data.data1 == agentA -> goto BRESPONDS
  od;
  
BRESPONDS:
  printf("Bob: responding with <msg2>_nonceB\n\n");

  /* Send msg2 *hopefuly* to Alice */
  atomic {
    printf("\n\nBob sending msg2...\n");
    Crypt cc;
    cc.key = pkey;
    cc.data1 = data.data2;
    cc.data2 = nonceB;
    network ! msg2 , partnerB , cc ;
  };

  

  
  /*(data.key == keyB) && (data.data1 == agentA);*/

/*
  pnonce = data.data2;

  network ! (msg3, partnerA, Crypt{ pkey, pnonce, 0});
  statusA = ok;*/

  
  
}

