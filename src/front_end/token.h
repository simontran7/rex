#include <string.h>
#include <stdint.h>

#ifndef TOKEN_H
#define TOKEN_H

static Entry keyword_map[37] = {
    [3] = { keyword: "array", token_type: ARRAY },   
    [5] = { keyword: "and", token_type: AND },       
    [9] = { keyword: "bool", token_type: BOOL },     
    [12] = { keyword: "break", token_type: BREAK },  
    [16] = { keyword: "char", token_type: CHAR },    
    [18] = { keyword: "const", token_type: CONST },  
    [19] = { keyword: "continue", token_type: CONTINUE },
    [7] = { keyword: "else", token_type: ELSE },
    [10] = { keyword: "enum", token_type: ENUM },
    [11] = { keyword: "false", token_type: FALSE },
    [1] = { keyword: "field", token_type: FIELD },
    [8] = { keyword: "float", token_type: FLOAT },
    [20] = { keyword: "func", token_type: FUNC },
    [6] = { keyword: "for", token_type: FOR },
    [0] = { keyword: "if", token_type: IF },
    [13] = { keyword: "implements", token_type: IMPLEMENTS },
    [2] = { keyword: "import", token_type: IMPORT },
    [14] = { keyword: "in", token_type: IN },
    [22] = { keyword: "int", token_type: INT },
    [29] = { keyword: "interface", token_type: INTERFACE },
    [30] = { keyword: "match", token_type: MATCH },
    [4] = { keyword: "None", token_type: NONE },
    [15] = { keyword: "not", token_type: NOT },
    [24] = { keyword: "or", token_type: OR },
    [17] = { keyword: "package", token_type: PACKAGE },
    [25] = { keyword: "pub", token_type: PUB },
    [23] = { keyword: "return", token_type: RETURN },
    [26] = { keyword: "string", token_type: STRING },
    [21] = { keyword: "struct", token_type: STRUCT },
    [27] = { keyword: "this", token_type: THIS },
    [28] = { keyword: "true", token_type: TRUE },
    [31] = { keyword: "tuple", token_type: TUPLE },
    [33] = { keyword: "var", token_type: VAR },
    [35] = { keyword: "void", token_type: VOID },
    [32] = { keyword: "while", token_type: WHILE },
    [34] = { keyword: "step", token_type: STEP }
};

TokenType lookup_keyword(const char *keyword) 
{
}

uint32_t hash(const char *str) 
{
}

typedef struct Entry {
    const char *keyword;
    TokenType token_type;
} Entry;

typedef enum TokenType {
    IDENTIFIER,

    INTEGER_LITERAL,
    FLOAT_LITERAL,
    CHAR_LITERAL,
    STRING_LITERAL,
    MULTILINE_STRING_LITERAL,

    LEFT_CIRCLE_BRACK,
    RIGHT_CIRCLE_BRACK,
    LEFT_CURLY_BRACK,
    RIGHT_CURLY_BRACK,
    LEFT_SQUARE_BRACK,
    RIGHT_SQUARE_BRACK,
    COLON,
    SEMICOLON,
    DOT,
    COMMA,

    EQUAL,
    BANG,
    PLUS,
    MINUS,
    ASTERISK,
    AMPERSAND,
    SLASH,
    PERCENT,
    AMPERSAND_EQUAL,
    TILDE,
    PIPE,
    PIPE_EQUAL,
    PLUS_EQUAL,
    MINUS_EQUAL,
    CARET_EQUAL,
    CARET,
    ASTERISK_EQUAL,
    SLASH_EQUAL,
    PERCENT_EQUAL,
    EQUAL_EQUAL,
    BANG_EQUAL,
    RIGHT_ANGLE_BRACKET,
    RIGHT_ANGLE_BRACKET_RIGHT_ANGLE_BRACKET_EQUAL,
    RIGHT_ANGLE_BRACKET_RIGHT_ANGLE_BRACKET,
    RIGHT_ANGLE_BRACKET_EQUAL,
    LEFT_ANGLE_BRACKET,
    LEFT_ANGLE_BRACKET_LEFT_ANGLE_BRACKET,
    LEFT_ANGLE_BRACKET_LEFT_ANGLE_BRACKET_EQUAL,
    LEFT_ANGLE_BRACKET_EQUAL,

    SKINNY_ARROW,
    FAT_ARROW,
    ELLIPSIS,
    ELLIPSIS_EQUAL,

    ARRAY,
    AND,
    BOOL,
    BREAK,
    CHAR,
    CONST,
    CONTINUE,
    ELSE,
    ENUM,
    FALSE,
    FIELD,
    FLOAT,
    FUNC,
    FOR,
    IF,
    IMPLEMENTS,
    IMPORT,
    IN,
    INT,
    INTERFACE,
    MATCH,
    NONE,
    NOT,
    OR,
    PACKAGE,
    PUB,
    RETURN,
    STRING,
    STRUCT,
    THIS,
    TRUE,
    TUPLE,
    VAR,
    VOID,
    WHILE,
    STEP,

    END_OF_FILE,
    ILLEGAL,
} TokenType;

#endif // TOKEN_H