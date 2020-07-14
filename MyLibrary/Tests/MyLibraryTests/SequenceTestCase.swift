//
//  File.swift
//  
//
//  Created by Victor Rolando Sanchez Jara on 7/14/20.
//

import Foundation

import XCTest
import MyLibrary // Works because Extension is Public
//@testable import MyLibrary

final class SequenceTestCase: XCTestCase {
    func test_first(){
        let odds = stride(from: 1, through: 9, by: 2)
        
        XCTAssertEqual(Array(odds), [1,3,5,7,9])
        XCTAssertEqual(odds.first, 1)
        XCTAssertNil(odds.prefix(0).first)
    }
    
    func test_sum(){
        let threeTwoOne = stride(from: 3, through: 1, by: -1)
        XCTAssertEqual(threeTwoOne.sum, 6)
        XCTAssertEqual([0.5, 1, 1.5].sum, 3)
        XCTAssertNil(Set<CGFloat>().sum)
        
        let oneThird = 1.0 / 3
        let thirdsSum10 = Array(repeating: oneThird, count: 30)
        XCTAssertEqual(thirdsSum10.sum, 10)
        let thirdsSum100 = Array(repeating: oneThird, count: 300)
        // Lost Precision below:
//        XCTAssertEqual(thirdsSum100.sum, 100)
        XCTAssertEqual(thirdsSum100.sum!, 100, accuracy: pow(0.1, 12))
    }
}
