//
//  File.swift
//  
//
//  Created by Victor Rolando Sanchez Jara on 7/13/20.
//

import XCTest
import MyLibrary // Works because Extension is Public
//@testable import MyLibrary

final class FloatingPointTestCase: XCTestCase {
    func test_initIntFromCGFloat() {
        let cgFloatInt: CGFloat = 3.0
        let cgFloatNotInt: CGFloat = 3.5
        XCTAssert(cgFloatInt.isInteger)
        XCTAssertFalse((1.1 as CGFloat).isInteger)
        XCTAssertFalse(cgFloatNotInt.isInteger)
        
        let doubleInt: Double = 1.0
        let doubleNotInt: Double = 1.5
        XCTAssert(doubleInt.isInteger)
        XCTAssertFalse(doubleNotInt.isInteger)
    }
}
