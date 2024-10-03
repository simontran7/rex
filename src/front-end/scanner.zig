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
    pub fn next(self: *Scanner) Token {
        self.skip_whitespace();
        var token: Token = undefined;
        switch (self.current_char) {
            '(' => {
                if (self.peek() == '*') {
                    self.skip_multi_line_comment();
                    return self.next();
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
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.AmbersandEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Ambersand, null);
                }
            },
            '~' => token = Token.init(Token.TokenType.Tilde, null),
            '|' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.PipeEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Pipe, null);
                }
            },
            '^' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.CaretEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Caret, null);
                }
            },
            ':' => token = Token.init(Token.TokenType.Colon, null),
            ';' => token = Token.init(Token.TokenType.Semicolon, null),
            '.' => {
                if (self.peek() == '.') {
                    self.read();
                    if (self.peek() == '=') {
                        self.read();
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
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.EqualEqual, null);
                } else if (self.peek() == '>') {
                    self.read();
                    token = Token.init(Token.TokenType.FatArrow, null);
                } else {
                    token = Token.init(Token.TokenType.Equal, null);
                }
            },
            '!' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.BangEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Bang, null);
                }
            },
            '+' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.PlusEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Plus, null);
                }
            },
            '-' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.MinusEqual, null);
                } else if (self.peek() == '>') {
                    self.read();
                    token = Token.init(Token.TokenType.SkinnyArrow, null);
                } else {
                    token = Token.init(Token.TokenType.Minus, null);
                }
            },
            '*' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.AsteriskEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Asterisk, null);
                }
            },
            '/' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.SlashEqual, null);
                } else if (self.peek() == '/') {
                    self.skip_line_comment();
                    return self.next();
                } else {
                    token = Token.init(Token.TokenType.Slash, null);
                }
            },
            '%' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.PercentEqual, null);
                } else {
                    token = Token.init(Token.TokenType.Percent, null);
                }
            },
            '>' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.RightAngleBracketEqual, null);
                } else if (self.peek() == '>') {
                    self.read();
                    if (self.peek() == '=') {
                        self.read();
                        token = Token.init(Token.TokenType.RightAngleBracketRightAngleBracketEqual, null);
                    } else {
                        token = Token.init(Token.TokenType.RightAngleBracketRightAngleBracket, null);
                    }
                } else {
                    token = Token.init(Token.TokenType.RightAngleBracket, null);
                }
            },
            '<' => {
                if (self.peek() == '=') {
                    self.read();
                    token = Token.init(Token.TokenType.LeftAngleBracketEqual, null);
                } else if (self.peek() == '<') {
                    self.read();
                    if (self.peek() == '=') {
                        self.read();
                        token = Token.init(Token.TokenType.LeftAngleBracketLeftAngleBracketEqual, null);
                    } else {
                        token = Token.init(Token.TokenType.LeftAngleBracketLeftAngleBracket, null);
                    }
                } else {
                    token = Token.init(Token.TokenType.LeftAngleBracket, null);
                }
            },
            'a'...'z', 'A'...'Z', '_' => {
                const lexeme = self.read_identifier();
                if (Token.keyword_map.get(lexeme)) |token_type_keyword| {
                    token = Token.init(token_type_keyword, null);
                } else {
                    token = Token.init(Token.TokenType.Identifier, lexeme);
                }
            },
            '0'...'9' => {
                if (self.peek() == '.') {
                    const lexeme = self.read_float();
                    if (lexeme == null) {
                        token = Token.init(Token.TokenType.Illegal, null);
                    } else {
                        token = Token.init(Token.TokenType.FloatLiteral, lexeme);
                    }
                } else {
                    token = Token.init(Token.TokenType.IntegerLiteral, self.read_integer());
                }
            },
            '"' => {
                if (self.peek() == '"') {
                    // TODO: multi-line string
                    self.read();
                    token = Token.init(Token.TokenType.Illegal, null);
                } else {
                    _ = self.read_string();
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
        self.read();
        return token;
    }

    /// skips whitespace or \t and \r escape sequences
    fn skip_whitespace(self: *Scanner) void {
        while (self.current_char == ' ' or self.current_char == '\n' or self.current_char == '\t' or self.current_char == '\r') {
            self.read();
        }
    }

    /// skips line comment
    fn skip_line_comment(self: *Scanner) void {
        while (self.current_char != '\n') {
            self.read();
        }
    }

    /// skips multi-line comment
    fn skip_multi_line_comment(self: *Scanner) void {
        // explicitely pass the initial (* such that if the multi line comment
        // is never closed with *), then the following loop will never terminate
        // – indicating a compile error
        self.read();
        self.read();
        while (!(self.current_char == '*' and self.peek() == ')')) {
            self.read();
        }
        self.read();
        self.read();
    }

    /// checks the character ahead to decide on a token
    fn peek(self: *Scanner) u8 {
        if (self.read_index >= self.source.len) {
            return ascii_null;
        }
        return self.source[self.read_index];
    }

    /// reads the next character and sets current_char to it
    fn read(self: *Scanner) void {
        if (self.read_index >= self.source.len) {
            self.current_char = ascii_null;
        } else {
            self.current_char = self.source[self.read_index];
        }
        self.current_index = self.read_index;
        self.read_index += 1;
    }

    /// reads the supposed identifier
    fn read_identifier(self: *Scanner) []const u8 {
        const initial_index = self.current_index;
        while (is_letter(self.peek()) or is_digit(self.peek()) or self.peek() == '_') {
            self.read();
        }
        return self.source[initial_index .. self.current_index + 1];
    }

    /// reads the supposed float
    fn read_float(self: *Scanner) ?[]const u8 {
        const initial_index = self.current_index;

        // in a supposed float "num.c1c2c3...", the following
        // two lines reads '.' and 'c1' then stops
        self.read();
        self.read();

        if (!is_digit(self.current_char)) { // if c1 isn't a digit, it's definitely not a float
            return null;
        }

        while (is_digit(self.peek())) {
            self.read();
        }
        return self.source[initial_index .. self.current_index + 1];
    }

    /// reads an integer
    fn read_integer(self: *Scanner) []const u8 {
        const initial_index = self.current_index;
        while (is_digit(self.peek())) {
            self.read();
        }
        return self.source[initial_index .. self.current_index + 1];
    }

    /// reads a string
    fn read_string(self: *Scanner) []const u8 {
        self.read(); // read the first lexeme character
        const initial_lexeme_index = self.current_index; // the initial index of the string lexeme
        while (true) {
            if (is_esc_seq(self.current_char, self.peek())) {
                self.read();
                self.read();
                continue;
            } else if (self.current_char == '"') {
                break;
            }
            self.read();
        }
        return self.source[initial_lexeme_index..self.current_index];
    }

    /// determines if character is a letter
    fn is_letter(c: u8) bool {
        return 'a' <= c and c <= 'z' or 'A' <= c and c <= 'Z';
    }

    /// determines if character is a digit
    fn is_digit(c: u8) bool {
        return '0' <= c and c <= '9';
    }
};

// TODO: fix so value does not contain the \ in Token determines if character forms an escape sequence
fn is_esc_seq(current_c: u8, next_char: u8) bool {
    return current_c == '\\' and (next_char == 'n' or next_char == 'r' or next_char == 't' or next_char == ' ' or next_char == 'f' or next_char == '\\' or next_char == '\'' or next_char == '"');
}

test "read_float()" {}

test "read_integer()" {}

test "is_letter()" {
    try std.testing.expectEqual(Scanner.is_letter('a'), true);
    try std.testing.expectEqual(Scanner.is_letter('0'), false);
}

test "is_digit()" {
    const valid_digits = [_]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
    for (valid_digits) |valid_digit| {
        try std.testing.expectEqual(Scanner.is_digit(valid_digit), true);
    }
}
