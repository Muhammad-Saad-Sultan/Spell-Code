%{
#include <stdio.h>
#include <string.h>
int line_no = 1;
FILE* fp;
%}

%%
[ \t]+ ;
\n { line_no++; }

spell|summon|cast|vanish|reveal|bind|chart|until|potion|magic|portal|else|rune|focus|endspell {
    fprintf(fp, "Line %d: KEYWORD %s\n", line_no, yytext);
}

[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?   { fprintf(fp, "Line %d: FLOAT %s\n", line_no, yytext); }
[0-9]+([eE][+-]?[0-9]+)            { fprintf(fp, "Line %d: EXPONENT %s\n", line_no, yytext); }
[0-9]+                             { fprintf(fp, "Line %d: NUMBER %s\n", line_no, yytext); }

[a-zA-Z_][a-zA-Z0-9_]*             { fprintf(fp, "Line %d: IDENTIFIER %s\n", line_no, yytext); }

[^a-zA-Z_0-9\n\t\"\'\+\-\*\/=<>\@\~{}\(\);]+  { fprintf(fp, "Line %d: ERROR %s invalid_character\n", line_no, yytext); }
[0-9][a-zA-Z_][a-zA-Z0-9_]*        { fprintf(fp, "Line %d: ERROR %s invalid_identifier\n", line_no, yytext); }

\"([^\"\\]|\\.)*\"                 { fprintf(fp, "Line %d: STRING %s\n", line_no, yytext); }
\'([^\'\\]|\\.)\'                  { fprintf(fp, "Line %d: CHAR %s\n", line_no, yytext); }

\"([^\"\n]*)$                      { fprintf(fp, "Line %d: ERROR %s unterminated_string\n", line_no, yytext); }
\'([^\'\n]*)$                      { fprintf(fp, "Line %d: ERROR %s unterminated_char\n", line_no, yytext); }

"~"|"\+"|"-"|"*"|"/"|"=="|"="|"<"|">"|"@" {
    fprintf(fp, "Line %d: OPERATOR %s\n", line_no, yytext);
}

"("|")"|"{"|"}"|";" { fprintf(fp, "Line %d: PUNCTUATION %s\n", line_no, yytext); }

. { fprintf(fp, "Line %d: ERROR %s invalid_token\n", line_no, yytext); }
%%

int main(void) {
    fp = fopen("tokens.txt", "w");
    if (!fp) {
        printf("Error opening tokens.txt for writing.\n");
        return 1;
    }

    yylex();

    fprintf(fp, "\nLexical analysis complete. Total lines: %d\n", line_no);
    fclose(fp);
    printf("Lexical analysis complete. Tokens saved to tokens.txt\n");
    return 0;
}
