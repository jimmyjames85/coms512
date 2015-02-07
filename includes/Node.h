#ifndef NODE_H
#define NODE_H
//#include <cstddef>
#include <vector>
using namespace std;

template<class T>
class Node
{
	public:
		Node();
		Node(const T & data){this->data = data;}
		T data;
		vector<Node> out;
		vector<Node> in;
};
#endif
