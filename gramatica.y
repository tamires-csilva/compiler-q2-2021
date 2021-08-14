%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

struct atributos
{
    string valor, codigo;
    char tipo;
};
string var_temps;
int n_var_temp = 0;
const struct atributos TK_VAZIO = { "","",'v' };
struct TS_VAR
{
    string id;
    char tipo;
};

struct TS_FUNC
{
    string id;
    int tipo_retorno; 
};

#define YYSTYPE struct atributos
#define TS_VAR_MAX      1000
#define TS_FUNC_MAX     1000
#define TS_VAR_MAX_TEMP 1000
#define MAX_OPERADORES  100

int yylex();
int yyparse();
char temPonto( struct atributos & );
char padraoImpressao( char );
void insereVar( string, int );
int buscaTipoVar( string id );
void insereVarTemp( string id, int tipo );
int buscaTipoVarTemp( string id );
int buscaVar( string );
void insereFunc( string, int );
int buscaFunc( string id );
string geraTemp( int tipo );
string geraLabel( string );
void geraCodigo(atributos & SS,atributos S1, atributos S3 , int operador , string oprstr);
char tipoResultado (int operador, char OP1, char OP2 );
int strToInt (string s);
char *intToStr (int x);
char *charToStr (char x);
string charToString (char x);
char *tiraAspas( string );
void yyerror( const char* st );

%}

%token TK_INT TK_REAL TK_CHAR TK_BOOL TK_STRING TK_TRUE TK_FALSE TK_BEGIN TK_VOID TK_CAR
%token TK_STEP TK_FROM TK_ELSE TK_MAIN TK_ENDFOR TK_ENDIF TK_ENDWHILE
%token TK_END TK_IF TK_THEN TK_WHILE TK_DO
%token TK_UNTIL TK_FOR TK_FUNC 
%token TK_ID TK_NUM TK_STR 
%nonassoc TK_AND TK_OR '!'
%right '='
%nonassoc TK_MOEQ TK_LEEQ TK_EQ TK_DIF '>' '<'
%left '+' '-'
%left '*' '/' TK_MOD

%start S

%% 
			  
S             : SVAR  { cout <<var_temps <<$1.codigo; }
              ;

SVAR          : V ';' SVAR   { $$.valor = ""; $$.codigo = $1.codigo + ";\n" + $3.codigo; }
              | ESTRUTURA    { $$.valor = ""; $$.codigo= $1.codigo; }
    	      ;
    	      
TIPO          : TK_INT     { $$.valor = "i"; $$.codigo= "int ";$$.tipo = 'i'; }
              | TK_REAL    { $$.valor = "r"; $$.codigo= "float ";$$.tipo = 'r'; }
              | TK_CHAR    { $$.valor = "c"; $$.codigo= "char ";$$.tipo = 'c'; }
              | TK_BOOL    { $$.valor = "b"; $$.codigo= "int ";$$.tipo = 'b'; }
              | TK_STRING  { $$.valor = "s"; $$.codigo= "char ";$$.tipo = 's'; }
	          | TK_VOID    {$$.valor = "v"; $$.codigo= "void ";$$.tipo = 'v'; }
              ;


V             : V ',' TK_ID { insereVar( $3.valor, $1.tipo );$$.valor = ""; 
                              if( $1.tipo == 's' )
                                  $$.codigo= $1.codigo + "," + $3.valor + "[256]";
                              else
                                  $$.codigo= $1.codigo + "," + $3.valor; 
                              $$.tipo = $1.tipo; }
	      	  | V ',' TK_ID '[' TK_NUM ']'{ insereVar( $3.valor, $1.tipo );
	                                    $$.valor = ""; 
                        		    if( $1.tipo == 's' )
                                		$$.codigo= $1.codigo + "," + $3.valor + "[" + $5.valor + "]"+ "[256]";
                        		    else
                                		$$.codigo= $1.codigo + "," + $3.valor+ "[" + $5.valor + "]"; 
                        		    $$.tipo = $1.tipo; }
              | TIPO TK_ID  { insereVar( $2.valor, $1.tipo );$$.valor = "";
                              if( $1.tipo == 's' )
                                  $$.codigo= $1.codigo + $2.valor + "[256]";
                              else
                                  $$.codigo= $1.codigo + $2.valor; 
		              $$.tipo = $1.tipo; }
              | TIPO TK_ID  '[' TK_NUM ']'{ insereVar( $2.valor, $1.tipo );$$.valor = "";
                                            if( $1.tipo == 's' )
                                                $$.codigo= $1.codigo + $2.valor + '[' + $4.valor + ']' + "[256]";
                                            else
                                                $$.codigo= $1.codigo + $2.valor  + '[' + $4.valor + ']'; 
		                            $$.tipo = $1.tipo; }
	      	  ;			  



