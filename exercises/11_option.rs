// EXERCISE 11 — Option<T>
//
// Option<T> represents a value that may or may not be present.
//   Some(value)  — something is there
//   None         — nothing is there
//
// It replaces null/nil. The compiler forces you to handle both cases.
//
//   let v = vec![1, 2, 3];
//   let first: Option<&i32> = v.first();
//   match first {
//       Some(n) => println!("first: {}", n),
//       None    => println!("empty"),
//   }
//
// Useful Option methods:
//   opt.unwrap_or(default)    — value or a fallback
//   opt.map(|x| x * 2)       — transform the inner value if Some
//   opt.is_some() / is_none() — check which variant

pub fn find_first_even(numbers: &[i32]) -> Option<i32> {
    // Return the first even number, or None if there are no even numbers.
    todo!()
}

pub fn safe_divide(a: f64, b: f64) -> Option<f64> {
    // Return Some(a / b), or None if b is zero.
    todo!()
}

pub fn last_word(s: &str) -> Option<&str> {
    // Return the last whitespace-separated word, or None if the string is empty.
    // Hint: s.split_whitespace().last()
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_first_even() {
        assert_eq!(find_first_even(&[1, 3, 4, 6]), Some(4));
        assert_eq!(find_first_even(&[2, 3, 5]),    Some(2));
        assert_eq!(find_first_even(&[1, 3, 5]),    None);
        assert_eq!(find_first_even(&[]),            None);
    }

    #[test]
    fn test_safe_divide() {
        assert_eq!(safe_divide(10.0, 2.0), Some(5.0));
        assert_eq!(safe_divide(7.0, 0.0),  None);
    }

    #[test]
    fn test_last_word() {
        assert_eq!(last_word("hello world"), Some("world"));
        assert_eq!(last_word("one"),         Some("one"));
        assert_eq!(last_word(""),            None);
        assert_eq!(last_word("  "),          None);
    }
}
