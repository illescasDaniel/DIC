import XCTest
@testable import DIC

final class DISendableMiniTests: XCTestCase {

	func testSaveLoadWithClosureMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.register {
			ExampleSendable(value: 1)
		}
		let example1: ExampleSendable = await diContainer.load()
		XCTAssertEqual(example1.value, 1)
	}

	func testSaveLoadWithSingletonClassAutoclosureMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.registerSingleton(ExampleSendable(value: 1))
		let example1: ExampleSendable = await diContainer.load()
		XCTAssertEqual(example1.value, 1)
	}

	func testSaveLoadWithSingletonClassWithClosureMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.registerSingleton {
			ExampleSendable(value: 1)
		}
		let example1: ExampleSendable = await diContainer.load()
		XCTAssertEqual(example1.value, 1)
	}

	func testSaveLoadWithAutoclosureMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.register(ExampleSendable(value: 2))
		let example2: ExampleSendable = await diContainer.load()
		XCTAssertEqual(example2.value, 2)
		let example2_1 = await diContainer.load(ExampleSendable.self)
		XCTAssertEqual(example2_1.value, 2)

		let data1: ExampleSendable = await diContainer.load()
		XCTAssertEqual(data1.value, 2)
		let data2 = await diContainer.load(ExampleSendable.self)
		XCTAssertEqual(data2.value, 2)
	}

	func testProtocolSaveAndLoadMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.register(
			{ ExampleSendable(value: 3) },
			as: ExampleProtocolSendable.self
		)
		let exampleProtocolValue: ExampleProtocolSendable = await diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = await diContainer.load(ExampleProtocolSendable.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testProtocolSaveAndLoadAutoclosureMini() async {

		let diContainer = SendableMiniDependencyInjectionContainer()

		// if the `objectBuilder` return type doesn't conform to the `desiredType`, it will throw a compilation error :)
		// diContainer.save(Example3(value: 3), as: Int.self)

		await diContainer.register(ExampleSendable(value: 3), as: ExampleProtocolSendable.self)
		let exampleProtocolValue: ExampleProtocolSendable = await diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = await diContainer.load(ExampleProtocolSendable.self)
		XCTAssertEqual(exampleProtocolValue_1.value, 3)
	}

	func testUnregisterDependenciesMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		await diContainer.register(ExampleSendable(value: 3), as: ExampleProtocolSendable.self)
		let exampleProtocolValue: ExampleProtocolSendable = await diContainer.load()
		XCTAssertEqual(exampleProtocolValue.value, 3)

		await diContainer.unregisterDependencies()
		let deps = await diContainer.dependencies()
		XCTAssertTrue(deps.isEmpty)
	}

	func testDependenciesMethodMini() async {
		let diContainer = SendableMiniDependencyInjectionContainer()
		var deps = await diContainer.dependencies()
		XCTAssertTrue(deps.isEmpty)

		await diContainer.register(ExampleSendable(value: 3), as: ExampleProtocolSendable.self)
		deps = await diContainer.dependencies()
		XCTAssertFalse(deps.isEmpty)

		await diContainer.unregisterDependencies()
		deps = await diContainer.dependencies()
		XCTAssertTrue(deps.isEmpty)
	}
}
