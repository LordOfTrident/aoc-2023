use std::io::{Read};
use std::fs::File;
use std::cmp::Ordering;
use std::collections::HashMap;

const LABELS: [char; 13] = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'];

fn read_file(path: &str) -> String {
	let (mut file, mut content) = (File::open(path).unwrap(), String::new());
	file.read_to_string(&mut content).unwrap();

	content
}

struct Hand {
	cards: String,
	bid:   i32,
}

fn parse_hands(lines: &Vec<&str>) -> Vec<Hand> {
	let mut hands: Vec<Hand> = vec![];
	for line in lines {
		let split = line.split(" ").collect::<Vec<_>>();
		hands.push(Hand{cards: split[0].to_string(), bid: split[1].parse::<i32>().unwrap()});
	}

	hands
}

fn card_value(card: char) -> u8 {
	for (i, label) in LABELS.iter().enumerate() {
		if card == *label {
			return i as u8;
		}
	}

	panic!("Unreachable");
}

#[derive(Debug, Copy, Clone)]
enum HandType {
	HighCard,
	OnePair,
	TwoPair,
	ThreeOfKind,
	FullHouse,
	FourOfKind,
	FiveOfKind,
}

impl Hand {
	// ------------------------------------- Close your eyes -------------------------------------
	fn find_type(&self) -> HandType {
		let mut map: HashMap<char, usize> = HashMap::new();

		for card in self.cards.chars() {
			*map.entry(card.to_owned()).or_default() += 1;
		}

		let mut two_share   = 0;
		let mut three_share = 0;
		let mut four_share  = 0;
		for (char, count) in &map {
			if *count == 5 || (*char == 'J' && *count == 4) {
				return HandType::FiveOfKind;
			} else if *count == 4 {
				four_share += 1
			} else if *count == 3 {
				three_share += 1;
			} else if *count == 2 {
				two_share += 1;
			}
		}

		let mut hand_type             = HandType::HighCard;
		let mut hand_type_with_jokers = HandType::HighCard;

		let jokers = *map.entry('J').or_default();
		if jokers > 0 {
			if (two_share   == 1 && jokers == 3) || jokers == 4 ||
			   (three_share == 1 && jokers == 2) || jokers == 5 ||
			   (four_share  == 1 && jokers == 1) {
				hand_type_with_jokers = HandType::FiveOfKind;
			} else if (three_share == 1 && jokers == 1) || jokers == 3 ||
			          (two_share   == 2 && jokers == 2) {
				hand_type_with_jokers = HandType::FourOfKind;
			} else if two_share == 2 && jokers == 1 {
				hand_type_with_jokers = HandType::FullHouse;
			} else if (two_share == 1 && jokers == 1) || (jokers == 2) {
				hand_type_with_jokers = HandType::ThreeOfKind;
			}
		}

		if four_share == 1 {
			hand_type = HandType::FourOfKind;
		} else if three_share == 1 && two_share == 1 {
			hand_type = HandType::FullHouse;
		} else if three_share == 1 && two_share == 0 {
			hand_type = HandType::ThreeOfKind;
		} else if two_share == 2 {
			hand_type = HandType::TwoPair;
		} else if two_share == 1 || jokers == 1 {
			hand_type = HandType::OnePair;
		}

		if (hand_type_with_jokers as u8) > (hand_type as u8) {
			return hand_type_with_jokers;
		} else {
			return hand_type;
		}
	}
}

fn compare_hands(a: &Hand, b: &Hand) -> Ordering {
	let a_type = a.find_type();
	let b_type = b.find_type();
	if (a_type as u8) > (b_type as u8) {
		return Ordering::Greater;
	} else if (a_type as u8) < (b_type as u8) {
		return Ordering::Less;
	}

	for (card_a, card_b) in a.cards.chars().zip(b.cards.chars()) {
		let a_value = card_value(card_a);
		let b_value = card_value(card_b);
		if a_value > b_value {
			return Ordering::Less;
		} else if a_value < b_value {
			return Ordering::Greater;
		}
	}

	panic!("Unreachable");
}

fn main() {
	let input = read_file("input.txt");
	let lines = input.split("\n").filter(|&x| !x.is_empty()).collect::<Vec<_>>();

	let mut hands: Vec<Hand> = parse_hands(&lines);

	hands.sort_by(|a, b| compare_hands(a, b));

	let mut sum = 0;
	for (rank, hand) in hands.iter().enumerate() {
		sum += ((rank + 1) as i32) * hand.bid;
	}

	println!("{}", sum);
}
