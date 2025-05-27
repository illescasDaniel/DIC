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

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public final class AsyncDependencyInjectionContainer {

	public enum InjectionLoadError: Error {
		case cannotFindDependency
	}

	private var asyncObjects: [ObjectIdentifier: () async -> Any] = [:]
	private var asyncObjectsThatCanThrow: [ObjectIdentifier: () async throws -> Any] = [:]

	public func registerAsync<T>(_ objectBuilder: @escaping () async -> T, as desiredType: T.Type = T.self) {
		asyncObjects[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public func registerAsync<T>(_ objectBuilder: @escaping () async throws -> T, as desiredType: T.Type = T.self) {
		asyncObjectsThatCanThrow[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public func loadAsync<T>(_ type: T.Type = T.self) async -> T {
		if let value = await loadAsyncOrNil(type) {
			return value
		}
		fatalError("[ERROR] DIC: error resolving dependency for \(type)")
	}

	public func loadAsyncOrNil<T>(_ type: T.Type = T.self) async -> T? {
		return try? await loadAsyncOrThrow(type)
	}

	public func loadAsyncOrThrow<T>(_ type: T.Type = T.self) async throws -> T {
		if let f = asyncObjects[ObjectIdentifier(T.self)] ?? asyncObjects[ObjectIdentifier(Optional<T>.self)], let value = await f() as? T {
			return value
		} else if let f = asyncObjectsThatCanThrow[ObjectIdentifier(T.self)] ?? asyncObjectsThatCanThrow[ObjectIdentifier(Optional<T>.self)], let value = try await f() as? T {
			return value
		}
		throw InjectionLoadError.cannotFindDependency
	}

	public func unregisterDependencies(keepingCapacity: Bool = false) {
		asyncObjects.removeAll(keepingCapacity: keepingCapacity)
		asyncObjectsThatCanThrow.removeAll(keepingCapacity: keepingCapacity)
	}

	public func dependencies() -> [ObjectIdentifier: () async -> Any] {
		return asyncObjects
	}

	public func throwableDependencies() -> [ObjectIdentifier: () async throws -> Any] {
		return asyncObjectsThatCanThrow
	}
}
