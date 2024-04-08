#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include  <stddef.h>

struct symbol_entry symbol_table[100];
int symbol_count = 0;
#define MAX_SCOPE_DEPTH 100
char scope_stack[MAX_SCOPE_DEPTH][50];
int scope_depth = 0;

void push_scope(char *scope) {
    if (scope_depth < MAX_SCOPE_DEPTH) {
        strcpy(scope_stack[scope_depth], scope);
        scope_depth++;
    } else {
        fprintf(stderr, "Scope stack overflow\n");
    }
}

void pop_scope() {
    if (scope_depth > 0) {
        scope_depth--;
    } else {
        fprintf(stderr, "Scope stack underflow\n");
    }
}
char *get_current_scope() {
    if (scope_depth > 0) {
        return scope_stack[scope_depth - 1];
    } else {
        return "global"; // Default to global scope if stack is empty
    }
}


 void add_value_for_id(char *val){
    strcpy(symbol_table[symbol_count].value, val);
 }
void add_to_symbol_table(char *name, int token, int location,bool is_function) {
    strcpy(symbol_table[symbol_count].name, name);
    symbol_table[symbol_count].token_type = token;
    symbol_table[symbol_count].location = location;
    symbol_table[symbol_count].is_function = is_function;
    strcpy(symbol_table[symbol_count].scope, get_current_scope());


    symbol_count++;
}
const char* boolToString(bool b) {
    return b ? "true" : "false";
}
const char* token_typeToString(int b) {
    return b==258 ? "identfier" : "keyword";
}
void set_is_function_attribute(char *name) {
    // Find the corresponding entry in the symbol table and update its is_function attribute
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].is_function = true;
            break;
        }
    }
}
int search_symbol_table(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0)
            return symbol_table[i].token_type;
    }
    return -1;
}

char* get_data_type(char* token_name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, token_name) == 0) {
            if (strlen(symbol_table[i].data_type) > 0) {
                return symbol_table[i].data_type;
            } else {
                return "UNKNOWN";
            }
        }
    }
    return "UNKNOWN";
}

void displaySymbolTable() {
    printf("Symbol Table:\n");
    printf("-------------------------------------------------------------------------------------------------\n");
    printf("%-20s | %-15s | %-10s | %-10s | %-10s| %-10s| %-10s\n", "Token Name", "Data Type", "line number" ,"Token Type","is function","value","scope");
    printf("---------------------------------------------------------------------------------------------------\n");
    for (int i = 0; i < symbol_count; i++) {                    
        printf("%-20s | %-15s | %-10d |%-10s |%-10s |%-10s| %-10s\n", symbol_table[i].name, symbol_table[i].data_type, symbol_table[i].location,token_typeToString(symbol_table[i].token_type),boolToString(symbol_table[i].is_function),symbol_table[i].value,symbol_table[i].scope);
    }
    printf("--------------------------------------------------------------------------------------------------\n");
}
bool check_constant_type_For_int(char *name){


  if(strcmp(get_data_type(name),"int")==0){

    return true;
 }
return false;
 
}
bool check_constant_type_For_String(char *name){


  if(strcmp(get_data_type(name),"String")==0){

    return true;
 }
return false;
 
}
bool check_constant_type_For_Float(char *name){


  if(strcmp(get_data_type(name),"float")==0){

    return true;
 }
return false;
 
}
bool is_declared(const char* name) {
    
    return false;
}
bool analyze_variable_declaration(const char* name, const char* data_type) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(name, symbol_table[i].name) == 0 && strcmp(symbol_table[i].data_type , data_type)==0) {
            printf("Error: Variable '%s' is already declared\n", name);
            return false;
        }
    }
    return true;
}