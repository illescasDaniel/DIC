//
//  AsyncDependencyInjectionContainer.swift
//  
//
//  Created by Daniel Illescas Romero on 30/10/22.
//

import Foundation

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public class AsyncDependencyInjectionContainer {

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
		fatalError("[ERROR] DIC: error resolving dependency")
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
