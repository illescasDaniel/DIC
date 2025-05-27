// The MIT License (MIT)
//
// Copyright (c) 2023 Daniel Illescas Romero
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

public final class MiniDependencyInjectionContainer {

	private var objects: [ObjectIdentifier: () -> Any] = [:]
	private var singletonObjects: [ObjectIdentifier: Any] = [:]
	private let lock = NSLock()

	public init() {}

	public func register<T>(_ objectBuilder: @escaping () -> T, as desiredType: T.Type = T.self) {
		lock.lock()
		defer { lock.unlock() }

		objects[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public func register<T>(_ objectBuilder: @autoclosure @escaping () -> T, as desiredType: T.Type = T.self) {
		register(objectBuilder, as: desiredType)
	}

	public func registerSingleton<T>(_ objectBuilder: @escaping () -> T, as desiredType: T.Type = T.self) {
		lock.lock()
		defer { lock.unlock() }

		singletonObjects[ObjectIdentifier(desiredType)] = objectBuilder()
	}

	public func registerSingleton<T>(_ objectBuilder: @autoclosure @escaping () -> T, as desiredType: T.Type = T.self) {
		registerSingleton(objectBuilder, as: desiredType)
	}

	public func load<T>(_ type: T.Type = T.self) -> T {
		lock.lock()
		defer { lock.unlock() }

		if let singletonObject = singletonObjects[ObjectIdentifier(T.self)] ?? singletonObjects[ObjectIdentifier(Optional<T>.self)],
		   let object = singletonObject as? T {
			return object
		} else if let objectBuilder = objects[ObjectIdentifier(T.self)] ?? objects[ObjectIdentifier(Optional<T>.self)],
				  let object = objectBuilder() as? T {
			return object
		}
		fatalError("[ERROR] DIC: cannot find dependency")
	}

	public func unregisterDependencies(keepingCapacity: Bool = false) {
		lock.lock()
		defer { lock.unlock() }

		objects.removeAll(keepingCapacity: keepingCapacity)
	}

	public func dependencies() -> [ObjectIdentifier: () -> Any] {
		lock.lock()
		defer { lock.unlock() }
		
		return objects
	}

	// Additional method to clear singletons if needed
	public func unregisterSingletons(keepingCapacity: Bool = false) {
		lock.lock()
		defer { lock.unlock() }

		singletonObjects.removeAll(keepingCapacity: keepingCapacity)
	}
}
