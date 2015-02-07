#include <string>
#include "Kripke.h"
#include <sstream>
using namespace std;
bool vectorContains(vector<string> list, string str)
{

	bool found = false;
	for (unsigned i = 0; !found && i < list.size(); i++)
		found = (0 == str.compare(list[i]));

	return found;
}

bool KripkeState::hasProperty(string p)
{
	return vectorContains(properties, p);
}

bool KripkeState::hasMarking(string m)
{
	return vectorContains(markings, m);
}

void Kripke::resetMarks()
{
	for (unsigned i = 0; i < this->states.size(); i++)
	{
		states[i].markings.clear();
		states[i].markings.push_back((string) "true");

		for (unsigned j = 0; j < states[i].properties.size(); j++)
				states[i].markings.push_back(states[i].properties[j]);
	}
}

void Kripke::markNot(string p)
{
	string m = "~(" + p+")";

	for (unsigned i = 0; i < states.size(); i++)
	{
		if (!states[i].hasMarking(p) && !states[i].hasMarking(m))
			states[i].markings.push_back(m);
	}
}

void Kripke::markAnd(string p, string q)
{
	string m1 = "(" + p + "&&" + q + ")";
	string m2 = "(" + q + "&&" + p + ")";
	for (unsigned i = 0; i < states.size(); i++)
	{
		if (states[i].hasMarking(p) && states[i].hasMarking(q))
		{
			if (!states[i].hasMarking(m1))
				states[i].markings.push_back(m1);
			if (!states[i].hasMarking(m2))
				states[i].markings.push_back(m2);
		}
	}
}
KripkeState::KripkeState()
{
	static int ksid = 0;
	id = ksid++;
}
string Kripke::toString()
{
	ostringstream ret;
	for (unsigned i = 0; i < states.size(); i++)
	{
		ret << "State " << states[i].id << ": (";

		for (unsigned j = 0; j < states[i].properties.size(); j++)
			ret << " " <<states[i].properties[j];
		ret <<" )\n";

		for (unsigned j = 0; j < states[i].markings.size(); j++)
			ret <<"\t" << states[i].markings[j] << "\n";

		ret << "\n\n";
	}
	return ret.str();
}

