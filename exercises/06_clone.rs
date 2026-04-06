// EXERCISE 6 — Clone
//
// When you need two independent copies of a non-Copy type, use `.clone()`.
// Unlike C++, Rust never clones implicitly — you opt in explicitly.
//
//   let s = String::from("hello");
//   let t = s.clone();  // t is an independent copy
//   println!("{} {}", s, t);  // both valid
//
// `clone()` can be expensive (it allocates new memory), so Rust makes you
// be explicit about it.
//
// Implement `send_to_both` without changing the signatures of
// `send_to_alice` or `send_to_bob`. Both functions take ownership.

fn send_to_alice(msg: String) -> String {
    format!("Alice received: {}", msg)
}

fn send_to_bob(msg: String) -> String {
    format!("Bob received: {}", msg)
}

pub fn send_to_both(msg: String) -> (String, String) {
    // TODO: call both functions. The first call will move `msg`,
    // so you need a clone for one of them.
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_send_to_both() {
        let (a, b) = send_to_both(String::from("hello"));
        assert_eq!(a, "Alice received: hello");
        assert_eq!(b, "Bob received: hello");
    }

    #[test]
    fn test_send_to_both_empty() {
        let (a, b) = send_to_both(String::from(""));
        assert_eq!(a, "Alice received: ");
        assert_eq!(b, "Bob received: ");
    }
}
