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

public struct ImmutableDependencyInjectionContainer {

	public enum InjectionLoadError: Error {
		case cannotFindDependency
	}

	public let objects: [ObjectIdentifier: () -> Any]
	public let throwableObjects: [ObjectIdentifier: () throws -> Any]
	public let singletonObjects: [ObjectIdentifier: Any]

	internal init(
		objects: [ObjectIdentifier: () -> Any],
		throwableObjects: [ObjectIdentifier: () throws -> Any],
		singletonObjects: [ObjectIdentifier: Any]
	) {
		self.objects = objects
		self.throwableObjects = throwableObjects
		self.singletonObjects = singletonObjects
	}

	public func load<T>(_ type: T.Type = T.self) -> T {
		guard let value = loadOrNil(type) else {
			fatalError("[ERROR] DIC: cannot find dependency for type \(type)")
		}
		return value
	}

	public func loadOrThrow<T>(_ type: T.Type = T.self) throws -> T {
		let id = ObjectIdentifier(type)
		let optionalID = ObjectIdentifier(Optional<T>.self)

		if let obj = singletonObjects[id] ?? singletonObjects[optionalID], let value = obj as? T {
			return value
		}
		if let factory = objects[id] ?? objects[optionalID], let value = factory() as? T {
			return value
		}
		if let factory = throwableObjects[id] ?? throwableObjects[optionalID], let value = try factory() as? T {
			return value
		}
		throw InjectionLoadError.cannotFindDependency
	}

	public func loadOrNil<T>(_ type: T.Type = T.self) -> T? {
		let id = ObjectIdentifier(type)
		let optionalID = ObjectIdentifier(Optional<T>.self)

		if let obj = singletonObjects[id] ?? singletonObjects[optionalID], let value = obj as? T {
			return value
		}
		if let factory = objects[id] ?? objects[optionalID] {
			return factory() as? T
		}
		if let factory = throwableObjects[id] ?? throwableObjects[optionalID] {
			return try? factory() as? T
		}
		return nil
	}
}
