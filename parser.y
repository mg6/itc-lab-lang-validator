%{

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

void yyerror(const char *s);
int yylex();
extern int yylineno;
extern FILE* yyin;

bool vars['z' - 'a'];

void declare_var(const char *s);
void assert_var_exists(const char *s);

%}

%token <string> DECLARE
%token READ
%token WRITE
%token <string> VAR

%start prog

%defines
%define parse.error verbose
%union {
    int   number;
    char* string;
}

%%

prog: prog '{' decl instr '}'
    | /* empty */
    ;

decl: decl DECLARE VAR ';'  { declare_var($3); }
    | /* empty */
    ;

instr: instr WRITE VAR ';'  { assert_var_exists($3); }
    | instr READ VAR ';'    { assert_var_exists($3); }
    | /* empty */
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
    exit(1);
}

void declare_var(const char *s) {
    if (vars[s[0] - 'a']) {
        char msg[50];
        sprintf(msg, "syntax error, identifier '%s' already declared", s);
        yyerror(msg);
    }
    else {
        vars[s[0] - 'a'] = true;
    }
}

void assert_var_exists(const char *s) {
    if (!vars[s[0] - 'a']) {
        char msg[50];
        sprintf(msg, "syntax error, undeclared identifier '%s'", s);
        yyerror(msg);
    }
}

int main(int argc, char **argv)
{
    memset(vars, false, 'z' - 'a');

    ++argv, --argc;
    yyin = (argc > 0) ? fopen(argv[0], "r") : stdin;
    yyparse();
    puts("valid");
    return 0;
}
