import XCTest
@testable import DIC

final class DICOtherDataTypesTests: XCTestCase {
	
	func testStruct() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(VerySpecificData(name: "daniel"))
		let data: VerySpecificData = diContainer.load()
		XCTAssertEqual(data.name, "daniel")
		let data_1 = diContainer.load(VerySpecificData.self)
		XCTAssertEqual(data_1.name, "daniel")
	}

	func testEnum() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(MyColor.blue)
		let data: MyColor = diContainer.load()
		XCTAssertEqual(data, MyColor.blue)
		let data_1 = diContainer.load(MyColor.self)
		XCTAssertEqual(data_1, MyColor.blue)
	}

	func testActor() async {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(SomeActor(name: "daniel"))

		let data: SomeActor = diContainer.load()
		XCTAssertEqual(data.name, "daniel")

		let data_1: SomeActor = diContainer.load()
		XCTAssertEqual(data_1.name, "daniel")
	}

	func testNSObject() {
		let diContainer = DependencyInjectionContainer()
		diContainer.register(ObjcCustomClass(someObjcObject: NSString("hi")))

		let data: ObjcCustomClass = diContainer.load()
		XCTAssertEqual(data.someObjcObject, NSString("hi"))

		let data_1: ObjcCustomClass = diContainer.load()
		XCTAssertEqual(data_1.someObjcObject, NSString("hi"))
	}
}
