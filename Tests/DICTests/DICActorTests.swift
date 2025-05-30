import XCTest
@testable import DIC

final class DICActorTests: XCTestCase {

	func testSaveLoadWithClosure() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.register {
			Example1(value: 1)
		}
		let example1_1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example1_1.value, 1)

		let dataOrNil_1 = await diContainer.loadOrNil(Example1.self)?.value
		XCTAssertEqual(dataOrNil_1?.value, 1)
		do {
			_ = try await diContainer.loadOrThrow(Example1.self)
		} catch {
			XCTFail()
		}
	}

	func testSaveLoadWithAutoclosure() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.register(Example1(value: 2))
		let example2 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example2.value, 2)
		let example2_1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example2_1.value, 2)

		let dataOrNil = await diContainer.loadOrNil(Example1.self)?.value
		XCTAssertEqual(dataOrNil?.value, 2)
		let dataOrNil_1 = await diContainer.loadOrNil(Example1.self)?.value
		XCTAssertEqual(dataOrNil_1?.value, 2)
		do {
			_ = try await diContainer.loadOrThrow(Example1.self)
		} catch {
			XCTFail()
		}
	}

	func testSaveLoadWithSingletonClassAutoclosure() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.registerSingleton(Example1(value: 1))
		let example1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example1.value, 1)

		example1.value = 90
		XCTAssertEqual(example1.value, 90)

		let example1_1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example1_1.value, 90)
		let data1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(data1.value, 90)
		let data2 = await diContainer.load(Example1.self).value
		XCTAssertEqual(data2.value, 90)
	}

	func testSaveLoadWithSingletonClassWithClosure() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.registerSingleton {
			Example1(value: 1)
		}
		let example1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example1.value, 1)

		example1.value = 90
		XCTAssertEqual(example1.value, 90)

		let example1_1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(example1_1.value, 90)
		let data1 = await diContainer.load(Example1.self).value
		XCTAssertEqual(data1.value, 90)
		let data2 = await diContainer.load(Example1.self).value
		XCTAssertEqual(data2.value, 90)
	}

	func testProtocolSaveAndLoad() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.register(
			{ Example3(value: 3) },
			as: ExampleProtocol.self
		)
		let exampleProtocolValue = await diContainer.load(ExampleProtocol.self).value
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = await diContainer.load(ExampleProtocol.self).value
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil = await diContainer.loadOrNil(ExampleProtocol.self)?.value
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = await diContainer.loadOrNil(ExampleProtocol.self)?.value
		XCTAssertEqual(dataOrNil_1?.value, 3)
		do {
			_ = try await diContainer.loadOrThrow(ExampleProtocol.self)
		} catch {
			XCTFail()
		}
	}

	func testProtocolSaveAndLoadAutoclosure() async throws {
		let diContainer = DependencyInjectionContainerActor()

		// if the `objectBuilder` return type doesn't conform to the `desiredType`, it will throw a compilation error :)
		// await diContainer.register(Example3(value: 3), as: Int.self)

		await diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue = await diContainer.load(ExampleProtocol.self).value
		XCTAssertEqual(exampleProtocolValue.value, 3)
		let exampleProtocolValue_1 = await diContainer.load(ExampleProtocol.self).value
		XCTAssertEqual(exampleProtocolValue_1.value, 3)

		let dataOrNil = await diContainer.loadOrNil(ExampleProtocol.self)?.value
		XCTAssertEqual(dataOrNil?.value, 3)
		let dataOrNil_1 = await diContainer.loadOrNil(ExampleProtocol.self)?.value
		XCTAssertEqual(dataOrNil_1?.value, 3)
		do {
			_ = try await diContainer.loadOrThrow(ExampleProtocol.self)
		} catch {
			XCTFail()
		}
	}

	func testUnregisterDependencies() async throws {
		let diContainer = DependencyInjectionContainerActor()
		await diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let exampleProtocolValue = await diContainer.load(ExampleProtocol.self).value
		XCTAssertEqual(exampleProtocolValue.value, 3)

		await diContainer.unregisterDependencies()
		let result = await diContainer.loadOrNil(ExampleProtocol.self)?.value
		XCTAssertNil(result)
	}

	func testDependenciesMethod() async throws {
		let diContainer = DependencyInjectionContainerActor()
		let emptyDependencies = await diContainer.dependencies().value
		XCTAssertTrue(emptyDependencies.isEmpty)

		await diContainer.register(Example3(value: 3), as: ExampleProtocol.self)
		let nonEmptyDependencies = await diContainer.dependencies().value
		XCTAssertFalse(nonEmptyDependencies.isEmpty)

		await diContainer.unregisterDependencies()
		let clearedDependencies = await diContainer.dependencies().value
		XCTAssertTrue(clearedDependencies.isEmpty)
	}
}