V_LOC         : V_LOC ',' TK_ID { insereVarTemp( $3.valor, $1.tipo );$$.valor = ""; 
                                  if( $1.tipo == 's' )
                                      $$.codigo= $1.codigo + "," + $3.valor + "[256]";
                                  else
                                      $$.codigo= $1.codigo + "," + $3.valor; 
                                  $$.tipo = $1.tipo; }
	     	  | V_LOC ',' TK_ID '[' TK_NUM ']'{ insereVarTemp( $3.valor, $1.tipo );
	                                    $$.valor = ""; 
                        		    if( $1.tipo == 's' )
                                		$$.codigo= $1.codigo + "," + $3.valor + "[" + $5.valor + "]"+ "[256]";
                        		    else
                                		$$.codigo= $1.codigo + "," + $3.valor+ "[" + $5.valor + "]"; 
                        		    $$.tipo = $1.tipo; }
              | TIPO TK_ID  { insereVarTemp( $2.valor, $1.tipo );$$.valor = ""; 
                              if( $1.tipo == 's' )
                                  $$.codigo= $1.codigo + $2.valor + "[256]";
                              else
                                  $$.codigo= $1.codigo + $2.valor; 
		              $$.tipo = $1.tipo; }
              | TIPO TK_ID  '[' TK_NUM ']'{ insereVarTemp( $2.valor, $1.tipo );$$.valor = "";
                                            if( $1.tipo == 's' )
                                                $$.codigo= $1.codigo + $2.valor + '[' + $4.valor + ']' + "[256]";
                                            else
                                                $$.codigo= $1.codigo + $2.valor  + '[' + $4.valor + ']'; 
		                            $$.tipo = $1.tipo; }
	          ;
SVAR_LOC      : V_LOC ';' SVAR_LOC       { $$.valor = ""; $$.codigo = $1.codigo + ";\n" + $3.codigo; }
              |                          { $$.valor = ""; $$.codigo = ""; }
    	      ;


ESTRUTURA     : FUNCAO PRINCIPAL FUNCAOFINAL2 { $$.valor = ""; $$.codigo= $1.codigo + $2.codigo + "\n" + $3.codigo; }
              ;

CABEC         : TIPO TK_ID '(' ARGUMENTOS ')' { $$.valor = ""; $$.codigo= $1.codigo + $2.valor + "(" +
                                                $4.codigo + ")\n"; insereFunc( $2.valor, $1.tipo ); }
              ;

CABEC_N_INS   : TIPO TK_ID '(' ARGUMENTOS ')' { if( $$.tipo == buscaFunc( $2.valor ) )
                                                {    
                                                    $$.valor = ""; $$.codigo= $1.codigo + $2.valor + "(" + $4.codigo + ")\n";
						}
					      }
              ;

ARGUMENTOS    : ARG_FINAL ',' ARGUMENTOS {$$.valor = ""; $$.codigo = $1.codigo + ", " + $3.codigo; }
              | ARG_FINAL                {$$.valor = ""; $$.codigo = $1.codigo; }
	          ;

ARG_FINAL     : TIPO TK_ID { $$.valor = $1.valor ; $$.codigo= $1.codigo + $2.valor;
                             insereVarTemp( $2.valor, $1.tipo ); }
	          ;

