import XCTest
@testable import DIC

final class DICWeirdCasesTests: XCTestCase {

	func testFailableDependencyInitSuccess() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(FailableDependency(value: 1))
		let failableDependency: FailableDependency? = diContainer.load()
		XCTAssertEqual(failableDependency?.value, 1)
		let failableDependency_1 = diContainer.load(FailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, 1)
		let failableDependency_2 = diContainer.load(Optional<FailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, 1)

		let dataOrNil: FailableDependency? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = diContainer.loadOrNil(FailableDependency?.self)
		XCTAssertEqual(dataOrNil_1??.value, 1)
		XCTAssertNoThrow(try diContainer.loadOrThrow(FailableDependency?.self))
	}

	func testFailableDependencyInitSuccessAlt() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(FailableDependency(value: 1))
		// Does succeed because the initializer will not fail with value 1
		let failableDependency: FailableDependency = diContainer.load()
		XCTAssertEqual(failableDependency.value, 1)
		let failableDependency_1 = diContainer.load(FailableDependency.self)
		XCTAssertEqual(failableDependency_1.value, 1)

		let dataOrNil: FailableDependency? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = diContainer.loadOrNil(FailableDependency.self)
		XCTAssertEqual(dataOrNil_1?.value, 1)
		XCTAssertNoThrow(try diContainer.loadOrThrow(FailableDependency.self))
	}

	func testFailableDependencyInitFail() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(FailableDependency(value: -2))
		let failableDependency: FailableDependency? = diContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = diContainer.load(FailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = diContainer.load(Optional<FailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)

		let dataOrNil: FailableDependency? = diContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, nil)
		let dataOrNil_1 = diContainer.loadOrNil(FailableDependency?.self)
		XCTAssertEqual(dataOrNil_1??.value, nil)

		XCTAssertNoThrow(try diContainer.loadOrThrow(FailableDependency?.self)) // will return nil from the init?
		XCTAssertThrowsError(try diContainer.loadOrThrow(FailableDependency.self)) // with throw because the init returned nil, so we can't get the not-nil value
	}

	func testThrowableDependencyInitSuccess() {
		let diContainer = DependencyInjectionContainer()
		diContainer.registerThrowable(try ThrowableDependency(value: 2))
		// will not fail because the value is > 0 and the init will not return nil
		let data: ThrowableDependency = diContainer.load()
		XCTAssertEqual(data.value, 2)
		let data_1 = diContainer.load(ThrowableDependency.self)
		XCTAssertEqual(data_1.value, 2)
		XCTAssertNoThrow(try diContainer.loadOrThrow(ThrowableDependency.self))
	}

	func testThrowableDependencyInitFail() {
		let diContainer = DependencyInjectionContainer()
		diContainer.registerThrowable(try ThrowableDependency(value: -2))
		// will fail because the value is < -2 and the init will return nil

		let data = diContainer.loadOrNil(ThrowableDependency.self)
		XCTAssertEqual(data?.value, nil)
		XCTAssertThrowsError(try diContainer.loadOrThrow(ThrowableDependency.self))
	}

	func testThrowableFailableDependencyInitSuccess() {
		let diContainer = DependencyInjectionContainer()
		// when the value is 1, this specific init will not throw or return nil
		diContainer.registerThrowable(try ThrowableFailableDependency(value: 1))
		let failableDependency: ThrowableFailableDependency? = diContainer.load()
		XCTAssertEqual(failableDependency?.value, 1)
		let failableDependency_1 = diContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, 1)
		let failableDependency_2 = diContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, 1)
		XCTAssertNoThrow(try diContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self))
		XCTAssertNoThrow(try diContainer.loadOrThrow(ThrowableFailableDependency.self))
	}

	func testThrowableFailableDependencyInitThrow() {
		let diContainer = DependencyInjectionContainer()
		// when the value is < 0, this specific init will throw an error
		diContainer.registerThrowable(try ThrowableFailableDependency(value: -2))
		let failableDependency: ThrowableFailableDependency? = diContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = diContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = diContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)
		XCTAssertThrowsError(try diContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self))
		XCTAssertThrowsError(try diContainer.loadOrThrow(ThrowableFailableDependency.self))
	}

	func testThrowableFailableDependencyInitFail() {
		let diContainer = DependencyInjectionContainer()
		// when the value is > 100, this specific init will return nil
		diContainer.registerThrowable(try ThrowableFailableDependency(value: 200))
		let failableDependency: ThrowableFailableDependency? = diContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = diContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = diContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)
		let failableDependency_3 = diContainer.loadOrNil(ThrowableFailableDependency.self)
		XCTAssertEqual(failableDependency_3?.value, nil)
		let failableDependency_4 = diContainer.loadOrNil(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_4??.value, nil)
		XCTAssertNoThrow(try diContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self)) // will NOT throw, because the init returned nil
		XCTAssertThrowsError(try diContainer.loadOrThrow(ThrowableFailableDependency.self)) // will throw, because we can't get the instance
	}

	func testAsyncDependencyInit() async {
		let diContainer = AsyncDependencyInjectionContainer()
		diContainer.registerAsync {
			await AsyncDependency(value: 1)
		}
		let asyncDependency: AsyncDependency = await diContainer.loadAsync()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = await diContainer.loadAsync(AsyncDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncDependencyInit() async {
		let diContainer = AsyncDependencyInjectionContainer()
		diContainer.registerAsync {
			await AsyncFailableDependency(value: 1)
		}
		let asyncDependencyOrNil: AsyncFailableDependency? = await diContainer.loadAsync()
		XCTAssertEqual(asyncDependencyOrNil?.value, 1)
		let asyncDependencyOrNil_1 = await diContainer.loadAsync(AsyncFailableDependency?.self)
		XCTAssertEqual(asyncDependencyOrNil_1?.value, 1)

		let asyncDependency: AsyncFailableDependency = await diContainer.loadAsync()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = await diContainer.loadAsync(AsyncFailableDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitSuccess() async throws {
		let diContainer = AsyncDependencyInjectionContainer()

		diContainer.registerAsync {
			try await AsyncFailableThrowableDependency(value: 1)
		}

		let asyncDependency: AsyncFailableThrowableDependency = try await diContainer.loadAsyncOrThrow()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = try await diContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitFail() async {

		let diContainer = AsyncDependencyInjectionContainer()

		diContainer.registerAsync {
			try await AsyncFailableThrowableDependency(value: -2)
		}

		do {
			_ = try await diContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency.self)

			XCTFail("fail because it didn't throw")
		} catch {
			// it has to throw
		}

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitFail2() async throws {

		let diContainer = AsyncDependencyInjectionContainer()
		diContainer.registerAsync {
			try await AsyncFailableThrowableDependency(value: 200)
		}

		let asyncDependency: AsyncFailableThrowableDependency? = try await diContainer.loadAsyncOrThrow()
		XCTAssertEqual(asyncDependency?.value, nil)
		let asyncDependency_1 = try await diContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency?.self)
		XCTAssertEqual(asyncDependency_1?.value, nil)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testUnregisterDependencies() async {
		let diContainer = AsyncDependencyInjectionContainer()

		diContainer.registerAsync {
			await AsyncDependency(value: 1)
		}
		let asyncDependency: AsyncDependency = await diContainer.loadAsync()
		XCTAssertEqual(asyncDependency.value, 1)

		diContainer.unregisterDependencies()
		let expectedNilValue = await diContainer.loadAsyncOrNil(AsyncDependency.self)
		XCTAssertNil(expectedNilValue)
	}

	func testDependenciesMethod() {
		let diContainer = AsyncDependencyInjectionContainer()

		XCTAssertTrue(diContainer.dependencies().isEmpty)

		diContainer.registerAsync {
			await AsyncDependency(value: 1)
		}
		XCTAssertFalse(diContainer.dependencies().isEmpty)

		diContainer.unregisterDependencies()
		XCTAssertTrue(diContainer.dependencies().isEmpty)
	}

	func testThrowingDependenciesMethod() {
		let diContainer = DependencyInjectionContainer()
		XCTAssertTrue(diContainer.throwableDependencies().isEmpty)

		diContainer.registerThrowable(try ThrowableDependency(value: 2))
		XCTAssertFalse(diContainer.throwableDependencies().isEmpty)

		diContainer.unregisterDependencies()
		XCTAssertTrue(diContainer.throwableDependencies().isEmpty)
	}

	func testAsyncThrowingDependenciesMethod() {
		let diContainer = AsyncDependencyInjectionContainer()
		XCTAssertTrue(diContainer.throwableDependencies().isEmpty)

		diContainer.registerAsync {
			try await AsyncFailableThrowableDependency(value: 200)
		}
		XCTAssertFalse(diContainer.throwableDependencies().isEmpty)

		diContainer.unregisterDependencies()
		XCTAssertTrue(diContainer.throwableDependencies().isEmpty)
	}
}
