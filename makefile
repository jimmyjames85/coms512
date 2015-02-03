CC=gcc
CFLAGS=-Iincludes -Wall

all:  main 

main:folders main.o node.o list.o stack.o state.o 
	$(CC) $(CFLAGS) obj/state.o obj/stack.o obj/list.o obj/node.o obj/main.o -o bin/main

state.o: src/state.c
	$(CC) $(CFLAGS) -c src/state.c -o obj/state.o
	
stack.o: src/stack.c
	$(CC) $(CFLAGS) -c src/stack.c -o obj/stack.o

list.o: src/list.c
	$(CC) $(CFLAGS) -c src/list.c -o obj/list.o

node.o: src/node.c
	$(CC) $(CFLAGS) -c src/node.c -o obj/node.o

main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

folders:
	if ! [ -d "./obj" ]; then mkdir obj ; fi; if ! [ -d "./bin" ]; then mkdir bin ; fi  
	
clean:
	rm -rf obj bin
