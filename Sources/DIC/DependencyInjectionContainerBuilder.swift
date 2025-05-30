// The MIT License (MIT)
//
// Copyright (c) 2025 Daniel Illescas Romero
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public typealias DICBuilder = DependencyInjectionContainerBuilder

public struct DependencyInjectionContainerBuilder {

	private let storage: Storage

	public init() {
		self.storage = Storage()
	}

	// Private initializer for internal copying
	private init(storage: Storage) {
		self.storage = storage
	}

	@discardableResult
	public func register<T>(_ objectBuilder: @escaping () -> T, as desiredType: T.Type = T.self) -> Self {
		storage.checkType(T.self)
		storage.objects[ObjectIdentifier(desiredType)] = objectBuilder
		return self
	}

	@discardableResult
	public func register<T>(_ objectBuilder: @autoclosure @escaping () -> T, as desiredType: T.Type = T.self) -> Self {
		return register(objectBuilder, as: desiredType)
	}

	@discardableResult
	public func registerThrowable<T>(_ objectBuilder: @escaping () throws -> T, as desiredType: T.Type = T.self) -> Self {
		storage.checkType(T.self)
		storage.throwableObjects[ObjectIdentifier(desiredType)] = objectBuilder
		return self
	}

	@discardableResult
	public func registerThrowable<T>(_ objectBuilder: @autoclosure @escaping () throws -> T, as desiredType: T.Type = T.self) -> Self {
		return registerThrowable(objectBuilder, as: desiredType)
	}

	@discardableResult
	public func registerSingleton<T>(_ objectBuilder: () -> T, as desiredType: T.Type = T.self) -> Self {
		storage.singletonObjects[ObjectIdentifier(desiredType)] = objectBuilder()
		return self
	}

	@discardableResult
	public func registerSingleton<T>(_ objectBuilder: @autoclosure () -> T, as desiredType: T.Type = T.self) -> Self {
		return registerSingleton(objectBuilder, as: desiredType)
	}

	public func build() -> ImmutableDependencyInjectionContainer {
		ImmutableDependencyInjectionContainer(
			objects: storage.objects,
			throwableObjects: storage.throwableObjects,
			singletonObjects: storage.singletonObjects
		)
	}
}

// MARK: - Private Storage Class

private final class Storage {
	var objects: [ObjectIdentifier: () -> Any] = [:]
	var throwableObjects: [ObjectIdentifier: () throws -> Any] = [:]
	var singletonObjects: [ObjectIdentifier: Any] = [:]

	init() {}

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
