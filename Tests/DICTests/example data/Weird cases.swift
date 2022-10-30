//
//  File.swift
//  
//
//  Created by Daniel Illescas Romero on 30/10/22.
//

import Foundation

class FailableDependency {
	let value: Int
	init?(value: Int) {
		if value < 0 {
			return nil
		} else {
			self.value = value
		}
	}
}

class ThrowableDependency {
	let value: Int

	enum CustomError: Error {
		case someError
	}

	init(value: Int) throws {
		if value < 0 {
			throw CustomError.someError
		} else {
			self.value = value
		}
	}
}

class ThrowableFailableDependency {
	let value: Int

	enum CustomError: Error {
		case someError
	}

	init?(value: Int) throws {
		if value < 0 {
			throw CustomError.someError
		} else if value > 100 {
			return nil
		} else {
			self.value = value
		}
	}
}

class AsyncDependency {
	let value: Int

	init(value: Int) async {
		try? await Task.sleep(nanoseconds: 100)
		self.value = value
	}
}

class AsyncFailableDependency {
	let value: Int

	init?(value: Int) async {
		try? await Task.sleep(nanoseconds: 100)

		if value < 0 {
			return nil
		} else {
			self.value = value
		}
	}
}

class AsyncFailableThrowableDependency {
	let value: Int

	enum CustomError: Error {
		case someError
	}
	
	init?(value: Int) async throws { // Don't do this, please...
		try? await Task.sleep(nanoseconds: 100)

		if value < 0 {
			throw CustomError.someError
		} else if value > 100 {
			return nil
		} else {
			self.value = value
		}
	}
}
