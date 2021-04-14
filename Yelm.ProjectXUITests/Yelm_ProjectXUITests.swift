//
//  Yelm_ProjectXUITests.swift
//  Yelm.ProjectXUITests
//
//  Created by Michael Safir on 13.04.2021.
//

import XCTest

class Yelm_ProjectXUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        app.tap()
        
        addUIInterruptionMonitor(withDescription: "Access") { (alert) -> Bool in
            let btnAllow = alert.buttons["Allow"]
            
            if btnAllow.exists {
                btnAllow.tap()
                return true
            }
            
            XCTFail("Unexpected System Alert")
            return false
        }
       
        
        let label = app.staticTexts["Категории"]
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: label) { () -> Bool in
            
            sleep(2)
            let btn_modal = app.buttons["Готово"]
            if (btn_modal.exists){
                app.tap()
            }
            
            sleep(5)
            print("app loaded fine")
            snapshot("start")
            
            
            let news = app.buttons["news"]
            
            if (news.exists){
                news.firstMatch.tap()
                sleep(2)
                snapshot("news")
                sleep(2)
                
                let exit = app.buttons["exit"]
                if (exit.exists){
                    exit.firstMatch.tap()
                }
            }
            
            sleep(5)
            
            return true
        }
        waitForExpectations(timeout: 25, handler: nil)
        
        
        
       
    
    }
    
}
