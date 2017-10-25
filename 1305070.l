
%x STRING
%x COMMENT
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<fstream>
#include<bits/stdc++.h>
#include "SymbolInfo.h"
# include "y.tab.h"

void yyerror(char*);
extern YYSTYPE yylval;
int line_count=1;
char *str;
char *cmt;
int error=0;
int f=0,j,k;
FILE *logout;
//HT h;
FILE *tokenout;
char *p,*q;
//string s;
void display()
{
    /*int i;
    for(i=0;i<n;i++){
        ll *e=h.table[i];
        //cout<<i<<" --->";
        fprintf(logout,"%d--->",i);
        while(e!=NULL){
            //cout<<"<"<<e->key<<" , "<<e->value<<">  ";
            p=(char *)malloc(500);
            q=(char *)malloc(500);
            s=e->key;
            for(j=0;j<e->key.length();j++)p[j]=s[j];
            s=e->value;
            for(j=0;j<e->value.length();j++)q[j]=s[j];
            fprintf(logout,"<<%s,%s>>",p,q);
            //fout<<e->key<<","<<e->value<<"    ";
            e=e->next;
        }
        //cout<<endl<<endl;
        fprintf(logout,"\n");
        //fout<<"\n";
    }*/
}

%}

delim [ \t\r\f\v]

ws [ \t\f\r\v]+ 

letter [a-zA-Z_]

digit [0-9]

newline \n

ba [\+\-\*%\/><=!&\[\]\(\)\{\};\|\,]

id (_|{letter})(_|{letter}|{digit})*

integer {digit}+

number {digit}*(\.{digit}+)?(E[+-]?{digit}+)?

%%
{delim}+ {};
{newline} {line_count++;}

"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"do"	{return DO;}
"continue"    {return CONTINUE;}
"int" {return INT;}
"float" {return FLOAT;}
"double" {return DOUBLE;}
"char" {return CHAR;}
"return" {return RETURN;}
"void" {return VOID;}
"main"	{return MAIN;}
"println"	{return PRINTLN;}


"+"|"-"	        {sscanf(yytext,"%c", &yylval);
		//yylval.sval = yytext;
		return ADDOP;}

"*"|"/"|"%"	   {sscanf(yytext,"%c", &yylval);
		//yylval.sval = yytext;
		return MULOP;}


"<"|"<="|">"|">="|"=="|"!="	 {if(strcmp(yytext,"<")==0)yylval.sval="<";
                                  else if(strcmp(yytext,"<=")==0)yylval.sval="<=";
                                  else if(strcmp(yytext,"!=")==0)yylval.sval="!=";else if(strcmp(yytext,">")==0)yylval.sval=">";else if(strcmp(yytext,"==")==0)yylval.sval="==";else if(strcmp(yytext,">=")==0)yylval.sval=">=";
                                                 return RELOP;}
 
"="	   {return ASSIGNOP;}

"&&"|"||"	   {if(strcmp(yytext,"&&")==0)yylval.sval="&&";
                                  else if(strcmp(yytext,"||")==0)yylval.sval="||";return LOGICOP;}

"!"		{	return NOT; }
";" 	{ return SEMICOLON;}
"," 	{return COMMA;}
"(" 	{return LPAREN;}
")" 	{return RPAREN;}
"{" 	{return LCURL;}
"}" 	{return RCURL;}
"[" 	{return LTHIRD;}
"]" 	{return RTHIRD;}
"++" 	{return INCOP;}
"--" 	{return DECOP;}

{integer}	        {
				//yylval.ival = atoi(*yytext);
                                sscanf(yytext,"%d", &yylval);
				return CONST_INT;
			}
{number} 	        {	
				//yylval.dval = atof(*yytext);
                                sscanf(yytext,"%lf", &yylval);
				return CONST_FLOAT; 
			}
{id} 			{	 
				//sscanf(yytext,"%s", &yylval);
                                //printf("%s",yytext);
		                yylval.sval = (char *)yytext;	
                                //printf("%s",yylval.sval)		;
				return ID;
			}

%%
int yywrap(void)
{
	return 1;
}

