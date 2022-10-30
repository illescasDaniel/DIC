import XCTest
@testable import DIC

final class DICWeirdCasesTests: XCTestCase {

	func testFailableDependencyInitSuccess() {
		DependencyInjectionContainer.save(FailableDependency(value: 1))
		let failableDependency: FailableDependency? = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency?.value, 1)
		let failableDependency_1 = DependencyInjectionContainer.load(FailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, 1)
		let failableDependency_2 = DependencyInjectionContainer.load(Optional<FailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, 1)

		let dataOrNil: FailableDependency? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(FailableDependency?.self)
		XCTAssertEqual(dataOrNil_1??.value, 1)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(FailableDependency?.self))
	}

	func testFailableDependencyInitSuccessAlt() {
		DependencyInjectionContainer.save(FailableDependency(value: 1))
		// Does succeed because the initializer will not fail with value 1
		let failableDependency: FailableDependency = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency.value, 1)
		let failableDependency_1 = DependencyInjectionContainer.load(FailableDependency.self)
		XCTAssertEqual(failableDependency_1.value, 1)

		let dataOrNil: FailableDependency? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, 1)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(FailableDependency.self)
		XCTAssertEqual(dataOrNil_1?.value, 1)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(FailableDependency.self))
	}

	func testFailableDependencyInitFail() {
		DependencyInjectionContainer.save(FailableDependency(value: -2))
		let failableDependency: FailableDependency? = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = DependencyInjectionContainer.load(FailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = DependencyInjectionContainer.load(Optional<FailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)

		let dataOrNil: FailableDependency? = DependencyInjectionContainer.loadOrNil()
		XCTAssertEqual(dataOrNil?.value, nil)
		let dataOrNil_1 = DependencyInjectionContainer.loadOrNil(FailableDependency?.self)
		XCTAssertEqual(dataOrNil_1??.value, nil)

		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(FailableDependency?.self)) // will return nil from the init?
		XCTAssertThrowsError(try DependencyInjectionContainer.loadOrThrow(FailableDependency.self)) // with throw because the init returned nil, so we can't get the not-nil value
	}

	func testThrowableDependencyInitSuccess() {
		DependencyInjectionContainer.saveThrowable(try ThrowableDependency(value: 2))
		// will not fail because the value is > 0 and the init will not return nil
		let data: ThrowableDependency = DependencyInjectionContainer.load()
		XCTAssertEqual(data.value, 2)
		let data_1 = DependencyInjectionContainer.load(ThrowableDependency.self)
		XCTAssertEqual(data_1.value, 2)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(ThrowableDependency.self))
	}

	func testThrowableDependencyInitFail() {
		DependencyInjectionContainer.saveThrowable(try ThrowableDependency(value: -2))
		// will fail because the value is < -2 and the init will return nil

		let data = DependencyInjectionContainer.loadOrNil(ThrowableDependency.self)
		XCTAssertEqual(data?.value, nil)
		XCTAssertThrowsError(try DependencyInjectionContainer.loadOrThrow(ThrowableDependency.self))
	}

	func testThrowableFailableDependencyInitSuccess() {
		// when the value is 1, this specific init will not throw or return nil
		DependencyInjectionContainer.saveThrowable(try ThrowableFailableDependency(value: 1))
		let failableDependency: ThrowableFailableDependency? = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency?.value, 1)
		let failableDependency_1 = DependencyInjectionContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, 1)
		let failableDependency_2 = DependencyInjectionContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, 1)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self))
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(ThrowableFailableDependency.self))
	}

	func testThrowableFailableDependencyInitThrow() {
		// when the value is < 0, this specific init will throw an error
		DependencyInjectionContainer.saveThrowable(try ThrowableFailableDependency(value: -2))
		let failableDependency: ThrowableFailableDependency? = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = DependencyInjectionContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = DependencyInjectionContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)
		XCTAssertThrowsError(try DependencyInjectionContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self))
		XCTAssertThrowsError(try DependencyInjectionContainer.loadOrThrow(ThrowableFailableDependency.self))
	}

	func testThrowableFailableDependencyInitFail() {
		// when the value is > 100, this specific init will return nil
		DependencyInjectionContainer.saveThrowable(try ThrowableFailableDependency(value: 200))
		let failableDependency: ThrowableFailableDependency? = DependencyInjectionContainer.load()
		XCTAssertEqual(failableDependency?.value, nil)
		let failableDependency_1 = DependencyInjectionContainer.load(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_1?.value, nil)
		let failableDependency_2 = DependencyInjectionContainer.load(Optional<ThrowableFailableDependency>.self)
		XCTAssertEqual(failableDependency_2?.value, nil)
		let failableDependency_3 = DependencyInjectionContainer.loadOrNil(ThrowableFailableDependency.self)
		XCTAssertEqual(failableDependency_3?.value, nil)
		let failableDependency_4 = DependencyInjectionContainer.loadOrNil(ThrowableFailableDependency?.self)
		XCTAssertEqual(failableDependency_4??.value, nil)
		XCTAssertNoThrow(try DependencyInjectionContainer.loadOrThrow(Optional<ThrowableFailableDependency>.self)) // will NOT throw, because the init returned nil
		XCTAssertThrowsError(try DependencyInjectionContainer.loadOrThrow(ThrowableFailableDependency.self)) // will throw, because we can't get the instance
	}

	func testAsyncDependencyInit() async {
		AsyncDependencyInjectionContainer.saveAsync {
			await AsyncDependency(value: 1)
		}
		let asyncDependency: AsyncDependency = await AsyncDependencyInjectionContainer.loadAsync()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = await AsyncDependencyInjectionContainer.loadAsync(AsyncDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncDependencyInit() async {
		AsyncDependencyInjectionContainer.saveAsync {
			await AsyncFailableDependency(value: 1)
		}
		let asyncDependencyOrNil: AsyncFailableDependency? = await AsyncDependencyInjectionContainer.loadAsync()
		XCTAssertEqual(asyncDependencyOrNil?.value, 1)
		let asyncDependencyOrNil_1 = await AsyncDependencyInjectionContainer.loadAsync(AsyncFailableDependency?.self)
		XCTAssertEqual(asyncDependencyOrNil_1?.value, 1)

		let asyncDependency: AsyncFailableDependency = await AsyncDependencyInjectionContainer.loadAsync()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = await AsyncDependencyInjectionContainer.loadAsync(AsyncFailableDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitSuccess() async throws {

		AsyncDependencyInjectionContainer.saveAsync {
			try await AsyncFailableThrowableDependency(value: 1)
		}

		let asyncDependency: AsyncFailableThrowableDependency = try await AsyncDependencyInjectionContainer.loadAsyncOrThrow()
		XCTAssertEqual(asyncDependency.value, 1)
		let asyncDependency_1 = try await AsyncDependencyInjectionContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency.self)
		XCTAssertEqual(asyncDependency_1.value, 1)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitFail() async {

		AsyncDependencyInjectionContainer.saveAsync {
			try await AsyncFailableThrowableDependency(value: -2)
		}

		do {
			_ = try await AsyncDependencyInjectionContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency.self)

			XCTFail("fail because it didn't throw")
		} catch {
			// it has to throw
		}

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}

	func testFailableAsyncThrowingDependencyInitFail2() async throws {

		AsyncDependencyInjectionContainer.saveAsync {
			try await AsyncFailableThrowableDependency(value: 200)
		}

		let asyncDependency: AsyncFailableThrowableDependency? = try await AsyncDependencyInjectionContainer.loadAsyncOrThrow()
		XCTAssertEqual(asyncDependency?.value, nil)
		let asyncDependency_1 = try await AsyncDependencyInjectionContainer.loadAsyncOrThrow(AsyncFailableThrowableDependency?.self)
		XCTAssertEqual(asyncDependency_1?.value, nil)

		// .load, .loadOrNil, .loadOrThrow are NOT meant for async values
	}
}
