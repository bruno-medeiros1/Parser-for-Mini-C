	/*Especificacoes YACC para a linguagem naive C*/


	/*Definicao de parametros para o nosso programa naive C*/
%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *fp;                                 /*apontador para o ficheiro*/
int err=0;                                       /*contabilizador de erros*/

int yyerror(const char *str);                    /*funcao responsavel quando ocorre um erro*/
int yylex(void);                                 /*funcao que invoca o scanner e retorna as tokens*/

extern int yylineno;                             /*variavel que contem o n da linha que esta a ser processada*/
extern char* yytext;                             /*texto reconhecido pela expressao regular*/
%}

/*Tokens esperados do analisador lexico*/

%token INT FLOAT CHAR DOUBLE VOID
%token FOR WHILE 
%token IF ELSE PRINTF RETURN MAIN REAL
%token STRUCT 
%token NUM ID
%token INCLUDE
%token PONTO

/*Especificacao da associatividade dos operadores para nao tornar a gramatica ambigua*/
%right '='
%right '+'
%left AND OR
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL DIFERENTE MENOR MAIOR
%%

/* ### Inicio da representacao da nossa gramatica (conjunto de producoes) ### */

/* Producoes responsaveis pela estrutura do nosso programa em naive C */
start:   multi_Declaracao  Funcao_Main 
	| include multi_Declaracao  Funcao_Main
	| include Funcao_Main
	| Funcao_Main
	;

/* Producoes responsaveis por definir varias declaracoes (recursividade) */
multi_Declaracao:TipoDeclaracao 
	|multi_Declaracao TipoDeclaracao 
	;

/* Producoes responsaveis por definir os tipos de declaracoes que podem ser feitas */
TipoDeclaracao: Tipo Atribuicao ';' /*int ... ;*/
	| Atribuicao ';'                /*...;*/
	| FunctionCall ';'              /*FUCTION(...);*/
	| StructStmt                    /*struct ID {...};*/
	| error			/*responsavel por mostrar varios erros*/
	;

/* Producoes responsaveis pela atribuicao de variaveis */
Atribuicao: ID '=' Atribuicao	
	| ID '=' FunctionCall		/*var = Fuction(...);*/
	| ID '+''+'',' Atribuicao
	| ID '-''-' ',' Atribuicao  /*fuction(num--,2)*/
	| '+''+' ID ',' Atribuicao
	| '-''-' ID  ','Atribuicao
	| ID ',' Atribuicao			/*fuction(num,...)*/
	| NUM ',' Atribuicao
	| ID '+' Atribuicao    /*num + 2;*/
	| ID '-' Atribuicao
	| ID '*' Atribuicao
	| ID '/' Atribuicao	
	| NUM '+' Atribuicao
	| NUM '-' Atribuicao	/*2 + num */
	| NUM '*' Atribuicao
	| NUM '/' Atribuicao
	| '\'' Atribuicao '\''	
	| '(' Atribuicao ')'
	| '-' '(' Atribuicao ')'
	| '-' NUM
	| '-' ID	
	|ID '+''+'	/*i++*/
	|ID '-''-'
	|'+''+' ID	/*++i*/
	|'-''-' ID
	|NUM
	|REAL
	|ID
	;

/* Producoes responsaveis pela estrutura de uma declaracao include */
include:'#' INCLUDE MENOR ID PONTO ID MAIOR          /*#include <ID.ID> ou #include "ID.ID"*/
	|include '#' INCLUDE MENOR ID PONTO ID MAIOR
	;

/* Producoes responsaveis pela estrutura de uma funcao */
FunctionCall : ID'('')'    /*FUNCAOX(...) OU FUNCAOX()*/
	| ID'('Atribuicao')'
	;

/* Producoes responsaveis pela estrutura da funcao main */
Funcao_Main: Tipo MAIN '(' ArgListOpt ')' CompoundStmt   /*int main (...){...}*/
	;
	
/* Producoes responsaveis pela existencia de argumentos ou nao */
ArgListOpt: ArgList
	|
	;
	
/* Producoes responsaveis pela estrutura de varios argumentos */
ArgList:  ArgList ',' Arg
	| Arg
	;
	
/* Producoes responsaveis pela estrutura de cada argumento */
Arg: Tipo ID
	;

/* Producao responsavel pela estrutura de uma declaracao de uma funcao */
CompoundStmt:	'{' ListaDeclaracoes '}'
	;
	
