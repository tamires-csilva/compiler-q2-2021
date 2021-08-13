# Projeto de Compiladores


[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Projeto desenvolvido para disciplina de Compiladores - Bacharelado em Ciência da Computação - UFABC

### Participantes

- Alexandre Costa Magalhaes 
- Erick Funier dos Santos   11031914
- Paulo Ricardo Cunha       11080312
- Tamires C da Silva        11093813

## Especificações

- Linguagem de destino: C++
- Integrador e compilador g++ 
- Adobe Linguistic Library
- Not case sensitivy

## Variáveis e Operadores

Estrutura básica da linguagem, abaixo são descritos os tipos de váriaveis e operadores implementados:

| Tipos de Variáveis | Descrição |
| ------ | ------ |
| String | Conjunto de caracteres |
| Inteiro | Números inteiros |
| Real | Números incluindo decimais ou ponto flutuante |
| Caractere | Símbolos alfanúmericos (ASCII) |
| Lógico | Booleanos (verdadeiro/ false) |
| Nada | [nN][aA][dD][aA] |


#### Exemplo de implementação
Implementação da variável *nada* no dicionário léxico
```sh
{nada}     {yylval.valor = yytext; yylval.codigo = ""; return TK_VOID;}
```
Implementação na linguagem de destino
```sh
 TK_VOID    {$$.valor = "v"; $$.codigo= "void ";$$.tipo = 'v'; }
```

Operadores matemáticos, comparativos e lógicos:

| Tipo | Operadores |
| ------ | ------ |
| Lógicos | e, ou |
| Comparativos | >=, <=, ==, != |
| Matemáticos | +, -, *, /, mod |


## Estruturas lógicas e de repetição

Os conceitos da linguagem C como if...else, for e while foram implementados. Abaixo estão exemplos da utilização dessas estruturas:

Estrutura lógica condicional:
```sh
Se(a>=3)
entao a=0;
senao b=3;
fim_se;
```

Estrutura de repetição, nessa primeira estrutura temos semelhança com o while, então dado um parâmetro uma ação é executada :
```sh
enquanto(a<5)
faca a=a+1;
fim_enquanto;
```

```sh
para (de a=0, ate a == 5, passo a++)
...
fim_para;
```

Importante: o desenvolvimento de uma estrutura de repetição ou condicional, tem uma linha indicando o final do bloco (fim_enquanto, fim_se).

#### Teste

Para executar o compilador desenvolvido:

```sh
chmod +x makefile
```
