// EXERCISE 7 — References & Borrowing
//
// Instead of taking ownership, functions can *borrow* a value via a reference.
// The function uses the value without consuming it — the caller keeps ownership.
//
//   fn length(s: &String) -> usize {  // borrows s
//       s.len()
//   }
//   let s = String::from("hello");
//   let n = length(&s);  // s is still valid here
//
// In practice, prefer &str over &String for string parameters — &str is more
// flexible (accepts both &String and string literals).
//
// Implement `first_word`: return a slice of the first word in the string.
// If there's no space, the whole string is the first word.
//
// A slice `&str` is a reference to part of a string — it borrows from
// the original without copying.

pub fn first_word(s: &str) -> &str {
    // Hint: use s.find(' ') to locate the first space.
    // find() returns Option<usize>.
    // &s[..pos] gives you the slice up to (not including) pos.
    todo!()
}

pub fn word_count(s: &str) -> usize {
    // Return the number of words (space-separated tokens).
    // Hint: s.split_whitespace() gives an iterator over words.
    // Iterator::count() gives the count.
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_first_word() {
        assert_eq!(first_word("hello world"), "hello");
        assert_eq!(first_word("hello"), "hello");
        assert_eq!(first_word("one two three"), "one");
        assert_eq!(first_word(""), "");
    }

    #[test]
    fn test_word_count() {
        assert_eq!(word_count("hello world"), 2);
        assert_eq!(word_count("one"), 1);
        assert_eq!(word_count(""), 0);
        assert_eq!(word_count("  spaces  "), 1);
        assert_eq!(word_count("a b c d"), 4);
    }
}
