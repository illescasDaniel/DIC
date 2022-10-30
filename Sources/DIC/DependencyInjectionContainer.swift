//
//  DependencyInjectionContainer.swift
//  
//
//  Created by Daniel Illescas Romero on 29/10/22.
//

import Foundation

public class DependencyInjectionContainer {

	enum InjectionLoadError: Error {
		case cannotFindDependency
	}

	private static var objects: [ObjectIdentifier: () -> Any] = [:]
	private static var objectsThatCanThrow: [ObjectIdentifier: () throws -> Any] = [:]

	public static func save<T>(_ objectBuilder: @escaping () -> T, as desiredType: T.Type = T.self) {
		checkType(T.self)
		objects[ObjectIdentifier(desiredType)] = objectBuilder
	}
	public static func save<T>(_ objectBuilder: @autoclosure @escaping () -> T, as desiredType: T.Type = T.self) {
		checkType(T.self)
		objects[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public static func saveThrowable<T>(_ objectBuilder: @escaping () throws -> T, as desiredType: T.Type = T.self) {
		checkType(T.self)
		objectsThatCanThrow[ObjectIdentifier(desiredType)] = objectBuilder
	}
	public static func saveThrowable<T>(_ objectBuilder: @autoclosure @escaping () throws -> T, as desiredType: T.Type = T.self) {
		checkType(T.self)
		objectsThatCanThrow[ObjectIdentifier(desiredType)] = objectBuilder
	}

	public static func load<T>(_ type: T.Type = T.self) -> T {
		if let object = loadOrNil(type) {
			return object
		}
		fatalError("[ERROR] DIC: cannot find dependency")
	}
	public static func loadOrThrow<T>(_ type: T.Type = T.self) throws -> T {
		if let f = objects[ObjectIdentifier(T.self)] ?? objects[ObjectIdentifier(Optional<T>.self)], let value = f() as? T {
			return value
		} else if let f = objectsThatCanThrow[ObjectIdentifier(T.self)] ?? objectsThatCanThrow[ObjectIdentifier(Optional<T>.self)], let value = try f() as? T {
			return value
		}
		throw InjectionLoadError.cannotFindDependency
	}
	public static func loadOrNil<T>(_ type: T.Type = T.self) -> T? {
		if let objectBuilder = objects[ObjectIdentifier(T.self)]  ?? objects[ObjectIdentifier(Optional<T>.self)]{
			return objectBuilder() as? T
		} else if let objectBuilder = objectsThatCanThrow[ObjectIdentifier(T.self)] ?? objectsThatCanThrow[ObjectIdentifier(Optional<T>.self)] {
			return (try? objectBuilder()) as? T
		}
		return nil
	}

	//

	private static func checkType<T>(_ type: T) {
		#if DEBUG
		let theType = "\(type)"
		if theType.contains(" async ") {
			fatalError("[ERROR] DIC: please use the saveAsync method instead for: \"\(type)\"")
		} else if theType.starts(with: "(") {
			print("[WARNING] DIC: Your dependency type is a function: \"\(type)\". Are you sure that's correct?")
		}
		#endif
	}
}
