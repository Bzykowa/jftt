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
[ \t]+  printf(" ");
[^ \t\n]+  {ECHO; ++word_count;}
[ \t]+$
\n  {printf("\n"); ++line_count;}
%%
int yywrap(){
  printf("Number of words: %d\n", word_count);
  printf("Number of lines: %d\n", line_count);
  return 1;
}
int main(int argc, char **argv){
  yyin = fopen(argv[1], "r");
  yylex();
}