FUNCAO        : TK_FUNC CABEC';' FUNCAO {$$.valor = ""; $$.codigo= $2.codigo + ";" + $4.codigo; }
	          | FUNCAOFINAL             {$$.valor = ""; $$.codigo= $1.codigo; }
	          ;

FUNCAOFINAL   : TK_FUNC CABEC CORPO FUNCAOFINAL  { n_var_temp = 0;$$.valor = ""; $$.codigo= $2.codigo + $3.codigo + "\n" + $4.codigo; }
              | 		        {$$.valor = ""; $$.codigo = ""; }
    	      ;
	        
FUNCAOFINAL2  : TK_FUNC CABEC_N_INS CORPO FUNCAOFINAL2  { n_var_temp= 0;$$.valor = ""; $$.codigo= $2.codigo + "\n" + $3.codigo + "\n" + $4.codigo; }
              | 		        
    	      ; 		        

CORPO         : TK_BEGIN SVAR_LOC CMDS TK_END { $$.valor = ""; $$.codigo = "{\n" + $2.codigo + $3.codigo + "}\n"; }
              ;
              
BLOCO         : CORPO      { $$.valor = ""; $$.codigo = $1.codigo; }
              | CMD ';'    {$$.valor = ""; $$.codigo = $1.codigo; }
              ;

PRINCIPAL     : TK_MAIN '(' ')' CORPO { $$.valor = ""; $$.codigo = "void main()\n" + $4.codigo; }
              ;

CMDS          : CMD ';' CMDS { $$.valor = ""; $$.codigo = $1.codigo + $3.codigo;  }
              |              { $$.valor = ""; $$.codigo = ""; }
	          ;
              
CMD           : CMD_WHILE                 { $$.valor = $1.valor; $$.codigo = $1.codigo;  }							     
              | CMD_IF                    { $$.valor = $1.valor; $$.codigo = $1.codigo;  }	      	  							     
	          | CMD_FOR                   { $$.valor = $1.valor; $$.codigo = $1.codigo;  }	          | 							     
	          | TK_FUNC CMD_FUNC          { $$.valor = $2.valor; $$.codigo = $2.codigo;  }							     
	          | TK_FUNC TK_ID '=' CMD_FUNC{ $2.tipo = buscaVar( $2.valor ); 
	                                    $$.codigo =  $2.valor + "=" + $4.codigo; }

              | E                         { $$.valor = $1.valor; $$.codigo = $1.codigo; $$.codigo;  }						     
              ;

CMD_FUNC      : TK_ID '(' PARAMS ')'    { $$.tipo = buscaFunc( $1.valor ); $$.valor = ""; $$.codigo = $3.codigo +
                                          $1.valor + "(" + $3.valor + ");\n";}
              ;

CMD_WHILE     : TK_WHILE '(' E ')' TK_DO CMDS TK_ENDWHILE { if( $3.tipo != 'b' )
                                                             {
							         cout<<"Expressao invalida no comando \"ENQUANTO\""<<endl;
								 exit(0);
							     }
                                                	     string m_label = geraLabel( "marca" ), m_fim = geraLabel( "fim" ), 
			        			     temp = geraTemp( 'b' );$$.valor="";
			        			     $$.codigo = $3.codigo +  m_label +":\n" + temp + "=!" + $3.valor + ";\nif(" + temp +")goto "
							     + m_fim + ";\n" + $6.codigo + "goto " + m_label + ";\n" + m_fim + ":\n"; }
              ;
	      
