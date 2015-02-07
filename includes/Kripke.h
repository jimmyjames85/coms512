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
		bool hasProperty(string);
		bool hasMarking(string);
		void addOut(KripkeState &);
		void addIn(KripkeState &);
		int id;
		vector<KripkeState> out;
		vector<KripkeState> in;

};

class Kripke
{
	public:
		Kripke(){};
		vector<KripkeState> states;
		void resetMarks();
		void markNot(string);
		void markAnd(string p, string q);
		void markOr(string p, string q);
		void markEX(string p);
		string toString();
};
#endif

