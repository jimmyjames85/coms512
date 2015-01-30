CC=gcc
CFLAGS=-Iincludes -Wall

all:  main

main: main.o node.o list.o stack.o
	$(CC) $(CFLAGS) obj/stack.o obj/list.o obj/node.o obj/main.o -o bin/main

stack.o: src/stack.c
	$(CC) $(CFLAGS) -c src/stack.c -o obj/stack.o

list.o: src/list.c
	$(CC) $(CFLAGS) -c src/list.c -o obj/list.o

node.o: src/node.c
	$(CC) $(CFLAGS) -c src/node.c -o obj/node.o

main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

clean:
	rm obj/* bin/*
