import XCTest
@testable import DIC

final class DICTests: XCTestCase {
	
	func testSaveLoadWithClosure() {
		DependencyInjectionContainer.save {
			Example1(value: 1)
		}
		let example1: Example1 = DependencyInjectionContainer.load()
		XCTAssertEqual(example1.value, 1)
		let example1_1 = DependencyInjectionContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 1)

		let dataOrNil: Example1? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(Example1.self)
		XCTAssertEqual(dataOrNil_1?.value, 1)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(Example1.self))
	}
	
	func testSaveLoadWithAutoclosure() {
		DependencyInjectionContainer.save(Example1(value: 2))
		let example2: Example1 = DependencyInjectionContainer.load()
		XCTAssertEqual(example2.value, 2)
		let example2_1 = DependencyInjectionContainer.load(Example1.self)
		XCTAssertEqual(example2_1.value, 2)

		let dataOrNil: Example1? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 2)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(Example1.self)
		XCTAssertEqual(dataOrNil_1?.value, 2)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(Example1.self))
	}
	
	func testProtocolSaveAndLoad() {
		DependencyInjectionContainer.save(
			{ Example3(value: 3) },
			as: ExampleProtocol.self
		)
		let exampleProtocolValue: ExampleProtocol = DependencyInjectionContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = DependencyInjectionContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil: ExampleProtocol? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(ExampleProtocol.self)
		XCTAssertEqual(dataOrNil_1?.value, 3)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(ExampleProtocol.self))
	}
	
	func testProtocolSaveAndLoadAutoclosure() {
		DependencyInjectionContainer.save(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue: ExampleProtocol = DependencyInjectionContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = DependencyInjectionContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil: ExampleProtocol? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(ExampleProtocol.self)
		XCTAssertEqual(dataOrNil_1?.value, 3)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(ExampleProtocol.self))
	}
}
