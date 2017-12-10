%{

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void yyerror(char *s);
int yylex();

extern FILE* yyin;

%}

%token <string> DECLARE
%token READ
%token WRITE
%token <string> VAR

%start prog

%defines
%union {
    int   number;
    char* string;
}

%%

prog: prog '{' decl instr '}'
    | /* empty */
    ;

decl: decl DECLARE VAR ';' { printf("%s\n", $3); }
    | /* empty */
    ;

instr: instr WRITE VAR ';'
    | instr READ VAR ';'
    | /* empty */
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv)
{
    ++argv, --argc;
    yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;
    yyparse();
    return 0;
}
