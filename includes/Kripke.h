#ifndef KRIPKE_H
#define KRIPKE_H
//#include <cstddef>
#include <vector>
#include <string>
using namespace std;

class KripkeState
{
	public:
		KripkeState();
		vector<string> properties;
		vector<string> markings;
		vector<KripkeState> out;
		vector<KripkeState> in;
		bool hasProperty(string);
		bool hasMarking(string);
		int id;
};

class Kripke
{
	public:
		Kripke(){};
		vector<KripkeState> states;
		void resetMarks();
		void markNot(string);
		void markAnd(string p, string q);
		string toString();
};
#endif

