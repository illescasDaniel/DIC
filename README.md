# DIC: Dependency Injection Container

A super small library for easy dependency injection for Swift.

## Basic example using DICBuilder:
```swift
// Build your dependency container using the builder
let diContainer = DICBuilder()
    .register {
        Example1(value: 1)
    }
    .build()

// load it (building it each time)
let example1: Example1 = diContainer.load()
XCTAssertEqual(example1.value, 1)
    // or like this:
let example1_1 = diContainer.load(Example1.self)
XCTAssertEqual(example1_1.value, 1)
```

```swift
// You can also do this, which will use an autoclosure (so it will NOT create an object right now)
let diContainer = DICBuilder()
    .register(Example1(value: 2))
    .build()
```

```swift
// You can chain multiple registrations and then build once
let diContainer = DICBuilder()
    .register { Example1(value: 1) }
    .register { Example2(name: "test") }
    .registerSingleton { DatabaseService() }
    .build()
```

## Referencing dependencies in new ones
Prefer using the normal closures instead of the autoclosures for this scenario, otherwise you'll get a circular reference compilation error (which shouldn't be true since the autoclosures runs later, as the function, but whatever...)
```swift
let DI2 = DICBuilder()
	.registerSingleton(HTTPClientImpl(httpDataRequestHandler: URLSession.shared), as: HTTPClient.self)
	.register {
		MyDataSource(httpClient: DI2.load(HTTPClient.self))
	}
	.register {
		MyRepositoryImpl(myDataSource: DI2.load(MyDataSource.self)) as MyRepository
	}
	.register {
		MyUseCase(myRepository: DI2.load(MyRepository.self))
	}
	// etc
	.build()
```

## Basic example using :DependencyInjectionContainer
```swift
// register your dependency (how to build it)
let diContainer = DependencyInjectionContainer() // you can leave it as a global variable for example

diContainer.register {
    Example1(value: 1)
}

// load it (building it each time)
let example1: Example1 = diContainer.load()
XCTAssertEqual(example1.value, 1)
    // or like this:
let example1_1 = diContainer.load(Example1.self)
XCTAssertEqual(example1_1.value, 1)
```

```swift
// You can also do this, which will use an autoclosure (so it will NOT create an object right now)
diContainer.register(Example1(value: 2))
```


## Save dependencies as protocol types

```swift
class OtherDependency { /* ... */ }

protocol UserRepository { /* ... */ }
class DefaultUserRepository: UserRepository { /* ... */ }

let diContainer = DependencyInjectionContainer()

// register the dependency

diContainer.register(OtherDependency())

    // if the value doesn't conform to the specified type, it will throw a COMPILATION error
diContainer.register(
    DefaultUserRepository(otherDependency: DIContainer.load()),
    as: UserRepository.self
)

// in other place like a view
MyView(userRepository: diContainer.load())
  // inside the view
  userRepository.XYZ()
```

## 'Singleton' support
```swift
// Simply use `registerSingleton` to save the dependency inside the container. It should always be 'alive' as long as the container is. 
diContainer.registerSingleton(
	HTTPClientImpl(
		urlSession: URLSession(configuration: .ephemeral),
		interceptors: [diContainer.load(MockRequestHTTPInterceptor.self), RequestLoggerHTTPInterceptor()]
	),
	as: HTTPClient.self
)

// Every time the load method is called, the exact same object will be returned.
// This is different than registering your dependencies with "register".
let httpClient = diContainer.load(HTTPClient.self)
```

### Other stuff
- This dependency injection library supports other data types such as structs, enum values, actors, async classes (`AsyncDependencyInjectionContainer`), classes with nullable constructors (failable initializers), classes with throwing constructors, etc.
- You can register your dependencies in the AppDelegate or inside your App class in SwiftUI.
- You should probably have only one container, but you can create as many as you like.
- You need almost no modifications to existing code that uses normal dependency injection, simply register all the dependencies in a place like the app delegate and then replace the initializers call from something like :
```swift
MyView(
    dependency: Dependency(
        otherDependency: X,
        otherOtherDependency: OmgAnotherOne(
            somethingHere: Z
        )
    )
)
``` 
to 
```swift
MyView(dependency: diContainer.load())
```

## Why use DICBuilder instead of DependencyInjectionContainer?

`DICBuilder` provides several advantages over the original mutable `DependencyInjectionContainer`:

### 🔒 **Thread Safety**
- **DICBuilder**: All registration operations are thread-safe using atomic operations
- **DependencyInjectionContainer**: Direct dictionary mutations are not thread-safe

### 🚀 **Performance** 
- **DICBuilder**: Built container is immutable, allowing lock-free concurrent reads
- **DependencyInjectionContainer**: Mutable state may require synchronization for safe concurrent access

### 🛡️ **Immutability**
- **DICBuilder**: Once built, the container cannot be modified (safer, more predictable)
- **DependencyInjectionContainer**: Can be modified at any time, potentially causing runtime issues

### 🔄 **Clear Lifecycle**
- **DICBuilder**: Separates building phase (mutable) from usage phase (immutable)
- **DependencyInjectionContainer**: Mixed concerns - can register and resolve simultaneously

### 🧩 **Fluent API**
- **DICBuilder**: Clean method chaining for configuration
- **DependencyInjectionContainer**: Requires separate method calls for each registration

**Recommendation**: Use `DICBuilder` for new projects, especially when thread safety and immutability are important.
