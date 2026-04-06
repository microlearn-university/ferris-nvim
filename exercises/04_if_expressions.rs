// EXERCISE 4 — if as an Expression
//
// In Rust, `if` is an expression — it produces a value and can be used
// anywhere an expression is expected:
//
//   let label = if score > 90 { "A" } else { "B" };
//
// Both branches must produce the same type, and you don't need a semicolon
// after the closing brace when using it as a value.
//
// Implement fizz_buzz using if/else if/else. Return a String.
// - Divisible by both 3 and 5 → "FizzBuzz"
// - Divisible by 3             → "Fizz"
// - Divisible by 5             → "Buzz"
// - Otherwise                  → the number as a string

pub fn fizz_buzz(n: u32) -> String {
    todo!()
}

// Also implement this one using an if expression (not a match).
// Return the absolute value of n.
pub fn absolute_value(n: i32) -> i32 {
    todo!()
    // Hint: if n < 0 { ... } else { ... }
    // Don't use n.abs() — the point is to use an if expression.
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fizz_buzz() {
        assert_eq!(fizz_buzz(1),  "1");
        assert_eq!(fizz_buzz(3),  "Fizz");
        assert_eq!(fizz_buzz(5),  "Buzz");
        assert_eq!(fizz_buzz(15), "FizzBuzz");
        assert_eq!(fizz_buzz(7),  "7");
        assert_eq!(fizz_buzz(30), "FizzBuzz");
    }

    #[test]
    fn test_absolute_value() {
        assert_eq!(absolute_value(5),    5);
        assert_eq!(absolute_value(-5),   5);
        assert_eq!(absolute_value(0),    0);
        assert_eq!(absolute_value(-100), 100);
    }
}
