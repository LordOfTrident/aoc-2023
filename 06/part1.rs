use std::io::{Read};
use std::fs::File;

fn read_file(path: &str) -> String {
	let (mut file, mut content) = (File::open(path).unwrap(), String::new());
	file.read_to_string(&mut content).unwrap();

	content
}

fn parse_list(mut input: String) -> Vec<i32> {
	input = input.chars().skip(input.find(':').unwrap() + 1).collect();

	let mut result: Vec<i32> = vec![];
	for part in input.split(" ").filter(|&x| !x.is_empty()) {
		result.push(part.parse::<i32>().unwrap())
	}

	result
}

fn main() {
	let input = read_file("input.txt");
	let lines = input.split("\n").collect::<Vec<_>>();
	let (times, dists) = (parse_list(lines[0].to_string()), parse_list(lines[1].to_string()));

	let mut result = 1;
	for (time, dist) in times.iter().zip(dists.iter()) {
		let mut count = 0;
		for button_time in 1 .. *time {
			if (time - button_time) * button_time > *dist {
				count += 1;
			}
		}

		result *= count;
	}

	println!("{}", result);
}
