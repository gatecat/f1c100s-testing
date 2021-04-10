use std::io::{self, Write, BufRead};
use libc::reboot as libc_reboot;

type Command = fn(&[&str]) -> u32;

fn echo(args: &[&str]) -> u32 {
	for part in args {
		print!("{} ", part);
	}
	println!();
	0
}

fn reboot(_: &[&str]) -> u32 {
	unsafe { libc_reboot(0x1234567); }
	0
}

const CMDS : &[(&str, Command)] = &[
	("echo", echo),
	("reboot", reboot),
];

fn main() {
	println!("Hello, world!");
	let mut line = String::new();
	let stdin = io::stdin();
	loop {
		print!("# ");
		io::stdout().flush().unwrap();
		line.clear();
		stdin.lock().read_line(&mut line).unwrap();
		let args: Vec<&str> = line.trim().split(' ').collect();
		if args.is_empty() || args[0].is_empty() { continue; }
		if let Some((_, func)) = CMDS.iter().find(|(c, _)| *c == args[0]) {
			func(&args[1..]);
		} else {
			println!("Unknown command '{}'", args[0]);
		}
	}
}