/* Producoes responsaveis pela recursao de varias declaracoes dentro de uma funcao */
ListaDeclaracoes: ListaDeclaracoes Stmt
	|
	;
	
/* Producoes responsaveis pelas varias declaracoes que podem existir numa funcao */
Stmt: WhileStmt
	| multi_Declaracao
	| ForStmt
	| IfStmt
	| retStmt
	| FuncPrint
	| ';'		/*ciclo for*/
	;
	
/* Producoes responsaveis pela estrutura de um return */
retStmt:RETURN '(' ID ')' ';'
	   |RETURN '(' NUM ')' ';'
	   ;
	
/* Producao responsavel pela definicao de variaveis,etc dentro de um ciclo*/
loopStmt: Stmt
		;
		
/* Producao responsavel pela estrutura interna de um ciclo */
loopCompoundStmt: '{' loopListaDeclaracoes '}'  /*ciclox {...}*/
	;
	
/* Producoes responsaveis pela estrutura entre "{" "}" de um ciclo */
loopListaDeclaracoes: loopListaDeclaracoes loopStmt
	|
	;

/* Tipo de identificadores */
Tipo: INT 
	| FLOAT
	| CHAR
	| DOUBLE
	| VOID 
	;
	
/* Producoes responsaveis pela estrutura de um ciclo While */ 
WhileStmt: WHILE '(' Expr ')' loopStmt  
		 | WHILE '(' Expr ')' loopCompoundStmt 
		 ;


/* Producoes responsaveis pela estrutura de um ciclo For */
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' loopStmt            /*for(...;...;...){}*/
	   | FOR '(' Expr ';' Expr ';' Expr ')' loopCompoundStmt 
       | FOR '(' Expr ')' loopStmt 
       | FOR '(' Expr ')' loopCompoundStmt 
	   ;

/* Producoes responsaveis pela estrutura de um if/else */
IfStmt : IF '(' Expr ')' Stmt                   /*if(...);*/
		|IF '(' Expr ')' CompoundStmt	/*if (...){...}*/
		|IF '(' Expr ')' CompoundStmt ELSE CompoundStmt /*if(...){...}else{...}*/
		|IF '(' Expr ')' CompoundStmt ELSE Stmt			/*if(...){...}else...*/
		;
 

/* Producoes responsaveis pela estrutura de um Struct */
StructStmt : STRUCT ID '{' multi_Declaracao '}' ';'                     /* struct ID {...}; */
	   | STRUCT ID '{' multi_Declaracao '}'  ID ';'	                /* struct ID {...}ID; */
	   | STRUCT ID '{' multi_Declaracao '}'  ID '['NUM']' ';'	/* struct ID {...}ID [NUM]; */
	;
	

/* Producoes responsaveis pela estrutura de um Printf */
FuncPrint : PRINTF '(' '"' print '"'   ')' ';'                         /* printf("....");*/
		  |PRINTF '(' '"' print '"'  ',' print ')' ';'
	      ;

/*Producoes complementar a do printf acima, onde existe recursao de varios ID, ou seja texto*/	
print	:ID print /*texto texto texto ...*/
	|ID    /*texto*/ 
	;
	
/* Producao responsavel pela estrutura das expressoes */
Expr:	
	| Expr MENORIGUAL Expr  /*algo <= algo*/
	| Expr MAIORIGUAL Expr
	| Expr DIFERENTE Expr
	| Expr IGUAL Expr
	| Expr MAIOR Expr
	| Expr MENOR Expr
	| Atribuicao
	;

%%

/*Codigo C que suporta o processamento da linguagem*/
/*Onde existe funcoes que sao chamadas pelo parser*/

#include "lex.yy.c" /*inclusao da tabela de tokens*/
#include <ctype.h> /*contém declarações para manipulação de caracteres. Usada quando se trabalha com diferentes idiomas e alfabetos.*/


int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r"); /*Abertura do ficheiro para leitura do mesmo*/
	
	if(!yyparse() && err==0){
		printf("\n\n\tAnalise Sintatica completa :)\n\n");
	}else{
		printf("\nUps... algo de errado aconteceu na analise sintatica, verifique em cima! :( \n");
	}
	fclose(yyin);
    return 0;
}

/*Funcao que é chamada quando ocorre um erro*/         
int yyerror(const char *str) {
    printf("\n-Linha numero: %d Mensagem de erro: %s Token: %s", yylineno, str, yytext);
    return 0;
}

