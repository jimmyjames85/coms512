#include <iostream>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Integer.h"
#include "ArrayList.h"
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

	return 0;
}

