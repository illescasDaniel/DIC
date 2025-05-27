//
//  Normal cases.swift
//  
//
//  Created by Daniel Illescas Romero on 30/10/22.
//

import Foundation

class Example1 {
	var value: Int
	init(value: Int) {
		self.value = value
	}
}

protocol ExampleProtocol {
	var value: Int { get }
}

class Example3: ExampleProtocol {
	let value: Int
	init(value: Int) {
		self.value = value
	}
}


protocol ExampleProtocolSendable: Sendable {
	var value: Int { get }
}

final class ExampleSendable: ExampleProtocolSendable {
	let value: Int
	init(value: Int) {
		self.value = value
	}
}
