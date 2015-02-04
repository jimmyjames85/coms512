#include "../includes/ArrayList.h"

#include <stdlib.h>

void ArrayList::doubleListCapacity()
{
	int newSize = 2*this->capacity;
	void ** newArr =(void**) malloc(newSize * sizeof(void *));

	int i = 0;
	for (i = 0; i < this->arrSize; i++)
		newArr[i] = this->arr[i];

	free((void*)this->arr);

	this->arr = newArr;
	this->capacity *= 2;
}
void ArrayList::halveListCapacity()
{
	if (this->capacity == 1)
		return;

	int newSize = this->capacity/2;
	void ** newArr =(void**) malloc(newSize * sizeof(void *));
	int i = 0;
	for (i = 0; i < this->arrSize; i++)
		newArr[i] = this->arr[i];

	free(this->arr);
	this->arr = newArr;
	this->capacity /= 2;
}

ArrayList::ArrayList()
{
	this->arr = (void**)malloc(sizeof(void *));
	this->capacity = 1;
	this->arrSize=0;
}

int ArrayList::size()
{
	return this->arrSize;
}

void ArrayList::add(void * data)
{
	if (this->arrSize + 1 >= this->capacity)
		this->doubleListCapacity();

	this->arr[this->arrSize] = data;
	this->arrSize++;
}

void * ArrayList::remove(int i)
{
	void * ret = (void *) 0;

	if (i >= this->arrSize)
		return ret;

	ret = this->arr[i];
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

ArrayList::~ArrayList()
{
	free(this->arr);
}
