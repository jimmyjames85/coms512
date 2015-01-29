all: main

main: main.o
	gcc -Wall obj/main.o -o bin/main

main.o: src/main.c
	gcc -Iincludes -Wall -c src/main.c -o obj/main.o

clean:
	rm obj/* bin/*
