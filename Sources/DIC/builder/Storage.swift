import Foundation

internal final class LazySingleton: @unchecked Sendable {
	private let builder: () -> Any
	private var instance: Any?
	private let lock = NSLock()

	init(builder: @escaping () -> Any) {
		self.builder = builder
	}

	func value() -> Any {
		lock.lock()
		defer { lock.unlock() }
		if let instance = instance {
			return instance
		}
		let newInstance = builder()
		instance = newInstance
		return newInstance
	}
}

internal struct Storage {

	private let atomicData = Atomic(StorageData())

	init() {}

	// Thread-safe getters - always return current snapshot
	var objects: [ObjectIdentifier: () -> Any] {
		atomicData.value.objects
	}

	var throwableObjects: [ObjectIdentifier: () throws -> Any] {
		atomicData.value.throwableObjects
	}

	var singletonObjects: [ObjectIdentifier: LazySingleton] {
		atomicData.value.singletonObjects
	}

	func setObject<T>(_ builder: @escaping () -> T, for type: T.Type) {
		atomicData.modify { currentData in
			currentData.addingObject(builder, for: type)
		}
	}

	func setThrowableObject<T>(_ builder: @escaping () throws -> T, for type: T.Type) {
		atomicData.modify { currentData in
			currentData.addingThrowableObject(builder, for: type)
		}
	}

	func setSingletonObject<T>(_ builder: @escaping () -> T, for type: T.Type) {
		atomicData.modify { currentData in
			currentData.addingSingletonObject(LazySingleton(builder: builder), for: type)
		}
	}

	func checkType<T>(_ type: T.Type) {
		#if DEBUG
		let name = String(describing: type)
		if name.contains(" async ") {
			fatalError("[ERROR] DIC: async type detected: \"\(name)\". Use an async container.")
		} else if name.starts(with: "(") {
			print("[WARNING] DIC: your dependency type is a function: \"\(name)\". Are you sure that's correct?")
		}
		#endif
	}
}

private final class Atomic<T> {
	private var _value: T
	private let lock = NSLock()

	init(_ value: T) {
		_value = value
	}

	var value: T {
		lock.lock()
		defer { lock.unlock() }
		return _value
	}

	func modify(_ transform: (T) -> T) {
		lock.lock()
		defer { lock.unlock() }
		_value = transform(_value)
	}
}

private struct StorageData {
	let objects: [ObjectIdentifier: () -> Any]
	let throwableObjects: [ObjectIdentifier: () throws -> Any]
	let singletonObjects: [ObjectIdentifier: LazySingleton]

	init(
		objects: [ObjectIdentifier: () -> Any] = [:],
		throwableObjects: [ObjectIdentifier: () throws -> Any] = [:],
		singletonObjects: [ObjectIdentifier: LazySingleton] = [:]
	) {
		self.objects = objects
		self.throwableObjects = throwableObjects
		self.singletonObjects = singletonObjects
	}

	// Copy-on-write methods that return new instances
	func addingObject<T>(_ builder: @escaping () -> T, for type: T.Type) -> StorageData {
		var newObjects = objects
		newObjects[ObjectIdentifier(type)] = builder
		return StorageData(
			objects: newObjects,
			throwableObjects: throwableObjects,
			singletonObjects: singletonObjects
		)
	}

	func addingThrowableObject<T>(_ builder: @escaping () throws -> T, for type: T.Type) -> StorageData {
		var newThrowableObjects = throwableObjects
		newThrowableObjects[ObjectIdentifier(type)] = builder
		return StorageData(
			objects: objects,
			throwableObjects: newThrowableObjects,
			singletonObjects: singletonObjects
		)
	}

	func addingSingletonObject(_ lazySingleton: LazySingleton, for type: Any.Type) -> StorageData {
		var newSingletonObjects = singletonObjects
		newSingletonObjects[ObjectIdentifier(type)] = lazySingleton
		return StorageData(
			objects: objects,
			throwableObjects: throwableObjects,
			singletonObjects: newSingletonObjects
		)
	}
}

