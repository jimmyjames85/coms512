
mtype = { ok, err, msg1, msg2, msg3, keyA, keyB, keyI, agentA, agentB, agentI, nonceA, nonceB, nonceI };


typedef Crypt {mtype key, data1, data2};


chan network = [0] of {mtype, mtype, Crypt};


mtype partnerA;
mtype statusA = err;

active proctype Alice()
{
  mtype pkey, pnonce;
  Crypt data;


  if
    ::partnerA = agentB; pkey = keyB;
    ::partnerA = agentI; pkey = keyI;
  fi;

  network ! (msg1, partnerA, Crypt{pkey, agentA, nonceA} );

  network ? (msg2, agentA, data);
  (data.key == keyA) && (data.info1 == nonceA);
  pnonce = data.info2;

  network ! (msg3, partnerA, Crypt{ pkey, pnonce, 0});
  statusA = ok;
  
}

active proctype Bob()
{
  mtype pkey, pnonce;
  Crypt data;


  if
    ::partnerA = agentA; pkey = keyA;
    ::partnerA = agentI; pkey = keyI;
  fi;

  network ? (msg1, agentB, data);


  network ! (msg2, partnerA, Crypt{pkey, msg1.data2, nonceB} );

  
  
}

