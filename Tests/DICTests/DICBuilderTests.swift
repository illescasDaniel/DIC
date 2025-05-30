import XCTest
@testable import DIC

final class DICBuilderTests: XCTestCase {

	func testMultipleRegister() {
		let diContainer = DICBuilder()
			.register {
				Example1(value: 1)
			}
			.register {
				Example3(value: 20)
			}
			.build()

		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)
		example1.value = 90
		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 1)

		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 1)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 1)

		let example3: Example3 = diContainer.load()
		XCTAssertEqual(example3.value, 20)
		let example3_1 = diContainer.load(Example3.self)
		XCTAssertEqual(example3_1.value, 20)
	}

	func testMultipleRegister2() {
		let diBuilder = DICBuilder()
		diBuilder.register {
			Example1(value: 1)
		}
		diBuilder.register {
			Example3(value: 20)
		}
		let diContainer = diBuilder.build()

		let example1: Example1 = diContainer.load()
		XCTAssertEqual(example1.value, 1)
		example1.value = 90
		let example1_1 = diContainer.load(Example1.self)
		XCTAssertEqual(example1_1.value, 1)

		let data1: Example1 = diContainer.load()
		XCTAssertEqual(data1.value, 1)
		let data2 = diContainer.load(Example1.self)
		XCTAssertEqual(data2.value, 1)

		let example3: Example3 = diContainer.load()
		XCTAssertEqual(example3.value, 20)
		let example3_1 = diContainer.load(Example3.self)
		XCTAssertEqual(example3_1.value, 20)
	}

	func testSaveLoadWithClosureMini() {
		let diContainer = DICBuilder()
			.register {
				Example1(value: 1)
			}
			.build()

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
		let diContainer = DICBuilder()
			.registerSingleton(Example1(value: 1))
			.build()

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
		let diContainer = DICBuilder()
			.registerSingleton {
				Example1(value: 1)
			}
			.build()

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
		let diContainer = DICBuilder()
			.register(Example1(value: 2))
			.build()

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
		let diContainer = DICBuilder()
			.register({ Example3(value: 3) }, as: ExampleProtocol.self)
			.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testProtocolSaveAndLoadAutoclosureMini() {
		let diContainer = DICBuilder()
			.register(Example3(value: 3), as: ExampleProtocol.self)
			.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testDependenciesMethodMini() {
		let builder = DICBuilder()
		let diContainer = builder.build()

		// Note: This test needs to be updated since we no longer expose 'objects' publicly
		// Instead, we can test by trying to load a dependency that doesn't exist
		XCTAssertNil(diContainer.loadOrNil(Example1.self))

		let diContainerWithDeps = DICBuilder()
			.register(Example3(value: 3), as: ExampleProtocol.self)
			.build()

		XCTAssertNotNil(diContainerWithDeps.loadOrNil(ExampleProtocol.self))
	}
}
