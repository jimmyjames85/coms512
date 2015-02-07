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
	char * str = (char *)malloc(sizeof(char) * 101);
	va_list args;
	va_start(args, format);
	vsprintf(str, format, args);
	va_end(args);
	return str;
}
int main()
{
	Kripke k;
	KripkeState k1 , k2;
	k1.properties.push_back("a");
	k2.properties.push_back("b");
	k2.properties.push_back("a");
	k1.markings.push_back("a");
	k.states.push_back(k1);
	k.states.push_back(k2);
	k.resetMarks();
	k.markAnd("a","b");
	cout << k.toString();

	return 0;

}

