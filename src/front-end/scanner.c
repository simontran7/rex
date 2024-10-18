#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

#include "token.h"

const char *BOM = "\xEF\xBB\xBF";
const uint8_t ASCII_NULL = 0;

typedef struct {
    const char *source;
    size_t current_index;
    size_t read_index;
    char current_char;
} Scanner;

void read(Scanner* scanner)
{
    if (scanner->read_index >= strlen(scanner->source)) {
        scanner->current_char = ASCII_NULL;
    } else {
        scanner->current_char = scanner->source[scanner->read_index];
    }
    scanner->current_index = scanner->read_index;
    scanner->read_index += 1;
}

char peek(Scanner* scanner) 
{
    if (scanner->read_index >= strlen(scanner->source)) {
        return ASCII_NULL;
    }
    return scanner->source[scanner->read_index];
}

void skip_whitespace(Scanner *scanner) 
{
    while (scanner->current_char == ' ' || scanner->current_char == '\n' 
            || scanner->current_char == '\t' || scanner->current_char == '\r') {
        read(scanner);
    }
}

void skip_line_comment(Scanner *scanner)
{
    while (scanner->current_char != '\n') {
        read(scanner);
    }
}

void skip_multi_line_comment(Scanner *scanner)
{
    // explicitely pass the initial (* such that if the multi line comment
    // is never closed with *), then the following loop will never terminate
    // – indicating a compile error
    read(scanner);
    read(scanner);
    while (!(scanner->current_char == '*' && peek(scanner) == ')')) {
        read(scanner);
    }
    read(scanner);
    read(scanner);
}

char *read_identifier(Scanner *scanner)
{
    const initial_index = scanner->current_index;
    while (isalpha(peek(scanner)) || isdigit(peek(scanner)) || peek(scanner) == '_') {
        read(scanner);
    }
    return scanner->source[initial_index..scanner->current_index + 1];
}

/// reads the supposed float
char *read_float(Scanner *scanner)
{
    const initial_index = scanner->current_index;

    // in a supposed float "num.c1c2c3...", the following
    // two lines reads '.' and 'c1' then stops
    read(scanner);
    read(scanner);

    if (!isdigit(scanner->current_char)) { // if c1 isn't a digit, it's definitely not a float
        return NULL;
    }

    while (isdigit(peek(scanner))) {
        read(scanner);
    }

    return scanner->source[initial_index .. scanner->current_index + 1];
}

char *read_integer(Scanner *scanner)
{
    const initial_index = scanner->current_index;
    while (isdigit(peek(scanner))) {
        read(scanner);
    }
    return scanner->source[initial_index .. this.current_index + 1];
}

char *read_string(Scanner *scanner)
{
    read(scanner); // read the first lexeme character
    const initial_lexeme_index = scanner->current_index; // the initial index of the string lexeme
    while (true) {
        if (is_esc_seq(scanner->current_char, peek(scanner))) {
            read(scanner);
            read(scanner);
            continue;
        } else if (scanner->current_char == '"') {
            break;
        }
        read(scanner);
    }
    return scanner->source[initial_lexeme_index..this.current_index];
}

// TODO: fix so value does not contain the \ in Token determines if character forms an escape sequence
bool is_esc_seq(char current_c, char next_char)
{
    return current_c == '\\' && (next_char == 'n' || next_char == 'r' || next_char == 't' || next_char == ' ' || next_char == 'f' || next_char == '\\' || next_char == '\'' || next_char == '"');
}

Scanner scanner_init(const char *source)
{
    size_t start_index;
    if (strncmp(source, BOM, 3) == 0) {
        start_index = 3; // ignore UTF-8 BOM
    }

    char start_char;
    if (start_index >= strlen(source)) {
        start_char = ASCII_NULL; // empty file, setting it to ASCII_NULL will lead to EOF when we call scanner_next() for the first time
    } else {
        start_char = source[start_index];
    }

    Scanner scanner = {source, start_index, start_index + 1, start_char};
    return scanner;
}

