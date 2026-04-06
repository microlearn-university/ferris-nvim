// EXERCISE 10 — Enums & Pattern Matching
//
// Rust enums are algebraic data types — each variant can carry different data.
//
//   enum Message {
//       Quit,                        // no data
//       Move { x: i32, y: i32 },    // named fields
//       Write(String),               // one value
//       Color(u8, u8, u8),           // tuple of values
//   }
//
// `match` lets you destructure and act on each variant. It is *exhaustive*:
// the compiler rejects a match that doesn't cover all cases.
//
// Implement `area` for the Shape enum using match.
// Then implement `describe` to return a human-readable string.

use std::f64::consts::PI;

pub enum Shape {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
    Triangle { base: f64, height: f64 },
}

impl Shape {
    pub fn area(&self) -> f64 {
        // TODO: match on self and compute the area
        // Circle:    PI * r²
        // Rectangle: w * h
        // Triangle:  0.5 * base * height
        todo!()
    }

    pub fn describe(&self) -> String {
        // Return a string like:
        //   "circle with radius 3"
        //   "rectangle 4x5"
        //   "triangle with base 3 and height 4"
        todo!()
    }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_circle_area() {
        let c = Shape::Circle { radius: 1.0 };
        let diff = (c.area() - PI).abs();
        assert!(diff < 1e-10, "expected ~{PI}, got {}", c.area());
    }

    #[test]
    fn test_rect_area() {
        let r = Shape::Rectangle { width: 3.0, height: 4.0 };
        assert_eq!(r.area(), 12.0);
    }

    #[test]
    fn test_triangle_area() {
        let t = Shape::Triangle { base: 6.0, height: 4.0 };
        assert_eq!(t.area(), 12.0);
    }

    #[test]
    fn test_describe() {
        let c = Shape::Circle { radius: 3.0 };
        assert_eq!(c.describe(), "circle with radius 3");
        let r = Shape::Rectangle { width: 4.0, height: 5.0 };
        assert_eq!(r.describe(), "rectangle 4x5");
        let t = Shape::Triangle { base: 3.0, height: 4.0 };
        assert_eq!(t.describe(), "triangle with base 3 and height 4");
    }
}
