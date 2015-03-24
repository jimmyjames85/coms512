#include <cstddef>
#ifndef ARRAYLIST_H
#define ARRAYLIST_H

template<class T>
class ArrayList
{
	public:
		ArrayList();
		~ArrayList();
		int size();
		void add(const T &);
		T * remove(int);
		const T & get(int);
	private:
		void doubleListCapacity();
		void halveListCapacity();
		T * arr;
		int capacity;
		int arrSize;
};

template<class T> const T & ArrayList<T>::get(int i)
{
	if(i<this->arrSize)
		return this->arr[i];

	return NULL;
}

template<class T> void ArrayList<T>::doubleListCapacity()
{
	int newSize = 2 * this->capacity;
	T * newArr = new T[newSize]; // T(T *) malloc(newSize * sizeof(T));

	int i = 0;
	for (i = 0; i < this->arrSize; i++)
		newArr[i] = this->arr[i];

	delete [] this->arr;

	this->arr = newArr;
	this->capacity *= 2;
}
template<class T> void ArrayList<T>::halveListCapacity()
{
	if (this->capacity == 1)
		return;

	int newSize = this->capacity / 2;
	T * newArr = new T[newSize]; //(T *) malloc(newSize * sizeof(T));
	int i = 0;
	for (i = 0; i < this->arrSize; i++)
		newArr[i] = this->arr[i];

	delete [] this->arr;

	this->arr = newArr;
	this->capacity /= 2;
}

template<class T>
ArrayList<T>::ArrayList()
{
	this->arr = new T[1];
	this->capacity = 1;
	this->arrSize = 0;
}

template<class T> int ArrayList<T>::size()
{
	return this->arrSize;
}

template<class T> void ArrayList<T>::add(const T & data)
{
	if (this->arrSize + 1 >= this->capacity)
		this->doubleListCapacity();

	this->arr[this->arrSize] = data;
	this->arrSize++;

}

template<class T> T * ArrayList<T>::remove(int i)
{
	T * ret = (T *) 0;

	if (i >= this->arrSize)
		return ret;

	ret = &this->arr[i];
	while (i < this->arrSize - 1)
	{
		this->arr[i] = this->arr[i + 1];
		i++;
	}
	this->arrSize--;

	if (this->arrSize < this->capacity / 2)
		this->halveListCapacity();

	return ret;
}

template<class T> ArrayList<T>::~ArrayList()
{
	delete[] this->arr;
}

#endif
