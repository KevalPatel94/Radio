//
//  RadioUITests.swift
//  RadioUITests
//
//  Created by Keval Patel on 4/28/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest
class RadioUITests: XCTestCase {
    let app = XCUIApplication()

//    let channelVC = ChannelListVC()
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    /**
     Test elements of DetailScreen
     */
    func testDetailScreenElements(){
        let tblSummary = app.tables["table--channlesTableView"]
        let tableCell = tblSummary.cells.element(boundBy: 0)
        tableCell.tap()
        let sevenInchSoulNavigationBar = app.navigationBars["Seven Inch Soul"]
        XCTAssert(sevenInchSoulNavigationBar.exists)
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssert(elementsQuery.staticTexts["Dion Watts Garcia"].exists)
        XCTAssert(elementsQuery.staticTexts["dion@somafm.com"].exists)
        XCTAssert(elementsQuery.staticTexts["Number of Listener"].exists)
        XCTAssert(elementsQuery.staticTexts["103"].exists)
        XCTAssert(elementsQuery.staticTexts["Genre"].exists)
        XCTAssert(elementsQuery.staticTexts["oldies"].exists)
        XCTAssert(elementsQuery.staticTexts["Desription"].exists)
        sevenInchSoulNavigationBar.buttons["Channels"].tap()
    }
    /**
     Test elements of filter functionality
     */
    func testFilter(){
        let filterButton = app.navigationBars["Channels"].buttons["Filter"]
        XCTAssert(filterButton.exists)
        filterButton.tap()
        let djSheet = app.sheets["DJ"]
        XCTAssert(djSheet.exists)
        XCTAssert(djSheet.buttons["Select"].exists)
        XCTAssert(djSheet.buttons["Cancel"].exists)
        djSheet.buttons["Cancel"].tap()
    }
    
    /**
     Test all the categories of tableview *tblSummary* from **FeedSummaryVC**
     */
    func testChannelListTableView(){
        let tblChannel = app.tables["table--channlesTableView"]
        if tblChannel.exists == true{
            XCTAssertTrue(tblChannel.exists, "Channel TableView Exist")
            let tableCells = tblChannel.cells
            guard tableCells.count >= 1 else {
                XCTAssert(false, "Not able to find summaryTableView")
                return
            }
            
            let count : Int = tableCells.count - 1
            let promise = expectation(description: "Wait for table cells")
            for i in stride(from: 0, to: count, by: 1){
                let tableCell = tableCells.element(boundBy: i)
                XCTAssertTrue(tableCell.exists, "The \(i) cell is in place on the table")
                tableCell.tap()
                if i == (count - 1){
                    promise.fulfill()
                }
                app.navigationBars.buttons.element(boundBy: 0).tap()
            }
            waitForExpectations(timeout: 20, handler: nil)
            
            XCTAssertTrue(true, "Finished validating the table cells")
        }
    }
    //Turn Of the Internet connectivity and run this test case to check the alertview behaviour
    /**
     Test usecase for Internet Connectivity not available
     */
    func testInternetConnectionUnavailable(){
        let app = XCUIApplication()
        let tblSummary = app.tables["table--channlesTableView"]
        XCTAssertTrue(tblSummary.exists, "Channle List tableView exists")
        let alertNointernetconnectionavailableAlert = XCUIApplication().alerts["No Internet Connection"]
        alertNointernetconnectionavailableAlert.staticTexts["Please connect your device to Internet"].tap()
        alertNointernetconnectionavailableAlert.buttons["OK"].tap()
    }
}
