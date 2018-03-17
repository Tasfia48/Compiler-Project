/* C Declarations */

%{
	#include<stdio.h>
	#include "final.tab.h"
	#include<stdlib.h>
	extern int yylval;
	
	
	int key_count=0;

	int id_count=0;

	int op_count=0;
    
    int con_op_count=0;
    
	int h_count=0;
	 
	int ml_count=0;
	
	int sl_count=0;
	
	void outFunc()
	{
	printf("Number of header:%d",h_count);
	printf("\n Number of KEYWORDS:%d",key_count);
	printf("\n Number of operator:%d",op_count);
	printf("\n Number of conditional operator:%d\n",con_op_count);
    return ;
	}
%}

/* RE and Actions */

%%
[A-Z]*.head {h_count++; printf("%s",yytext); printf( "-------this is a header\n");}

[0-9]+	{ yylval = atoi(yytext);
         return NUMBER;}

[A-Z]	{
		yylval = *yytext - 'A';
		return	VARIABLE;}

"main func"	{ return MAIN; }
"int"  return(INT);
"char" return(CHAR);
"float" return(FLOAT);

"IFCon" {return IF;  }
"ELCon" {return ELSE;   }
"SWITCHCon" {return SWITCH;   }
"CASECon" {return CASE;   }
"ForLoop" {return FOR;   }


"LessThan" {return LT;  }
"GreaterThan" {return GT;  }
"LeftFirstB" {return LFB; }
"RightFirstB" {return RFB; }
"LeftSecondB" {return LSB; }
"RightSecondFirstB" {return RSB; }
"SemiC" {return ';';}
"Com" {return ',';}

"++" {
			yylval = yytext[0];
			return *yytext;
		}

":"	{
			yylval = yytext[0];
			return *yytext;
		}
		

"Sum" {return ADD; op_count++;}
"Sub" {return SUB;op_count++;}
"Mul" {return MUL;op_count++;}
"Div" {return DIV;op_count++;}
"Power" {return POW;op_count++;}



"Equal" {return '=';con_op_count++;}

[$][$].* {ml_count++;printf("%s",yytext);printf("    -----#This is a multi line comment\n");}
[$][!].* {sl_count++;printf("%s",yytext);	printf("   -----This is a single line comment\n");}													


[ \t\n]*	;

.	{
		yyerror("Unknown Character.\n");
	}
%%

main(){
	yyin = freopen("in.txt","r",stdin);

	yyout = freopen("out.txt","w",stdout);
	
	yyparse();
}

