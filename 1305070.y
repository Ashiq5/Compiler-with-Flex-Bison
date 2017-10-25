%{
#include <stdlib.h>
#include <stdio.h>
#include<bits/stdc++.h>
#include"SymbolInfo.h"
#include"SymbolTable.h"
//int yydebug;
int yyparse(void);
int yylex(void);
FILE *logou;
SymbolTable su(7);
int cnt=0,i,gh;
extern int line_count;
int eror=0;
SymbolInfo *identifiers[100];
extern "C" FILE *yyin;
void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
	return;
}

%}

%union { double dval; int ival; char *sval; char c; SymbolInfo *s;bool b;}
%token   INT MAIN LPAREN RPAREN ASSIGNOP NOT LCURL RCURL LTHIRD RTHIRD FLOAT CHAR  INCOP DECOP
           RETURN VOID PRINTLN ELSE  FOR IF WHILE DO CONTINUE DOUBLE COMMA SEMICOLON
%token <dval> CONST_FLOAT
%token <ival> CONST_INT
%token <sval> ID
%token <c> ADDOP
%token <c> MULOP
%token <sval> RELOP
%token <sval> LOGICOP
%token <c> CONST_CHAR
%type <dval> expression;
%type <dval> logic_expression
%type <dval> rel_expression
%type <dval> simple_expression
%type <dval> term
%type <dval> unary_expression
%type <dval> factor
%type <s> variable
%type <sval> type_specifier
%type <b> expression_statement
%nonassoc RPAREN
%nonassoc ELSE
%%


Program : INT MAIN LPAREN RPAREN compound_statement    
{
fprintf(logou,"Program : INT MAIN LPAREN RPAREN compound_statement\n\n");
su.printHashTable(logou);
fprintf(logou,"Total errors: %d",eror);
}
	;


compound_statement : LCURL var_declaration statements RCURL        {fprintf(logou,"compound_statement : LCURL var_declaration RCURL\n\n");}
                   | LCURL statements RCURL                        {fprintf(logou,"compound_statement : LCURL statements RCURL\n\n");}
		   | LCURL RCURL                                   {fprintf(logou,"compound_statement : LCURL RCURL\n\n");}
		   ;

			 
var_declaration	: type_specifier declaration_list SEMICOLON         

{
fprintf(logou,"var_declaration : type_specifier declaration_list SEMICOLON\n\n");
for(int i=0;i<cnt;i++){identifiers[i]->Type=$1;}
gh=cnt;
su.printHashTable();
}
		|  var_declaration type_specifier declaration_list SEMICOLON  
{
fprintf(logou,"var_declaration : var_declaration type_specifier declaration_list SEMICOLON\n\n");
for(int i=gh;i<cnt;i++){identifiers[i]->Type=$2;}
gh=cnt;
su.printHashTable();
}
                ;

type_specifier	: INT                    {fprintf(logou,"type_specifier : INT\n\n");$$="INT";}
		| FLOAT                  {fprintf(logou,"type_specifier : FLOAT\n\n");$$="FLOAT";}
		| CHAR                   {fprintf(logou,"type_specifier : CHAR\n\n");$$="CHAR";}
		;
			
declaration_list : declaration_list COMMA ID       

{
for(i=0;$3[i]!='\0';i++){if(($3[i]>='A' && $3[i]<='Z') || ($3[i]>='a' && $3[i]<='z') || ($3[i]>='0' && $3[i]<='9'))continue;else break;}
$3[i]='\0';
fprintf(logou,"declaration_list : declaration_list COMMA ID %s\n\n",$3);
if(su.LookUp($3)!=NULL) {fprintf(logou,"ERROR at line %d : %s declared multiple times\n\n",line_count,$3);eror++;}
else
{
	su.Insert($3,"void",-99999,-1,-1);
	//su.printHashTable();
	identifiers[cnt++]=su.LookUp($3);
}
}


		 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD    


{
for(i=0;$3[i]!='\0';i++){if(($3[i]>='A' && $3[i]<='Z') || ($3[i]>='a' && $3[i]<='z') || ($3[i]>='0' && $3[i]<='9'))continue;else break;}
$3[i]='\0';
fprintf(logou,"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD %s\n\n",$3);
if(su.LookUp($3)!=NULL) {fprintf(logou,"ERROR at line %d : %s declared multiple times\n\n",line_count,$3);eror++;}
else{
	for(int j=0;j<$5;j++){su.Insert($3,"void",-99999,j,$5);identifiers[cnt++]=su.LookUp($3,j);}
	//su.printHashTable();
	identifiers[cnt++]=su.LookUp($3,$5);
}
}

		 | ID                                

