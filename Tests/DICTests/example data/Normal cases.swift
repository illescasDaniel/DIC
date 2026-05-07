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

class Example2 {
	let example1: Example1
	init(example1: Example1) {
		self.example1 = example1
	}
}
