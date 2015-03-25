all: pan

run: trail  hw4.pml.trail
	spin -t hw4.pml

trail: pan
	./pan -a

pan: pan.c
	gcc -DNXT -DXUSAFE -o pan pan.c

pan.c: hw4.pml
	spin -a hw4.pml

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
