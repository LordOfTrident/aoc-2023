const std    = @import("std");
const fs     = std.fs;
const io     = std.io;
const stdout = io.getStdOut().writer();

const allocator   = std.heap.page_allocator;
const String      = std.ArrayList(u8);
const StringArray = std.ArrayList(String);

pub fn rollRock(board: *StringArray, x: usize, y: usize) void {
	var fallY = y;
	while (fallY > 0 and board.items[fallY - 1].items[x] == '.') {
		board.items[fallY - 1].items[x] = 'O';
		board.items[fallY].items[x] = '.';
		fallY -= 1;
	}
}

pub fn rollRocks(board: *StringArray) void {
	const h = board.items.len;
	const w = board.items.len;

	for (0 .. w) |x| {
		for (1 .. h) |y| {
			if (board.items[y].items[x] == 'O')
				rollRock(board, x, y);
		}
	}
}

pub fn main() !void {
	var file = try fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var reader = io.bufferedReader(file.reader());
	var stream = reader.reader();
	var buf: [256]u8 = undefined;

	var board = StringArray.init(allocator);
	defer board.deinit();

	var sum: usize = 0;
	while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		var row = String.init(allocator);
		try row.appendSlice(line);
		try board.append(row);
	}

	rollRocks(&board);

	for (board.items, 0..) |row, i| {
		for (row.items) |tile| {
			if (tile == 'O')
				sum += board.items.len - i;
		}
	}

	try stdout.print("{d}\n", .{sum});
}
