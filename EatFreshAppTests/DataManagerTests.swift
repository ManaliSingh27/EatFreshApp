//
//  DataManagerTests.swift
//  EatFreshAppTests
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import EatFreshApp

class DataManagerTests: XCTestCase {
    
    var dataManager : DataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager.shared
        setEateryObj()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_init_DataManager(){
        
        let instance = DataManager.shared
        XCTAssertNotNil( instance )
    }
    
    private func setEateryObj()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let eateryObj  = Eatery(context: context)
        eateryObj.name = "test name"
        eateryObj.rating = 4.1
        eateryObj.userRatingTotal = 230
        eateryObj.vicinity = "Test vicinity"
        eateryObj.iconUrl = "test url"
        
        let OpenHrsObj  = OpeningHours(context: context)
        OpenHrsObj.openNow = true
        OpenHrsObj.eatery = eateryObj
        
        let photoObj  = Photos(context: context)
        photoObj.width = 320
        photoObj.height = 320
        photoObj.photoRef = "test"
        photoObj.eatery = eateryObj
        
    }
    
    func test_fetchEateries()
    {
        let instance = DataManager.shared
        XCTAssertNotNil(instance.fetchEateries)
        XCTAssertEqual(instance.fetchEateries().count, 1)
        instance.fetchEateries()
        
    }
    
    func test_clearStorage()
    {
        let instance = DataManager.shared
        instance.clearStorage()
        XCTAssertEqual(instance.fetchEateries().count, 0)
        
    }
    
  
    
}
