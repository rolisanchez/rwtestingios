import XCTest
import MyLibrary // Works because Extension is Public
//@testable import MyLibrary

final class BoolInitTestCase: XCTestCase {
    func test_validBits() throws {
        if let boolFromTrueBit = Bool(bit: 1) {
            XCTAssertTrue(boolFromTrueBit)
        } else {
            XCTFail("Got nil")
        }
        
        // Test Fail because of nil below:
//        try XCTUnwrap( Bool(bit: -1) )
        
        let boolFromFalseBit = try XCTUnwrap( Bool(bit: 0) )
        XCTAssertFalse(boolFromFalseBit)
    }
    
    func test_invalidBits() throws {
        XCTAssertNil(Bool(bit: -1))
        XCTAssertNil(Bool(bit: 2))
    }
    
    func test_DataByte() throws {
        let data = Data(0...2)
        let falseByte = data[0]
        let trueByte: UInt8 = data[1]
        let invalidByte = data[2]
        
        let boolFromFalseByte = try XCTUnwrap( Bool(bit: falseByte) )
        XCTAssertFalse(boolFromFalseByte)
        
        let boolFromTrueByte = try XCTUnwrap( Bool(bit: trueByte) )
        XCTAssertTrue(boolFromTrueByte)
        
        XCTAssertNil(Bool(bit: invalidByte))
    }
}
