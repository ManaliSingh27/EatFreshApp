//
//  UtilityTests.swift
//  EatFreshAppTests
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import EatFreshApp

class UtilityTests: XCTestCase {

   
    var sut: EateriesTableViewController!

       override func setUp() {
           super.setUp()
           sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EateriesTableViewController") as? EateriesTableViewController
           
           UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = sut
       }

       override func tearDown() {
           super.tearDown()

       }

       func testAlert_HasTitle() {
           Utility.showAlert(title: "Test Title", message: "Test Message", vc: sut)
         XCTAssertTrue(sut.presentedViewController is UIAlertController)
         XCTAssertEqual(sut.presentedViewController?.title, "Test Title")
       }

}
