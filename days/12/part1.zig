const std    = @import("std");
const fs     = std.fs;
const io     = std.io;
const stdout = io.getStdOut().writer();

pub fn rowContains(row: []const u8, ch: u8) bool {
	for (row) |col| {
		if (col == ch) {
			return true;
		}
	}
	return false;
}

pub fn count(row: []const u8, groups: []const usize) usize {
	if (groups.len == 0)
		return if (rowContains(row, '#')) 0 else 1;

	const len = groups[0];
	var   sum: usize = 0;
	for (row, 0..) |_, i| {
		if (row[i..].len < len or (i > 0 and row[i - 1] == '#')) {
			break;
		} else if (rowContains(row[i .. i + len], '.')) {
			continue;
		}

		if (row[i..].len > len) {
			if (row[i + len] == '#')
				continue;

			sum += count(row[i + len + 1..], groups[1..]);
		} else if (groups.len == 1) {
			sum += 1;
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
	var sum: usize   = 0;
	while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		var delim: usize = 0;
		for (line, 0..) |ch, i| {
			if (ch == ' ') {
				delim = i;
				break;
			}
		}
		const row = line[0 .. delim];

		var groups = std.ArrayList(usize).init(std.heap.page_allocator);
		defer groups.deinit();

		var len:    usize = 0;
		var strBuf: [3]u8 = undefined;
		for (line[delim + 1..]) |ch| {
			if (ch == ',') {
				try groups.append(try std.fmt.parseInt(usize, strBuf[0 .. len], 10));
				len = 0;
			} else {
				strBuf[len] = ch;
				len += 1;
			}
		}
		try groups.append(try std.fmt.parseInt(usize, strBuf[0 .. len], 10));

		sum += count(row, groups.items);
	}

	try stdout.print("{d}\n", .{sum});
}
