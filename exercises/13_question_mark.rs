// EXERCISE 13 — The ? Operator
//
// The `?` operator short-circuits on errors: if the expression is Err,
// it returns that Err from the current function. If it's Ok, it unwraps.
//
//   fn read_number(s: &str) -> Result<i32, String> {
//       let n = s.trim().parse::<i32>().map_err(|e| e.to_string())?;
//       //                                                          ^
//       //  if parse fails → return Err immediately
//       //  if parse succeeds → n gets the i32 value
//       Ok(n * 2)
//   }
//
// The function's return type must be Result (or Option) for ? to work.
//
// Implement these functions using ? — avoid explicit match expressions.

pub fn parse_and_double(s: &str) -> Result<i32, String> {
    // Parse s as i32, double it, return it.
    // Use ? to propagate parse errors. Use .map_err(|e| e.to_string()).
    todo!()
}

pub fn parse_and_add(a: &str, b: &str) -> Result<i32, String> {
    // Parse both strings as i32 and return their sum.
    // Use ? twice. If either parse fails, propagate the error.
    todo!()
}

pub fn find_and_double(v: &[i32], idx: usize) -> Option<i32> {
    // ? also works with Option. Return None if idx is out of bounds,
    // otherwise return Some(v[idx] * 2).
    // Hint: v.get(idx) returns Option<&i32>. Use ? to unwrap or return None.
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_and_double() {
        assert_eq!(parse_and_double("5"),   Ok(10));
        assert_eq!(parse_and_double("-3"),  Ok(-6));
        assert!(parse_and_double("abc").is_err());
    }

    #[test]
    fn test_parse_and_add() {
        assert_eq!(parse_and_add("3", "4"), Ok(7));
        assert!(parse_and_add("x", "4").is_err());
        assert!(parse_and_add("3", "y").is_err());
    }

    #[test]
    fn test_find_and_double() {
        let v = vec![10, 20, 30];
        assert_eq!(find_and_double(&v, 1), Some(40));
        assert_eq!(find_and_double(&v, 5), None);
        assert_eq!(find_and_double(&[], 0), None);
    }
}
