%{
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <setjmp.h>
#include <math.h>
#include <errno.h>

static jmp_buf s_jumpBuffer;

#define TRY do{ s_jumpBuffer; if( !setjmp(s_jumpBuffer) ){
#define CATCH } else {
#define ETRY } }while(0)
#define THROW longjmp(s_jumpBuffer, 1)

struct StackNode {
    int data;
    struct StackNode* next;
};

struct StackNode* newNode(int data);
int isEmpty(struct StackNode* root);
void push(struct StackNode** root, int data);
int pop(struct StackNode** root);
struct StackNode* root = NULL;

int yylex();
int yywrap();

int result = 0;
int y = 0;
int x = 0;
int simp_pow(int x, int y);
int divide(int x, int y);
int modulo(int x, int y);
%}
%%
"-"[0-9]+ push(&root, atoi(yytext));
[0-9]+ push(&root, atoi(yytext));
"+" {y = pop(&root); x = pop(&root); push(&root, y+x);}
"-" {y = pop(&root); x = pop(&root); push(&root, x-y);}
"*" {y = pop(&root); x = pop(&root); push(&root, y*x);}
"^" {y = pop(&root); x = pop(&root); push(&root, simp_pow(x,y));}
"%" {y = pop(&root); x = pop(&root); push(&root, modulo(x,y));}
"/" {y = pop(&root); x = pop(&root); push(&root, divide(x,y));}
[^-0-9+*/\^% \t\n]+     {perror("Unknown symbol"); root = NULL; THROW;}
\n  {result = pop(&root); if(!isEmpty(root)){ perror("Too many arguments\n"); root = NULL; THROW;} else{ printf("%d\n", result); root = NULL;}}
" "
%%

struct StackNode* newNode(int data)
{
    struct StackNode* stackNode = (struct StackNode*)malloc(sizeof(struct StackNode));
    stackNode->data = data;
    stackNode->next = NULL;
    return stackNode;
}

int isEmpty(struct StackNode* root)
{
    return !root;
}

void push(struct StackNode** root, int data)
{
    struct StackNode* stackNode = newNode(data);
    stackNode->next = *root;
    *root = stackNode;
}

int pop(struct StackNode** root)
{
    if (isEmpty(*root)){
        perror("Not enough arguments\n");
        THROW;
    }
    struct StackNode* temp = *root;
    *root = (*root)->next;
    int popped = temp->data;
    free(temp);

    return popped;
}

int simp_pow(int x, int y){
    int res = 1;
    for(int i = 0; i<y; ++i){
        res*=x;
    }
    return res;
}

int divide(int x, int y){
    if(y == 0){
        perror("Division by zero");
        THROW;
    } else{
        return x/y;
    }
}

int modulo(int x, int y){
    if(y == 0){
        perror("Division by zero in modulo");
        THROW;
    } else{
        return x%y;
    }
}

int yywrap(){
  return 1;
}

int main(int argc, char **argv){
    while(1){
      TRY {
          yylex();
      }
      CATCH {
          root = NULL;
          fflush(stdin);
          yyrestart(stdin);
      }
      ETRY;
    }
}
