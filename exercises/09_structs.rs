// EXERCISE 9 — Structs & Methods
//
// Structs group related data. Methods live in `impl` blocks.
//
//   struct Point { x: f64, y: f64 }
//
//   impl Point {
//       // associated function (no `self`) — called as Point::new(1.0, 2.0)
//       fn new(x: f64, y: f64) -> Self { Point { x, y } }
//
//       // method — borrows self, called as point.distance_from_origin()
//       fn distance_from_origin(&self) -> f64 {
//           (self.x * self.x + self.y * self.y).sqrt()
//       }
//   }
//
// Implement a Rectangle struct with methods.

pub struct Rectangle {
    // TODO: add `width: f64` and `height: f64` fields
}

impl Rectangle {
    // Associated function: create a new Rectangle
    pub fn new(width: f64, height: f64) -> Self {
        todo!()
    }

    // Associated function: create a square (width == height)
    pub fn square(size: f64) -> Self {
        todo!()
    }

    // Method: return the area
    pub fn area(&self) -> f64 {
        todo!()
    }

    // Method: return the perimeter
    pub fn perimeter(&self) -> f64 {
        todo!()
    }

    // Method: true if this rectangle can fit inside `other`
    pub fn fits_inside(&self, other: &Rectangle) -> bool {
        todo!()
    }
}

// ─── Tests ────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_area() {
        let r = Rectangle::new(4.0, 5.0);
        assert_eq!(r.area(), 20.0);
    }

    #[test]
    fn test_perimeter() {
        let r = Rectangle::new(3.0, 4.0);
        assert_eq!(r.perimeter(), 14.0);
    }

    #[test]
    fn test_square() {
        let s = Rectangle::square(6.0);
        assert_eq!(s.area(), 36.0);
        assert_eq!(s.perimeter(), 24.0);
    }

    #[test]
    fn test_fits_inside() {
        let small = Rectangle::new(2.0, 3.0);
        let big   = Rectangle::new(5.0, 5.0);
        assert!(small.fits_inside(&big));
        assert!(!big.fits_inside(&small));
    }
}
