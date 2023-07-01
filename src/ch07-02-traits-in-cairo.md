# Traits in Cairo

Traits specify functionality blueprints that can be implemented. The blueprint specification includes a set of function signatures containing type annotations for the parameters and return value. This sets a standard to implement the specific functionality.

## Defining a Trait

To define a trait, you use the keyword `trait` followed by the name of the trait in `PascalCase` then the function signatures in a pair of curly braces.

For example, let's say that we have multiple structs representing shapes. We want our application to be able to perform geometry operations on these shapes, So we define a trait `ShapeGeometry` that contains a blueprint to implement geometry operations on a shape like this:

```rust
trait ShapeGeometry {
    fn boundary(self: Rectangle) -> u64;
    fn area(self: Rectangle) -> u64;
}
```

Here our trait `ShapeGeometry` declares signatures for two methods `boundary` and `area`. When implemented, both these functions should return a `u64` and accept parameters as specified by the trait.

## Implementing a Trait

A trait can be implemented using `impl` keyword with the name of your implementation followed by `of` then the name of trait being implemented. Here's an example implementing `ShapeGeometry` trait.

```rust
impl RectangleGeometry of ShapeGeometry {
	fn boundary(self: Rectangle) -> u64 {
        2 * (self.height + self.width)
    }
	fn area(self: Rectangle) -> u64 {
		self.height * self.width
	}
}
```

In the code above, `RectangleGeometry` implements the trait `ShapeGeometry` defining what the methods `boundary` and `area` should do. Note that the function parameters and return value types are identical to the trait specification.

## Implementing a trait, without writing its declaration.

You can write implementations directly without definining the corresponding trait. This is made possible by using the `#[generate_trait]` attribute with on the implementation, which will make the compiler generate the trait corresponding to the implementation automatically. Remember to add `Trait` as a suffix to your trait name, as the compiler will create the trait by adding a `Trait` suffix to the implementation name.

```rust
#[generate_trait]
impl RectangleGeometry of RectangleGeometryTrait {
	fn boundary(self: Rectangle) -> u64 {
        2 * (self.height + self.width)
    }
	fn area(self: Rectangle) -> u64 {
		self.height * self.width
	}
}
```

In the aforementioned code, there is no need to manually define the trait. The compiler will automatically handle its definition, dynamically generating and updating it as new functions are introduced.

Implements annotated with the `#[generate_trait]` attribute are programmed to automatically generate trait and export on a compilation like this bottom code.

```rust
trait RectangleGeometryTrait {
    fn boundary(self: Rectangle) -> u64;
    fn area(self: Rectangle) -> u64;
}
```

This plugin also supports generic implementations. If use `#[generate_trait]` instead of defining WalletTrait as in the previous generic chapter, it will be looks like this.

```rust
#[derive(Copy, Drop)]
struct Wallet<T> {
    balance: T
}

#[generate_trait]
impl WalletImpl<T, impl TCopy: Copy<T>> of WalletTrait<T> {
    fn balance(self: @Wallet<T>) -> T {
        return *self.balance;
    }
}
```

Every generic type and impl will all reflect on auto-generated trait by the plugin. Because generated trait must have generic args matching the impl's generic params.

```rust
trait WalletTrait<T, impl TCopy: Copy<T>> {
    fn balance(self: @Wallet<T>) -> T;
}
```

If you take a look at [GenerateTraitPlugin](https://github.com/starkware-libs/cairo/blob/main/crates/cairo-lang-plugins/src/plugins/generate_trait.rs) better to understand how this attribute works in deep underhood in compiler level.

## Parameter `self`

In the example above, `self` is a special parameter. When a parameter with name `self` is used, the implemented functions are also [attached to the instances of the type as methods](ch04-03-method-syntax.md#defining-methods). Here's an illustration,

When the `ShapeGeometry` trait is implemented, the function `area` from the `ShapeGeometry` trait can be called in two ways:

```rust
let rect = Rectangle { ... }; // Rectangle instantiation

// First way, as a method on the struct instance
let area1 = rect.area();
// Second way, from the implementation
let area2 = RectangleGeometry::area(rect);
// `area1` has same value as `area2`
area1.print();
area2.print();
```

And the implementation of the `area` method will be accessed via the `self` parameter.

## Generic Traits

Usually we want to write a trait when we want multiple types to implement a functionality in a standard way. However, in the example above the signatures are static and cannot be used for multiple types. To do this, we use generic types when defining traits.

In the example below, we use generic type `T` and our method signatures can use this alias which can be provided during implementation.

```rust
use debug::PrintTrait;

#[derive(Copy, Drop)]
struct Rectangle {
    height: u64,
    width: u64,
}

#[derive(Copy, Drop)]
struct Circle {
    radius: u64
}

// Here T is an alias type which will be provided during implementation
trait ShapeGeometry<T> {
    fn boundary(self: T) -> u64;
    fn area(self: T) -> u64;
}

// Implementation RectangleGeometry passes in <Rectangle>
// to implement the trait for that type
impl RectangleGeometry of ShapeGeometry<Rectangle> {
    fn boundary(self: Rectangle) -> u64 {
        2 * (self.height + self.width)
    }
    fn area(self: Rectangle) -> u64 {
        self.height * self.width
    }
}

// We might have another struct Circle
// which can use the same trait spec
impl CircleGeometry of ShapeGeometry<Circle> {
    fn boundary(self: Circle) -> u64 {
        (2 * 314 * self.radius) / 100
    }
    fn area(self: Circle) -> u64 {
        (314 * self.radius * self.radius) / 100
    }
}

fn main() {
    let rect = Rectangle { height: 5, width: 7 };
    rect.area().print(); // 35
    rect.boundary().print(); // 24

    let circ = Circle { radius: 5 };
    circ.area().print(); // 78
    circ.boundary().print(); // 31
}
```

## Managing and using external trait implementations

To use traits methods, you need to make sure the correct traits/implementation(s) are imported. In the code above we imported `PrintTrait` from `debug` with `use debug::PrintTrait;` to use the `print()` methods on supported types.

In some cases you might need to import not only the trait but also the implementation if they are declared in separate modules.
If `CircleGeometry` was in a separate module/file `circle` then to use `boundary` on `circ: Circle`, we'd need to import `CircleGeometry` in addition to `ShapeGeometry`.

If the code was organised into modules like this,

```rust,does_not_compile,ignore_format
use debug::PrintTrait;

// struct Circle { ... } and struct Rectangle { ... }

mod geometry {
    use super::Rectangle;
    trait ShapeGeometry<T> {
        // ...
    }

    impl RectangleGeometry of ShapeGeometry::<Rectangle> {
        // ...
    }
}

// Could be in a different file
mod circle {
    use super::geometry::ShapeGeometry;
    use super::Circle;
    impl CircleGeometry of ShapeGeometry<Circle> {
        // ...
    }
}

fn main() {
    let rect = Rectangle { height: 5, width: 7 };
    let circ = Circle { radius: 5 };
    // Fails with this error
    // Method `area` not found on... Did you import the correct trait and impl?
    rect.area().print();
    circ.area().print();
}
```

To make it work, in addition to,

```rust
use geometry::ShapeGeometry;
```

you might also need to use `CircleGeometry`,

```rust
use circle::CircleGeometry
```
