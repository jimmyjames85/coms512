file=fuel-hw.pml
NEXTENABLED=
NONEXT=-DNXT

all: pan


run: trail ${file}.trail
	spin -t -v ${file}

#-g show all global variables

trail: pan
	./pan -a -v

pan: pan.c
	gcc ${NEXTENABLED} -DXUSAFE -o pan pan.c

pan.c: ${file}
	spin -a ${file}

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
