/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import DogPatch

final class AsynchronousTestCase: XCTestCase {
  let timeout: TimeInterval = 2
  var expectation: XCTestExpectation!
  
  override func setUp() {
    expectation = expectation(description: "Server responds in reasonable time")
  }
  
  func test_noServerResponse(){
    let url = URL(string: "doggone")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      // Fulfill MUST be called at the end
      defer { self.expectation.fulfill() }
      
      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertNotNil(error)
    }
    .resume()
    
    waitForExpectations(timeout: timeout)
  }
  
  func test_decodeDogs(){
    let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      // Fulfill MUST be called at the end
      defer { self.expectation.fulfill() }
      
      XCTAssertNil(error)
      
      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 200)
        let data = try XCTUnwrap(data)
        XCTAssertNoThrow(
          try JSONDecoder().decode([Dog].self, from: data)
        )
      }
      catch {
        // Leave blank here because everything will be caught by XCTAssertNoThrow
      }
    }
    .resume()
    
    waitForExpectations(timeout: timeout)
  }
  
  func test_404(){
    let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/cats")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      // Fulfill MUST be called at the end
      defer { self.expectation.fulfill() }
      
      XCTAssertNil(error)
      
      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 404)
        let data = try XCTUnwrap(data)
        XCTAssertThrowsError(
          try JSONDecoder().decode([Dog].self, from: data)
        ) { error in
          guard case DecodingError.typeMismatch = error else {
            XCTFail("\(error)")
            return
          }
        }
      }
      catch {
        // Leave blank here because everything will be caught by XCTAssertNoThrow
      }
    }
    .resume()
    
    waitForExpectations(timeout: timeout)
  }
}