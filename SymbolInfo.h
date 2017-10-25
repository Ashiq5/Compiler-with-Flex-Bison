#ifndef A_H
#define A_H


#include<bits/stdc++.h>


using namespace std;
#define NULL_VALUE -99999
#define SUCCESS_VALUE 99999

class SymbolInfo
{
public:
    char *Name;
    char *Type;
    double val;
    int a_l;
    int a_size;
    SymbolInfo *next;
    SymbolInfo *prev;
};

#endif
