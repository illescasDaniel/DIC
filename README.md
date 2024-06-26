# DIC: Dependency Injection Container

A super small library for easy dependency injection for Swift.

## Basic example:
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
