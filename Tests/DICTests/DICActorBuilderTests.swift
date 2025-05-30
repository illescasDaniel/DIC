
import XCTest
@testable import DIC

final class DICActorBuilderTests: XCTestCase {

	func testMultipleRegister() async {
		let diContainer = await DICActorBuilder()
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

	func testSaveLoadWithClosureMini() async {
		let diContainer = await DICActorBuilder()
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

	func testSaveLoadWithSingletonClassAutoclosureMini() async {
		let diContainer = await DICActorBuilder()
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

	func testSaveLoadWithSingletonClassWithClosureMini() async {
		let diContainer = await DICActorBuilder()
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

	func testSaveLoadWithAutoclosureMini() async {
		let diContainer = await DICActorBuilder()
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

	func testProtocolSaveAndLoadMini() async {
		let diContainer = await DICActorBuilder()
			.register({ Example3(value: 3) }, as: ExampleProtocol.self)
			.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testProtocolSaveAndLoadAutoclosureMini() async {
		let diContainer = await DICActorBuilder()
			.register(Example3(value: 3), as: ExampleProtocol.self)
			.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testDependenciesMethodMini() async {
		let builder = DICActorBuilder()
		var diContainer = await builder.build()

		// Note: This test needs to be updated since we no longer expose 'objects' publicly
		// Instead, we can test by trying to load a dependency that doesn't exist
		XCTAssertNil(diContainer.loadOrNil(Example1.self))

		let diContainerWithDeps = await DICActorBuilder()
			.register(Example3(value: 3), as: ExampleProtocol.self)
			.build()

		XCTAssertNotNil(diContainerWithDeps.loadOrNil(ExampleProtocol.self))
	}
}
