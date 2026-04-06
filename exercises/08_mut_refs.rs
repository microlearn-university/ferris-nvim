// EXERCISE 8 — Mutable References
//
// The borrow checker enforces one rule:
//   At any point, you can have EITHER:
//     - one mutable reference, OR
//     - any number of immutable references
//   …but NOT both at the same time.
//
// This prevents data races: if someone could mutate a Vec while you hold a
// reference into it, a reallocation could leave your reference dangling.
//
// The code below won't compile. `first` is an immutable reference into `v`.
// `v.push(...)` is a mutable borrow of `v`. Both are alive at the same time.
//
// Fix `push_and_get_first` — copy the value out before the push.
// Change `&v[0]` to `v[0]` (i32 is Copy, so this is a copy, not a borrow).

pub fn push_and_get_first(v: &mut Vec<i32>, new_val: i32) -> i32 {
    let first = &v[0];   // immutable borrow of v — a reference into the vec
    v.push(new_val);     // ERROR: mutable borrow while reference `first` is alive
    *first               // reference still used here — vec may have been reallocated!
}

// Implement this: append `n` copies of `value` to the vector.
pub fn fill(v: &mut Vec<i32>, value: i32, n: usize) {
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_push_and_get_first() {
        let mut v = vec![10, 20, 30];
        let first = push_and_get_first(&mut v, 99);
        assert_eq!(first, 10);
        assert_eq!(v, vec![10, 20, 30, 99]);
    }

    #[test]
    fn test_push_empty_vec() {
        // When vec is empty, &v[0] would panic — but after your fix, that
        // won't matter for this test since the vec starts non-empty.
        let mut v = vec![42];
        let first = push_and_get_first(&mut v, 1);
        assert_eq!(first, 42);
    }

    #[test]
    fn test_fill() {
        let mut v = vec![1, 2];
        fill(&mut v, 9, 3);
        assert_eq!(v, vec![1, 2, 9, 9, 9]);
    }

    #[test]
    fn test_fill_zero() {
        let mut v = vec![1];
        fill(&mut v, 9, 0);
        assert_eq!(v, vec![1]);
    }
}
