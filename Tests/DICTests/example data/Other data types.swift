//
//  Other data types.swift
//  
//
//  Created by Daniel Illescas Romero on 30/10/22.
//

import Foundation

struct VerySpecificData {
	let name: String
}

enum MyColor {
	case blue
	case green
}

actor SomeActor {
	let name: String
	init(name: String) {
		self.name = name
	}
}

class ObjcCustomClass: NSObject {
	let someObjcObject: NSString
	init(someObjcObject: NSString) {
		self.someObjcObject = someObjcObject
		super.init()
	}
}
