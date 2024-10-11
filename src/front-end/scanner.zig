//! STEP 1: scanner used to convert source code into tokens
const std = @import("std");
const Token = @import("token.zig").Token;

/// a Scanner data type compromised of the file content
/// `source`, the current index `current_index`, the
/// current character `current_char` and the index of
/// the next character `read_index`
pub const Scanner = struct {
    const BOM = "\xEF\xBB\xBF";
    const ascii_null = 0;

    source: []const u8,
    current_index: usize,
    read_index: usize,
    current_char: u8,

    /// creates and returns a scanner object
    pub fn init(source: []const u8) Scanner {
        const start_index: usize = if (std.mem.startsWith(u8, source, BOM)) 3 else 0; // ignore UTF-8 BOM
        const start_char = if (start_index >= source.len) 0 else source[start_index];
        return Scanner{
            .source = source,
            .current_index = start_index,
            .read_index = start_index + 1,
            .current_char = start_char,
        };
    }

    /// returns the next token
    pub fn next(this: *Scanner) Token {
        this.skip_whitespace();
        var token: Token = undefined;
        switch (this.current_char) {
            '(' => {
                if (this.peek() == '*') {
                    this.skip_multi_line_comment();
                    return this.next();
                } else {
                    token = Token.init(Token.TokenType.LeftCircleBrack, null);
                }
            },
            ')' => token = Token.init(Token.TokenType.RightCircleBrack, null),
            '{' => token = Token.init(Token.TokenType.LeftCurlyBrack, null),
            '}' => token = Token.init(Token.TokenType.RightCurlyBrack, null),
            '[' => token = Token.init(Token.TokenType.LeftSquareBrack, null),
            ']' => token = Token.init(Token.TokenType.RightSquareBrack, null),
            '&' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.AmbersandEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Ambersand, null);
                }
            },
            '~' => token = Token.init(Token.TokenType.Tilde, null),
            '|' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.PipeEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Pipe, null);
                }
            },
            '^' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.CaretEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Caret, null);
                }
            },
            ':' => token = Token.init(Token.TokenType.Colon, null),
            ';' => token = Token.init(Token.TokenType.Semicolon, null),
            '.' => {
                if (this.peek() == '.') {
                    this.read();
                    if (this.peek() == '=') {
                        this.read();
                        token = Token.init(Token.TokenType.EllipsisEqual, null);
                    } else {
                        token = Token.init(Token.TokenType.Ellipsis, null);
                    }
                } else {
                    token = Token.init(Token.TokenType.Dot, null);
                }
            },
            ',' => token = Token.init(Token.TokenType.Comma, null),
            '=' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.EqualEqual, null);
                } else if (this.peek() == '>') {
                    this.read();
                    token = Token.init(Token.TokenType.FatArrow, null);
                } else {
                    token = Token.init(Token.TokenType.Equal, null);
                }
            },
            '!' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.BangEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Bang, null);
                }
            },
            '+' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.PlusEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Plus, null);
                }
            },
            '-' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.MinusEqual, null);
                } else if (this.peek() == '>') {
                    this.read();
                    token = Token.init(Token.TokenType.SkinnyArrow, null);
                } else {
                    token = Token.init(Token.TokenType.Minus, null);
                }
            },
            '*' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.AsteriskEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Asterisk, null);
                }
            },
            '/' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.SlashEqual, null);
                } else if (this.peek() == '/') {
                    this.skip_line_comment();
                    return this.next();
                } else {
                    token = Token.init(Token.TokenType.Slash, null);
                }
            },
            '%' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.PercentEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Percent, null);
                }
            },
            '>' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.RightAngleBracketEqual, null);
                } else if (this.peek() == '>') {
                    this.read();
                    if (this.peek() == '=') {
                        this.read();
                        token = Token.init(Token.TokenType.RightAngleBracketRightAngleBracketEqual, null);
                    } else {
                        token = Token.init(Token.TokenType.RightAngleBracketRightAngleBracket, null);
                    }
                } else {
                    token = Token.init(Token.TokenType.RightAngleBracket, null);
                }
            },
            '<' => {
                if (this.peek() == '=') {
                    this.read();
                    token = Token.init(Token.TokenType.LeftAngleBracketEqual, null);
                } else if (this.peek() == '<') {
                    this.read();
                    if (this.peek() == '=') {
                        this.read();
                        token = Token.init(Token.TokenType.LeftAngleBracketLeftAngleBracketEqual, null);
                    } else {
                        token = Token.init(Token.TokenType.LeftAngleBracketLeftAngleBracket, null);
                    }
                } else {
                    token = Token.init(Token.TokenType.LeftAngleBracket, null);
                }
            },
            'a'...'z', 'A'...'Z', '_' => {
                const lexeme = this.read_identifier();
                if (Token.keyword_map.get(lexeme)) |token_type_keyword| {
                    token = Token.init(token_type_keyword, null);
                } else {
                    token = Token.init(Token.TokenType.Identifier, lexeme);
                }
            },
            '0'...'9' => {
                if (this.peek() == '.') {
                    const lexeme = this.read_float();
                    if (lexeme == null) {
                        token = Token.init(Token.TokenType.Illegal, null);
                    } else {
                        token = Token.init(Token.TokenType.FloatLiteral, lexeme);
                    }
                } else {
                    token = Token.init(Token.TokenType.IntegerLiteral, this.read_integer());
                }
            },
            '"' => {
                if (this.peek() == '"') {
                    // TODO: multi-line string
                    this.read();
                    token = Token.init(Token.TokenType.Illegal, null);
                } else {
                    _ = this.read_string();
                    // if (lexeme) {
                    //     Ok(lexeme) => Token {
                    //         token_type: TokenType::StringLiteral,
                    //         lexeme: Some(lexeme.to_string()),
                    //     },
                    //     Err(_) => Token {
                    //         token_type: TokenType::Illegal,
                    //         lexeme: None,
                    //     },
                    // }
                }
            },
            ascii_null => token = Token.init(Token.TokenType.Eof, null),
            else => token = Token.init(Token.TokenType.Illegal, null),
        }
        this.read();
        return token;
    }

    /// skips whitespace or \t and \r escape sequences
    fn skip_whitespace(this: *Scanner) void {
        while (this.current_char == ' ' or this.current_char == '\n' or this.current_char == '\t' or this.current_char == '\r') {
            this.read();
        }
    }

    /// skips line comment
    fn skip_line_comment(this: *Scanner) void {
        while (this.current_char != '\n') {
            this.read();
        }
    }

    /// skips multi-line comment
    fn skip_multi_line_comment(this: *Scanner) void {
        // explicitely pass the initial (* such that if the multi line comment
        // is never closed with *), then the following loop will never terminate
        // – indicating a compile error
        this.read();
        this.read();
        while (!(this.current_char == '*' and this.peek() == ')')) {
            this.read();
        }
        this.read();
        this.read();
    }

    /// checks the character ahead to decide on a token
    fn peek(this: *Scanner) u8 {
        if (this.read_index >= this.source.len) {
            return ascii_null;
        }
        return this.source[this.read_index];
    }

    /// reads the next character and sets current_char to it
    fn read(this: *Scanner) void {
        if (this.read_index >= this.source.len) {
            this.current_char = ascii_null;
        } else {
            this.current_char = this.source[this.read_index];
        }
        this.current_index = this.read_index;
        this.read_index += 1;
    }

    /// reads the supposed identifier
    fn read_identifier(this: *Scanner) []const u8 {
        const initial_index = this.current_index;
        while (std.ascii.isAlphabetic(this.peek()) or std.ascii.isDigit(this.peek()) or this.peek() == '_') {
            this.read();
        }
        return this.source[initial_index .. this.current_index + 1];
    }

    /// reads the supposed float
    fn read_float(this: *Scanner) ?[]const u8 {
        const initial_index = this.current_index;

        // in a supposed float "num.c1c2c3...", the following
        // two lines reads '.' and 'c1' then stops
        this.read();
        this.read();

        if (!std.ascii.isDigit(this.current_char)) { // if c1 isn't a digit, it's definitely not a float
            return null;
        }

        while (std.ascii.isDigit(this.peek())) {
            this.read();
        }
        return this.source[initial_index .. this.current_index + 1];
    }

    /// reads an integer
    fn read_integer(this: *Scanner) []const u8 {
        const initial_index = this.current_index;
        while (std.ascii.isDigit(this.peek())) {
            this.read();
        }
        return this.source[initial_index .. this.current_index + 1];
    }

    /// reads a string
    fn read_string(this: *Scanner) []const u8 {
        this.read(); // read the first lexeme character
        const initial_lexeme_index = this.current_index; // the initial index of the string lexeme
        while (true) {
            if (is_esc_seq(this.current_char, this.peek())) {
                this.read();
                this.read();
                continue;
            } else if (this.current_char == '"') {
                break;
            }
            this.read();
        }
        return this.source[initial_lexeme_index..this.current_index];
    }
};

// TODO: fix so value does not contain the \ in Token determines if character forms an escape sequence
fn is_esc_seq(current_c: u8, next_char: u8) bool {
    return current_c == '\\' and (next_char == 'n' or next_char == 'r' or next_char == 't' or next_char == ' ' or next_char == 'f' or next_char == '\\' or next_char == '\'' or next_char == '"');
}

test "read_float()" {}

test "read_integer()" {}

test "is_esc_seq()" {}
