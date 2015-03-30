file=frogcrossing-hw.pml
NEXTENABLED=
NONEXT=-DNXT

all: pan

run: trail  frogcrossing-hw.pml.trail
	spin -t ${file}

trail: pan
	./pan -a

pan: pan.c
	gcc ${NEXTENABLED} -DXUSAFE -o pan pan.c

pan.c: frogcrossing-hw.pml
	spin -a ${file}

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
