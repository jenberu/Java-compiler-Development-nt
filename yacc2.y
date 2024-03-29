%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int search_symbol_table(char *name);
extern void add_to_symbol_table(char *name, int type);
extern void displaySymbolTable();
extern char* get_data_type(char* token_name);
extern void displaySymbolTable();
extern struct symbol_entry {
    char name[50];
    char data_type[20];
    int token_type;
    // Add more attributes as needed
} symbol_table[100];

extern int symbol_count;

extern int line_number;
extern int yylex();
extern FILE *yyin;
void yyerror(const char *s);

// Define YYSTYPE struct for semantic values
typedef struct {
    char* strval;
    float floatval;
    int intval;
    char charval;
} YYSTYPE;

#define YYSTYPE_IS_DECLARED
%}

%union {
    char* strval;
    float floatval;
    int intval;
    char charval;
}

%token <strval> IDENTIFIER STRING_CONST
%token <floatval> FLOAT_CONST
%token <intval> INT_CONST
%token <charval> CHAR_CONST

%token  CLASS STATIC PRINTLN NEW IMPORT BREAK FOR RETURN DO WHILE IF ELSE SWITCH PRIVATE PROTECTED PUBLIC IMPLEMENTS THIS
%token  SEMICOLON EXTENDS COMMA ASSIGN MINUS NEWLINE PLUS MULTIPLY DIVIDE MODULO DOT RBRACKET LBRACKET IN OUT SYSTEM JAVA_IMPORT CASE DEFAULT
%token  LESS_THAN LESS_EQUAL GREATER_THAN GREATER_EQUAL EQUALS NOT_EQUALS AND OR NOT    
%token  MAIN LBRACE RBRACE LPAREN RPAREN 
%token  INT FLOAT VOID STRING

%left OR
%left AND
%left EQUALS NOT_EQUALS
%left LESS_THAN LESS_EQUAL GREATER_THAN GREATER_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO
%right NOT

%%

program : class_declaration { printf("Parsing completed !\n");}
        |program class_declaration
        
       |/* empty */
        ;

statement_list :statement
               |statement_list statement
              
               
               
               
               ;
class_declaration: PUBLIC CLASS IDENTIFIER EXTENDS IDENTIFIER  LBRACE class_body RBRACE
                  | CLASS IDENTIFIER EXTENDS IDENTIFIER  LBRACE class_body RBRACE
                 | CLASS IDENTIFIER LBRACE class_body RBRACE
                | PUBLIC CLASS IDENTIFIER LBRACE class_body RBRACE

                 ;

class_body:statement_list 
           |statement_list function_decl
           |function_decl statement_list
           |main_method
           |function_decl
           |
          ;

                   ;
function_decl: modifier static_func type_specifier IDENTIFIER LPAREN parm RPAREN LBRACE  func_body RBRACE   
             |static_func type_specifier IDENTIFIER LPAREN parm RPAREN LBRACE  func_body RBRACE   
             |static_func VOID IDENTIFIER LPAREN parm RPAREN LBRACE  func_body RBRACE   
             |modifier static_func VOID IDENTIFIER LPAREN parm RPAREN LBRACE  func_body RBRACE  

             ;   
static_func:  STATIC
              |
              ;
main_method : PUBLIC STATIC VOID MAIN LPAREN STRING LBRACKET RBRACKET IDENTIFIER RPAREN LBRACE  func_body RBRACE 
  ;
parm: type_specifier IDENTIFIER
      |parm COMMA type_specifier IDENTIFIER
      |
      ;

func_body: statement_list
           |
           ;
modifier: PUBLIC  
         |PRIVATE 
         |PROTECTED
         
         
            
        ; 
assignment : IDENTIFIER ASSIGN expression {  char* identifier =$1;
                                         // Check if the identifier exists in the symbol table
                                        char *data_type = get_data_type($1);
                                        int result =strcmp(data_type,"UNKNOWN");
                                       if (result!=0) {
                                          // Identifier exists, perform the assignment
                                       printf("Assignment to identifier '%s' is allowed.\n", identifier);
                                            }
                                        else {
                                              // Identifier does not exist, print an error message
                                         printf("Error: Identifier '%s' not declared.\n", identifier);
                                         yyerror("Assignment before declaration is not allowed");
                                            // You can also choose to exit parsing or handle the error differently
                                           } 
                                           } 
                                           ;
statement :type_specifier expression SEMICOLON     
          | declaration SEMICOLON
          | assignment SEMICOLON { printf("Assignment statement parsed.\n"); }
          | selection_statement
          | iteration_statement
          | jump_statement
          |increament_decreament SEMICOLON
          |system_out_println SEMICOLON
          |object_creation
          |object_call
          ;
