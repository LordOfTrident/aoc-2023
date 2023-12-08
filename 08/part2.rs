use std::io::{Read};
use std::fs::File;
use std::collections::HashMap;

fn gcd(first: usize, second: usize) -> usize {
	let mut max = first;
	let mut min = second;
	if min > max {
		let val = max;
		max = min;
		min = val;
	}

	loop {
		let res = max % min;
		if res == 0 {
			return min;
		}

		max = min;
		min = res;
	}
}

fn lcm(first: usize, second: usize) -> usize {
	first * second / gcd(first, second)
}

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

	let mut current_nodes: Vec<Node> = vec![];
	for line in lines[2..lines.len()].iter().filter(|&x| !x.is_empty()) {
		let (name, node) = parse_node(line.to_string());

		if (name.as_bytes()[2] as char) == 'A' {
			current_nodes.push(node.clone());
		}

		map.insert(name, node);
	}

	let (mut i, mut stepNum) = (0, 1);
	let mut periods: Vec<usize> = vec![0; current_nodes.len()];
	let mut at_end_count = 0;
	while at_end_count < periods.len() {
		let step = steps.as_bytes()[i] as char;
		i += 1;
		if i >= steps.len() {
			i = 0;
		}

		for pos in 0..periods.len() {
			if periods[pos] != 0 {
				continue;
			}

			let current = &mut current_nodes[pos];

			let name: String;
			if step == 'R' {
				name = current.right.clone();
			} else if step == 'L' {
				name = current.left.clone();
			} else {
				panic!("Unreachable");
			}

			if (name.as_bytes()[2] as char) == 'Z' {
				periods[pos] = stepNum;
				at_end_count += 1;
				continue;
			}

			*current = map.entry(name).or_default().clone();
		}

		stepNum += 1;
	}

	let mut num = periods[0];
	for period in periods {
		num = lcm(period, num);
	}

	println!("{}", num);
}
