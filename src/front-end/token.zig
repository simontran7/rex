//! token data type for lexical analysis
const std = @import("std");

/// a Token data type compromised of its type `token_type`,
/// its lexeme `value` for identifiers and literals, and
/// its position `pos` for compiler errors
pub const Token = struct {
    token_type: TokenType,
    value: ?[]const u8,

    /// create a new token object
    pub fn init(token_type: TokenType, value: ?[]const u8) Token {
        return Token{
            .token_type = token_type,
            .value = value,
        };
    }

    /// a token's type
    pub const TokenType = enum {
        /// identifier
        Identifier,

        /// literals
        IntegerLiteral,
        FloatLiteral,
        CharLiteral,
        StringLiteral,
        MultilineStringLiteral,

        /// delimiters
        LeftCircleBrack,
        RightCircleBrack,
        LeftCurlyBrack,
        RightCurlyBrack,
        LeftSquareBrack,
        RightSquareBrack,
        Colon,
        Semicolon,
        Dot,
        Comma,

        /// operators
        Equal,
        Bang,
        Plus,
        Minus,
        Asterisk,
        Ambersand,
        Slash,
        Percent,
        AmbersandEqual,
        Tilde,
        Pipe,
        PipeEqual,
        PlusEqual,
        MinusEqual,
        CaretEqual,
        Caret,
        AsteriskEqual,
        SlashEqual,
        PercentEqual,
        EqualEqual,
        BangEqual,
        RightAngleBracket,
        RightAngleBracketRightAngleBracketEqual,
        RightAngleBracketRightAngleBracket,
        RightAngleBracketEqual,
        LeftAngleBracket,
        LeftAngleBracketLeftAngleBracket,
        LeftAngleBracketLeftAngleBracketEqual,
        LeftAngleBracketEqual,

        SkinnyArrow,
        FatArrow,
        Ellipsis,
        EllipsisEqual,

        /// keywords
        Array,
        And,
        Bool,
        Break,
        Char,
        Const,
        Continue,
        Else,
        Enum,
        False,
        Field,
        Float,
        Fn,
        For,
        If,
        Implements,
        Import,
        In,
        Int,
        Interface,
        Match,
        Nil,
        Not,
        Or,
        Package,
        Pub,
        Return,
        String,
        Struct,
        This,
        True,
        Tuple,
        Var,
        Void,
        While,
        Step,

        /// special tokens
        Eof,
        Illegal,
    };

    /// a map to lookup if an identifier is actually a keyword
    pub const keyword_map = std.StaticStringMap(TokenType).initComptime(.{
        .{ "array", TokenType.Array },
        .{ "and", TokenType.And },
        .{ "bool", TokenType.Bool },
        .{ "break", TokenType.Break },
        .{ "char", TokenType.Char },
        .{ "const", TokenType.Const },
        .{ "continue", TokenType.Continue },
        .{ "else", TokenType.Else },
        .{ "enum", TokenType.Enum },
        .{ "false", TokenType.False },
        .{ "field", TokenType.Field },
        .{ "float", TokenType.Float },
        .{ "fn", TokenType.Fn },
        .{ "for", TokenType.For },
        .{ "if", TokenType.If },
        .{ "implements", TokenType.Implements },
        .{ "import", TokenType.Import },
        .{ "in", TokenType.In },
        .{ "int", TokenType.Int },
        .{ "interface", TokenType.Interface },
        .{ "match", TokenType.Match },
        .{ "nil", TokenType.Nil },
        .{ "not", TokenType.Not },
        .{ "or", TokenType.Or },
        .{ "package", TokenType.Package },
        .{ "pub", TokenType.Pub },
        .{ "return", TokenType.Return },
        .{ "string", TokenType.String },
        .{ "struct", TokenType.Struct },
        .{ "this", TokenType.This },
        .{ "true", TokenType.True },
        .{ "tuple", TokenType.Tuple },
        .{ "var", TokenType.Var },
        .{ "void", TokenType.Void },
        .{ "while", TokenType.While },
        .{ "step", TokenType.Step },
    });
};
