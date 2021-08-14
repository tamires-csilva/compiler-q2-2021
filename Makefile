all: compilador

lex.yy.c: gralex.lex
	lex gralex.lex

y.tab.c: gramatica.y
	yacc gramatica.y

compilador: lex.yy.c y.tab.c
	g++ -o compilador y.tab.c -lfl
clean:
	rm -f lex.yy.c
	rm -f compilador
	rm -f cc.tab.c
	rm -f cc.tab.h
	rm -f y.tab.c
	clear	
