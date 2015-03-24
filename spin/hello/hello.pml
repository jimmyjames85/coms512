#define println(str) atomic{ printf("%s\n",str);}

active proctype HelloWorld()
{
  printf("Hello process, my pid is %d\n", _pid);
}

init
{
  int lastpid;
  printf("init process, my pid is: %d\n", _pid);
  lastpid = run HelloWorld();
  printf("last pid was: %d\n", _pid);
}

