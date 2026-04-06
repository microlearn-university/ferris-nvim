// EXERCISE 17 — Lifetime Annotations
//
// Every reference has a lifetime. Usually the compiler infers it (elision).
// When it can't — typically when a function takes multiple references and
// returns one — you annotate.
//
// A lifetime annotation names a relationship, it doesn't change how long
// anything lives. `'a` says "these references are related: the output
// lives at most as long as the shorter-lived input."
//
//   fn longer<'a>(x: &'a str, y: &'a str) -> &'a str {
//       if x.len() >= y.len() { x } else { y }
//   }
//
// The annotations below are missing. Add them so the code compiles.

// Fix the signature — add lifetime parameters so the compiler knows
// the returned reference lives as long as the shorter of x and y.
pub fn longer_str(x: &str, y: &str) -> &str {
    if x.len() >= y.len() { x } else { y }
}

// This struct holds a reference. It needs a lifetime parameter too.
// Fix the struct definition and impl.
pub struct FirstWord {
    pub word: &str,   // what lifetime does this reference have?
}

impl FirstWord {
    pub fn new(s: &str) -> FirstWord {
        let end = s.find(' ').unwrap_or(s.len());
        FirstWord { word: &s[..end] }
    }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_longer_str() {
        let s1 = String::from("long string");
        let result;
        {
            let s2 = String::from("xy");
            result = longer_str(&s1, &s2);
            assert_eq!(result, "long string");
        }
    }

    #[test]
    fn test_longer_equal() {
        assert_eq!(longer_str("abc", "xyz"), "abc");
        assert_eq!(longer_str("a", "bb"),    "bb");
    }

    #[test]
    fn test_first_word() {
        let s = String::from("hello world");
        let fw = FirstWord::new(&s);
        assert_eq!(fw.word, "hello");
    }

    #[test]
    fn test_first_word_single() {
        let s = String::from("rust");
        let fw = FirstWord::new(&s);
        assert_eq!(fw.word, "rust");
    }
}
