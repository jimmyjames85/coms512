CCP=g++
CC=gcc
CFLAGS=-Iincludes  -Wall

all:  main2

main2: folders Integer.o main2.o Kripke.o 
	$(CCP) $(CFLAGS) obj/Kripke.o obj/Integer.o obj/main2.o -o bin/main

Kripke.o: src/Kripke.cpp
	$(CCP) $(CFLAGS) -c src/Kripke.cpp -o obj/Kripke.o
	
Integer.o: src/Integer.cpp
	$(CCP) $(CFLAGS) -c src/Integer.cpp -o obj/Integer.o

main2.o: src/main2.cpp
	$(CCP) $(CFLAGS) -c src/main2.cpp -o obj/main2.o
	
	
	
main:folders main.o cnode.o list.o stack.o state.o 
	$(CC) $(CFLAGS) obj/state.o obj/stack.o obj/list.o obj/cnode.o obj/main.o -o bin/main

state.o: src/state.c
	$(CC) $(CFLAGS) -c src/state.c -o obj/state.o
	
stack.o: src/stack.c
	$(CC) $(CFLAGS) -c src/stack.c -o obj/stack.o

list.o: src/list.c
	$(CC) $(CFLAGS) -c src/list.c -o obj/list.o

cnode.o: src/cnode.c
	$(CC) $(CFLAGS) -c src/cnode.c -o obj/cnode.o

main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

folders:
	if ! [ -d "./obj" ]; then mkdir obj ; fi; if ! [ -d "./bin" ]; then mkdir bin ; fi  
	
clean:
	rm -rf obj bin