{
for(i=0;$1[i]!='\0';i++){if(($1[i]>='A' && $1[i]<='Z') || ($1[i]>='a' && $1[i]<='z') || ($1[i]>='0' && $1[i]<='9'))continue;else break;}
$1[i]='\0';
fprintf(logou,"declaration_list : ID %s\n\n",$1);
if(su.LookUp($1)!=NULL) {fprintf(logou,"ERROR at line %d : %s declared multiple times\n\n",line_count,$1);eror++;}
else{
	su.Insert($1,"void",-99999,-1,-1);
	//su.printHashTable();
	identifiers[cnt++]=su.LookUp($1);
}
}

		 | ID LTHIRD CONST_INT RTHIRD         

{
for(i=0;$1[i]!='\0';i++){if(($1[i]>='A' && $1[i]<='Z') || ($1[i]>='a' && $1[i]<='z') || ($1[i]>='0' && $1[i]<='9'))continue;else break;}
$1[i]='\0';
fprintf(logou,"declaration_list : ID LTHIRD CONST_INT RTHIRD %s %d\n\n",$1,$3);
if(su.LookUp($1)!=NULL) {fprintf(logou,"ERROR at line %d : %s declared multiple times\n\n",line_count,$1);eror++;}
else
{
	for(int j=0;j<$3;j++){
		su.Insert($1,"void",-99999,j,$3);
		identifiers[cnt++]=su.LookUp($1,j);
	}	
	//su.printHashTable();
}
}
		 ; 


statements : statement                        {fprintf(logou,"statements : statement\n\n");}
	   | statements statement             {fprintf(logou,"statements : statements statement\n\n");}
	   ;


