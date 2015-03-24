all: pan

run: trail  hw5.pml.trail
	spin -t hw5.pml

trail: pan
	./pan -a


pan: pan.c
	gcc -DNXT -o pan pan.c

pan.c: hw5.pml
	spin -a hw5.pml

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
