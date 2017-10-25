#include "SymbolInfo.h"
#define _SIZE 100
class SymbolTable
{
    SymbolInfo *hashTableHead[_SIZE];
    SymbolInfo *hashTableTail[_SIZE];
    int TABLE_SIZE;
public:
    SymbolTable(int n)
    {
        this->TABLE_SIZE=n;
        for(int i=0; i<TABLE_SIZE; i++)
        {
            hashTableHead[i]=hashTableTail[i]=0;
        }
    }
    int hashFunc(char *Name)
    {
        //int l= Name.length();
        int sum=0;
        for(int i=0; Name[i]!='\0'; i++) sum+=Name[i];
        int x=sum%TABLE_SIZE;
        return x;
    }
    SymbolInfo * LookUp(char *Name)
    {
        int value = hashFunc(Name);
        SymbolInfo *temp;
        temp = hashTableHead[value];
        int pos = 0;
        while(temp!=0)
        {
            if(strcmp(temp->Name,Name)==0) return temp;
            temp=temp->next;
            pos++;
        }
        return NULL;
    }
     
    SymbolInfo * LookUp(char *Name,int a_l)
    {
        int value = hashFunc(Name);
        SymbolInfo *temp;
        temp = hashTableHead[value];
        int pos = 0;
        while(temp!=0)
        {
            if(strcmp(temp->Name,Name)==0 && temp->a_l==a_l) return temp;
            temp=temp->next;
            pos++;
        }
        return NULL;
    }
    
  

    bool Insert(char *Name, char *Type,double val,int a_l,int a_size)
    {
	SymbolInfo *x;
    	if(a_l!=-1)x =LookUp(Name,a_l);
        else x=LookUp(Name);
    	if(x!=NULL)
    	{
		//fprintf(logout,"already exist.\n");
		return 0;
	}
        int value = hashFunc(Name);
        SymbolInfo *newNode;
        newNode= new SymbolInfo();
        newNode->Name=Name;
        newNode->Type=Type;
        newNode->val=val;
        newNode->a_l=a_l;
        newNode->a_size=a_size;
        newNode->next=0;
        if(hashTableHead[value]==0)
        {
            hashTableHead[value]= newNode;
            newNode->prev = 0;
            hashTableTail[value]= newNode;
        }
        else
        {
            hashTableTail[value]->next=newNode;
            newNode->prev=hashTableTail[value];
            hashTableTail[value]=newNode;
        }
        return 1;

    }

    int Delete(char *Name)
    {
        SymbolInfo * check = LookUp(Name);
        if(check == NULL) return NULL_VALUE;
        if(check!= NULL)
        {
            int value = hashFunc(Name);
            SymbolInfo *temp;
            temp = hashTableHead[value];
            if (check ==0)
            {
                if(hashTableHead[value]==hashTableTail[value])
                {
                    hashTableHead[value]=hashTableTail[value]=0;
                }
                else
                {
                    hashTableHead[value]= hashTableHead[value]->next;
                    hashTableHead[value]->prev=0;
                }
            }
            else
            {
                while(temp->Name!=Name) temp=temp->next;
                if(temp->next==0)
                {
                    temp->prev->next=0;
                    hashTableTail[value]=temp->prev;
                }
                else
                {
                    temp->prev->next=temp->next;
                    temp->next->prev=temp->prev;
                }
            }
            delete temp;
            return SUCCESS_VALUE;

        }
    }
    void printHashTable()
    {
        printf("\n");
        SymbolInfo *temp;
        for(int i=0 ; i<TABLE_SIZE ; i++)
        {

            //output<<i<<"->";
            temp = hashTableHead[i];
            if(temp == NULL) continue;
			printf("%d -->",i);
            while(temp!=0)
            {
                printf("<%s,%s,%d>",temp->Name,temp->Type,temp->a_l);
                temp=temp->next;
            }
            printf("\n");

        }
    }
    void printHashTable(FILE *log)
    {
        fprintf(log,"\n");
        SymbolInfo *temp;
        for(int i=0 ; i<TABLE_SIZE ; i++)
        {

            //output<<i<<"->";
            temp = hashTableHead[i];
            if(temp == NULL) continue;
			fprintf(log,"%d -->",i);
            while(temp!=0)
            {
                fprintf(log,"<%s,%d,%lf>",temp->Name,temp->a_l,temp->val);
                temp=temp->next;
            }
            fprintf(log,"\n\n");

        }
    }
};


