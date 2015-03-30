file=frogcrossing-hw.pml
NEXTENABLED=
NONEXT=-DNXT

all: pan

run: trail ${file}.trail
	spin -t -v ${file}

trail: pan
	./pan -a

pan: pan.c
	gcc ${NEXTENABLED} -DXUSAFE -o pan pan.c

pan.c: ${file}
	spin -a ${file}

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
