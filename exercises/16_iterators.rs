// EXERCISE 16 — Iterators & Closures
//
// Iterators in Rust are lazy — they do nothing until consumed.
// Adaptor methods transform the iterator; consumers force evaluation.
//
//   let doubled: Vec<i32> = vec![1, 2, 3]
//       .iter()
//       .map(|&x| x * 2)     // adaptor: transform each element
//       .collect();           // consumer: gather into Vec
//
// Common adaptors: map, filter, flat_map, take, skip, enumerate, zip
// Common consumers: collect, sum, count, fold, any, all, find, for_each
//
// Closures capture their environment:
//   let threshold = 5;
//   let big: Vec<_> = v.iter().filter(|&&x| x > threshold).collect();
//
// Implement each function using iterators — no explicit loops.

pub fn double_positives(v: &[i32]) -> Vec<i32> {
    // Keep only positive numbers, then double each one.
    todo!()
}

pub fn sum_squares(v: &[i32]) -> i32 {
    // Return the sum of the squares of all elements.
    todo!()
}

pub fn words_longer_than(words: &[&str], min_len: usize) -> Vec<String> {
    // Return words whose length is > min_len, converted to uppercase.
    // Hint: .filter(...).map(...).collect()
    todo!()
}

pub fn running_total(v: &[i32]) -> Vec<i32> {
    // Return a new vec where each element is the sum of all elements up to
    // and including that index.
    // Input:  [1, 2, 3, 4]
    // Output: [1, 3, 6, 10]
    // Hint: scan is like fold but yields each intermediate accumulator.
    //   .scan(0, |acc, &x| { *acc += x; Some(*acc) })
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_double_positives() {
        assert_eq!(double_positives(&[1, -2, 3, -4, 5]), vec![2, 6, 10]);
        assert_eq!(double_positives(&[-1, -2]), Vec::<i32>::new());
        assert_eq!(double_positives(&[0, 1, 2]), vec![2, 4]);
    }

    #[test]
    fn test_sum_squares() {
        assert_eq!(sum_squares(&[1, 2, 3]), 14);  // 1+4+9
        assert_eq!(sum_squares(&[]),        0);
        assert_eq!(sum_squares(&[-3]),      9);
    }

    #[test]
    fn test_words_longer_than() {
        let words = vec!["hi", "hello", "rust", "a", "world"];
        assert_eq!(
            words_longer_than(&words, 3),
            vec!["HELLO", "WORLD"]
        );
    }

    #[test]
    fn test_running_total() {
        assert_eq!(running_total(&[1, 2, 3, 4]), vec![1, 3, 6, 10]);
        assert_eq!(running_total(&[5]),          vec![5]);
        assert_eq!(running_total(&[]),           Vec::<i32>::new());
    }
}
