// EXERCISE 5 — Ownership: Move Semantics
//
// `String` does not implement `Copy`. When you assign a String to another
// variable or pass it to a function, ownership *moves* — the original
// binding becomes invalid.
//
//   let s = String::from("hello");
//   let t = s;          // s is moved into t
//   println!("{}", s);  // ERROR: s was moved
//
// This code won't compile. The function `process` passes `s` to
// `get_length`, which moves it, and then tries to use `s` again.
//
// Fix it. You have two options:
//   A) Get what you need from `s` BEFORE moving it (reorder the lines)
//   B) Change `get_length` to borrow instead of taking ownership
//
// Either fix is valid. Pick the one that feels more natural.

pub struct Container {
    pub value: String,
}

fn get_length(s: String) -> usize {
    s.len()
}

pub fn process(s: String) -> (Container, usize) {
    let container = Container { value: s };  // s is moved here
    let len = get_length(s);                 // ERROR: s was already moved
    (container, len)
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let (container, len) = process(String::from("hello"));
        assert_eq!(container.value, "hello");
        assert_eq!(len, 5);
    }

    #[test]
    fn test_process_empty() {
        let (container, len) = process(String::from(""));
        assert_eq!(container.value, "");
        assert_eq!(len, 0);
    }
}
