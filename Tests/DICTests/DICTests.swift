import XCTest
@testable import DIC

final class DICTests: XCTestCase {
	
	func testSaveLoadWithClosure() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register {
			Example1(value: 1)
		}
		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)
		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 1)

		let dataOrNil: Example1? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = diContainer.loadOrNil(Example1.self)
		XCTAssertEqual(dataOrNil_1?.value, 1)
		XCTAssertNoThrow(try diContainer.loadOrThrow(Example1.self))
	}
	
	func testSaveLoadWithAutoclosure() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(Example1(value: 2))
		let example2: Example1 = diContainer.load()
		XCTAssertEqual(example2.value, 2)
		let example2_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example2_1.value, 2)

		let dataOrNil: Example1? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 2)
		let dataOrNil_1 = diContainer.loadOrNil(Example1.self)
		XCTAssertEqual(dataOrNil_1?.value, 2)
		XCTAssertNoThrow(try diContainer.loadOrThrow(Example1.self))
	}
	
	func testProtocolSaveAndLoad() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(
			{ Example3(value: 3) },
			as: ExampleProtocol.self
		)
		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil: ExampleProtocol? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = diContainer.loadOrNil(ExampleProtocol.self)
		XCTAssertEqual(dataOrNil_1?.value, 3)
		XCTAssertNoThrow(try diContainer.loadOrThrow(ExampleProtocol.self))
	}
	
	func testProtocolSaveAndLoadAutoclosure() {

		let diContainer = DependencyInjectionContainer()

		// if the `objectBuilder` return type doesn't conform to the `desiredType`, it will throw a compilation error :)
		// diContainer.save(Example3(value: 3), as: Int.self)

		diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil: ExampleProtocol? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = diContainer.loadOrNil(ExampleProtocol.self)
		XCTAssertEqual(dataOrNil_1?.value, 3)
		XCTAssertNoThrow(try diContainer.loadOrThrow(ExampleProtocol.self))
	}

	func testUnregisterDependencies() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)

		diContainer.unregisterDependencies()
		XCTAssertNil(diContainer.loadOrNil(ExampleProtocol.self))
	}

	func testDependenciesMethod() {
		let diContainer = DependencyInjectionContainer()
		XCTAssertTrue(diContainer.dependencies().isEmpty)

		diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		XCTAssertFalse(diContainer.dependencies().isEmpty)

		diContainer.unregisterDependencies()
		XCTAssertTrue(diContainer.dependencies().isEmpty)
	}
}