CMD_IF        : TK_IF '(' E ')' TK_THEN CMDS TK_ENDIF{ if( $3.tipo != 'b' )
							   {
							       cout<<"Expressao invalida no comando \"SE\""<<endl;
							       exit(0);
							   }
					        	   string m_fim = geraLabel( "fim" ), temp = geraTemp( 'b' );
                                                	   $$.codigo = $3.codigo + temp + "=!" + $3.valor + ";\nif(" +
							   temp + ") goto "+ m_fim + ";\n" + $6.codigo + m_fim + ":\n"; }
						   
              | TK_IF '(' E ')' TK_THEN BLOCO TK_ELSE BLOCO TK_ENDIF { if( $3.tipo != 'b' )
									  {
									      cout<<"Expressao invalida no comando \"SE\""<<endl;
									      exit(0);
									  }
       		          			    string m_label = geraLabel( "marca" ), m_fim = geraLabel( "fim" ), 
			        		    temp = geraTemp( 'b' );$$.valor="";
			        		    $$.codigo = $3.codigo + temp + "=!" + $3.valor + ";\nif(" + temp + ")goto "
						    +  m_label +";\n"+ $6.codigo + "goto " +m_fim +
						    ";\n" + m_label + ":\n" + $8.codigo + m_fim + ":\n"; }
              ;


CMD_FOR       : TK_FOR TK_ID TK_FROM E TK_UNTIL E TK_STEP E TK_DO CMDS TK_ENDFOR
                              { string m_label = geraLabel( "marca" ), m_fim = geraLabel( "fim" ), 
			        temp = geraTemp( 'b' );$$.valor="";
			        $$.codigo += $4.codigo + $6.codigo + $8.codigo + $2.valor + "=" + $4.valor + ";\n"
				+ m_label + ":\n" + temp + "=" + $2.valor + ">" + $6.valor + ";\nif(" +
				temp + ") goto " + m_fim + ";\n"+ $10.codigo + $2.valor + "=" + $2.valor + "+"
				+ $8.valor + ";\ngoto " + m_label + ";\n" + m_fim + ":\n"; }
              ;              

PARAMS        : E ',' PARAMS { $$.valor = $1.valor + "," + $3.valor; $$.codigo = $1.codigo + $3.codigo;  }
	      	  | E            { $$.valor = $1.valor; $$.codigo = $1.codigo;  }
              ;
           
E             : F '=' E     { geraCodigo( $$, $1, $3, '=', "=" );  }
              | F '+' E     { geraCodigo( $$, $1, $3, '+', "+" );  }
              | F '-' E     { geraCodigo( $$, $1, $3, '-', "-" );  }
              | F '*' E     { geraCodigo( $$, $1, $3, '*', "*" );  }
              | F '/' E     { geraCodigo( $$, $1, $3, '/', "/" );  }
              | F TK_MOD E     { geraCodigo( $$, $1, $3, TK_MOD, "%" );  }
              | '(' E ')'   {$$.tipo = $2.tipo;$$.valor = $2.valor; $$.codigo = $2.codigo;  }
              | E TK_MOEQ E { geraCodigo( $$, $1, $3, TK_MOEQ , ">=" );  }
              | E TK_LEEQ E { geraCodigo( $$, $1, $3, TK_LEEQ, "<=" );  }     
              | E TK_DIF E  { geraCodigo( $$, $1, $3, TK_DIF, "!=" );  }
              | E TK_OR E   {geraCodigo( $$, $1, $3, TK_OR, " || " );  }
              | E TK_AND E  {geraCodigo( $$,$1, $3, TK_AND, " && " );  }
              | '!' E       {geraCodigo( $$, $2, TK_VAZIO, '!', "!" );  }
              | E '<' E     { geraCodigo( $$, $1, $3, '<', "<" );  }
              | E '>' E     { geraCodigo( $$, $1, $3, '>', ">" );  }
              | E TK_EQ E {geraCodigo( $$, $1, $3, TK_EQ, "==" );  }
	          | F           {$$.codigo = $1.codigo; $$.tipo = $1.tipo; }
              | TK_ID '[' E ']' '=' E {$$.tipo = $6.tipo; 
	                              $$.valor = ""; $$.codigo = $3.codigo + $6.codigo +
				      $1.valor + "[" + $3.valor + "]=" + $6.valor +";\n";  }
	          ;

