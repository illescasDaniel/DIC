//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/10/22.
//

import Foundation

public class AsyncDependencyInjectionContainer {

	enum InjectionLoadError: Error {
		case cannotFindDependency
	}

	private static var asyncObjects: [ObjectIdentifier: () async -> Any] = [:]
	private static var asyncObjectsThatCanThrow: [ObjectIdentifier: () async throws -> Any] = [:]

	public static func saveAsync<T>(_ objectBuilder: @escaping () async -> T, as desiredType: T.Type = T.self) {
		asyncObjects[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public static func saveAsync<T>(_ objectBuilder: @escaping () async throws -> T, as desiredType: T.Type = T.self) {
		asyncObjectsThatCanThrow[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public static func loadAsync<T>(_ type: T.Type = T.self) async -> T {
		if let f = asyncObjects[ObjectIdentifier(type)] ?? asyncObjects[ObjectIdentifier(Optional<T>.self)] {
			let value = await f()
			if let goodValue = value as? T {
				return goodValue
			}
		}
		fatalError("[ERROR] DIC: error resolving dependency")
	}

	public static func loadAsyncOrThrow<T>(_ type: T.Type = T.self) async throws -> T {
		if let f = asyncObjects[ObjectIdentifier(T.self)] ?? asyncObjects[ObjectIdentifier(Optional<T>.self)], let value = await f() as? T {
			return value
		} else if let f = asyncObjectsThatCanThrow[ObjectIdentifier(T.self)] ?? asyncObjectsThatCanThrow[ObjectIdentifier(Optional<T>.self)], let value = try await f() as? T {
			return value
		}
		throw InjectionLoadError.cannotFindDependency
	}
}
