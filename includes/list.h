#ifndef LIST_H
#define LIST_H
typedef struct _struct_list
{
		void ** arr;//get is the storage array
		int capacity;
		int size;
} List;

List * newList();
void list_add(List * list, void * data);
void * list_remove(List * list, int i);
void freeList(List * list);
#endif
