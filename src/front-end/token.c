#include "token.h"
#include <string.h>
#include <stdint.h>

typedef struct {
    const char *keyword;
    TokenType token_type;
} Entry;

uint32_t hash(const char *str) 
{
    uint32_t hash = 0;
    while (*str) {
        hash = hash * 31 + *str;
        str += 1;
    }
    return hash % 37;  // Use modulo of 37, the number of keywords
}

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
    [4] = { keyword: "nil", token_type: NIL },
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
    size_t index = hash(keyword);
    if (keyword_map[index].keyword && strcmp(keyword_map[index].keyword, keyword) == 0) {
        return keyword_map[index].token;
    }
    return NULL;
}


