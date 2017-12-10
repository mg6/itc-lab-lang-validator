%option noyywrap

%{
  #include <stdlib.h> 
  #include "parser.h"

  extern YYSTYPE yylval;
%}

%%

#.*\n   {}
[ \n\r\t]+ {}
declare { return DECLARE; }
write   { return WRITE; }
read    { return READ; }
[a-z]+  {
            yylval.string = malloc(strlen(yytext) + 1);
            strcpy(yylval.string, yytext);
            return VAR;
        }
[{};]   { return yytext[0]; }
.|\n    {}

%%
