#ifndef COMPARABLE_H
#define COMPARABLE_H
class Comparable
{
	public:
		virtual int compare(Comparable * other)=0;
		virtual ~Comparable(){};
};
#endif
