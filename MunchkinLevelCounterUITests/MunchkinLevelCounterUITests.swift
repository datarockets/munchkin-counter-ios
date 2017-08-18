//
//  MunchkinLevelCounterUITests.swift
//  MunchkinLevelCounterUITests
//
//  Created by Pavel V on 8/17/17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import XCTest

class MunchkinLevelCounterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshots() {
        let app = XCUIApplication()
        XCUIDevice.shared().orientation = .portrait
        
        // Players
        sleep(2)
        snapshot("0-Launch")
        
        // Counter
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(2)
        snapshot("1-Counter")
        
        // Results
        app.navigationBars.buttons.element(boundBy: 1).tap()
        app.alerts.element(boundBy: 0).buttons.element(boundBy: 1).tap()
        sleep(2)
        snapshot("2-Results")
        
        // Clean up
        XCUIApplication().navigationBars.buttons.element(boundBy: 0).tap()
        
        XCTAssert(true)
    }
    
}
