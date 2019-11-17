%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yywrap();
%}
%%
"\"".*"\""  fprintf(yyout, yytext);
"["([^*]|\*+[^*/])*"]"  fprintf(yyout, yytext);
"<!--".*"--".*"-->" fprintf(yyout, yytext);
"<!--".*"-->"
%%
int yywrap(){
  return 1;
}
int main(int argc, char **argv){
  yyin = fopen(argv[1], "r");
  yyout = fopen("results2", "w");
  yylex();
  fclose(yyout);
}
