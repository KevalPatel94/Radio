//
//  RadioTests.swift
//  RadioTests
//
//  Created by Keval Patel on 4/28/19.
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import XCTest
@testable import Radio
class RadioTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testremoveDuplicates() {
        let resultArray = [0,1,2,3,4,5,6,7,8,9,10]
        var array = [1,2,3,4,5,3,2,3,4,5,6,7,8,9,0,10,1,2,3,4,5,8,6,7,8]
        array = array.removeDuplicates()
        array.sort(by: {$0 < $1})
        XCTAssertEqual(array, resultArray)
    }
}
