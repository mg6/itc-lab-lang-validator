LEX := flex -l
YACC := bison -y
CC := cc

all: lab

parser.c parser.h: parser.y
	$(YACC) -d $< -o parser.c

lex.yy.c: lexer.l parser.h
	$(LEX) $<

lab: lex.yy.c parser.c parser.h
	$(CC) $^ -o $@

test: lab
	./test.sh

clean:
	- rm lab parser.c parser.h lex.yy.c

.PHONY: all clean test
