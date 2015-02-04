#include <iostream>
#include "ArrayList.h"

using namespace std;
int main()
{
	ArrayList * list = new ArrayList();
	list->add((void*)"hi");
	list->add((void*)"bye");
	list->add((void*)"hi again");

	cout << "hello world!\n" << list->size() << " is the size\n";
	return 0;
}

