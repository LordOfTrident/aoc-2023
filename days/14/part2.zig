const std    = @import("std");
const fs     = std.fs;
const io     = std.io;
const stdout = io.getStdOut().writer();

const allocator   = std.heap.page_allocator;
const String      = std.ArrayList(u8);
const StringArray = std.ArrayList(String);

pub fn rollRockY(board: *StringArray, x: usize, y: usize, dir: i32) void {
	if (board.items[y].items[x] != 'O')
		return;

	var fallY: i32 = @intCast(y);
	while ((if (dir < 0) fallY > 0 else fallY < board.items.len - 1)
	       and board.items[@intCast(fallY + dir)].items[x] == '.') {
		board.items[@intCast(fallY + dir)].items[x] = 'O';
		board.items[@intCast(fallY)].items[x] = '.';
		fallY += dir;
	}
}

pub fn rollRockX(board: *StringArray, x: usize, y: usize, dir: i32) void {
	if (board.items[y].items[x] != 'O')
		return;

	var fallX: i32 = @intCast(x);
	while ((if (dir < 0) fallX > 0 else fallX < board.items[0].items.len - 1)
	       and board.items[y].items[@intCast(fallX + dir)] == '.') {
		board.items[y].items[@intCast(fallX + dir)] = 'O';
		board.items[y].items[@intCast(fallX)] = '.';
		fallX += dir;
	}
}

pub fn rollRocks(board: *StringArray) void {
	const h = board.items.len;
	const w = board.items.len;

	for (0 .. w) |x| { // north
		for (1 .. h) |y|
			rollRockY(board, x, y, -1);
	}

	for (0 .. h) |y| { // west
		for (1 .. w) |x|
			rollRockX(board, x, y, -1);
	}

	for (0 .. w) |x| { // south
		for (1 .. h + 1) |y|
			rollRockY(board, x, h - y, 1);
	}

	for (0 .. h) |y| { // east
		for (1 .. w + 1) |x|
			rollRockX(board, w - x, y, 1);
	}
}

pub fn copyBoard(board: StringArray) !StringArray {
	var copied = StringArray.init(allocator);
	for (board.items) |row| {
		var copy = String.init(allocator);
		try copy.appendSlice(row.items);
		try copied.append(copy);
	}
	return copied;
}

pub fn areBoardsEqual(a: StringArray, b: StringArray) bool {
	var equals = true;
	for (0 .. a.items.len) |y| {
		for (0 .. a.items[0].items.len) |x| {
			if (a.items[y].items[x] != b.items[y].items[x]) {
				equals = false;
				break;
			}
		}
		if (!equals)
			break;
	}
	return equals;
}

pub fn boardNorthLoad(board: StringArray) usize {
	var sum: usize = 0;
	for (board.items, 0..) |row, i| {
		for (row.items) |tile| {
			if (tile == 'O')
				sum += board.items.len - i;
		}
	}
	return sum;
}

pub fn main() !void {
	var file = try fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var reader = io.bufferedReader(file.reader());
	var stream = reader.reader();
	var buf: [256]u8 = undefined;

	var board = StringArray.init(allocator);
	defer board.deinit();

	while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		var row = String.init(allocator);
		try row.appendSlice(line);
		try board.append(row);
	}

	const cycles: usize = 1000000000;

	var cache = std.ArrayList(StringArray).init(allocator);
	defer cache.deinit();

	var finalStatePos: usize = 0;
	for (0 .. cycles) |n| {
		var foundRepetition = false;
		for (cache.items, 0..) |cached, pos| {
			if (areBoardsEqual(board, cached)) {
				foundRepetition = true;
				finalStatePos = pos + (cycles - pos) % (n - pos);
				break;
			}
		}

		if (foundRepetition)
			break;

		try cache.append(try copyBoard(board));
		rollRocks(&board);
	}

	try stdout.print("{d}\n", .{boardNorthLoad(cache.items[finalStatePos])});
}
