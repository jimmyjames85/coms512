SECURITY_FILE=security-hw.pml
SECURITY_FILTER="^[[:space:]]*INFO:"

NS_FILE=ns.pml
NS_FILTER="^[[:space:]]+(Alice)|^[[:space:]]+(Bob)|^[[:space:]]+(Intruder)"

PML_FILE= ${SECURITY_FILE}
#${NS_FILE}
GREP_FILTER=${SECURITY_FILTER}
#${NS_FILTER}


NEXTENABLED=
NONEXT=-DNXT

all: interactive

interactive: ${PML_FILE}
	spin -i $(PML_FILE);

runFilter: trail ${PML_FILE}.trail
	spin -t -v ${PML_FILE} | grep -E ${GREP_FILTER}; rm ${PML_FILE}.trail

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
