#include <Node.h>
#include <iostream>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Integer.h"
#include "ArrayList.h"
#include "Kripke.h"

using namespace std;

//MAX 100 characters
char * newString(char * volatile format, ...)
{
	char * str = (char *) malloc(sizeof(char) * 101);
	va_list args;
	va_start(args, format);
	vsprintf(str, format, args);
	va_end(args);
	return str;
}
int main()
{
	Kripke k;
	KripkeState k0, k1, k2;

	k0.properties.push_back("c");
	k1.properties.push_back("a");
	k1.properties.push_back("b");
	k2.properties.push_back("a");


	k0.addOut(k0);
	k1.addOut(k0);
	k2.addOut(k1);

	k.states.push_back(k0);
	k.states.push_back(k1);
	k.states.push_back(k2);


	k.resetMarks();
	k.markAnd("a", "b");
	k.markEX("b");
	cout << k.toString();

	return 0;

}

