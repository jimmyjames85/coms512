all: main

main: main.o node.o
	gcc -Wall obj/node.o obj/main.o -o bin/main

node.o: src/node.c
	gcc -Iincludes -Wall -c src/node.c -o obj/node.o

main.o: src/main.c
	gcc -Iincludes -Wall -c src/main.c -o obj/main.o

clean:
	rm obj/* bin/*
