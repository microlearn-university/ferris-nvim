// EXERCISE 14 — Traits
//
// A trait defines shared behaviour that types can implement.
// It's Rust's answer to interfaces.
//
//   trait Greet {
//       fn hello(&self) -> String;
//   }
//   impl Greet for Dog {
//       fn hello(&self) -> String { String::from("Woof!") }
//   }
//
// Fill in the three TODOs:
//   1. The body of `summarise` for Article: return "{title}, by {author}"
//   2. The body of `summarise` for Tweet: return "{username}: {content}"
//   3. The body of `notify`: call summarise and prepend "Breaking news! "

pub struct Article {
    pub title:  String,
    pub author: String,
    pub body:   String,
}

pub struct Tweet {
    pub username: String,
    pub content:  String,
}

pub trait Summary {
    fn summarise(&self) -> String;
}

impl Summary for Article {
    fn summarise(&self) -> String {
        // TODO: return "{title}, by {author}"
        todo!()
    }
}

impl Summary for Tweet {
    fn summarise(&self) -> String {
        // TODO: return "{username}: {content}"
        todo!()
    }
}

// This function accepts any type that implements Summary.
// Both `&impl Summary` and `<T: Summary>(item: &T)` are equivalent here.
pub fn notify(item: &impl Summary) -> String {
    // TODO: return "Breaking news! {summarise result}"
    todo!()
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_article_summary() {
        let a = Article {
            title:  String::from("Rust is great"),
            author: String::from("Ferris"),
            body:   String::from("..."),
        };
        assert_eq!(a.summarise(), "Rust is great, by Ferris");
    }

    #[test]
    fn test_tweet_summary() {
        let t = Tweet {
            username: String::from("ferris_crab"),
            content:  String::from("loving the borrow checker"),
        };
        assert_eq!(t.summarise(), "ferris_crab: loving the borrow checker");
    }

    #[test]
    fn test_notify_article() {
        let a = Article {
            title:  String::from("Big News"),
            author: String::from("Reporter"),
            body:   String::from("..."),
        };
        assert_eq!(notify(&a), "Breaking news! Big News, by Reporter");
    }

    #[test]
    fn test_notify_tweet() {
        let t = Tweet {
            username: String::from("rustlang"),
            content:  String::from("1.78 released"),
        };
        assert_eq!(notify(&t), "Breaking news! rustlang: 1.78 released");
    }
}
