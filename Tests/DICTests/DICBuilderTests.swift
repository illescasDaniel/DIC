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

	func testSaveLoadWithClosureMini() {
		let builder = DependencyInjectionContainerBuilder()
		builder.register {
			Example1(value: 1)
		}
		let diContainer = builder.build()

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
		let builder = DependencyInjectionContainerBuilder()
		builder.registerSingleton(Example1(value: 1))
		let diContainer = builder.build()

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
		let builder = DependencyInjectionContainerBuilder()
		builder.registerSingleton {
			Example1(value: 1)
		}
		let diContainer = builder.build()

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
		let builder = DependencyInjectionContainerBuilder()
		builder.register(Example1(value: 2))
		let diContainer = builder.build()

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
		let builder = DependencyInjectionContainerBuilder()
		builder.register({ Example3(value: 3) }, as: ExampleProtocol.self)
		let diContainer = builder.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testProtocolSaveAndLoadAutoclosureMini() {
		let builder = DependencyInjectionContainerBuilder()
		builder.register(Example3(value: 3), as: ExampleProtocol.self)
		let diContainer = builder.build()

		let exampleProtocolValue: ExampleProtocol = diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = diContainer.load(ExampleProtocol.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testDependenciesMethodMini() {
		let builder = DependencyInjectionContainerBuilder()
		var diContainer = builder.build()
		XCTAssertTrue(diContainer.objects.isEmpty)

		builder.register(Example3(value: 3), as: ExampleProtocol.self)
		diContainer = builder.build()
		XCTAssertFalse(diContainer.objects.isEmpty)
	}
}