F             : TK_NUM        {$$.valor = $1.valor; $$.codigo = ""; $$.tipo = temPonto( $1 ); }
              | TK_TRUE       { $$.valor = "1"; $$.codigo = ""; $$.tipo = 'b'; }
              | TK_FALSE      { $$.valor = "0"; $$.codigo = ""; $$.tipo = 'b'; }
              | TK_ID         {$$.valor = $1.valor; $$.codigo = ""; $$.tipo = buscaVar( $1.valor ); }
              | TK_STR        {$$.valor = $1.valor; $$.codigo = ""; $$.tipo = 's'; }
	      	  | TK_CAR        {$$.valor = $1.valor; $$.codigo = ""; $$.tipo = 'c'; }
		      | TK_ID'['E']'  {$$.tipo = buscaVar( $1.valor ); $$.valor = geraTemp( $$.tipo );
	                          $$.codigo = $3.codigo + $$.valor + "=" + $1.valor + '[' + $3.valor + "];\n";  }
              ;

%% 
#include "lex.yy.c"


int main (int argc, char * argv[])
{
   yyparse();
}

struct Operacao
{
    int operador;
    char op1,op2,resultado;
} operacoes[MAX_OPERADORES] =  
{     {TK_AND, 'b', 'b', 'b'},  		 
	  {TK_OR , 'b', 'b', 'b'},  		 
	  {'+', 'i', 'i', 'i'}, 			 
	  {'+', 'i', 'r', 'r'}, 			 
	  {'+', 'r', 'i', 'r'}, 			 
	  {'+', 'r', 'r', 'r'}, 			 
	  {'+', 'c', 'c', 's'}, 			 
	  {'+', 's', 'c', 's'}, 			 
	  {'+', 'c', 's', 's'}, 			 
	  {'+', 's', 's', 's'}, 			 
	  {'-', 'i', 'i', 'i'}, 			 
	  {'-', 'i', 'r', 'r'}, 			 
	  {'-', 'r', 'i', 'r'}, 			 
	  {'-', 'r', 'r', 'r'}, 			 
	  {'*', 'i', 'i', 'i'}, 			 
	  {'*', 'i', 'r', 'r'}, 			 
	  {'*', 'r', 'i', 'r'}, 			 
	  {'*', 'r', 'r', 'r'}, 			 
	  {'/', 'i', 'i', 'i'}, 			 
	  {'/', 'i', 'r', 'r'}, 			 
	  {'/', 'r', 'i', 'r'}, 			 
	  {'/', 'r', 'r', 'r'}, 			 
	  {TK_MOD, 'i', 'i', 'i'},  		 
	  {TK_MOD, 'r', 'i', 'r'},  		 
	  {'>', 'i', 'i', 'b'}, 			 
	  {'>', 'i', 'r', 'b'}, 			 
	  {'>', 'r', 'i', 'b'}, 			 
	  {'>', 'r', 'r', 'b'}, 			 
	  {'>', 'c', 'c', 'b'}, 			 
	  {'>', 's', 's', 'b'}, 			 
	  {TK_MOEQ, 'i', 'i', 'b'}, 		 
	  {TK_MOEQ, 'i', 'r', 'b'}, 		 
	  {TK_MOEQ, 'r', 'i', 'b'}, 		 
	  {TK_MOEQ, 'r', 'r', 'b'}, 		 
	  {TK_MOEQ, 'c', 'c', 'b'}, 		 
	  {TK_MOEQ, 's', 's', 'b'}, 		 
	  {'<', 'i', 'i', 'b'}, 			 
	  {'<', 'i', 'r', 'b'}, 			 
	  {'<', 'r', 'i', 'b'}, 			 
	  {'<', 'r', 'r', 'b'}, 			 
	  {'<', 'c', 'c', 'b'}, 			 
	  {'<', 's', 's', 'b'}, 			 
	  {TK_LEEQ, 'i', 'i', 'b'}, 		 
	  {TK_LEEQ, 'i', 'r', 'b'}, 		 
	  {TK_LEEQ, 'r', 'i', 'b'}, 		 
	  {TK_LEEQ, 'r', 'r', 'b'}, 		 
	  {TK_LEEQ, 'c', 'c', 'b'}, 		 
	  {TK_LEEQ, 's', 's', 'b'}, 		 
          {'!','b','v','b'}, 			 
	  {TK_DIF, 'i', 'i', 'b'},  		 
	  {TK_DIF, 'i', 'r', 'b'},  		 
	  {TK_DIF, 'r', 'i', 'b'},  		 
	  {TK_DIF, 'r', 'r', 'b'},  		 
	  {TK_DIF, 'c', 'c', 'b'},  		 
	  {TK_DIF, 's', 's', 'b'},  		 
	  {TK_DIF, 'b', 'b', 'b'},  		 
	  {'=', 'i', 'i', 'i'}, 			 
	  {'=', 'i', 'r', 'i'}, 			 
	  {'=', 'r', 'i', 'r'}, 			 
	  {'=', 'r', 'r', 'r'}, 			 
	  {'=', 'c', 'c', 'c'}, 			 
	  {'=', 's', 's', 's'}, 			 
	  {'=', 'b', 'b', 'b'}, 			 
	  {TK_EQ, 'i', 'i', 'b'}, 			 
	  {TK_EQ, 'i', 'r', 'b'}, 			 
	  {TK_EQ, 'r', 'i', 'b'}, 			 
	  {TK_EQ, 'r', 'r', 'b'}, 			 
	  {TK_EQ, 'c', 'c', 'b'}, 			 
	  {TK_EQ, 's', 's', 'b'}, 			 
	  {TK_EQ, 'b', 'b', 'b'},  		 
};

