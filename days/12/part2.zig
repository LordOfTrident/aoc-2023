const std    = @import("std");
const fs     = std.fs;
const io     = std.io;
const math   = std.math;
const stdout = io.getStdOut().writer();

const allocator = std.heap.page_allocator;

pub fn rowContains(row: []const u8, ch: u8) bool {
	for (row) |col| {
		if (col == ch) {
			return true;
		}
	}
	return false;
}

pub fn count(memo: [][]usize, row: []const u8, groups: []const usize) usize {
	if (memo[row.len][groups.len] != math.maxInt(usize)) {
		return memo[row.len][groups.len];
	} else if (groups.len == 0) {
		const ret: usize = if (rowContains(row, '#')) 0 else 1;
		memo[row.len][groups.len] = ret;
		return ret;
	}

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

			sum += count(memo, row[i + len + 1..], groups[1..]);
		} else if (groups.len == 1) {
			sum += 1;
		}
	}

	memo[row.len][groups.len] = sum;
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
		const rowLen = line[0 .. delim].len;
		const row = try allocator.alloc(u8, (rowLen + 1) * 5 - 1);
		for (0 .. 5) |n| {
			const calc = (rowLen + 1) * n;
			@memcpy(row[calc .. calc + rowLen], line[0 .. delim]);

			if (n < 4)
				@memcpy(row[calc + rowLen .. calc + rowLen + 1], "?");
		}

		var groups = std.ArrayList(usize).init(allocator);
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

		const groupsLen = groups.items.len;
		for (0 .. 4) |_| {
			for (groups.items[0 .. groupsLen]) |group| {
				try groups.append(group);
			}
		}

		const memo = try allocator.alloc([]usize, row.len + 1);
		for (0 .. memo.len) |i| {
			memo[i] = try allocator.alloc(usize, groups.items.len + 1);
			@memset(memo[i], math.maxInt(usize));
		}

		sum += count(memo, row, groups.items);
	}

	try stdout.print("{d}\n", .{sum});
}
