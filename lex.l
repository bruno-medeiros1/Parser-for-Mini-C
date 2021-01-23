	/* Especificacoes do lex para a linguagem naive C */
%{
    #include "y.tab.h"
%}

	/* Declaracao das expressoes regulares */

LETRA                   [a-zA-Z]
DIGITO                  [0-9]

%%

	/*Este codigo e responsavel por retornar tokens e contar linhas*/
        /*O parser vai receber estas mesmas tokens para analise sintatica*/



[ \t]						;
[ \n]                                           { yylineno = yylineno + 1;}


	/* Keyword */
"int"						{return INT;}
"float"						{return FLOAT;}
"char"						{return CHAR;}
"void"						{return VOID;}
"double"					{return DOUBLE;}
"while"						{return WHILE;}
"for"						{return FOR;}
"if"					        {return IF;}
"else"						{return ELSE;}
"printf"					{return PRINTF;}
"main"						{return MAIN;}
"struct"					{return STRUCT;}
"include"					{return INCLUDE;}
"return"					{return RETURN;}

	/* Operadores */

"<="                                            {return MENORIGUAL;}
">="                                            {return MAIORIGUAL;}
"=="                                            {return IGUAL;}
"!="                                            {return DIFERENTE;}
">"						{return MAIOR;}
"<"						{return MENOR;}

	/* Pontuacao */

\.                                              {return PONTO;}

	/* Comentarios  */
       /*Não são retornados para o parser*/	

\/\/.*                                          ; /*Linha*/
\/\*(.*\n)*.*\*\/                               ; /*Multi-linha*/

	/* Numeros */

{DIGITO}+                   {return NUM;} 
{DIGITO}+"."{DIGITO}+       {return REAL;}

	/* Identificadores - ID */

{LETRA}({LETRA}|{DIGITO})*                     {return ID;} 
[!%]					       {return ID;}

.	                                       {return yytext[0];}

%%
