// EXERCISE 15 — Generics & Trait Bounds
//
// Generic functions work across multiple types. Trait bounds constrain
// which types are allowed and unlock operations on them.
//
//   fn print_all<T: std::fmt::Display>(items: &[T]) {
//       for item in items {
//           println!("{}", item);  // requires Display bound
//       }
//   }
//
// Multiple bounds with +: T: Display + Clone
// Where clause for readability:
//   fn foo<T>(x: T) where T: Clone + Display { ... }

// Implement `largest` — returns a reference to the largest element.
// Needs a PartialOrd bound (enables the > operator).
pub fn largest<T>(list: &[T]) -> &T
where
    T: PartialOrd,
{
    // TODO: iterate over list, track the largest element seen.
    // Start with &list[0] as the current largest.
    // (You may assume list is non-empty.)
    todo!()
}

// Implement `clamp_all` — clamps every element in the slice to [min, max].
// Returns a new Vec.
// Bounds needed: T: PartialOrd + Copy
pub fn clamp_all<T>(values: &[T], min: T, max: T) -> Vec<T>
where
    T: PartialOrd + Copy,
{
    // Hint: use a loop or .iter().map(|&v| ...).collect()
    // For each value: if v < min → min, if v > max → max, else v
    todo!()
}

// A generic struct. Implement `new` and `value` for it.
pub struct Wrapper<T> {
    inner: T,
}

impl<T> Wrapper<T> {
    pub fn new(val: T) -> Self {
        todo!()
    }

    pub fn value(&self) -> &T {
        todo!()
    }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_largest_ints() {
        let v = vec![34, 50, 25, 100, 65];
        assert_eq!(*largest(&v), 100);
    }

    #[test]
    fn test_largest_chars() {
        let v = vec!['y', 'm', 'a', 'q'];
        assert_eq!(*largest(&v), 'y');
    }

    #[test]
    fn test_clamp_all() {
        assert_eq!(clamp_all(&[1, 5, 10, 3, 8], 3, 7), vec![3, 5, 7, 3, 7]);
        assert_eq!(clamp_all(&[0.0_f64, 1.5, 2.0], 0.5, 1.0), vec![0.5, 1.0, 1.0]);
    }

    #[test]
    fn test_wrapper() {
        let w = Wrapper::new(42);
        assert_eq!(*w.value(), 42);
        let s = Wrapper::new(String::from("hi"));
        assert_eq!(s.value(), "hi");
    }
}
