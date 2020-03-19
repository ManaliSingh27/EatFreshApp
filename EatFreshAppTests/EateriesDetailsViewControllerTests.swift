//
//  EateriesDetailsViewControllerTests.swift
//  EatFreshAppTests
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
import CoreData
@testable import EatFreshApp

class EateriesDetailsViewControllerTests: XCTestCase {

   var viewControllerUnderTest: EateriesDetailsTableViewController!

   override func setUp() {
       // Put setup code here. This method is called before the invocation of each test method in the class.
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       self.viewControllerUnderTest = (storyboard.instantiateViewController(withIdentifier: "EateriesDetailsTableViewController") as! EateriesDetailsTableViewController)
       
    
    
    self.viewControllerUnderTest.selectedEatery = getEateryObject()
       self.viewControllerUnderTest.loadView()
       self.viewControllerUnderTest.viewDidLoad()
   }

    func getEateryObject() ->Eatery
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
         let context = appDelegate!.persistentContainer.viewContext
         let eateryObj  = Eatery(context: context)
         eateryObj.name = "test name"
         eateryObj.rating = 4.1
         eateryObj.userRatingTotal = 230
         eateryObj.vicinity = "Test vicinity"
         eateryObj.iconUrl = "test url"
        eateryObj.placeId = "test"
         let OpenHrsObj  = OpeningHours(context: context)
        // OpenHrsObj.openNow = true
         OpenHrsObj.eatery = eateryObj
         let photoObj  = Photos(context: context)
         photoObj.width = 320
         photoObj.height = 320
         photoObj.photoRef = "test"
         photoObj.eatery = eateryObj
        
        let reviewsObj  = Review(context: context)
        reviewsObj.authorName = "test author"
        reviewsObj.text = "test description"
        eateryObj.reviews = [reviewsObj]

        
        return eateryObj
    }
   override func tearDown() {
       // Put teardown code here. This method is called after the invocation of each test method in the class.
       super.tearDown()
   }

   func testHasATableView() {
       XCTAssertNotNil(viewControllerUnderTest.tableView)
   }
   
   func testTableViewHasDelegate() {
       XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
   }
   
   
   
   func testTableViewHasDataSource() {
       XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
   }
   
   func testTableViewConformsToTableViewDataSourceProtocol() {
       XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
       XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.numberOfSections(in:))))
       XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
       XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
   }

   func testTableViewCellHasReuseIdentifier() {
       let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EateryDetailsTableViewCell
       let actualReuseIdentifer = cell?.reuseIdentifier
       let expectedReuseIdentifier = "detailsCell"
       XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    
    let cell1 = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? EateryImagesTableViewCell
    let actualReuseIdentifer1 = cell1?.reuseIdentifier
    let expectedReuseIdentifier1 = "imageCell"
    XCTAssertEqual(actualReuseIdentifer1, expectedReuseIdentifier1)
    
    let cell2 = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 2)) as? EateryUserReviewsTableViewCell
      let actualReuseIdentifer2 = cell2?.reuseIdentifier
      let expectedReuseIdentifier2 = "reviewCell"
      XCTAssertEqual(actualReuseIdentifer2, expectedReuseIdentifier2)
   }
   
   func testTableCellHasCorrectLabelText() {
       let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EateryDetailsTableViewCell
       XCTAssertNotNil(cell?.nameLabel)
       XCTAssertNotNil(cell?.openHrsLabel)
       XCTAssertNotNil(cell?.vicinityLabel)
    
    
    let cell1 = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? EateryImagesTableViewCell
    XCTAssertNotNil(cell1?.eateryImageView)
    
    let cell2 = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 2)) as? EateryUserReviewsTableViewCell
      XCTAssertNotNil(cell2?.authorNameLabel)
    XCTAssertNotNil(cell2?.commentText)
    XCTAssertNotNil(cell2?.authorProfilePicImageView)
    XCTAssertNotNil(cell2?.ratingLabel)

   
       
      
   }


}
