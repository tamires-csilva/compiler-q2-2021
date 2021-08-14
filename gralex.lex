%{
%}
letra        [a-zA-Z]
digito       [0-9]

id           (_|{letra})("_"|{letra}|{digito})*
num          {digito}+(\.{digito}+)?

principal    [pP][rR][iI][nN][cC][iI][pP][aA][lL]
inteiro      [Ii][Nn][Tt][Ee][Ii][Rr][Oo]
real         [Rr][Ee][Aa][Ll]
caractere    [Cc][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ee]
logico       [Ll][Oo][Gg][Ii][Cc][Oo]
string       [sS][tT][rR][iI][nN][gG]
nada         [nN][aA][dD][aA]
verdadeiro   [Vv][Ee][Rr][Dd][Aa][Dd][Ee][Ii][Rr][Oo]
falso        [Ff][Aa][Ll][Ss][Oo]

comeco [Cc][Oo][Mm][Ee][Cc][Oo]
final    [fF][iI][nN][Aa][Ll]

se           [Ss][Ee]
entao        [Ee][Nn][Tt][Aa][Oo]
senao        [Ss][Ee][Nn][Aa][Oo]
fim_se       [Ff][Ii][Mm][_][Ss][Ee]

enquanto     [Ee][Nn][Qq][Uu][Aa][Nn][Tt][Oo]
faca         [Ff][Aa][Cc][Aa]
fim_enquanto [Ff][Ii][Mm]_[Ee][Nn][Qq][Uu][Aa][Nn][Tt][Oo]




para         [Pp][Aa][Rr][Aa]
de           [Dd][Ee]
passo        [Pp][Aa][Ss][Ss][Oo]
ate          [Aa][Tt][Ee]
fim_para     [Ff][Ii][Mm][_][Pp][Aa][Rr][Aa]

abandone     [Aa][Bb][Aa][Nn][Dd][Oo][Nn][Ee]

tipo         [Tt][Ii][Pp][Oo]

vetor        [Vv][eE][Tt][oO][Rr]

e            [eE]
ou           [oO][uU]
mod          [mM][oO][dD]


funcao       [Ff][Uu][Nn][Cc][Aa][Oo]
fim_funcao   [fF][iI][mM]_{id}

espaco [" "|\t|\n]

car          '{letra}'
str          (\"[^"]*\")
%%
{espaco}    {}
{principal} { yylval.valor = yytext; yylval.codigo = ""; return TK_MAIN;}
{inteiro}      {yylval.valor = yytext; yylval.codigo = ""; return TK_INT;}

{real}         {yylval.valor = yytext; yylval.codigo = ""; return TK_REAL;}

{caractere}    {yylval.valor = yytext; yylval.codigo = ""; return TK_CHAR;}

{logico}       {yylval.valor = yytext; yylval.codigo = ""; return TK_BOOL;}

{string}       {yylval.valor = yytext; yylval.codigo = ""; return TK_STRING;}

{nada}          {yylval.valor = yytext; yylval.codigo = ""; return TK_VOID;}

{verdadeiro}   {yylval.valor = yytext; yylval.codigo = ""; return TK_TRUE;}

{falso}        {yylval.valor = yytext; yylval.codigo = ""; return TK_FALSE;}

{comeco} {yylval.valor = yytext; yylval.codigo = ""; return TK_BEGIN; }
{final} {yylval.valor = yytext; yylval.codigo = ""; return TK_END;}

{se}           {yylval.valor = yytext; yylval.codigo = ""; return TK_IF;}
{entao}        {yylval.valor = yytext; yylval.codigo = ""; return TK_THEN;}
{senao}        {yylval.valor = yytext; yylval.codigo = ""; return TK_ELSE;}

{enquanto}     {yylval.valor = yytext; yylval.codigo = ""; return TK_WHILE;}
{faca}         {yylval.valor = yytext; yylval.codigo = ""; return TK_DO;}


{para}         {yylval.valor = yytext; yylval.codigo = ""; return TK_FOR;}
{de}           {yylval.valor = yytext; yylval.codigo = ""; return TK_FROM;}
{ate}          {yylval.valor = yytext; yylval.codigo = ""; return TK_UNTIL;}
{passo}        {yylval.valor = yytext; yylval.codigo = ""; return TK_STEP;}

{fim_para}     {yylval.valor = yytext; yylval.codigo = ""; return TK_ENDFOR;}
{fim_se}       {yylval.valor = yytext; yylval.codigo = ""; return TK_ENDIF;}
{fim_enquanto} {yylval.valor = yytext; yylval.codigo = ""; return TK_ENDWHILE;}

{funcao}       {yylval.valor = yytext; yylval.codigo = ""; return TK_FUNC;}

{e}            {yylval.valor = yytext; yylval.codigo = ""; return TK_AND;}      
{ou}           {yylval.valor = yytext; yylval.codigo = ""; return TK_OR;}       
">="           {yylval.valor = yytext; yylval.codigo = ""; return TK_MOEQ;}     
"<="           {yylval.valor = yytext; yylval.codigo = ""; return TK_LEEQ;}     
"=="           {yylval.valor = yytext; yylval.codigo = ""; return TK_EQ;}     
"!="           {yylval.valor = yytext; yylval.codigo = ""; return TK_DIF;}      

{mod}          {yylval.valor = yytext; yylval.codigo = ""; return TK_MOD;}

{car}          {yylval.valor = yytext; yylval.codigo = ""; return TK_CAR;}

{str}          {yylval.valor = yytext; yylval.codigo = ""; return TK_STR;}

{id}           {yylval.valor = yytext; yylval.codigo = ""; return TK_ID;}       

{num}          {yylval.valor = yytext; yylval.codigo = ""; return TK_NUM;}

.              {yylval.valor = yytext; yylval.codigo = ""; return *yytext;}
%%
