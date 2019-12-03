%{
  #include <math.h>
  #include <stdio.h>
  #include <stdbool.h>
  #include <stdlib.h>
  #include <string.h>
  int yylex (void);
  int yyerror (char const *);
  int divide (int a, int b){return floor((double) a / (double) b);}
  int modulo (int a, int b){return (a - divide(a,b) * b);}
  extern int yylineno;
  bool error = false;
  char onp[256];
  void print_err (char *err){printf("Error in line %d : %s\n", yylineno-1, err); error = true;}
%}


/* Bison declarations. */
%define api.value.type {int}
%token NUM RT_BR LT_BR
%left PLUS MINUS
%left MULT DIV MOD
%right POW
%precedence NEG
%token EOL ERROR

%% /* The grammar follows. */

input:
  %empty
  | input line
;


line:
  exp EOL  { if(!error) printf ("%s\n= %d \n",onp ,$1); error = false; memset(onp,0,strlen(onp));}
  | error EOL {printf("Syntax error in line %d \n", yylineno-1); error = false; memset(onp,0,strlen(onp));}
;

/*
exp:
  exp PLUS exp          { $$ = $1 + $3; strcat(onp,"+ "); }
  | exp MINUS exp       { $$ = $1 - $3; strcat(onp,"- "); }
  | exp MULT exp        { $$ = $1 * $3; strcat(onp,"* "); }
  | exp MOD exp         { if($3 == 0) {print_err("Can't modulo zero");} else {$$ = modulo($1,$3); strcat(onp,"mod ");} }
  | exp DIV exp         { if($3 == 0) {print_err("Can't divide by zero");} else {$$ = divide($1,$3); strcat(onp,"/ ");}}
  | exp POW exp         { $$ = (int) pow((double) $1,(double) $3); strcat(onp,"^ ");}
  | LT_BR exp RT_BR     { $$ = $2; }
  | MINUS NUM %prec NEG { $$ = -$2;  strcat(onp,"-"); char *s; sprintf(s, "%d", $2); strcat(onp,s); strcat(onp, " ");}
  | NUM                 { $$ = $1; char *s; sprintf(s, "%d", $1); strcat(onp,s); strcat(onp," ");}
;
*/

exp: exp PLUS term        { $$ = $1 + $3; strcat(onp,"+ "); }
    | exp MINUS term      { $$ = $1 - $3; strcat(onp,"- "); }
    | exp POW exp         { $$ = (int) pow((double) $1,(double) $3); strcat(onp,"^ ");}
    | term
;

term: term MULT factor       { $$ = $1 * $3; strcat(onp,"* "); }
    | term MOD factor        { if($3 == 0) {print_err("Can't modulo zero");} else {$$ = modulo($1,$3); strcat(onp,"mod ");} }
    | term DIV factor        { if($3 == 0) {print_err("Can't divide by zero");} else {$$ = divide($1,$3); strcat(onp,"/ ");}}
    | factor
;

factor:  NUM                { $$ = $1; char *s; sprintf(s, "%d", $1); strcat(onp,s); strcat(onp," ");}
        | MINUS NUM    { $$ = -$2;  strcat(onp,"-"); char *s; sprintf(s, "%d", $2); strcat(onp,s); strcat(onp, " ");}
        | MINUS LT_BR exp RT_BR   { $$ = -$3; strcat(onp,"~ ");}
        | LT_BR exp RT_BR   { $$ = $2; }
;

%%

int yyerror(char const *s){return 1;}

int main(){strcpy(onp,""); yyparse(); return 0;}
