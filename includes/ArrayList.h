//using namespace std;

class ArrayList
{
	public:
		ArrayList();
		int size();
		void add(void * );
		void * remove(int);
		~ArrayList();
	private:
		void doubleListCapacity();
		void halveListCapacity();
		void ** arr;
		int capacity;
		int arrSize;

};
