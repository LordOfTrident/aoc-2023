use std::io::{Read};
use std::fs::File;

fn read_file(path: &str) -> String {
	let (mut file, mut content) = (File::open(path).unwrap(), String::new());
	file.read_to_string(&mut content).unwrap();

	content
}

fn parse_number(mut input: String) -> i64 {
	input = input.chars().skip(input.find(':').unwrap() + 1).collect();

	let mut string: String = Default::default();
	for part in input.split(" ").filter(|&x| !x.is_empty()) {
		string += part;
	}

	string.parse::<i64>().unwrap()
}

fn main() {
	let input = read_file("input.txt");
	let lines = input.split("\n").collect::<Vec<_>>();
	let (time, dist) = (parse_number(lines[0].to_string()), parse_number(lines[1].to_string()));

	let mut count = 0;
	for button_time in 1 .. time {
		if (time - button_time) * button_time > dist {
			count += 1;
		}
	}

	println!("{}", count);
}