Token scanner_next(Scanner *scanner) 
{
    skip_whitespace(scanner);
    Token token;
    switch (scanner->current_char) {
        case '(':
            if (peek(scanner) == '*') {
                skip_multi_line_comment(scanner);
                return scanner_next(scanner);
            } else {
                token.token_type = LEFT_CIRCLE_BRACK;
                token.value = NULL;
            }
            break;
        case ')':
            token.token_type = RIGHT_CIRCLE_BRACK;
            token.value = NULL;
            break;
        case '{':
            token.token_type = LEFT_CURLY_BRACK;
            token.value = NULL;
            break;
        case '}':
            token.token_type = RIGHT_CURLY_BRACK;
            token.value = NULL;
            break;
        case '[':
            token.token_type = LEFT_SQUARE_BRACK;
            token.value = NULL;
            break;
        case ']':
            token.token_type = RIGHT_SQUARE_BRACK;
            token.value = NULL;
            break;
        case '&':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = AMPERSAND_EQUAL;
            } else {
                token.token_type = AMPERSAND;
            }
            token.value = NULL;
            break;
        case '~':
            token.token_type = TILDE;
            token.value = NULL;
            break;
        case '|':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = PIPE_EQUAL;
            } else {
                token.token_type = PIPE;
            }
            token.value = NULL;
            break;
        case '^':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = CARET_EQUAL;
            } else {
                token.token_type = CARET;
            }
            token.value = NULL;
            break;
        case ':':
            token.token_type = COLON;
            token.value = NULL;
            break;
        case ';':
            token.token_type = SEMICOLON;
            token.value = NULL;
            break;
        case '.':
            if (peek(scanner) == '.') {
                read(scanner);
                if (peek(scanner) == '=') {
                    read(scanner);
                    token.token_type = ELLIPSIS_EQUAL;
                } else {
                    token.token_type = ELLIPSIS;
                }
            } else {
                token.token_type = DOT;
            }
            token.value = NULL;
            break;
        case ',':
            token.token_type = COMMA;
            token.value = NULL;
            break;
        case '=':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = EQUAL_EQUAL;
            } else if (peek(scanner) == '>') {
                read(scanner);
                token.token_type = FAT_ARROW;
            } else {
                token.token_type = EQUAL;
            }
            token.value = NULL;
            break;
        case '!':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = BANG_EQUAL;
            } else {
                token.token_type = BANG;
            }
            token.value = NULL;
            break;
        case '+':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = PLUS_EQUAL;
            } else {
                token.token_type = PLUS;
            }
            token.value = NULL;
            break;
        case '-':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = MINUS_EQUAL;
            } else if (peek(scanner) == '>') {
                read(scanner);
                token.token_type = SKINNY_ARROW;
            } else {
                token.token_type = MINUS;
            }
            token.value = NULL;
            break;
        case '*':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = ASTERISK_EQUAL;
            } else {
                token.token_type = ASTERISK;
            }
            token.value = NULL;
            break;
        case '/':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = SLASH_EQUAL;
            } else if (peek(scanner) == '/') {
                skip_line_comment(scanner);
                return next(scanner);
            } else {
                token.token_type = SLASH;
            }
            token.value = NULL;
            break;
        case '%':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = PERCENT_EQUAL;
            } else {
                token.token_type = PERCENT;
            }
            token.value = NULL;
            break;
        case '>':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = RIGHT_ANGLE_BRACKET_EQUAL;
            } else if (peek(scanner) == '>') {
                read(scanner);
                if (peek(scanner) == '=') {
                    read(scanner);
                    token.token_type = RIGHT_ANGLE_BRACKET_RIGHT_ANGLE_BRACKET_EQUAL;
                } else {
                    token.token_type = RIGHT_ANGLE_BRACKET_RIGHT_ANGLE_BRACKET;
                }
            } else {
                token.token_type = RIGHT_ANGLE_BRACKET;
            }
            token.value = NULL;
            break;
        case '<':
            if (peek(scanner) == '=') {
                read(scanner);
                token.token_type = LEFT_ANGLE_BRACKET_EQUAL;
            } else if (peek(scanner) == '<') {
                read(scanner);
                if (peek(scanner) == '=') {
                    read(scanner);
                    token.token_type = LEFT_ANGLE_BRACKET_LEFT_ANGLE_BRACKET_EQUAL;
                } else {
                    token.token_type = LEFT_ANGLE_BRACKET_LEFT_ANGLE_BRACKET;
                }
            } else {
                token.token_type = LEFT_ANGLE_BRACKET;
            }
            token.value = NULL;
            break;
        case ASCII_NULL:
            token.token_type = END_OF_FILE;
            token.value = NULL;
            break;
        default:
            if (isalpha(scanner->current_char) || scanner->current_char == '_') {
                char *lexeme = read_identifier(scanner);
                token.token_type = IDENTIFIER; // TODO: MIGHT NOT BE IDENTIFIER
                token.value = lexeme; 
            } else if (isdigit(scanner->current_char)) {
                if (peek(scanner) == '.') {
                    char *lexeme = read_float(scanner);
                    if (lexeme == NULL) {
                        token.token_type = ILLEGAL;
                    } else {
                        token.token_type = FLOAT_LITERAL;
                    }
                    token.value = lexeme;
                } else {
                    token.token_type = INTEGER_LITERAL;
                    token.value = read_integer(scanner);
                }
            } else {
                token.token_type = ILLEGAL;
                token.value = NULL;
            }
    }
    read(scanner);
    return token;
}