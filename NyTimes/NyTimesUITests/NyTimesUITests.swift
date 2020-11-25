//
//  NyTimesUITests.swift
//  NyTimesUITests
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import XCTest

class NyTimesUITests: XCTestCase {

    let testApp = XCUIApplication()

    override func setUpWithError() throws {

        continueAfterFailure = false
        testApp.launch()
    }

    func testArtcleListDisplay() throws {
                
        //Expectation for waiting, until table is clickable
        expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: testApp.tables.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20.0, handler: nil)

        //Check if table exists
        let articlesTable = testApp.tables.element(boundBy: 0)
        XCTAssertTrue(articlesTable.exists)
        
        let cellCount = articlesTable.cells.count
        XCTAssertTrue(cellCount > 0)

        //Check if first cell exists and then Tap on it
        let firstCell = testApp.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        //Check for textview
        let textView = testApp.textViews.element(boundBy: 0)
        XCTAssertTrue(textView.exists)
        
        //Check if "NEXT ARTCLE" (Right Arrow) button extsts on navigation bar and Clcik it
        let navigationbarButtons = testApp.navigationBars.element(boundBy: 0).children(matching: .button)
        XCTAssert(navigationbarButtons.element(boundBy: 2).exists)
        navigationbarButtons.element(boundBy: 2).tap()

        
        XCTAssert(navigationbarButtons.element(boundBy: 0).exists)
        navigationbarButtons.element(boundBy: 0).tap()
        
    }
    
    func testPullToRefresh() throws {
        
        //Expectation for waiting, until table is clickable
        expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: testApp.tables.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20.0, handler: nil)
                
        //Check if table exists
        let articlesTable = testApp.tables.element(boundBy: 0)
        XCTAssert(articlesTable.exists)
        
        let cellCount = articlesTable.cells.count
        XCTAssertTrue(cellCount > 0)

        //Check if first cell exists and then Tap on it
        let firstCell = testApp.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 100))
        start.press(forDuration: 0, thenDragTo: finish, withVelocity: 2000, thenHoldForDuration: 0)
    }
    
    func testPeriodChange() throws {
       
        //Expectation for waiting, until table is clickable
        expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: testApp.tables.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20.0, handler: nil)
        
        let nyTimesNavigationBar = testApp.navigationBars.element(boundBy: 0)
        
        nyTimesNavigationBar.buttons["Day"].tap()
        expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: testApp.tables.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20.0, handler: nil)
        
        nyTimesNavigationBar/*@START_MENU_TOKEN@*/.buttons["Week"]/*[[".segmentedControls[\"NY Times\"].buttons[\"Week\"]",".buttons[\"Week\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: testApp.tables.element(boundBy: 0), handler: nil)
        waitForExpectations(timeout: 20.0, handler: nil)
        
        nyTimesNavigationBar/*@START_MENU_TOKEN@*/.buttons["Month"]/*[[".segmentedControls[\"NY Times\"].buttons[\"Month\"]",".buttons[\"Month\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
