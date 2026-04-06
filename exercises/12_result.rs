// EXERCISE 12 — Result<T, E>
//
// Result<T, E> represents success or failure:
//   Ok(value)  — it worked, here's the value
//   Err(error) — it failed, here's why
//
// Like Option, you must handle both cases. Panicking on errors (unwrap)
// is fine in tests and prototypes but not in production code.
//
//   fn parse_int(s: &str) -> Result<i32, String> {
//       s.parse::<i32>().map_err(|e| e.to_string())
//   }
//
// Implement these functions. Return descriptive error strings.

pub fn parse_positive(s: &str) -> Result<u64, String> {
    // Parse `s` as a positive integer (> 0).
    // Return Err if it's not a valid integer, or if it's zero or negative.
    //
    // s.parse::<i64>() returns Result<i64, ParseIntError>
    // .map_err(|e| e.to_string()) converts the error to String
    todo!()
}

pub fn divide(a: f64, b: f64) -> Result<f64, String> {
    // Return Ok(a / b) or Err("division by zero") if b is zero.
    todo!()
}

pub fn nth(v: &[i32], idx: usize) -> Result<i32, String> {
    // Return Ok(v[idx]) or a descriptive Err if idx is out of bounds.
    // Do NOT use v[idx] directly — that panics. Use v.get(idx).
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_positive() {
        assert_eq!(parse_positive("42"), Ok(42));
        assert!(parse_positive("0").is_err());
        assert!(parse_positive("-5").is_err());
        assert!(parse_positive("abc").is_err());
        assert_eq!(parse_positive("1000000"), Ok(1_000_000));
    }

    #[test]
    fn test_divide() {
        assert_eq!(divide(10.0, 2.0), Ok(5.0));
        assert!(divide(1.0, 0.0).is_err());
    }

    #[test]
    fn test_nth() {
        let v = vec![10, 20, 30];
        assert_eq!(nth(&v, 0), Ok(10));
        assert_eq!(nth(&v, 2), Ok(30));
        assert!(nth(&v, 5).is_err());
        assert!(nth(&[], 0).is_err());
    }
}
