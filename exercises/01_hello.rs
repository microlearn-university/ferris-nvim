// EXERCISE 1 — Hello, Rust!
//
// Implement `greeting` so it returns "Hello, {name}!" as a String.
//
//   greeting("Ferris")  →  "Hello, Ferris!"
//   greeting("world")   →  "Hello, world!"
//
// The `format!` macro builds a String from a template:
//   format!("The value is {}", x)
//
// Unlike `println!`, `format!` returns the String instead of printing it.

pub fn greeting(name: &str) -> String {
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────
// Make these pass. Do not edit below this line.

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ferris() {
        assert_eq!(greeting("Ferris"), "Hello, Ferris!");
    }

    #[test]
    fn test_world() {
        assert_eq!(greeting("world"), "Hello, world!");
    }

    #[test]
    fn test_empty() {
        assert_eq!(greeting(""), "Hello, !");
    }
}