int n_label = 0, n_temp = 0;

struct TS_VAR tabela_var[TS_VAR_MAX];
int n_var = 0;

struct TS_VAR tabela_var_temp[TS_VAR_MAX_TEMP];



struct TS_FUNC tabela_func[TS_FUNC_MAX];
int n_func = 0;



char temPonto( struct atributos &S_NUM )
{
    char retval;
	if( strchr( S_NUM.valor.data(), '.' ) == NULL )
    {
        retval = 'i';
    	S_NUM.tipo = 'i';
    } 
	else
    {
        retval = 'r';
    	S_NUM.tipo = 'r';
    } 
    return retval;
}

char padraoImpressao( char c )
{
    switch( c )
	{
	    case 'i':
		    return 'd'; break;
	    case 'r':
		    return 'f'; break;
	    case 'c':
		    return 'c'; break;
	    case 'b':
		    fprintf( stderr, "Valor invalido, nao ´e possivel ler valor booleano\n" );
			exit( 0 );
			break;
	    case 's':
		    return 's'; break;
	}
}

void insereVar( string id, int tipo )
{
    int i = 0;
    for( i = 0; i < n_var; i++ )
    {
        if( id == tabela_var[i].id )
		{
	    	cout << "Variavel previamente declarada" << endl;
	    	exit( 0 );
		}
    }
    if( n_var >= TS_VAR_MAX )
    {
        cout << "Numero de variáveis no limite" << endl;
		exit( 1 );
    }
    tabela_var[i].id   = id;
    tabela_var[i].tipo = tipo;
    n_var++;
}

int buscaTipoVar( string id )
{
    int i;
    for( i = 0; i < n_var; i++ )
        if( id == tabela_var[i].id )
	        return tabela_var[i].tipo;
    cout << "Variavel " << id <<" inexistente" << endl;
    exit( 1 );
}

void insereVarTemp( string id, int tipo )
{
    int i = 0;
    for( i = 0; i < n_var_temp; i++ )
    {
        if( id == tabela_var_temp[i].id )
		{
	    	cout << "Variavel local " + id + " previamente declarada" << endl;
	    	exit( 0 );
		}
    }
    if( n_var_temp >= TS_VAR_MAX_TEMP )
    {
        cout << "Numero de variaveis no limite" << endl;
		exit( 1 );
    }
    tabela_var_temp[i].id   = id;
    tabela_var_temp[i].tipo = tipo;
    n_var_temp++;
}

