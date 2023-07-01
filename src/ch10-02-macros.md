# Macros

The Cairo language has some plugins that allows developers to simplify their code. They are called `inline_macros` and are a way of writing code that writes code. It is easier to understand with an example.

Here is a function that prints the `felt252` passed to it.

```rust
fn print_felt252(message: felt252) {
    let mut arr = Default::default();
    arr.append(message);
    print(arr);
}
```

And this is the exact same function with a macro `array!` instead.

```rust
fn print_felt252(message: felt252) {
    print(array![message]);
}
```

In Cairo, there are only two `macros`: `array![]` and `consteval_int!()`.

`array!` creates an array with the elements passed in paramater.
`consteval_int!` performs the computations passed to it before returning the constant result.

Here is an example of `consteval_int!`:

```rust
const a: felt252 = consteval_int!(2 * 2 * 2);
```

What happens under-the-hood is that the `macros` will be expanded and evaluated before the compiler interprets the code.
Hence, if we take the previous example of `consteval_int!`, `const a: felt252 = consteval_int!(2 * 2 * 2);` will be interprated as `const a: felt252 = 8;` by the compiler.
