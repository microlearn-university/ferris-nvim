# ferris.nvim

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

An interactive Rust tutorial inside Neovim. Each exercise opens as a real `.rs` file in your buffer. Save, and `rustc` runs instantly — compile errors appear as inline diagnostics, test failures echo at the bottom. When all tests pass, advance to the next exercise.

No separate terminal. No context switching. Just Rust, in your editor.

## Features

- **17 exercises** spanning Rust fundamentals through intermediate concepts — ownership, borrowing, traits, generics, iterators, lifetimes, and more
- **Instant feedback** — `rustc --test` runs on every save; errors appear as native Neovim diagnostics on the exact line
- **Two exercise types** — implement `todo!()` stubs until tests go green, or fix intentional compile errors (move semantics, borrow conflicts, missing lifetime annotations)
- **Progressive hints** — `:FerrisHint` reveals hints one at a time without spoiling the solution
- **Persistent progress** — working copies and completion state saved to `~/.local/share/nvim/ferris-nvim/`; `:FerrisReset` restores any exercise to its original state
- **Exercise picker** — `:Ferris` opens a `vim.ui.select` list of all exercises with completion markers

## Requirements

- Neovim 0.9+
- `rustc` in `PATH` — a standard [rustup](https://rustup.rs/) installation is sufficient; no Cargo project needed

## Installation

### lazy.nvim

```lua
{
  "microlearn-university/ferris-nvim",
  config = function()
    require('ferris').setup()
  end,
}
```

### Local path (lazy.nvim)

```lua
{
  dir = "~/path/to/ferris.nvim",
  config = function()
    require('ferris').setup()
  end,
}
```

### Manual

```lua
-- init.lua
vim.opt.runtimepath:append("~/path/to/ferris.nvim")
require('ferris').setup()
```

## Commands

| Command            | Description                                           |
|--------------------|-------------------------------------------------------|
| `:Ferris`          | Open the exercise picker                              |
| `:FerrisNext`      | Advance to the next exercise                          |
| `:FerrisPrev`      | Go back one exercise                                  |
| `:FerrisHint`      | Reveal the next hint (call repeatedly for more)       |
| `:FerrisCheck`     | Check the current exercise manually                   |
| `:FerrisProgress`  | Show a summary of completed exercises                 |
| `:FerrisReset`     | Reset the current exercise to its original state      |

Exercises are checked automatically on every `:w`.

## Exercises

| #  | Title                     | Concept                           |
|----|---------------------------|-----------------------------------|
| 1  | Hello, Rust!              | `format!`, Strings                |
| 2  | Variables & Mutability    | `let mut` — fix a compile error   |
| 3  | Functions & Return Values | implicit return, no semicolon     |
| 4  | if as an Expression       | `if`/`else` as values             |
| 5  | Ownership: Move Semantics | move semantics — fix a compile error |
| 6  | Clone                     | explicit cloning, `clone()`       |
| 7  | References & Borrowing    | `&str`, borrow without ownership  |
| 8  | Mutable References        | `&mut`, borrow rules — fix a compile error |
| 9  | Structs & Methods         | `struct`, `impl`, methods         |
| 10 | Enums & Pattern Matching  | enum variants with data, `match`  |
| 11 | Option\<T\>               | `Some`/`None`, optional values    |
| 12 | Result\<T, E\>            | `Ok`/`Err`, error handling        |
| 13 | The ? Operator            | error propagation                 |
| 14 | Traits                    | defining and implementing traits  |
| 15 | Generics & Trait Bounds   | `<T: Bound>`, generic functions   |
| 16 | Iterators & Closures      | `map`, `filter`, `collect`, `scan`|
| 17 | Lifetime Annotations      | `'a` — fix a compile error        |

## How it works

When you open an exercise, ferris.nvim copies it to `~/.local/share/nvim/ferris-nvim/exercises/` — the original is never modified. A floating window shows the exercise description and any hints you've unlocked.

On save, the plugin runs:

```
rustc --edition 2021 --test -o <tmpfile> <exercise.rs>
```

If compilation fails, the first error (with its error code) echoes at the bottom and all errors appear as inline diagnostics. If compilation succeeds, the test binary runs — tests passing means the exercise is complete.

Progress is written to `~/.local/share/nvim/ferris-nvim/progress.json`.

## License

[MIT](LICENSE)
