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

class DogYearsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func test_navigationBackToMenu() throws {
        let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = XCUIDevice.shared.orientation.isPortrait
        
        
        //        XCUIApplication().navigationBars["Master"].buttons["Menu"].tap()
        // Extract from above:
        
        let masterNavBar = app.navigationBars["Master"]
//        let menuButton = masterNavBar.buttons["Menu"]
//        menuButton.tap()
        
        // Verify iPad conditions and landscape
        switch (isiPad, isPortrait) {
            case (true, true):
                print("here")
                app.navigationBars["DogYears.CalculatorView"].buttons["Master"].tap()
            case (true, false):
                break
            case (false, _):
                masterNavBar.buttons["Menu"].tap()
        }
        
        XCTAssertFalse(masterNavBar.exists)
        XCTAssert(app.navigationBars["Menu"].exists)
        
    }
    
    func test_calculatorEntry() {
        app/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["4"].tap()
        //        app.descendants(matching: .staticText)
        // Could do it using above, but .staticTexts is shorter
        XCTAssertEqual(app.staticTexts.matching(identifier: "output").firstMatch.label, "24")
        //        app.staticTexts["24"].tap()
        
    }
}
