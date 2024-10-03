//! main code to coordinate compilation process
const std = @import("std");
const Scanner = @import("front-end/scanner.zig").Scanner;
const Token = @import("front-end/token.zig").Token;
const Parser = @import("front-end/parser.zig");

/// main function that drives the whole compiler
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const stdout_file = std.io.getStdOut();
    var bw = std.io.bufferedWriter(stdout_file.writer());
    const stdout = bw.writer();

    switch (args.len) {
        1 => try help(stdout),
        2 => {
            const arg = args[1];
            if (std.mem.eql(u8, arg, "version")) {
                try version(stdout);
            } else if (std.mem.eql(u8, arg, "help")) {
                try help(stdout);
            } else {
                return error.InvalidCommand;
            }
        },
        3 => {
            const command = args[1];
            const file_path = args[2];
            if (!std.mem.eql(u8, command, "build")) {
                return error.InvalidCommand;
            }
            if (file_path.len < 4 or !std.mem.eql(u8, file_path[file_path.len - 4 ..], ".dgn")) {
                return error.InvalidFileExtension;
            }
            try compile(allocator, file_path);
        },
        else => return error.IncorrectUsage,
    }

    try bw.flush();
}

/// prints the help menu to STDOUT
fn help(stdout: anytype) !void {
    const message =
        \\Dragon compiler
        \\
        \\    Usage: dragon [COMMAND] [ARGUMENT]
        \\
        \\    Commands:
        \\        build [file].dgn        Compile the current package
        \\        help                    Display possible commands
        \\        version                 Display compiler version
        \\
    ;
    try stdout.print("{s}", .{message});
}

/// prints the version to STDOUT
fn version(stdout: anytype) !void {
    const version_message = "crawfish 1.0.0";
    try stdout.print("{s}\n", .{version_message});
}

/// attempts to compile the source code
fn compile(allocator: std.mem.Allocator, file_path: []const u8) !void {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_stat = try file.stat();
    const file_content = try file.readToEndAlloc(allocator, file_stat.size);
    defer allocator.free(file_content);

    // TODO: remove debug scanner
    var scanner = Scanner.init(file_content);
    var token: Token = scanner.next();
    while (token.token_type != Token.TokenType.Eof) {
        if (token.value) |value| {
            std.debug.print("The token type is {s} and the token value is {s}\n", .{ @tagName(token.token_type), value });
        } else {
            std.debug.print("The token type is {s} and the token value is {any}\n", .{ @tagName(token.token_type), token.value });
        }
        token = scanner.next();
    }
}

test {
    std.testing.refAllDecls(@This());
}