statement  : expression_statement            {fprintf(logou,"statement : expression_statement\n\n");}
	   | compound_statement              {fprintf(logou,"statement : compound_statement\n\n");}
	   | FOR LPAREN expression_statement expression_statement expression RPAREN statement 
{
fprintf(logou,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n");
}
	   | IF LPAREN expression RPAREN statement      {fprintf(logou,"statement : IF LPAREN expression RPAREN statement\n\n");}
	   | IF LPAREN expression RPAREN statement ELSE statement {fprintf(logou,"statement : IF LPAREN expression RPAREN statement ELSE statement\n\n");}
	   | WHILE LPAREN expression RPAREN statement    {fprintf(logou,"statement : WHILE LPAREN expression RPAREN statement\n\n");}
	   | PRINTLN LPAREN ID RPAREN SEMICOLON     {fprintf(logou,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n");}
	   | RETURN expression SEMICOLON            {fprintf(logou,"statement : RETURN expression SEMICOLON\n\n");}
	   ; 
		

expression_statement	: SEMICOLON			{fprintf(logou,"expression_statement : SEMICOLON\n\n");}
			| expression SEMICOLON          
{
fprintf(logou,"expression_statement : expression SEMICOLON\n\n");
if((int)$1!=0)$$=true;
else $$=false;
}
			;
						
variable : ID 		                                

{
for(i=0;$1[i]!='\0';i++){if(($1[i]>='A' && $1[i]<='Z') || ($1[i]>='a' && $1[i]<='z') || ($1[i]>='0' && $1[i]<='9'))continue;else break;}
$1[i]='\0';
fprintf(logou,"variable : ID\n\n");
$$=su.LookUp($1);
if($$==NULL){fprintf(logou,"ERROR at line %d : %s not declared\n\n",line_count,$1);eror++;}
if($$!=NULL && $$->a_size!=-1) {fprintf(logou,"ERROR at line %d : Type mismatch\n\n",line_count);eror++;}
}

	 | ID LTHIRD expression RTHIRD                   

{
for(i=0;$1[i]!='\0';i++){if(($1[i]>='A' && $1[i]<='Z') || ($1[i]>='a' && $1[i]<='z') || ($1[i]>='0' && $1[i]<='9'))continue;else break;}
$1[i]='\0';
fprintf(logou,"variable : ID LTHIRD expression RTHIRD\n\n");
$$=su.LookUp($1,$3);
if($$==NULL){
        SymbolInfo *n=su.LookUp($1,0);
        int m;
	if(n!=NULL)m=n->a_size;
        else m=10000000;
        if($3>=m){fprintf(logou,"ERROR at line %d : Array index out of bound\n\n",line_count);eror++;}
	else {fprintf(logou,"ERROR at line %d : %s not declared\n\n",line_count,$1);eror++;}
}
}

	 ;
			
expression : logic_expression	                       {fprintf(logou,"expression : logic_expression\n\n");$$=$1;}
	   | variable ASSIGNOP logic_expression 	
{
fprintf(logou,"expression : variable ASSIGNOP logic_expression\n\n");
$$=1;
if($1!=NULL){
        if($1->Type=="INT"){
		if((int)$3!=$3){fprintf(logou,"ERROR at line %d : Type mismatch\n\n",line_count);eror++;}
                $1->val=(int)$3;
        }
        else if($1->Type=="CHAR"){
		if((int)$3!=$3){fprintf(logou,"ERROR at line %d : Type mismatch\n\n",line_count);eror++;}
                $1->val=(char)$3;
        }
        else if($1->Type=="FLOAT"){
		//if((float)$3!=$3){fprintf(logou,"ERROR: Type mismatch\n\n");}
                $1->val=(float)$3;
        }
	else $1->val=$3;
	printf("assignop %s %lf\n",$1->Name,$3);
}
//else{printf("ERROR: not declared\n\n");}
su.printHashTable(logou);
}
	   ;
			
logic_expression : rel_expression 	                {fprintf(logou,"logic_expression : rel_expression\n\n");$$=$1;}
		 | rel_expression LOGICOP rel_expression 

{
fprintf(logou,"logic_expression : rel_expression LOGICOP rel_expression\n\n");
if($2[0]=='&' && $2[1]=='&') $$=($1&&$3);
else if($2[0]=='|' && $2[1]=='|') $$=($1||$3);
printf("logicop %lf\n",$$);
} 	
		 ;
			
rel_expression	: simple_expression                          {fprintf(logou,"rel_expression : simple_expression\n\n");$$=$1;}
		| simple_expression RELOP simple_expression  {fprintf(logou,"rel_expression : simple_expression RELOP simple_expression\n\n");
                                                              if($2[0]=='<' && $2[1]=='=') {$$=($1<=$3);}
						              else if($2[0]=='>' && $2[1]=='=') {$$=($1>=$3);}
							      else if($2[0]=='!' && $2[1]=='=') {$$=($1!=$3);}
							      else if($2[0]=='=' && $2[1]=='=') {$$=($1==$3);}
                                                              else if($2[0]=='>') $$=($1>$3);
                                                              else if($2[0]=='<') $$=($1<$3);
							      printf("relop %lf\n",$$);
                                                             }	
		;
				
simple_expression : term                                    {fprintf(logou,"simple_expression : term\n\n");$$=$1;}
		  | simple_expression ADDOP term            {fprintf(logou,"simple_expression : simple_expression ADDOP term\n\n");
                                                             if($2=='+') {$$=$1+$3;}
                                                             else if($2=='-') {$$=$1-$3;}
                                                             //else $$=$1+$3;
							     printf("addop %lf\n",$$);
							    }
		  ;
					
term :	unary_expression                                {fprintf(logou,"term : unary_expression\n\n");$$=$1;}
     |  term MULOP unary_expression                     {fprintf(logou,"term : term MULOP unary_expression\n\n");
                                                         if($2=='*') $$=$1*$3;
                                                         else if($2=='/') $$=$1/$3;
                                                         else if($2=='%'){
						       	 	if($1==(int)$1 && $3==(int)$3)$$=(int)$1%(int)$3;
                                                         	else {fprintf(logou,"Error at line %d : Operands should be integer\n\n",line_count);eror++;}
                                                         }
                                                         printf("mulop %lf\n",$$);
							}
     ;

unary_expression : ADDOP unary_expression              {fprintf(logou,"unary_expression : ADDOP unary_expression\n\n");
                                                        if($1=='+') $$=$2;
                                                        else if($1=='-') $$=-$2;
                                                        printf("addop unary %lf\n",$$);
						       }
		 | NOT unary_expression                {fprintf(logou,"unary_expression : NOT unary_expression\n\n");$$=!$2;printf("not unary %lf\n",$$);}
		 | factor                              {fprintf(logou,"unary_expression : factor\n\n");$$=$1;}
		 ;
	
factor	: variable                                     {fprintf(logou,"factor : variable\n\n");if($1!=NULL)$$=$1->val;}
	| LPAREN expression RPAREN             {fprintf(logou,"factor : LPAREN expression RPAREN\n\n");$$=$2;}
	| CONST_INT                            {fprintf(logou,"factor : CONST_INT %d\n\n",$1);$$=(double)$1;}
	| CONST_FLOAT                         {fprintf(logou,"factor : CONST_FLOAT %lf\n\n",$1);$$=(double)$1;}
	| CONST_CHAR                       {fprintf(logou,"factor : CONST_CHAR %c\n\n",$1);$$=(double)$1;}
	| factor INCOP                    {fprintf(logou,"factor : factor INCOP\n\n");$$=$1+1;}
	| factor DECOP                   {fprintf(logou,"factor : factor DECOP\n\n");$$=$1-1;}
	;

%%

int main(int argc,char *argv[]){
	//yydebug=1;
        FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}

        logou= fopen("che.txt","w");
        if(logou==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
        yyin=fin;
	yyparse();
        fclose(logou);
	return 0;
}
