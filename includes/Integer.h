#include "Comparable.h"
#include "ArrayList.h"
#ifndef INTEGER_H
#define INTEGER_H

class Integer: public Comparable
{
	public:
		Integer(int);
		int compare(Comparable * other);
		virtual ~Integer(){};
	private:
		int value;
};
#endif