int buscaTipoVarTemp( string id )
{
    int i;
    for( i = 0; i < n_var_temp; i++ )
        if( id == tabela_var_temp[i].id )
	        return tabela_var_temp[i].tipo;

    return 0;    
}

int buscaVar( string str )
{
    int retval;
    if( ( retval = buscaTipoVarTemp( str ) ) == 0 )
	    retval = buscaTipoVar( str );
	return retval;
}

void insereFunc( string id, int tipo )
{
    int i = 0;
    for( i = 0; i < n_func; i++ )
    {
        if( id == tabela_func[i].id )
	    {
	    	cout << "Funcao previamente declarada" << endl;
	    	exit( 0 );
	    }
    }
    if( n_func >= TS_FUNC_MAX )
    {
        cout << "Numero de funcoes no limite" << endl;
	    exit( 1 );
    }
    tabela_func[i].id   = id;
    tabela_func[i].tipo_retorno = tipo;
    n_func++;
    
}

int buscaFunc( string id )
{
    char **sep_params;
    int i, j = 0;
    for( i = 0; i < n_func; i++ )
        if( id == tabela_func[i].id )
        return tabela_func[i].tipo_retorno;
        fprintf( stderr, "Funcao %s nao foi declarada ou prototipada\n", id.data() );
        exit( 1 );

}

string geraTemp( int tipo )
{
    char buf[100];
    char temp[105];
    sprintf(buf, "T%d", n_temp++ );
    switch( tipo )
    {
        case 'i':
            sprintf(temp, "int %s;\n", buf );
	    break;
        case 'r':
            sprintf(temp, "float %s;\n", buf );
	    break;
        case 'b':
            sprintf(temp, "int %s;\n", buf );
	    break;
        case 'c':
            sprintf(temp, "char %s;\n", buf );
	    break;
        case 's':
            sprintf(temp, "char %s[256];\n", buf );
	    break;
	default:
	    fprintf( stderr, "Tipo não reconhecido ao gerar variavel temporaria!\n" );
	    exit( 0 );
	    break;
    }
    var_temps += temp;
    return buf;
}

string geraLabel( string a )
{
    char buf[200];
    sprintf(buf, "%s%d", a.data(), n_label++ );
    return buf;
}

