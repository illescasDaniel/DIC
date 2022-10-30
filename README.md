# DIC: Dependency Injection Container

A super small library for easy dependency injection for Swift.

## Basic example:
```swift
// save your dependency (how to build it)
DependencyInjectionContainer.save {
	Example1(value: 1)
}

// build it
let example1: Example1 = DependencyInjectionContainer.load()
XCTAssertEqual(example1.value, 1)
	// or like this:
let example1_1 = DependencyInjectionContainer.load(Example1.self)
XCTAssertEqual(example1_1.value, 1)
```

```
// You can also do this, which will use an autoclosure
DependencyInjectionContainer.save(Example1(value: 2))
```

## Save dependencies as protocol types

```
class OtherDependency { /* ... */ }

protocol UserRepository { /* ... */ }
class DefaultUserRepository: UserRepository { /* ... */ }

// tip to make it shorter
typealias DIContainer = DependencyInjectionContainer

// save the dependency

DIContainer.save(OtherDependency())

	// if the value doesn't conform to the specified type, it will throw a COMPILATION error
DIContainer.save(
	DefaultUserRepository(otherDependency: DIContainer.load())
	as: UserRepository.self
)
```

### Other stuff
- This dependency injection library supports other data types such as structs, enum values, actors, async classes, classes with nullable constructors (failable initializers), classes with throwing constructors, etc.
- You can save your dependencies in the AppDelegate or inside your App class in SwiftUI.
