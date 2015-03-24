all: pan

pan: pan.c
	gcc -DNXT -o pan pan.c

pan.c: rivercrossing.pml
	spin -a rivercrossing.pml

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
