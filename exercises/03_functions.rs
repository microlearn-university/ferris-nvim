// EXERCISE 3 — Functions & Return Values
//
// In Rust, the last expression in a function body is automatically returned —
// no `return` keyword needed (though `return` is valid for early returns).
//
//   fn double(x: i32) -> i32 {
//       x * 2       // no semicolon = return value
//   }
//
// Note: adding a semicolon turns the expression into a statement,
// which returns () (unit) — probably not what you want.
//
// Implement both functions. Neither needs a `return` keyword.

pub fn celsius_to_fahrenheit(c: f64) -> f64 {
    // Formula: F = C × 9/5 + 32
    todo!()
}

pub fn is_leap_year(year: u32) -> bool {
    // Divisible by 4, except centuries, except 400-year centuries.
    // A year is a leap year if:
    //   (divisible by 4 AND NOT divisible by 100) OR (divisible by 400)
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_celsius() {
        assert_eq!(celsius_to_fahrenheit(0.0), 32.0);
        assert_eq!(celsius_to_fahrenheit(100.0), 212.0);
        assert_eq!(celsius_to_fahrenheit(-40.0), -40.0);
    }

    #[test]
    fn test_leap_year() {
        assert!(is_leap_year(2000));   // 400-year century
        assert!(is_leap_year(2024));   // divisible by 4
        assert!(!is_leap_year(1900));  // century, not 400-year
        assert!(!is_leap_year(2023));  // not divisible by 4
    }
}
