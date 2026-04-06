return {
  -- ── Foundations ─────────────────────────────────────────────────────────────

  {
    id          = '01_hello',
    file        = '01_hello.rs',
    title       = 'Hello, Rust!',
    module      = 'entry_hall',
    description = 'Implement greeting() using the format! macro to build a string like "Hello, Ferris!"',
    hints = {
      'format! works like println! but returns a String instead of printing.',
      'format!("The answer is {}", 42) — curly braces are the placeholder.',
      'You want: format!("Hello, {}!", name)',
    },
  },

  {
    id          = '02_variables',
    file        = '02_variables.rs',
    title       = 'Variables & Mutability',
    module      = 'entry_hall',
    description = 'Variables are immutable by default in Rust. Fix count_up() by making the right variable mutable with `mut`.',
    hints = {
      'Variables are declared with `let`. To make one mutable: `let mut x = 0;`',
      'Only the variable being reassigned needs `mut`. The loop counter is already `mut`.',
    },
  },

  {
    id          = '03_functions',
    file        = '03_functions.rs',
    title       = 'Functions & Return Values',
    module      = 'entry_hall',
    description = 'Implement celsius_to_fahrenheit(). In Rust, the last expression in a function body is the return value — no `return` keyword needed.',
    hints = {
      'Formula: F = C × 9/5 + 32',
      'The last expression in a block is automatically returned. No semicolon means "this is the return value".',
      'celsius * 9.0 / 5.0 + 32.0',
    },
  },

  {
    id          = '04_if_expressions',
    file        = '04_if_expressions.rs',
    title       = 'if as an Expression',
    module      = 'entry_hall',
    description = 'In Rust, `if` is an expression — it produces a value. Implement fizz_buzz() using if/else if/else expressions.',
    hints = {
      'if/else can be used on the right side of a `let`: `let x = if cond { 1 } else { 2 };`',
      'Check divisibility with %: `n % 3 == 0`',
      'Check FizzBuzz (both) first, then Fizz, then Buzz, then the number.',
      'Use format!("{}", n) to convert n to a String.',
    },
  },

  {
    id          = '05_ownership_move',
    file        = '05_ownership_move.rs',
    title       = 'Ownership: Move Semantics',
    module      = 'ownership_chamber',
    description = 'String does not implement Copy. When you pass a String to a function, ownership moves and the original is gone. Fix process() so it compiles.',
    hints = {
      'The error is "use of moved value". `s` is moved into `get_length`, so it cannot be used afterwards.',
      'One fix: get the length BEFORE calling get_length — just reorder the lines.',
      'Another fix: change get_length to borrow (&str) instead of taking ownership.',
    },
  },

  {
    id          = '06_clone',
    file        = '06_clone.rs',
    title       = 'Clone',
    module      = 'ownership_chamber',
    description = 'When you need two owners of the same data, clone() creates an independent copy. Implement send_to_both() without changing the function signatures.',
    hints = {
      'You cannot pass `msg` to both functions — the first call would move it.',
      'Call msg.clone() to create a copy: send_to_alice(msg.clone())',
      'After clone, msg is still valid and can be passed to send_to_bob.',
    },
  },

  {
    id          = '07_borrowing',
    file        = '07_borrowing.rs',
    title       = 'References & Borrowing',
    module      = 'borrowing_room',
    description = 'References let you use a value without taking ownership. Implement first_word() using a &str reference — the caller keeps ownership of their String.',
    hints = {
      'The function signature should be: pub fn first_word(s: &str) -> &str',
      'Find the first space with: s.find(\' \')',
      'find() returns Option<usize>. Use match or unwrap_or.',
      '&s[..pos] gives you a slice up to (not including) pos.',
    },
  },

  {
    id          = '08_mut_refs',
    file        = '08_mut_refs.rs',
    title       = 'Mutable References',
    module      = 'borrowing_room',
    description = 'You can have ONE mutable reference OR many immutable references — never both. Fix the borrow conflict in double_first().',
    hints = {
      'The error: you cannot have a mutable borrow while an immutable borrow is active.',
      'The immutable borrow `first` keeps v borrowed. Drop it before the mutable borrow.',
      'Copy the value out: `let first_val = v[0];` — i32 is Copy, so this does not borrow.',
    },
  },

  {
    id          = '09_structs',
    file        = '09_structs.rs',
    title       = 'Structs & Methods',
    module      = 'struct_workshop',
    description = 'Implement a Rectangle struct with an area() method and a square() constructor. Methods live in `impl` blocks.',
    hints = {
      'Define the struct: `pub struct Rectangle { pub width: f64, pub height: f64 }`',
      'impl Rectangle { pub fn area(&self) -> f64 { ... } }',
      '`&self` borrows the struct. `self.width` accesses the field.',
      'A constructor is an associated function: `pub fn square(size: f64) -> Self { ... }`',
    },
  },

  {
    id          = '10_enums',
    file        = '10_enums.rs',
    title       = 'Enums & Pattern Matching',
    module      = 'struct_workshop',
    description = 'Enums in Rust can carry data. Implement area() for a Shape enum using an exhaustive match expression.',
    hints = {
      'match is exhaustive — you must handle every variant.',
      'Destructure enum data in the pattern: `Shape::Circle { radius } => ...`',
      'Or with tuple variants: `Shape::Rectangle(w, h) => w * h`',
      'Use std::f64::consts::PI for circle area.',
    },
  },

  -- ── Intermediate ─────────────────────────────────────────────────────────────

  {
    id          = '11_option',
    file        = '11_option.rs',
    title       = 'Option<T>',
    module      = 'pattern_hall',
    description = 'Option<T> represents a value that may or may not exist. Implement find_first_even() that returns None if no even number exists.',
    hints = {
      'Option has two variants: Some(value) and None.',
      'Use a for loop and return Some(n) when you find an even number.',
      'If the loop ends without finding one, return None.',
      'Or use iter().find(|&&n| n % 2 == 0).copied()',
    },
  },

  {
    id          = '12_result',
    file        = '12_result.rs',
    title       = 'Result<T, E>',
    module      = 'error_forge',
    description = 'Result<T, E> represents success (Ok) or failure (Err). Implement parse_positive() that returns an error if the string is not a positive integer.',
    hints = {
      'str::parse::<i64>() returns Result<i64, ParseIntError>. Use match or ?.',
      'Return Err(String::from("...")) for the error cases.',
      'Check: parse succeeds, then check the value is > 0.',
      'You can use .map_err(|e| e.to_string()) to convert the parse error to a String.',
    },
  },

  {
    id          = '13_question_mark',
    file        = '13_question_mark.rs',
    title       = 'The ? Operator',
    module      = 'error_forge',
    description = 'The ? operator propagates errors automatically. Rewrite read_username() to use ? instead of explicit match expressions.',
    hints = {
      '? after a Result expression: returns Err early if Err, unwraps if Ok.',
      'file?.read_to_string(&mut s)? — both operations can fail.',
      'The function return type must be Result<_, _> for ? to work.',
      'std::fs::File::open() and Read::read_to_string() both return Result.',
    },
  },

  {
    id          = '14_traits',
    file        = '14_traits.rs',
    title       = 'Traits',
    module      = 'trait_gallery',
    description = 'A trait defines shared behaviour. Implement the Summary trait for Article and Tweet, then use it in a generic function.',
    hints = {
      'Define: `pub trait Summary { fn summarise(&self) -> String; }`',
      'Implement: `impl Summary for Article { fn summarise(&self) -> String { ... } }`',
      'Generic function: `pub fn notify(item: &impl Summary)` or `pub fn notify<T: Summary>(item: &T)`',
      'Both syntax forms are equivalent for this case.',
    },
  },

  {
    id          = '15_generics',
    file        = '15_generics.rs',
    title       = 'Generics & Trait Bounds',
    module      = 'trait_gallery',
    description = 'Implement largest<T>() that works for any ordered type using a trait bound. The function should work for both &[i32] and &[char].',
    hints = {
      'The bound you need: T: PartialOrd — this enables the > operator.',
      'Signature: pub fn largest<T: PartialOrd>(list: &[T]) -> &T',
      'Start with &list[0] and iterate, keeping a reference to the largest seen.',
      'Use a for loop over list: `for item in list { if item > largest { largest = item; } }`',
    },
  },

  {
    id          = '16_iterators',
    file        = '16_iterators.rs',
    title       = 'Iterators & Closures',
    module      = 'iterator_engine',
    description = 'Implement these three functions using iterator adaptors — map, filter, collect, sum — instead of explicit loops.',
    hints = {
      'v.iter().map(|x| x * 2).collect::<Vec<_>>()',
      'filter keeps elements where the closure returns true: .filter(|&&x| x > 0)',
      'sum() consumes the iterator: v.iter().sum::<i32>()',
      'Chain adaptors: .iter().filter(...).map(...).collect()',
    },
  },

  {
    id          = '17_lifetimes',
    file        = '17_lifetimes.rs',
    title       = 'Lifetime Annotations',
    module      = 'lifetime_lab',
    description = 'Annotate the lifetimes in longer_str() so the compiler knows the return value lives as long as the shorter of the two inputs.',
    hints = {
      "The compiler error: 'missing lifetime specifier'.",
      "Add a lifetime parameter: fn longer_str<'a>(x: &'a str, y: &'a str) -> &'a str",
      "The annotation says: the output lives at least as long as both inputs.",
      "You're not changing how long anything lives — you're naming the relationship.",
    },
  },
}
