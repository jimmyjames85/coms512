PML_FILE=ns.pml
NEXTENABLED=
NONEXT=-DNXT

all: interactive

interactive: ${PML_FILE=ns}
	spin -i $(PML_FILE);

runFilter: trail ${PML_FILE}.trail
	make run | grep -E "^[[:space:]]+(Alice)|^[[:space:]]+(Bob)|^[[:space:]]+(Intruder)"
#	spin -t -v ${PML_FILE} | grep -E "^[[:space:]]+(Alice)|^[[:space:]]+(Bob)"; rm ${PML_FILE}.trail

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
