//
//  StorageActor.swift
//  DIC
//
//  Created by Daniel Illescas Romero on 30/5/25.
//


internal actor StorageActor {
	private var objects: [ObjectIdentifier: () -> Any] = [:]
	private var throwableObjects: [ObjectIdentifier: () throws -> Any] = [:]
	private var singletonObjects: [ObjectIdentifier: Any] = [:]

	init() {}

	func setObject(_ builder: @escaping () -> Any, for identifier: ObjectIdentifier) {
		objects[identifier] = builder
	}

	func setThrowableObject(_ builder: @escaping () throws -> Any, for identifier: ObjectIdentifier) {
		throwableObjects[identifier] = builder
	}

	func setSingletonObject(_ object: Any, for identifier: ObjectIdentifier) {
		singletonObjects[identifier] = object
	}

	func getAllData() -> (
		objects: [ObjectIdentifier: () -> Any],
		throwableObjects: [ObjectIdentifier: () throws -> Any],
		singletonObjects: [ObjectIdentifier: Any]
	) {
		return (
			objects: objects,
			throwableObjects: throwableObjects,
			singletonObjects: singletonObjects
		)
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