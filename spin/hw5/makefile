PML_FILE=frogcrossing-hw.pml
NEXTENABLED=
NONEXT=-DNXT

all: pan


run: trail ${PML_FILE}.trail
	spin -t -v ${PML_FILE}; rm ${PML_FILE}.trail

#-g show all global variables

trail: pan
	./pan -a -v

pan: pan.c
	gcc ${NEXTENABLED} -DXUSAFE -o pan pan.c

pan.c: ${PML_FILE}
	spin -a ${PML_FILE}

clean:
	rm pan*; rm *.tmp; rm *.trail; clear
