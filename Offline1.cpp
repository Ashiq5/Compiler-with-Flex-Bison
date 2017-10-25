#include<bits/stdc++.h>

using namespace std;
//#define ll long long
#define max3(a, b, c) max(a, b) > max(b, c) ? max(a, b) : max(b, c)
#define min3(a, b, c) min(a, b) < min(b, c) ? min(a, b) : min(b, c)
#define mod 1000000007
#define digit(c) (c - '0')
#define pb push_back
#define mp make_pair
#define fi first
#define se second
#define ss scanf
#define pp printf
struct node{
   float val;
   string s;
   string p;
};
int n=7;
int hash_function (string word)
{
    int sum = 0;
    for (int k = 0; k < word.length(); k++)
        sum = sum + int(word[k]);
    return  sum % n;
}

class ll {
public:
      string key;
      string value;
      float val;
      string type;
      ll *next;

      ll(string key, string value,float val,string type) {
            this->key = key;
            this->value = value;
            this->val = val;
            this->type = type;
            this->next = NULL;
      }

      string getKey() {
            return key;
      }

      string getValue() {
            return value;
      }

      void setValue(string value) {
            this->value = value;
      }

      ll *getNext() {
            return next;
      }

      void setNext(ll *next) {
            this->next = next;
      }
};

class HT {
private:
public:
      ll **table;
      HT() {
            table = new ll*[n];
            for (int i = 0; i < n; i++)
                  table[i] = NULL;
      }

      node get(string key) {
            int hash = hash_function(key),i=0;
            if (table[hash] == NULL)
                  cout<<key<< " NOT FOUND\n\n";
            else {
                  ll *entry = table[hash];
                  while (entry != NULL && entry->getKey() != key){
                        i++;
                        entry = entry->getNext();
                  }
                  if (entry == NULL)
                        cout<<key<< "NOT FOUND\n\n";
                  else{
                        cout<<"<"<<key<<","<<entry->getValue()<<"> found at position "<<hash<<" ,"<<i<<" ."<<endl<<endl;
                        return new node(entry.val,entry.type,entry.)
                        //return entry->getValue();
                  }
            }
      }

      void insert(string key,string value,float val,string type) {
            int hash = hash_function(key),i=1;
            if (table[hash] == NULL){
                  table[hash] = new ll(key, value,val,type);
                  cout<<"<"<<key<<","<<value<<"> inserted at position "<<hash<<" ,"<<0<<" ."<<endl<<endl;
            }
            else {
                  ll *entry = table[hash];
                  while (entry->getNext() != NULL){
                        if(entry->getKey()==key) {
                            cout<<key<<" already exists."<<endl<<endl;
                            return;
                        }
                        entry = entry->getNext();
                        i++;
                  }
                  if(entry->getKey()==key) {
                      cout<<key<<" already exists."<<endl<<endl;
                      return;
                  }
                  entry->setNext(new ll(key, value,val,type));
                  cout<<"<"<<key<<","<<value<<"> inserted at position "<<hash<<" ,"<<i<<" ."<<endl<<endl;
            }
      }

      void remove(string key) {
            int hash = hash_function(key),i=0;
            if (table[hash] != NULL) {
                  ll *prevEntry = NULL;
                  ll *entry = table[hash];
                  while (entry->getNext() != NULL && entry->getKey() != key) {
                        i++;
                        prevEntry = entry;
                        entry = entry->getNext();
                  }
                  if (entry->getKey() == key) {
                        if (prevEntry == NULL) {
                             ll *nextEntry = entry->getNext();
                             cout<<"Deleted from "<<hash<<", 0 ."<<endl<<endl;
                             delete entry;
                             table[hash] = nextEntry;
                        }
                        else {
                             ll *next = entry->getNext();
                             cout<<"Deleted from "<<hash<<" , "<<i<<" ."<<endl<<endl;
                             delete entry;
                             prevEntry->setNext(next);
                        }
                  }
                  else{
                    cout<<key<<" not found"<<endl<<endl;
                  }
            }
      }

};
int main(){
string s="kjkjk\
kjnkjn";
}
/*int main()
{
    ifstream fin("1_input.txt");
    char c;
    fin>>n;
    HT h;
    while(fin>>c){
        if(c=='I'){
            string a;
            string b;
            fin>>a>>b;
            h.put(a,b);
        }
        else if(c=='P')
        {
            for(int i=0;i<n;i++){
                ll *e=h.table[i];
                cout<<i<<" --->";
                while(e!=NULL){
                    cout<<"<"<<e->getKey()<<" , "<<e->getValue()<<">  ";
                    e=e->getNext();
                }
                cout<<endl<<endl;
            }
        }
        else if(c=='D')
        {
            string b;
            fin>>b;
            h.remove(b);
        }
        else if(c=='L')
        {
            string b;
            fin>>b;
            h.get(b);
        }
    }
    return 0;
}
*/
