const std    = @import("std");
const fs     = std.fs;
const io     = std.io;
const stdout = io.getStdOut().writer();

const allocator   = std.heap.page_allocator;
const String      = std.ArrayList(u8);
const StringArray = std.ArrayList(String);

pub fn tryVPatternAt(pattern: []String, at: usize) usize {
	if (at < 0 or at >= pattern.len - 1)
		return 0;

	var smudgeRemoved = false;
	for (0 .. pattern.len) |i| {
		if (at < i or at + i + 1 >= pattern.len)
			break;

		const y1 = at - i;
		const y2 = at + i + 1;

		for (0 .. pattern[0].items.len) |x| {
			if (pattern[y1].items[x] != pattern[y2].items[x]) {
				if (smudgeRemoved) {
					return 0;
				} else {
					smudgeRemoved = true;
				}
			}
		}
	}

	return if (smudgeRemoved) at + 1 else 0;
}

pub fn findVPattern(pattern: []String) usize {
	const half = pattern.len / 2;
	for (0 .. half + 1) |i| {
		var count = tryVPatternAt(pattern, half - i);
		if (count == 0)
			count = tryVPatternAt(pattern, half + i + 1);

		if (count != 0)
			return count;
	}

	return 0;
}

pub fn tryHPatternAt(pattern: []String, at: usize) usize {
	if (at < 0 or at >= pattern[0].items.len - 1)
		return 0;

	var smudgeRemoved = false;
	for (0 .. pattern[0].items.len) |i| {
		if (at < i or at + i + 1 >= pattern[0].items.len)
			break;

		const x1 = at - i;
		const x2 = at + i + 1;

		for (0 .. pattern.len) |y| {
			if (pattern[y].items[x1] != pattern[y].items[x2]) {
				if (smudgeRemoved) {
					return 0;
				} else {
					smudgeRemoved = true;
				}
			}
		}
	}

	return if (smudgeRemoved) at + 1 else 0;
}

pub fn findHPattern(pattern: []String) usize {
	const half = pattern[0].items.len / 2;
	for (0 .. half + 1) |i| {
		var count = tryHPatternAt(pattern, half - i);
		if (count == 0)
			count = tryHPatternAt(pattern, half + i + 1);

		if (count != 0)
			return count;
	}

	return 0;
}

pub fn findPattern(pattern: []String) usize {
	var value = findHPattern(pattern);
	if (value == 0)
		value = findVPattern(pattern) * 100;

	return value;
}

pub fn main() !void {
	var file = try fs.cwd().openFile("input.txt", .{});
	defer file.close();

	var reader = io.bufferedReader(file.reader());
	var stream = reader.reader();
	var buf: [256]u8 = undefined;

	var pattern = StringArray.init(allocator);
	defer pattern.deinit();

	var sum: usize = 0;
	while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			sum += findPattern(pattern.items);

			pattern.deinit();
			pattern = StringArray.init(allocator);
		} else {
			var value = String.init(allocator);
			try value.appendSlice(line);
			try pattern.append(value);
		}
	}

	sum += findPattern(pattern.items);

	try stdout.print("{d}\n", .{sum});
}
