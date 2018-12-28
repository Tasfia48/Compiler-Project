/* C Declarations */

%{
	#include<stdio.h>
	int alphabet[26];
	int ch[26];
	int i,sum,s,q,j;
%}

/* bison declarations */

%token NUMBER VARIABLE IF ELSE LFB RFB MAIN INT FLOAT CHAR FOR LSB RSB
%nonassoc IF
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc FOR
%left LT GT
%left ADD SUB '++'
%left MUL DIV POW


/* Grammar rules and actions follow.  */

%%

PROGRAM: MAIN LFB RFB LSB new_statement RSB  {for(i=0;i<26;i++) {if(ch[i]>1){printf("%c multiple %d\nwhich is invalid so this variables are are considered as once declared",i+65,ch[i]);
                                                                     ch[i]=1;}}} 
	 ;

new_statement: 

	| new_statement STATEMENT  
	;

STATEMENT: ';'

	| EXPRESSION ';' 			{ printf("The value of expression: %d\n", $1); }
	

    | VARIABLE '=' EXPRESSION ';' 		{ 
							alphabet[$1] = $3; 
							printf("Value of the variable %c: %d\t\n",65+$1,$3);
						}
	| TYPE_0F_ID ';'
	
	/* loop */
	| FOR LFB VARIABLE '=' EXPRESSION ';' VARIABLE LT  EXPRESSION ';' VARIABLE '++' RFB LSB EXPRESSION RSB ';' %prec FOR
                                   {
								   alphabet[$3] = $5;
								   i=$5;
								   j=$9;
								   for(q=i;q<j;q++)
								   {
								    i=$15+q;
								    printf("value of expression in loop: %d\n",i);
								   
								   }							   
								   }
	/* switch case */							   
	| SWITCH LFB EXPRESSION RFB CASE LFB EXPRESSION RFB ':' EXPRESSION ';' CASE  LFB EXPRESSION RFB ':' EXPRESSION ';' CASE LFB EXPRESSION RFB ':' EXPRESSION ';' %prec SWITCH
                                   {if($3==$7)
								   {
								   printf("value of EXPRESSION in case 1: %d\n",$10);
								   }
								   else if($3==$13)
								   {
								   printf("value of EXPRESSION in case 2: %d\n",$17);
								   }
								   else
								   {
								   printf("value of EXPRESSION in case 3: %d\n",$24);
								   }
								   
								   }
    
	/* if */
	| IF LFB EXPRESSION RFB EXPRESSION ';' %prec IF {
								if($3)
								{
									printf("\n The value of expression in IF: %d\n",$5);
								}
								else
								{
								printf("zero in IF block\n");
								}
							}

    /* if-else */
	| IF LFB EXPRESSION RFB EXPRESSION ';' ELSE EXPRESSION ';' {
								 	if($3)
									{
										printf(" The value of expression in IF: %d\n",$5);
									}
									else
									{
										printf("The value of expression in ELSE: %d\n",$8);
									}
								   }
	/* increment */
	| VARIABLE '++' ';' { i=alphabet[$1]+1;
	                       alphabet[$1]=i;} 									
	                                {
										printf("The value of %c is : %d\n",$1+65,i);
									}
  
  	
    
	;

EXPRESSION: NUMBER				{ $$ = $1; 	}

	| VARIABLE			{ $$ = alphabet[$1]; } 
	
	| EXPRESSION ADD EXPRESSION	{ $$ = $1 + $3; }

	| EXPRESSION SUB EXPRESSION	{ $$ = $1 - $3; }

	| EXPRESSION MUL EXPRESSION	{ $$ = $1 * $3; }

	| EXPRESSION DIV EXPRESSION	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
						
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}
						
	| EXPRESSION POW EXPRESSION	{ 	if($3) 
				  		{
						        sum=1;
				                s=$3;
								q=$1;
								for(i=0;i<s;i++)
                                 {
                                  sum=sum*q;								 
                                }
								$$=sum;
							}	
							
				  		else
				  		{
							$$ = 1;
							
				  		} 	
				    	}
	
					
				

	| EXPRESSION LT EXPRESSION	{ $$ = $1 < $3; }

	| EXPRESSION GT EXPRESSION	{ $$ = $1 > $3; }

	| LFB EXPRESSION RFB		{ $$ = $2;	}
	 

	;
	



TYPE_0F_ID : INT ID							
     | FLOAT ID						
     | CHAR  ID							
     ;



ID : ID ',' VARIABLE 				{ch[$3]++;}
    |VARIABLE						{ch[$1]++;}
    ;


%%

int yywrap()
{
return 1;
}

yyerror(char *s){
	printf( "%s\n", s);
}