void geraCodigo(atributos &SS,atributos S1, atributos S3 , int operador , string oprstr)
{
     SS.tipo = tipoResultado ( operador,S1.tipo,S3.tipo );     
     
     SS.valor= geraTemp(SS.tipo);
	if( S1.tipo == 'c' && S3.tipo == 'c' )
	{
	     if( operador == '+' )
	     {
		     string temp = geraTemp( 's' ), temp2 = geraTemp( 's' );
		     SS.codigo += temp + "= charToStr(" + S1.valor +  " );\n" + temp2 + "= charToStr(" + S3.valor +  " );\nstrncpy("
			           + SS.valor + "," + temp + ", 256 );\n" + "strncat(" + SS.valor + "," +  temp2
					   + " , 256 );\n $$.valor[strlen( $$.valor )] = '\0';\n ";
	     }
		 else
             SS.codigo += SS.valor + "=" + S1.valor + oprstr + S3.valor + ";\n";
	}
	else if( S1.tipo == 'c' && S3.tipo == 's' )
	{
	         string temp = geraTemp( 's' );
		 SS.codigo += temp + "= charToStr(" + S1.valor +  " );\n";
	     if( operador == '+' )
		 {
		     SS.codigo += "strncpy(" + SS.valor + "," + temp + ",256);\n" + 
			 				"strncat(" + SS.valor + "," + S3.valor + ",256);\n";
	     }
	     else
	     {
	          SS.codigo += SS.valor + "= strcmp ( " + temp + "," + S3.valor + ");\n";
		      switch ( operador )
		      {
			     case '=':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 0;\n";
					break;
			     case TK_DIF:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 0;\n";
					break;
			     case '<':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== -1;\n";
					break;
			     case '>':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 1;\n";
					break;
			     case TK_MOEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= -1;\n";
					break;
			     case TK_LEEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 1;\n";
					break;
			  }
	     }				
	}
	else if( S1.tipo == 's' && S3.tipo == 'c' )
	{
	         string temp = geraTemp( 's' );
		 SS.codigo += temp + "= charToStr(" + S3.valor +  " );\n";
	     if( operador == '+' )
		 {
		     SS.codigo += "strncpy(" + SS.valor + "," + S1.valor + ",256);\n" + 
			 				"strncat(" + SS.valor + "," + temp + ",256);\n";
	     }
	     else
	     {
	          SS.codigo += SS.valor + "= strcmp ( " + S1.valor + "," + temp + ");\n";
		      switch ( operador )
		      {
			     case '=':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 0;\n";
					break;
			     case TK_DIF:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 0;\n";
					break;
			     case '<':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== -1;\n";
					break;
			     case '>':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 1;\n";
					break;
			     case TK_MOEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= -1;\n";
					break;
			     case TK_LEEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 1;\n";
					break;
			  }
	     }				
	}
	else if( S1.tipo == 's' && S3.tipo == 's' )
	{
	     if( operador == '+' )
		 {
		     SS.codigo += "strncpy(" + SS.valor + "," + S1.valor + ",256);\n" + 
			 				"strncat(" + SS.valor + "," + S3.valor + ",256);\n";
	     }
	     else
	     {
	          SS.codigo += SS.valor + "= strcmp ( " + S1.valor + "," + S3.valor + ");\n";
		      switch ( operador )
		      {
			     case '=':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 0;\n";
					break;
			     case TK_DIF:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 0;\n";
					break;
			     case '<':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== -1;\n";
					break;
			     case '>':
				    SS.codigo+= SS.valor + " = " + SS.valor + "== 1;\n";
					break;
			     case TK_MOEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= -1;\n";
					break;
			     case TK_LEEQ:
				    SS.codigo+= SS.valor + " = " + SS.valor + "!= 1;\n";
					break;
			  }
	     }				
	}
        else if( oprstr != "!" )
	{
	     if( operador == '=' )
	         SS.codigo = S3.codigo+ S1.codigo + S1.valor + "=" + S3.valor + ";\n";
	     else
	     {
                 SS.codigo = S1.codigo+ S3.codigo + SS.valor + "=" + S1.valor + oprstr + S3.valor + ";\n";		 
	     }
        }
        else
             SS.codigo += SS.valor + "= !" + S1.valor + ";\n";
}

char tipoResultado (int operador, char OP1, char OP2 )
{
    int i;
    for (i=0;i<MAX_OPERADORES;i++)
        if (operacoes[i].operador == operador &&
             operacoes[i].op1 == OP1 &&
             operacoes[i].op2 == OP2)
             return operacoes[i].resultado;
    cout<<"Operacao entre tipos"<< OP1 <<" e "<< OP2<<"nao permitida" <<(char)operador<<endl; ;

}

void yyerror( const char* st )
{
  fprintf( stderr, "%s - %d", st, yychar );
}

int strToInt (string s)
{
  int result = 0;
  sscanf(s.c_str(), "%d", &result);
  return result;
}

char *intToStr (int x)
{
	char *result = (char *) malloc( 256 * sizeof(char) );
	snprintf( result, 256, "%d", x );
	return result;
}

char *charToStr (char x)
{
	char *result = (char *) malloc( 256 * sizeof(char) );
	snprintf( result, 256, "%c", x );
	return result;
}

string charToString (char x)
{
    string a = charToStr( x );
	return a;
}

char *tiraAspas( string entrada )
{
    int i;
    char *retval = ( char * ) malloc( sizeof( char ) * strlen( entrada.data() ) );
	for( i = 0; i < strlen( entrada.data() ) - 2; i++ )
	    retval[i] = entrada[i+1];
		retval[strlen( retval )] = '\0';
	return retval;
}

