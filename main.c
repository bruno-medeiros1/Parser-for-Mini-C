/* Codigo com todas as especificacoes requeridas pelo analisador sintatico*/

#include <stdio.h>

struct Pessoa { // Cria uma STRUCT para armazenar os dados de uma pessoa

    float Peso;
    int Idade;    
    float Altura;
};

void main(){

	int num1=1; //variavel numero
	float num2=2.0;
	double num3=2.35;
	char letra = 'x'; 

	/*Ciclo que incrementa
	o num1 a cada ciclo.*/

	while(num1 <= 5) {
		if(num1 == 2){
			printf("%d",num1);  //resultado esperado "2"
			num1++;  
		}
		else{
			num1++;
		}
	}

	int i;

	for(i=0;i<10;i++){
		printf("%d",i);	 //resultado esperado "1 2 3 4 5 6 7 8 9 10"
	}
}
