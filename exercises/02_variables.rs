// EXERCISE 2 — Variables & Mutability
//
// In Rust, variables are immutable by default. This code will not compile
// because `count` is being reassigned but was not declared mutable.
//
// Fix it by adding `mut` in the right place.
//
// Only variables being reassigned need `mut`. The rest can stay immutable.

pub fn count_up(n: u32) -> u32 {
    let count = 0u32;   // TODO: make this mutable
    let mut i = 0u32;
    while i < n {
        count = count + 1;
        i += 1;
    }
    count
}

pub fn sum_to(n: u32) -> u32 {
    let total = 0u32;   // TODO: make this mutable too
    let mut i = 1u32;
    while i <= n {
        total += i;
        i += 1;
    }
    total
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_count_up() {
        assert_eq!(count_up(0), 0);
        assert_eq!(count_up(1), 1);
        assert_eq!(count_up(5), 5);
    }

    #[test]
    fn test_sum_to() {
        assert_eq!(sum_to(0), 0);
        assert_eq!(sum_to(4), 10);  // 1+2+3+4
        assert_eq!(sum_to(10), 55);
    }
}