system_out_println : SYSTEM DOT OUT DOT PRINTLN LPAREN expr_or_string RPAREN
                     ;
expr_or_string : expression
               | 
               ;
increament_decreament:IDENTIFIER PLUS PLUS 
                      |IDENTIFIER MINUS MINUS            

          ;


declaration : type_specifier var_declarations  
            
             
            ;
object_creation:IDENTIFIER IDENTIFIER ASSIGN NEW IDENTIFIER LPAREN parm RPAREN SEMICOLON {  
                                                                                        symbol_count=symbol_count-1;
                                                                                         strcpy(symbol_table[symbol_count].data_type, $1);
                                                                                             symbol_count=symbol_count+1;                                                                                       
                                                                                          
                                                                }
                ;
object_call: IDENTIFIER DOT IDENTIFIER  LPAREN parm RPAREN SEMICOLON
           ;
var_declarations : var_declaration
                 | var_declarations COMMA var_declaration
                 ;

var_declaration :  IDENTIFIER
                |  IDENTIFIER ASSIGN expression
                
                ;

type_specifier : INT {strcpy(symbol_table[symbol_count].data_type, "intger");
                    } 
               | FLOAT { 
                         strcpy(symbol_table[symbol_count].data_type, "float");
                            } 
               | STRING
                      {
                    strcpy(symbol_table[symbol_count].data_type, "String");
                 } 
              ;

selection_statement : IF LPAREN expression RPAREN statement
                    | IF LPAREN expression RPAREN statement ELSE statement
                    |IF LPAREN expression RPAREN LBRACE statement RBRACE ELSE statement
                    |IF LPAREN expression RPAREN LBRACE statement RBRACE LBRACE statement RBRACE
                    | SWITCH LPAREN expression RPAREN statement
                    |IF LPAREN expression RPAREN LBRACE statement RBRACE
                    ;

iteration_statement : WHILE LPAREN expression RPAREN LBRACE iteration_statement_body RBRACE
                    | DO LBRACE iteration_statement_body RBRACE WHILE LPAREN expression RPAREN SEMICOLON 
                    | FOR LPAREN declaration SEMICOLON expression SEMICOLON expression RPAREN LBRACE iteration_statement_body RBRACE
                    | FOR LPAREN  SEMICOLON SEMICOLON SEMICOLON RPAREN RPAREN LBRACE iteration_statement_body RBRACE
                    | FOR LPAREN declaration SEMICOLON SEMICOLON RPAREN RPAREN LBRACE iteration_statement_body RBRACE
                    ;
             
iteration_statement_body:statement_list
                         |

jump_statement : RETURN expression SEMICOLON
               | BREAK SEMICOLON
               ;

expression : expression PLUS expression
           | expression MINUS expression
           | expression MULTIPLY expression
           | expression DIVIDE expression
           | expression MODULO expression
           | expression LESS_THAN expression
           | expression LESS_EQUAL expression
           | expression GREATER_THAN expression
           | expression GREATER_EQUAL expression
           | expression EQUALS expression
           | expression NOT_EQUALS expression
           | expression AND expression
           | expression OR expression
           | NOT expression
           | LPAREN expression RPAREN
           | primary_expression
           | expression PLUS PLUS
           | expression MINUS MINUS
           |MINUS expression
           |PLUS PLUS expression
           
           ;

primary_expression : IDENTIFIER {  char* identifier =$1;
                                         // Check if the identifier exists in the symbol table
                                        char *data_type = get_data_type($1);
                                         int result =strcmp(data_type,"UNKNOWN");
                                       if (result!=0) {
                                          // Identifier exists, perform the assignment
                                       printf("Assignment to identifier for '%s' is allowed.\n", identifier);
                                            }
                                        else {
                                              // Identifier does not exist, print an error message
                                         printf("Error: Identifier '%s' not declared.\n", identifier);
                                         yyerror("Assignment not allowed");
                                            // You can also choose to exit parsing or handle the error differently
                                           } 
                                           } 
                    | FLOAT_CONST
                    | INT_CONST
                    | STRING_CONST
                    | CHAR_CONST
                    
                    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d: %s\n", line_number, s);
    exit(EXIT_FAILURE);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        printf("Error opening input file.\n");
        return 1;
    }

    yyin = input_file;

   if (yyparse() == 0) {
        printf("Your input java code is correct\n");
    }

    fclose(input_file);
    displaySymbolTable();

    return 0;
}

