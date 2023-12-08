use std::io::{Read};
use std::fs::File;
use std::collections::HashMap;

fn read_file(path: &str) -> String {
	let (mut file, mut content) = (File::open(path).unwrap(), String::new());
	file.read_to_string(&mut content).unwrap();

	content
}

#[derive(Default, Clone)]
struct Node {
	left:  String,
	right: String,
}

fn parse_node(mut input: String) -> (String, Node) {
	let mut node: Node = Default::default();

	let name   = input.chars().take(3).collect();
	input      = input.chars().skip(input.find('(').unwrap() + 1).collect();
	node.left  = input.chars().take(3).collect();
	input      = input.chars().skip(input.find(' ').unwrap() + 1).collect();
	node.right = input.chars().take(3).collect();

	(name, node)
}

fn main() {
	let input = read_file("input.txt");
	let lines = input.split("\n").collect::<Vec<_>>();
	let steps = lines[0].to_string();

	let mut map: HashMap<String, Node> = HashMap::new();

	for line in lines[2..lines.len()].iter().filter(|&x| !x.is_empty()) {
		let (name, node) = parse_node(line.to_string());
		map.insert(name, node);
	}

	let mut sum = 1;
	let mut current: Node = map.entry("AAA".to_string()).or_default().clone();
	let mut i = 0;
	loop {
		let step = steps.as_bytes()[i] as char;
		i += 1;
		if i >= steps.len() {
			i = 0;
		}

		let name: String;
		if step == 'R' {
			name = current.right.clone();
		} else if step == 'L' {
			name = current.left.clone();
		} else {
			panic!("Unreachable");
		}

		if name == "ZZZ" {
			break;
		}

		current = map.entry(name).or_default().clone();
		sum += 1;
	}

	println!("{}", sum);
}
