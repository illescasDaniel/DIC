import XCTest
@testable import DIC

final class DICOtherDataTypesTests: XCTestCase {

	func testStruct() {
		DependencyInjectionContainer.save(VerySpecificData(name: "daniel"))
		let data: VerySpecificData = DependencyInjectionContainer.load()
		XCTAssertEqual(data.name, "daniel")
		let data_1 = DependencyInjectionContainer.load(VerySpecificData.self)
		XCTAssertEqual(data_1.name, "daniel")
	}

	func testEnum() {
		DependencyInjectionContainer.save(MyColor.blue)
		let data: MyColor = DependencyInjectionContainer.load()
		XCTAssertEqual(data, MyColor.blue)
		let data_1 = DependencyInjectionContainer.load(MyColor.self)
		XCTAssertEqual(data_1, MyColor.blue)
	}

	func testActor() async {
		DependencyInjectionContainer.save(SomeActor(name: "daniel"))

		let data: SomeActor = DependencyInjectionContainer.load()
		XCTAssertEqual(data.name, "daniel")

		let data_1: SomeActor = DependencyInjectionContainer.load()
		XCTAssertEqual(data_1.name, "daniel")
	}

	func testNSObject() {
		DependencyInjectionContainer.save(ObjcCustomClass(someObjcObject: NSString("hi")))

		let data: ObjcCustomClass = DependencyInjectionContainer.load()
		XCTAssertEqual(data.someObjcObject, NSString("hi"))

		let data_1: ObjcCustomClass = DependencyInjectionContainer.load()
		XCTAssertEqual(data_1.someObjcObject, NSString("hi"))
	}
}
