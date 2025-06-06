import XCTest
@testable import DIC

final class MiniDICTests: XCTestCase {

	func testSaveLoadWithClosureMini() {
		let diContainer = MiniDependencyInjectionContainer()
		diContainer.register {
			Example1(value: 1)
		}
		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)
		example1.value = 90
		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 1)

		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 1)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 1)
	}

	func testSaveLoadWithSingletonClassAutoclosureMini() {
		let diContainer = MiniDependencyInjectionContainer()
		diContainer.registerSingleton(Example1(value: 1))
		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)

		example1.value = 90
		XCTAssertEqual(example1.value, 90)

		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 90)
		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 90)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 90)
	}

	func testSaveLoadWithSingletonClassWithClosureMini() {
		let diContainer = MiniDependencyInjectionContainer()
		diContainer.registerSingleton {
			Example1(value: 1)
		}
		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)

		example1.value = 90
		XCTAssertEqual(example1.value, 90)

		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 90)
		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 90)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 90)
	}
	func testSaveLoadWithAutoclosureMini() {
		let diContainer = MiniDependencyInjectionContainer()
		diContainer.register(Example1(value: 2))
		let example2: Example1 = diContainer.load()
		XCTAssertEqual(example2.value, 2)
		let example2_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example2_1.value, 2)

		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 2)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 2)
	}

	func testProtocolSaveAndLoadMini() {
		let diContainer = MiniDependencyInjectionContainer()
		diContainer.register(
			{ Example3(value: 3) },
			as: ExampleProtocol.self
		)
		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testProtocolSaveAndLoadAutoclosureMini() {

		let diContainer = MiniDependencyInjectionContainer()

		// if the `objectBuilder` return type doesn't conform to the `desiredType`, it will throw a compilation error :)
		// diContainer.save(Example3(value: 3), as: Int.self)

		diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testDependenciesMethodMini() {
		let diContainer = MiniDependencyInjectionContainer()
		XCTAssertTrue(diContainer.dependencies().isEmpty)

		diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		XCTAssertFalse(diContainer.dependencies().isEmpty)

		diContainer.unregisterDependencies()
		XCTAssertTrue(diContainer.dependencies().isEmpty)
	}
}
