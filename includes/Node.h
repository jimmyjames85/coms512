#ifndef NODE_H
#define NODE_H



typedef struct _struct_dllnode
{
    _struct_dllnode * prev;
    _struct_dllnode * next;
    void * data;
}DLLNode;


#endef
