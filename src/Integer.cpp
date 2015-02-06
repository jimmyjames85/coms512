#include "Integer.h"
#include "Comparable.h"

Integer::Integer(int v)
{
	this->value = v;
}

int Integer::compare(Comparable * other)
{
	Integer * o = (Integer *) other;
	return this->value - o->value;
}

