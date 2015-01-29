CC=gcc
CFLAGS=-Iincludes -Wall

all:  main

main: main.o node.o list.o
	$(CC) $(CFLAGS) obj/list.o obj/node.o obj/main.o -o bin/main


list.o: src/list.c
	$(CC) $(CFLAGS) -c src/list.c -o obj/list.o

node.o: src/node.c
	$(CC) $(CFLAGS) -c src/node.c -o obj/node.o

main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o obj/main.o

clean:
	rm obj/* bin/*
