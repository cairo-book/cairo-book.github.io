# Macros

The Cairo language has some plugins that allows developers to simplify their code. They are called `inline_macros` and are a way of writing code that generates other code. In Cairo, there are only two `macros`: `array![]` and `consteval_int!()`.

### Let's start by `array!`

Sometimes, we need to create arrays with values that are already known at compile time. The basic way of doing that is redundant. You would first declare the array and then append one by one every values. `array!` creates a simpler way of doing this task by combining the two steps.
At compile-time, the compiler will create an array and append sequencially every values passed to the `array!` macro.

Without `array!`:

```rust
let mut input = Default::default();
input.append(0x0000000000000001);
input.append(0x0000000000000002);
input.append(0x0000000000000003);
input.append(0x0000000000000004);
input.append(0x0000000000000005);
input.append(0x0000000000000006);
input.append(0x0000000000000007);
input.append(0x0000000000000008);
input.append(0x0000000000000009);
```

With `array!`:

```rust
let mut input = array![
        0x0000000000000001,
        0x0000000000000002,
        0x0000000000000003,
        0x0000000000000004,
        0x0000000000000005,
        0x0000000000000006,
        0x0000000000000007,
        0x0000000000000008,
        0x0000000000000009,
    ];
```

### `consteval_int!`

In some situtations, a developer might need to declare a constant that is the result of a computation of integers. To compute a constant expression and use its result at compile time, it is required to use the `consteval_int!` macro.

Here is an example of `consteval_int!`:

```rust
const a: felt252 = consteval_int!(2 * 2 * 2);
```

This will be interprated as `const a: felt252 = 8;` by the compiler.
