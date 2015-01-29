#include <stdlib.h>
#include "list.h"

List * newList()
{
	List * ret = (List *) malloc(sizeof(List));
	ret->arr = (void**)malloc(sizeof(void *));
	ret->capacity = 1;
	ret->size = 0;
	return ret;
}

void doubleListCapacity(List * list)
{

	int newSize = 2*list->capacity;
	void ** newArr =(void**) malloc(newSize * sizeof(void *));

	int i = 0;
	for (i = 0; i < list->size; i++)
		newArr[i] = list->arr[i];

	free((void*)list->arr);

	list->arr = newArr;
	list->capacity *= 2;
}
void halveListCapacity(List * list)
{
	if (list->capacity == 1)
		return;

	int newSize = list->capacity/2;
	void ** newArr =(void**) malloc(newSize * sizeof(void *));
	int i = 0;
	for (i = 0; i < list->size; i++)
		newArr[i] = list->arr[i];

	free(list->arr);
	list->arr = newArr;
	list->capacity /= 2;
}
void list_add(List * list, void * data)
{
	if (list->size + 1 >= list->capacity)
		doubleListCapacity(list);

	list->arr[list->size] = data;
	list->size++;
}

void * list_remove(List * list, int i)
{
	void * ret = (void *) 0;

	if (i >= list->size)
		return ret;

	ret = list->arr[i];
	while (i < list->size - 1)
	{
		list->arr[i] = list->arr[i + 1];
		i++;
	}
	list->size--;

	if (list->size < list->capacity / 2)
		halveListCapacity(list);
	return ret;
}

void freeList(List * list)
{
	free(list->arr);
	free(list);
}

/*
 void * list_get(List * list, int i)
 {
 //	if(list_size(list) > i)
 //	return
 }

 void * list_remove(List * list, int i);
 int list_isEmpty(List * list);
 int list_size(List * list);



 void * remove(int i);
 int isEmpty();
 int size();
 */
