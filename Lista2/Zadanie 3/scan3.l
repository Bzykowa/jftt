%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
int yylex();
int yywrap();
bool doc = false;
%}
%%
"\"".*"\""  fprintf(yyout, yytext);
"<".*">" fprintf(yyout, yytext);
"///".*(\\\n.*)+ {if(doc) {fprintf(yyout, yytext);}}
"//!".*(\\\n.*)+ {if(doc) {fprintf(yyout, yytext);}}
"//".*(\\\n.*)+
"///".* {if(doc) {fprintf(yyout, yytext);}}
"//!".* {if(doc) {fprintf(yyout, yytext);}}
"//".*
"/"(\\\n.*)*
"/**"([^*]|\*+[^*/])*"*/"  {if(doc) {fprintf(yyout, yytext);}}
"/*!"([^*]|\*+[^*/])*"*/"  {if(doc) {fprintf(yyout, yytext);}}
"/*"([^*]|\*+[^*/])*"*/"
%%
int yywrap(){
  return 1;
}
int main(int argc, char **argv){
  yyin = fopen(argv[1], "r");
  yyout = fopen("results3", "w");
  if(argv[2]){
    doc = true;
  }
  yylex();
  fclose(yyout);
}
