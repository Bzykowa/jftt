%{
#include <stdio.h>
#include <stdlib.h>
int yywrap();
int yylex();
int word_count=0;
int line_count=0;
%}
%%
^[ \t\n]+
[ \t]+  fprintf(yyout," ");
[^ \t\n]+  {fprintf(yyout,yytext); ++word_count;}
[ \t]+$
\n  {fprintf(yyout,"\n"); ++line_count;}
%%
int yywrap(){
  fprintf(yyout,"Number of words: %d\n", word_count);
  fprintf(yyout,"Number of lines: %d\n", line_count);
  return 1;
}
int main(int argc, char **argv){
  yyin = fopen(argv[1], "r");
  yyout = fopen("results1", "w");
  yylex();
  fclose(yyout);
}
